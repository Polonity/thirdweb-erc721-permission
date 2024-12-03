// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC721Base.sol";
import "@thirdweb-dev/contracts/extension/Permissions.sol";

contract ERC721Permissions is ERC721Base, Permissions {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    modifier onlyAdmin() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "ERC721Permissions: must have admin role to perform this action");
        _;
    }

    modifier onlyMinter() {
        require(hasRole(MINTER_ROLE, msg.sender), "ERC721Permissions: must have minter role to mint");
        _;
    }

      constructor(
        address _defaultAdmin,
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps
    )
        ERC721Base(
            _defaultAdmin,
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps
        )
    {
        // Set the minter role to the default admin
        _setupRole(MINTER_ROLE, _defaultAdmin);
    }

    function mint(
        address _to,
        string memory _tokenURI
    ) public onlyRole(MINTER_ROLE) {
        mintTo(_to, _tokenURI);
    }

    /**
     * @dev Set the minter role
     * @param _minter the minter address
     */
    function setMinter(address _minter) public onlyAdmin {
        _setupRole(MINTER_ROLE, _minter);

        emit RoleGranted(MINTER_ROLE, _minter, msg.sender);
    }

    /**
     * @dev Remove the minter role
     * @param _minter the minter address
     */
    function removeMinter(address _minter) public onlyAdmin {
        _revokeRole(MINTER_ROLE, _minter);

        emit RoleRevoked(MINTER_ROLE, _minter, msg.sender);
    }

    /**
     * @dev Check if the address has the minter role
     * @param _minter the minter address
     */
    function hasMinterRole(address _minter) public view returns (bool) {
        return hasRole(MINTER_ROLE, _minter);
    }


}