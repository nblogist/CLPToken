pragma solidity ^0.4.24;

interface IERC20Token {
    function balanceOf(address owner) public returns (uint256);
    function transfer(address to, uint256 amount) public returns (bool);
    function decimals() public returns (uint256);
}


import "chainlink/contracts/ChainlinkClient.sol";



contract TokenSale is ChainlinkClient  {
    IERC20Token public tokenContract;
    uint public price; //in wei //to be changed by the Coin Market Cap API BY CHAINLINK
    address owner;


    constructor (IERC20Token _tokenContract, uint _price,uint256 _oraclePayment) public{
        owner=msg.sender;
        tokenContract = _tokenContract;
        price = _price;
        setPublicChainlinkToken();
        oraclePayment = _oraclePayment;
    }
/*
    //COIN MARKET CAP ORACLE
    uint256 oraclePayment;

    function requestCoinMarketCapPrice
    (
    address _oracle,
    bytes32 _jobId,
    string _coin,
    string _market
    ) 
    public
    onlyOwner
    {
    Chainlink.Request memory req = buildChainlinkRequest(_jobId, this, this.fulfill.selector);
    req.add("sym", _coin);
    req.add("convert", _market);
    string[] memory path = new string[](5);
    path[0] = "data";
    path[1] = _coin;
    path[2] = "quote";
    path[3] = _market;
    path[4] = "price";
    req.addStringArray("copyPath", path);
    req.addInt("times", 100);
    sendChainlinkRequestTo(_oracle, req, oraclePayment);
    }
    uint256 public currentPrice;

    function fulfill(bytes32 _requestId, uint256 _price) public
    recordChainlinkFulfillment(_requestId)
    {
        currentPrice = _price;
    }

*/
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    uint256 public tokensSold;

    event Sold(address buyer, uint256 amount) //BROADCASTS The sale of tokens

    function buyCLPToken(uint numberOfTokens) public payable {
        require(msg.value == safeMul(numberOfTokens, price));//ADD SOME COIN MARKET CAP LOGIC HERE
        uint scaledAmount = safeMul(numberOfTokens, uint256(10) ** tokenContract.decimals());
        require(tokenContract.balanceOf(this) >= scaledAmount);
        emit Sold(msg.sender, numberOfTokens);
        tokenSold += numberOfTokens;
        require(tokeContract.transfer(msg.sender,scaledAmount));
    }

    function endSale() public {
        require((msg.sender == owner));
        require(tokenContract.transfer(owner,tokenContract.balanceOf(this)));
        msg.sender.transfer(address(this).balance);
    }
    //
    function CoinMarketCapData() returns (uint) {
        
    }
}