pragma solidity >= 0.5.0;

import './basic/ERC20.sol';
import "./lib/SafeMath.sol";
import './basic/ERC20Detailed.sol';
import "./lib/Address.sol";
import "./basic/ReentrancyGuard.sol";
// import "@nomiclabs/buidler/console.sol";

interface TokenRecipient {
  // must return true
  function tokensReceived(
    address from,
    uint amount,
    bytes calldata exData
  ) external returns (bool);
}


//contract GoodCoin is ERC20 , ERC20Detailed("Good Coin", "GoodCoin", 6) {
contract GlobalCoin is ERC20 , ERC20Detailed("Global Coin", "GlobalCoin", 6),ReentrancyGuard {

  using SafeMath for uint256;
  using Address for address;
  address public owner;

  constructor() public {
    _mint(msg.sender, 380000000000 * 10 ** 6);
    owner = msg.sender;
  }

  // 直接数组转为地址
  function bytesToAddress(bytes memory bys) internal pure returns (address addr) {
    assembly {
      addr := mload(add(bys,20))
    }
  }
  function send(address recipient, uint256 amount, bytes calldata exData) external nonReentrant returns (bool) {
    _transfer(msg.sender, recipient, amount);
    // console.log('transfer end');

    if (recipient.isContract()) {  //验证是否为合约
      bool rv = TokenRecipient(recipient).tokensReceived(msg.sender, amount, exData);
      require(rv, "tokensReceived not found");
    }
    return true;
  }

  function burn(uint256 amount) public {
    _burn(msg.sender, amount);
  }

  function burnFrom(address account, uint256 amount) public {
    _burnFrom(account, amount);
  }
}
