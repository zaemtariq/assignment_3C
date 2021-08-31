pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/83644fdb6a9f75a652d2fe2d96cb26073a14f6f8/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/Pausable.sol";

// SPDX-License-Identifier: MIT


// Name: Zaeem Tariq
// Assignment 3C
// Roll.No: PIAIC79218

contract ASSGNMT_ERC20 is ERC20,Ownable,Pausable{
    using SafeMath for uint;
    uint public cap;
    uint currentDate;
    uint256 public curentTime;
    uint256 public timelimit;
    uint256 public token_Price_Per_Ether;
     mapping (address => uint256) private _balances;
    
    mapping(address => address) public Managers;
    
    constructor() ERC20("DemoToken","er20"){
        uint InitialSupply = 10000 * ( 10 ** uint(decimals()));
        cap = InitialSupply.mul(2);
        _mint(msg.sender, InitialSupply);
        curentTime = block.timestamp; 
        timelimit = 0;
        _balances[owner()]= balanceOf(owner());
        token_Price_Per_Ether=100;
    }
    
    function generateToken(address account,uint amount) public whenNotPaused onlyOwner{
        require(curentTime > timelimit, "You can not Transfer Token util time exceeds.");
        require(account != address(0),"INVALID ADDRESS");
        require(amount >0, "Enter amount");
        require(totalSupply().add(amount) < cap, "OverFlow");
        _mint(account,amount);
    }
    
    // modifier to check that only owner and Managers can change price of token
    modifier onlyMangeronlyOwner(){
        address man= Managers[owner()];
        require(owner()==msg.sender|| msg.sender == man,"Only Owner and Manager can change the token Price");
        _;
    }
    
    
    //function to _unpause the transferTokens
    function startTran() public whenPaused onlyOwner{
        _unpause();
    }
    
    //function to pause the transferTokens
    function stopTran() public whenNotPaused onlyOwner{
        _pause();
    }
    
    
    function transferTokens(address receiver, uint amount) public{
       // address own = owner();
        transfer(receiver, amount);
    }
    
    //function to set limit for token transfer
    function setTimeLimitForTransaction(uint256 numOfDays) public onlyOwner{
        timelimit = block.timestamp + (numOfDays * 1 days );
    }
    
    //function to tranfer the ownership of Tokens
    function transferTokenOwnerhsip (address newOwner) public onlyOwner{
        transferOwnership ( newOwner );
    }
    
       modifier notOwner {
        require(msg.sender != owner(),"Your already Owner u can  not do this task.");
        _;
    }
    
    //function to buy tokens
      function buy_Token() external payable notOwner{
        require(msg.value >= 1 ether, "NOT SUFFICIENT BALANCE.");
        (payable(owner())).transfer(msg.value);
    uint256 guu= token_Price_Per_Ether * (msg.value/(10 ** uint(decimals())) );
   // guu * (10 ** uint(decimals()));
        _balances[owner()] = _balances[owner()] - guu * (10 ** uint(decimals()));
        _balances[msg.sender] = _balances[msg.sender] + guu * (10 ** uint(decimals()));
    }
    
    
    // function to get tokens refunds
    
    function getTokensRefunds()public payable notOwner{
        require(_balances[msg.sender]>= 100, "Not SUFFICIENT tokens");
        
    _balances[owner()] =_balances[owner()] + _balances[msg.sender];
        _balances[msg.sender] = 0;
        
     //   (payable(msg.sender)).transfer()
        
    
//        (payable(owner)).transfer(msg.value);
    }
    
    function setTokenPrice(uint256 newTokenPrice) public onlyMangeronlyOwner {
        token_Price_Per_Ether=newTokenPrice;
    }
    
    
    //function to set the token price manager
    function setAccountManager(address manager) public onlyOwner{
        Managers[owner()] = manager;
    }
    
    
    
    
    function check_token_balance() view public onlyOwner returns(uint256) {
    
   return balanceOf(msg.sender);
    
    }
    

}

