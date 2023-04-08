//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
import "../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Token is ERC20Capped , Ownable , ReentrancyGuard{
    constructor() ERC20("tenup" , "TUP") ERC20Capped(10*10**18)  {
        
    } 
    function minting (address _add, uint256 _amount)  external onlyOwner  {
       _mint(_add, _amount);
    }
    function transfer(address from, address to, uint256 amount) external nonReentrant {
        _transfer(from, to, amount);
        }
    function apporve(address _spender, uint256 _amount) external {
        _approve(msg.sender, _spender, _amount);
    }

     function burn(uint256 amount) public virtual onlyOwner {
        _burn(_msgSender(), amount);
    }
      function burnFrom(address account, uint256 amount) public virtual {
        _spendAllowance(account, _msgSender(), amount);
        _burn(account, amount);
    }
    
}

