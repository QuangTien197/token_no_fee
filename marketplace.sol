// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8 .20;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

contract NFTMarketplace is ERC721URIStorage, IERC721Receiver {

    using Counters
    for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;
    Counters.Counter private _itemsBid;
    // NftMarketPlace
    uint256 listingPrice = 1000000000000000000;
    address payable owner;

    mapping(uint256 => MarketItem) private idToMarketItem;

    struct MarketItem {
        uint256 tokenId;
        address seller;
        address owner;
        uint256 price;
        bool sold;
        bool bid;
        bool list;
    }

    event MarketItemCreated(
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    event NftAuctionCreated(
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price
    );


    //Auction
    uint256 public startingPrice = 10000000;
    uint256 public discountRate = 110;
    uint256 public startAt = block.timestamp + (7 days);

    /*auction information*/
    struct AuctionInfo {
        address seller;
        uint256 _tokenId;
        uint256 startingPrice;
        address previousBidder;
        uint256 lastBid;
        address lastBidder;
        uint256 startAt;
        uint256 expiresAt;
        bool completed;
        bool active;
        uint256 auctionId;
    }

    AuctionInfo[] private auction;

    IERC20 private token;
    using SafeERC20 for IERC20;

    constructor() ERC721("O-TI", "OTI") { //address _token
        owner = payable(msg.sender);
        token = IERC20(0xACAF2Bb6C435B3740c1e76cc1f17B87dbd2f9723);
    }

    /* onERC721Received*/
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns(bytes4) {
        return
        bytes4(
            keccak256("onERC721Received(address,address,uint256,bytes)")
        );
    }

    /* Updates the listing price of the contract */
    function updateListingPrice(uint256 _listingPrice) public payable {
        require(
            owner == msg.sender,
            "Only marketplace owner can update listing price."
        );
        listingPrice = _listingPrice;
    }

    /* Returns the listing price of the contract */
    function getListingPrice() public view returns(uint256) {
        return listingPrice;
    }

    /* Mints a token and lists it in the marketplace */
    function createToken(
        string memory tokenURI,
        uint256 price
    ) public returns(uint256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        createMarketItem(newTokenId, price);
        return newTokenId;
    }

    /* Mints a token and lists it in the marketplace */
    function createMarketItem(uint256 tokenId, uint256 price) private {
        require(price > 0, "Price must be at least 1 wei");
        require(
            token.balanceOf(msg.sender) >= listingPrice,
            "Insufficient token balance"
        );
        
        idToMarketItem[tokenId] = MarketItem(
            tokenId,
            msg.sender,
            address(this),
            price,
            false,
            false,
            true
        );
        token.transferFrom(msg.sender,  address(this), listingPrice);
        _transfer(msg.sender, address(this), tokenId);
        emit MarketItemCreated(
            tokenId,
            msg.sender,
            address(this),
            price,
            false
        );
    }

    /* allows someone to resell a token they have purchased */
    function resellToken(uint256 tokenId, uint256 price) public  {
        require(
            idToMarketItem[tokenId].owner == msg.sender,
            "Only item owner can perform this operation"
        );
        // require(
        //     msg.value == listingPrice,
        //     "Price must be equal to listing price"
        // );
        require(
            idToMarketItem[tokenId].bid == false && idToMarketItem[tokenId].list == false,
            "Not the right trading market"
        );

        idToMarketItem[tokenId].sold = false;
        idToMarketItem[tokenId].price = price;
        idToMarketItem[tokenId].list = true;
        idToMarketItem[tokenId].seller = msg.sender;
        idToMarketItem[tokenId].owner = address(this);
        _itemsSold.decrement();
        _transfer(msg.sender, address(this), tokenId);
    }

    /* Creates the sale of a marketplace item */
    /* Transfers ownership of the item, as well as funds between parties */
    function createMarketSale(uint256 tokenId) public  {
        uint256 price = idToMarketItem[tokenId].price;
        require(
            token.balanceOf(msg.sender) >= price,
            "Insufficient token balance"
        );
        require(
            idToMarketItem[tokenId].list == true && idToMarketItem[tokenId].bid == false,
            "Not the right trading market"
        );
        token.transferFrom(msg.sender,  idToMarketItem[tokenId].seller, price);
        idToMarketItem[tokenId].owner = msg.sender;
        idToMarketItem[tokenId].sold = true;
        idToMarketItem[tokenId].seller = address(0);
        idToMarketItem[tokenId].list = false;
        _itemsSold.increment();
        _transfer(address(this), msg.sender, tokenId);
        
    }

    /* Change price market items */
    function updateListPriceNFT(uint256 tokenId, uint256 price) public {
        require(
            idToMarketItem[tokenId].seller == msg.sender &&
            idToMarketItem[tokenId].owner == address(this),
            "Only item owner can perform this operation"
        );
        require(price > 0, "Price must be at least 1 wei");
        require(
            idToMarketItem[tokenId].list == true && idToMarketItem[tokenId].bid == false,
            "Not the right trading market"
        );
        idToMarketItem[tokenId].price = price;
     
    }

    function unlistNFT(uint256 tokenId) public {
        require(
            idToMarketItem[tokenId].seller == msg.sender &&
            idToMarketItem[tokenId].owner == address(this),
            "Only item owner can perform this operation"
        );
        require(
            idToMarketItem[tokenId].list == true && idToMarketItem[tokenId].bid == false,
            "Not the right trading market"
        );
        idToMarketItem[tokenId].owner = msg.sender;
        idToMarketItem[tokenId].sold = false;
        idToMarketItem[tokenId].seller = address(0);
        idToMarketItem[tokenId].list = false;
        _itemsSold.increment();
        _transfer(address(this), msg.sender, tokenId);

    }

    /* TransferNFT market items */
    function TransferNFT(address to, uint256 tokenId) public {
        require(
            idToMarketItem[tokenId].owner == msg.sender,
            "Only item owner can perform this operation"
        );
        require(
            idToMarketItem[tokenId].list == false && idToMarketItem[tokenId].bid == false,
            "Not the right trading market"
        );
        require(to != address(0), "Invalid address");
        idToMarketItem[tokenId].owner = to;
        _transfer(msg.sender, to, tokenId);
    }

    /* Returns all unsold market items */
    function fetchMarketItems() public view returns(MarketItem[] memory) {
        uint256 totalItemCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == address(this) ) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == address(this)) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    /* Returns all unsold market items */
    function fetchMarketItemsList() public view returns(MarketItem[] memory) {
        uint256 itemCount = _tokenIds.current();
        uint256 unsoldItemCount = _tokenIds.current() - _itemsSold.current();

        uint256 currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        for (uint256 i = 0; i < itemCount; i++) {
            if (idToMarketItem[i + 1].owner == address(this) && idToMarketItem[i + 1].list == true && idToMarketItem[i + 1].bid == false) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    function fetchMarketItemsAuction() public view returns(MarketItem[] memory) {
        uint256 totalItemCount = _tokenIds.current();
        uint256 itemCount = 0;
        // uint256 itemCount = _tokenIds.current();
        // uint256 unsoldItemCount = _tokenIds.current() - _itemsBid.current();
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == address(this)  && idToMarketItem[i + 1].bid == true && idToMarketItem[i + 1].list == false) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == address(this) && idToMarketItem[i + 1].list == false && idToMarketItem[i + 1].bid == true) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    /* Returns only items that a user has purchased */
    function fetchMyNFTs() public view returns(MarketItem[] memory) {
        uint256 totalItemCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == msg.sender ) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == msg.sender) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

        /* Returns only items that a user has purchased */
    function fetchMySellNFTs(address _sell) public view returns(MarketItem[] memory) {
        uint256 totalItemCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == _sell ) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == _sell) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }


    /* Returns only items a user has listed */

    function fetchItemsListed() public view returns(MarketItem[] memory) {
        uint256 totalItemCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].seller == msg.sender && idToMarketItem[i + 1].bid == false && idToMarketItem[i + 1].list == true) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].seller == msg.sender && idToMarketItem[i + 1].bid == false && idToMarketItem[i + 1].list == true) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }
    /* Returns only items a user has listed */
    function fetchSellItemsListed(address _sell) public view returns(MarketItem[] memory) {
        uint256 totalItemCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].seller == _sell && idToMarketItem[i + 1].bid == false && idToMarketItem[i + 1].list == true) {
                itemCount += 1;
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].seller == _sell && idToMarketItem[i + 1].bid == false && idToMarketItem[i + 1].list == true) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }


    function fetchItemsAuction() public view returns(MarketItem[] memory) {
        uint256 totalItemCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].seller == msg.sender && idToMarketItem[i + 1].bid == true && idToMarketItem[i + 1].list == false) {
                itemCount += 1;
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].seller == msg.sender && idToMarketItem[i + 1].bid == true && idToMarketItem[i + 1].list == false) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    function fetchSellItemsAuction(address _sell) public view returns(MarketItem[] memory) {
        uint256 totalItemCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].seller == _sell && idToMarketItem[i + 1].bid == true && idToMarketItem[i + 1].list == false) {
                itemCount += 1;
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].seller == _sell && idToMarketItem[i + 1].bid == true && idToMarketItem[i + 1].list == false) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }


    function createAuction(
        uint256 _tokenId,
        uint256 _startingPrice,
        // uint256 _startAt,
        uint256 _expiresAt
    ) public {
        // require(block.timestamp <= _startAt, "Auction can not start");
        require(
            block.timestamp < _expiresAt,
            "Auction can not end before it starts"
        );
        require(
            0 < _startingPrice,
            "Initial price must be greater than 0"
        );

        require(idToMarketItem[_tokenId].owner == msg.sender && idToMarketItem[_tokenId].bid == false && idToMarketItem[_tokenId].list == false, "Must stake your own token");



        // Transfer ownership to the auctioneer
        safeTransferFrom(msg.sender, address(this) , _tokenId);

        idToMarketItem[_tokenId].price = _startingPrice;
        idToMarketItem[_tokenId].bid = true;
        idToMarketItem[_tokenId].seller = msg.sender;
        idToMarketItem[_tokenId].owner = address(this);
     
        AuctionInfo memory _auction = AuctionInfo(
            msg.sender, // seller
            _tokenId, // _tokenId
            _startingPrice, // startingPrice
            address(0), // previousBidder
            _startingPrice, // lastBid
            address(0), // lastBidder
            block.timestamp, // startAt
            _expiresAt, // expiresAt
            false, // completed
            true, // active
            auction.length // auctionId
        );
        auction.push(_auction);
    }


    function joinAuction(uint256 _auctionId, uint256 _bid) public  {
        AuctionInfo memory _auction = auction[_auctionId];

        require(
            block.timestamp >= _auction.startAt,
            "Auction has not started"
        );
        require(_auction.completed == false, "Auction is already completed");
        require(_auction.active == true, "Auction is not active");

        uint256 _minBid = _auction.lastBidder == address(0)? _auction.startingPrice: (_auction.lastBid * discountRate) / 100;

        require(
            _minBid <= _bid,
            "Bid price must be greater than the minimum price"
        );
        require(token.balanceOf(msg.sender) >= _bid, "Insufficient balance");
        require(
            token.allowance(msg.sender, address(this)) >= _bid,
            "Insufficient allowance"
        );

        require(_auction.lastBidder != msg.sender, "You have already bid on this auction");

        require(
            _auction.seller != msg.sender,
            "Can not bid on your own auction"
        );
        uint256 _tokenId = _auction._tokenId;
        // Next bidder transfer token to contract
        SafeERC20.safeTransferFrom(token, msg.sender, address(this), _bid);

        // Refund token to previous bidder
        if (_auction.lastBidder != address(0)) {
            token.transfer(_auction.lastBidder, _auction.lastBid);
        }

        // Update auction info
        auction[_auctionId].previousBidder = _auction.lastBidder;
        auction[_auctionId].lastBidder = msg.sender;
        auction[_auctionId].lastBid = _bid;
        
        // Update auction info
        idToMarketItem[_tokenId].price = _bid;


    }

 
function getAuctionByTokenIdPresent(uint256 _tokenId) public view returns (AuctionInfo memory) {
    AuctionInfo memory foundAuction;
    for (uint256 i = 0; i < auction.length; i++) {
        if (auction[i]._tokenId == _tokenId && auction[i].active == true) {
            foundAuction = auction[i];
            break;
        }
    }
    // Kiểm tra nếu không tìm thấy đấu giá với tokenId tương ứng và active là true
    require(foundAuction._tokenId != 0, "No auction found for the given tokenId");
    return foundAuction;
}
     
    // function getAuctionByTokenId(uint256 _tokenId) public view returns (AuctionInfo memory) {
    //     AuctionInfo memory foundAuction;
    //     for (uint256 i = 0; i < auction.length; i++) {
    //         if (auction[i]._tokenId == _tokenId) {
    //             foundAuction = auction[i];
    //             break;
    //         }
    //     }
    //     return foundAuction;
    // }

    function getAuctionByAuctionId(uint256 _auctionId) public view returns (AuctionInfo memory) {
        require(_auctionId < auction.length, "Invalid index");
        return auction[_auctionId];
    }

    function getAuctionByStatus(
        bool _active
    ) public view returns (AuctionInfo[] memory) {
        uint length = 0;
        for (uint i = 0; i < auction.length; i++) {
            if (auction[i].active == _active) {
                length++;
            }
        }

        AuctionInfo[] memory results = new AuctionInfo[](length);
        uint j = 0;
        for (uint256 index = 0; index < auction.length; index++) {
            if (auction[index].active == _active) {
                results[j] = auction[index];
                j++;
            }
        }
        return results;
    }

    function finishAuction(
        uint256 _auctionId
    ) public onlyAuctioneer(_auctionId) {
        require(
            auction[_auctionId].completed == false,
            "Auction is already completed"
        );
        require(auction[_auctionId].active, "Auction is not active");

        // Transfer NFT to winner which is the last bidder
        _transfer(address(this), auction[_auctionId].lastBidder, auction[_auctionId]._tokenId);
        
        uint256 _tokenId = auction[_auctionId]._tokenId;
        // Calculate all fee
        uint256 lastBid = auction[_auctionId].lastBid;

        // SafeERC20.safeTransferFrom(token, address(this), auction[_auctionId].seller, lastBid);
        token.transfer(auction[_auctionId].seller, lastBid);

        auction[_auctionId].completed = true;
        auction[_auctionId].active = false;


        // Update auction info
        idToMarketItem[_tokenId].owner = auction[_auctionId].lastBidder;
        idToMarketItem[_tokenId].sold = true;
        idToMarketItem[_tokenId].seller = address(0);
        idToMarketItem[_tokenId].list = false;
        idToMarketItem[_tokenId].bid = false;
        idToMarketItem[_tokenId].price = lastBid;
    }

    function cancelAuction(
        uint256 _auctionId
    ) public onlyAuctioneer(_auctionId) {
        require(
            auction[_auctionId].completed == false,
            "Auction is already completed"
        );
        require(auction[_auctionId].active, "Auction is not active");
        uint256 _tokenId = auction[_auctionId]._tokenId;
        // Return NFT back to auctioneer
        _transfer(address(this), auction[_auctionId].seller, auction[_auctionId]._tokenId);
        // Refund token to previous bidder
        if (auction[_auctionId].lastBidder != address(0)) {
            token.transfer(
                auction[_auctionId].lastBidder,
                auction[_auctionId].lastBid
            );
        }
        auction[_auctionId].completed = true;
        auction[_auctionId].active = false;

          // Update auction info
        idToMarketItem[_tokenId].owner = auction[_auctionId].seller;
        idToMarketItem[_tokenId].sold = false;
        idToMarketItem[_tokenId].seller = address(0);
        idToMarketItem[_tokenId].list = false;
        idToMarketItem[_tokenId].bid = false;
        idToMarketItem[_tokenId].price = auction[_auctionId].lastBid;
    }

    modifier onlyAuctioneer(uint256 _auctionId) {
        require(msg.sender == auction[_auctionId].seller,"Only auctioneer or owner can perform this action");
        _;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721URIStorage) returns(bool) {
        return super.supportsInterface(interfaceId);
    }
}