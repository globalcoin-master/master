pragma solidity >= 0.5.0;

import './Ownable.sol';

contract MinterRole is Ownable {

    mapping (address => uint) public minters;
    mapping (address => uint) public minted;
    address[] public minterList;

    constructor() internal {
    }

    function getMintInfo(address account) public view returns (uint, uint)  {
      return (minters[account], minted[account]);
    }

    function allMinters() public view returns (address[] memory) {
      return minterList;
    }

    modifier onlyMinter() {
        require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
        _;
    }

    function isMinter(address account) public view returns (bool) {
        uint arrayLength = minterList.length;
        for (uint i = 0; i < arrayLength; i++) {
          if( account == minterList[i]) {
            return true;
          }
        }

        return false;
    }

    // 增加或修改
    function updateMinter(address account, uint limit) external onlyOwner {
      if (!isMinter(account)) {
        minterList.push(account);
      }
      minters[account] = limit;
    }

    function removeMinter(address account) external onlyOwner {
        require(isMinter(account), "not minter");
        minters[account] = 0;

        uint arrayLength = minterList.length;
        // 从数组中删除
        for (uint i = 0; i < arrayLength; i++) {
          if( account == minterList[i]) {
              if (i == arrayLength - 1) {
                  // 最后一个直接删除
                  minterList.pop();
                  break;
              } else {
                // 后面的元素往前移
                minterList[i] = minterList[arrayLength - 1];
                minterList.pop();
                break;
              }
          }
        }
    }

}
