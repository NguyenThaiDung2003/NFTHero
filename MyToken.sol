// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol"; // Hỗ trợ duyệt danh sách NFT
import "@openzeppelin/contracts/access/Ownable.sol"; // Chỉ định owner để rút tiền

contract HeroNFT is ERC721Enumerable, Ownable {
    // Cấu trúc thông tin hero
    struct Hero {
        uint8 rarity; // 0 = common, 1 = rare, 2 = legendary, 3 = mythical
        uint8 strength;
        uint8 agility;
        uint8 intelligence;
    }

    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public constant MINT_PRICE = 0.001 ether;
    uint256 public constant MAX_PER_WALLET = 10;

    // Số lượng còn lại của từng độ hiếm
    uint256[4] public raritySupply = [600, 300, 90, 10];

    mapping(uint256 => Hero) public heroes; // Lưu thông tin hero theo tokenId
    mapping(address => uint256) public mintedCount; // Số lượng NFT đã mint của mỗi ví

    // Dữ liệu marketplace
    mapping(uint256 => uint256) public listings; // tokenId => price
    struct Offer {
        address buyer;
        uint256 price;
    }
    mapping(uint256 => Offer) public offers; // tokenId => offer info

    // Sự kiện
    event HeroMinted(address indexed user, uint256 indexed tokenId, uint8 rarity);
    event Listed(address indexed seller, uint256 indexed tokenId, uint256 price);
    event Delisted(address indexed seller, uint256 indexed tokenId);
    event Offered(address indexed buyer, uint256 indexed tokenId, uint256 price);
    event OfferAccepted(address indexed seller, address indexed buyer, uint256 indexed tokenId, uint256 price);
    constructor() ERC721("HeroNFT", "HERO") Ownable(msg.sender) {}

    // Mint NFT với chỉ số và độ hiếm ngẫu nhiên
    function mintHero(uint256 amount) external payable {
        require(amount > 0 && amount <= 10, "Invalid mint amount");
        require(msg.value == amount * MINT_PRICE, "Incorrect ETH sent");
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        require(mintedCount[msg.sender] + amount <= MAX_PER_WALLET, "Mint limit per wallet exceeded");

        for (uint256 i = 0; i < amount; i++) {
            uint8 rarity = _getRandomRarity();
            uint256 tokenId = totalSupply() + 1;

            heroes[tokenId] = Hero({
                rarity: rarity,
                strength: _randomStat("strength", tokenId),
                agility: _randomStat("agility", tokenId),
                intelligence: _randomStat("intelligence", tokenId)
            });

            _safeMint(msg.sender, tokenId);
            mintedCount[msg.sender]++;
            emit HeroMinted(msg.sender, tokenId, rarity);
        }
    }

    // Tính độ hiếm ngẫu nhiên dựa vào số còn lại
    function _getRandomRarity() internal returns (uint8) {
        uint256 seed = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, totalSupply()))
        );
        uint256 rand = seed % (raritySupply[0] + raritySupply[1] + raritySupply[2] + raritySupply[3]);

        uint8 rarity = 0;
        uint256 sum = 0;

        for (uint8 i = 0; i < 4; i++) {
            sum += raritySupply[i];
            if (rand < sum) {
                raritySupply[i]--;
                rarity = i;
                break;
            }
        }
        return rarity;
    }

    // Sinh ngẫu nhiên chỉ số (10-100)
    function _randomStat(string memory label, uint256 tokenId) internal view returns (uint8) {
        uint256 rand = uint256(keccak256(abi.encodePacked(label, tokenId, block.timestamp))) % 91 + 10;
        return uint8(rand);
    }

    function _checkOwnerOrApproved(address spender, uint256 tokenId) internal view {
        address owner = ownerOf(tokenId);
        address approved = getApproved(tokenId);
        require(spender == owner || spender == approved || isApprovedForAll(owner, spender), "Not owner or approved");
    }
    // List NFT lên chợ
    function listNFT(uint256 tokenId, uint256 price) external {
        _checkOwnerOrApproved(msg.sender, tokenId);
        require(price > 0, "Invalid price");
        listings[tokenId] = price;
        emit Listed(msg.sender, tokenId, price);
    }

    // Hủy list
    function delistNFT(uint256 tokenId) external {
        _checkOwnerOrApproved(msg.sender, tokenId);
        require(listings[tokenId] > 0, "Not listed");
        delete listings[tokenId];
        emit Delisted(msg.sender, tokenId);
    }


    // Chấp nhận offer
    function acceptOffer(uint256 tokenId) external {
        _checkOwnerOrApproved(msg.sender, tokenId);
        Offer memory offer = offers[tokenId];
        require(offer.price > 0, "No offer");
        delete offers[tokenId];
        _transfer(ownerOf(tokenId), offer.buyer, tokenId);
        payable(msg.sender).transfer(offer.price);
        emit OfferAccepted(msg.sender, offer.buyer, tokenId, offer.price);
    }


    // Gửi offer mua NFT của người khác
    function offerNFT(uint256 tokenId) external payable {
        require(ownerOf(tokenId) != msg.sender, "Cannot offer your own NFT");
        require(msg.value > 0, "Invalid offer");
        require(offers[tokenId].price < msg.value, "Offer not higher");

        // Trả lại offer cũ nếu có
        if (offers[tokenId].price > 0) {
            payable(offers[tokenId].buyer).transfer(offers[tokenId].price);
        }

        offers[tokenId] = Offer({buyer: msg.sender, price: msg.value});
        emit Offered(msg.sender, tokenId, msg.value);
    }

    // Admin rút tiền về ví của mình
    function withdraw() external onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }

    // Xem thông tin hero
    function getHero(uint256 tokenId) external view returns (Hero memory) {
        return heroes[tokenId];
    }

    // Xem NFT của user
    function getUserNFTs(address user) external view returns (uint256[] memory) {
        uint256 count = balanceOf(user);
        uint256[] memory result = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            result[i] = tokenOfOwnerByIndex(user, i);
        }
        return result;
    }
}