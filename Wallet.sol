//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract wallet is Ownable , ReentrancyGuard {
    
    using SafeMath for uint256;
    struct token {
        bytes32 ticker ;
        address tokenAddress;
    }
    bytes32[] public tokenList;

    mapping(bytes32 => token ) public tokenMapping;

    mapping(address =>mapping(bytes32 => uint256)) public balances  ;
    

    function addToken(bytes32 ticker, address tokenAddress) external onlyOwner {
        tokenMapping[ticker] = token(ticker, tokenAddress);
        tokenList.push(ticker);
        emit addTokenEvent(ticker, tokenAddress);
    }

    function deposite(uint256 amount,bytes32 ticker ) external nonReentrant   {
        require(tokenMapping[ticker].tokenAddress != address(0));
        IERC20(tokenMapping[ticker].tokenAddress).transferFrom(msg.sender, address(this), amount);
        balances[msg.sender][ticker] = balances[msg.sender][ticker].add(amount);
        emit depositTokens(amount, ticker, msg.sender);
    }

    function withdraw(uint256 amount, bytes32 ticker) external nonReentrant  {
        require(tokenMapping[ticker].tokenAddress != address(0), "token not listed");
        require(balances[msg.sender][ticker] >= amount , "balance not sufficient");
        IERC20(tokenMapping[ticker].tokenAddress).transfer(msg.sender, amount);
        balances[msg.sender][ticker] = balances[msg.sender][ticker].sub(amount);
        emit withdrawTokens(amount, ticker, msg.sender);
        
    }


    event addTokenEvent(bytes32 _ticker, address _tokenAddress);
    event depositTokens(uint256 _amount, bytes32 _ticker, address _depositAddress);
    event withdrawTokens(uint256 _amount, bytes32 _ticker, address _withdrawalAddress);
}