Tạo contract Hero NFT(ERC721):
Giới hạn 1000 NFT bao gồm 600 common, 300 rare, 90 legendary, 10 mythical tương ứng với độ hiếm.
Hero có các chỉ số Strength, Agility, Intelligence ngẫu nhiên có giá trị giới hạn trong khoảng từ 10 -> 100.
Giá mint 0.001ETH/1NFT, mỗi ví được mint tổng tối đa 10NFT, tỉ lệ độ hiếm ra ngẫu nhiên.
Người dùng có thể list(đăng bán) NFT, delist(hủy đăng bán) NFT, accept(chấp nhận lời đề nghị mua) NFT.
Người dùng có thể offer(đề nghị mua) NFT của người khác.
Ghi lại các sự kiện mint, list, delist, offer, accept NFT.
Tạo trang web chợ quản lý tương tác với contract:
Kết nối ví(Metamask, okx, ...). 
Người dùng có chỗ nhập số lượng mint và mint, hiển thị thông báo khi mint thành công.
Hiển thị danh sách id các NFT người dùng đang sở hữu.
Người dùng có thể list(đăng bán) NFT, delist(hủy đăng bán) NFT, accept(chấp nhận lời đề nghị mua) NFT.
Người dùng có thể offer(đề nghị mua) NFT của người khác, làm đơn giản bằng cách nhập id và giá offer.
Hiển thị thông báo khi người dùng thao tác thành công, không thành công.

#Chạy chương trình:
-Deloy bằng Remix+Meta mask
-Contract address: 0xeEe1BC2c13c49118cB750Dbe4C1784052e0a79f9
-Testnet: Sepolia (11155111) network
-Thanh toán NFT bằng ETH
-Sử dụng vscode live share file index.html
-Kết nối với tài khoản MetaMask, ví
-Dùng sepolia faucet lấy ETH miễn phí để giao dịch
