
contract TokenSwapper {
    ERC20 tokenA; // gives this token
    ERC20 tokenB; // takes this token
    
    constructor(ERC20 tokenToSwap) public {
        // create the token to give
        // (mints this contract an initial balance) 
        tokenA = new ERC20();
        // assign the token to take
        tokenB = tokenToSwap;
    }
    
    // swaps one of token A for one of token B.
    function swap() public returns (bool) {
        // take one of token B from the caller (NEEDS APPROVAL)
        tokenB.transferFrom(msg.sender, address(this), 1);
        
        // give the caller one of token A in return.
        tokenA.transfer(msg.sender, 1);
      
        return true;
    }
}

interface ITokenSwapper {
    function swap() external returns (bool);
}
interface IERC20 {
    function approve(address spender, uint256 amount)
      external returns (bool);
}
// deploy this "transaction" contract to the home address.
contract ApproveAndTransferFrom {
    constructor(s
        ITokenSwapper tokenSwapper,
        IERC20 tokenToSwap
    ) public {
        // approve the swapper to transfer for you.
        require(tokenToSwap.approve(address(tokenSwapper), 1));
        // make the swap.
        require(tokenSwapper.swap());
        // clean up the code here so we can use it again...
        // and DO NOT set address(this) as the recipient!!
        selfdestruct(tx.origin);
    }
}