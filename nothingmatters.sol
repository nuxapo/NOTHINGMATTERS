// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract NOTHINGMATTERS is ERC20, Ownable, Pausable {
    mapping(address => bool) private _blacklist;

    event Blacklisted(address indexed account);
    event Unblacklisted(address indexed account);
    event TokensBurned(address indexed account, uint256 amount);

    constructor(uint256 initialSupply) ERC20("NOTHINGMATTERS", "NMT") {
        _mint(msg.sender, initialSupply);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function blacklist(address account) external onlyOwner {
        _blacklist[account] = true;
        emit Blacklisted(account);
    }

    function unblacklist(address account) external onlyOwner {
        _blacklist[account] = false;
        emit Unblacklisted(account);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }

    function isBlacklisted(address account) external view returns (bool) {
        return _blacklist[account];
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override whenNotPaused {
        require(!_blacklist[from], "NOTHINGMATTERS: sender is blacklisted");
        require(!_blacklist[to], "NOTHINGMATTERS: recipient is blacklisted");
        super._beforeTokenTransfer(from, to, amount);
    }
}
