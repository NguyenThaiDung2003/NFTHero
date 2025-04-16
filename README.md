Tạo contract Hero NFT(ERC721):
Giới hạn 1000 NFT bao gồm 600 common, 300 rare, 90 legendary, 10 mythical tương ứng với độ hiếm.<br>
Hero có các chỉ số Strength, Agility, Intelligence ngẫu nhiên có giá trị giới hạn trong khoảng từ 10 -> 100.<br>
Giá mint 0.001ETH/1NFT, mỗi ví được mint tổng tối đa 10NFT, tỉ lệ độ hiếm ra ngẫu nhiên.<br>
Người dùng có thể list(đăng bán) NFT, delist(hủy đăng bán) NFT, accept(chấp nhận lời đề nghị mua) NFT.<br>
Người dùng có thể offer(đề nghị mua) NFT của người khác.<br>
Ghi lại các sự kiện mint, list, delist, offer, accept NFT.<br>
Tạo trang web chợ quản lý tương tác với contract:<br>
Kết nối ví(Metamask, okx, ...). <br>
Người dùng có chỗ nhập số lượng mint và mint, hiển thị thông báo khi mint thành công.<br>
Hiển thị danh sách id các NFT người dùng đang sở hữu.<br>
Người dùng có thể list(đăng bán) NFT, delist(hủy đăng bán) NFT, accept(chấp nhận lời đề nghị mua) NFT.<br>
Người dùng có thể offer(đề nghị mua) NFT của người khác, làm đơn giản bằng cách nhập id và giá offer.<br>
Hiển thị thông báo khi người dùng thao tác thành công, không thành công.<br>

#Chạy chương trình:<br>
-Deloy bằng Remix+Meta mask<br>
-Contract address: 0xeEe1BC2c13c49118cB750Dbe4C1784052e0a79f9<br>
-Testnet: Sepolia (11155111) network<br>
-Thanh toán NFT bằng ETH<br>
-Sử dụng vscode live share file index.html<br>
-Kết nối với tài khoản MetaMask, ví<br>
-Dùng sepolia faucet lấy ETH miễn phí để giao dịch<br>
