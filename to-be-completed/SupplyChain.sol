// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

/*
    This exercise has been updated to use Solidity version 0.5
    Breaking changes from 0.4 to 0.5 can be found here: 
    https://solidity.readthedocs.io/en/v0.5.0/050-breaking-changes.html
*/

contract SupplyChain {
    /* set owner */
    address public owner;

    /* Add a variable called skuCount to track the most recent sku # */
    uint256 public skuCount;

    /* Add a line that creates a public mapping that maps the SKU (a number) to an Item.
     Call this mappings items
  */
    mapping(uint256 => Item) items;

    /* Add a line that creates an enum called State. This should have 4 states
    ForSale
    Sold
    Shipped
    Received
    (declaring them in this order is important for testing)
  */
    enum State {
        ForSale,
        Sold,
        Shipped,
        Received
    }

    /* Create a struct named Item.
    Here, add a name, sku, price, state, seller, and buyer
    We've left you to figure out what the appropriate types are,
    if you need help you can ask around :)
    Be sure to add "payable" to addresses that will be handling value transfer
  */
    struct Item {
        string name;
        uint256 sku;
        uint256 price;
        State state;
        address payable seller;
        address payable buyer;
    }
    /* Create 4 events with the same name as each possible State (see above)
    Prefix each event with "Log" for clarity, so the forSale event will be called "LogForSale"
    Each event should accept one argument, the sku */
    event LogForSale(uint256 sku);
    event LogSold(uint256 sku);
    event LogShipped(uint256 sku);
    event LogRecieved(uint256 sku);
    /* Create a modifer that checks if the msg.sender is the owner of the contract */
    modifier onlyOwner() {
        require(owner == msg.sender, "caller is not owner");
        _;
    }
    modifier verifyCaller(address _address) {
        require(msg.sender == _address);
        _;
    }

    modifier paidEnough(uint256 _price) {
        require(msg.value >= _price, "Insufficient Balance");
        _;
    }
    modifier checkValue(uint256 _sku) {
        //refund them after pay for item (why it is before, _ checks for logic before func)
        if (msg.value > items[_sku].price) {
            uint256 _price = items[_sku].price;
            payable(items[_sku].seller).transfer(msg.value - _price);
        } else {
            payable(items[_sku].seller).transfer(msg.value);
        }
        _;
    }

    /* For each of the following modifiers, use what you learned about modifiers
   to give them functionality. For example, the forSale modifier should require
   that the item with the given sku has the state ForSale. 
   Note that the uninitialized Item.State is 0, which is also the index of the ForSale value,
   so checking that Item.State == ForSale is not sufficient to check that an Item is for sale.
   Hint: What item properties will be non-zero when an Item has been added?
   */
    modifier forSale(uint256 _sku) {
        require(items[_sku].state == State.ForSale, "Item is not on sale");
        require(items[_sku].price != 0, "Sale price can't be zero");
        _;
    }
    modifier sold(uint256 _sku) {
        require(items[_sku].state == State.Sold, "Item is not sold");
        _;
    }

    modifier shipped(uint256 _sku) {
        require(items[_sku].state == State.Shipped, "Item is not shipped");
        _;
    }

    modifier recieved(uint256 _sku) {
        require(items[_sku].state == State.Received, "Item is not returned");
        _;
    }

    constructor() {
        /* Here, set the owner as the person who instantiated the contract
       and set your skuCount to 0. */
        owner = msg.sender;
        skuCount = 0;
    }

    function addItem(string memory _name, uint256 _price)
        public
        returns (bool)
    {
        emit LogForSale(skuCount);
        items[skuCount] = Item({
            name: _name,
            sku: skuCount,
            price: _price,
            state: State.ForSale,
            seller: payable(msg.sender),
            buyer: payable(address(0))
        });
        skuCount = skuCount + 1;
        return true;
    }

    /* Add a keyword so the function can be paid. This function should transfer money
    to the seller, set the buyer as the person who called this transaction, and set the state
    to Sold. Be careful, this function should use 3 modifiers to check if the item is for sale,
    if the buyer paid enough, and check the value after the function is called to make sure the buyer is
    refunded any excess ether sent. Remember to call the event associated with this function!*/

    function buyItem(uint256 sku) public {}

    /* Add 2 modifiers to check if the item is sold already, and that the person calling this function
  is the seller. Change the state of the item to shipped. Remember to call the event associated with this function!*/
    function shipItem(uint256 sku) public {}

    /* Add 2 modifiers to check if the item is shipped already, and that the person calling this function
  is the buyer. Change the state of the item to received. Remember to call the event associated with this function!*/
    function receiveItem(uint256 sku) public {}

    /* We have these functions completed so we can run tests, just ignore it :) */
    function fetchItem(uint256 _sku)
        public
        view
        returns (
            string memory name,
            uint256 sku,
            uint256 price,
            uint256 state,
            address seller,
            address buyer
        )
    {
        name = items[_sku].name;
        sku = items[_sku].sku;
        price = items[_sku].price;
        state = uint256(items[_sku].state);
        seller = items[_sku].seller;
        buyer = items[_sku].buyer;
        return (name, sku, price, state, seller, buyer);
    }
}
