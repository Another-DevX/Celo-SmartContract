// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyToken is ERC1155, Ownable, ERC1155Supply {
    struct args {
        uint8 maxPerWallet;
        uint8 maxSupply;
        uint256 price;
    }
    mapping(string => args) private Collection;
    IERC20 public tokenAddress;

    constructor(address _tokenAddress)
        ERC1155(
            "https://ipfs.io/ipfs/bafybeich7u4lv2zue2cqsxgqhtukdpwknjlftzng4on7tzx2tzyaw4caj4/"
        )
    {
        Collection["Legendary"] = args(1, 10, 100 * 10 ** 18);
        Collection["Rare"] = args(5, 50, 25 * 10 ** 18);
        Collection["Common"] = args(10, 100, 1 * 10 ** 18);
        tokenAddress = IERC20(_tokenAddress);
    }

    function sendCUSD() public returns (bool) {
        tokenAddress.transferFrom(msg.sender, address(this), 1 * 10**18);
        return true;
    }

    function uri(uint256 _id)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(exists(_id), "Invalid ID");
        return
            string(
                abi.encodePacked(super.uri(_id), Strings.toString(_id), ".json")
            );
    }

    function mint(uint256 id, uint256 amount) external {
        require(id != 0 && id <= 18, "Invalid ID");
        if (id <= 6) {
            require(
                balanceOf(msg.sender, id) <
                    Collection["Legendary"].maxPerWallet,
                "You have the limit of this NFTS"
            );
            require(
                totalSupply(id) <= Collection["Legendary"].maxSupply + amount,
                "Cannot mint that ammount of nfts"
            );
            require(
                IERC20(tokenAddress).balanceOf(msg.sender) >=
                    Collection["Legendary"].price * amount,
                "Insuficent amount"
            );
            IERC20(tokenAddress).transfer(
                address(this),
                Collection["Legendary"].price * amount
            );
        } else if (id <= 12) {
            require(
                balanceOf(msg.sender, id) < Collection["Rare"].maxPerWallet,
                "You have the limit of this NFTS"
            );
            require(
                totalSupply(id) <= Collection["Rare"].maxSupply + amount,
                "Cannot mint that ammount of nfts"
            );
            require(
                IERC20(tokenAddress).balanceOf(msg.sender) >=
                    Collection["Rare"].price * amount,
                "Insuficent amount"
            );
            IERC20(tokenAddress).transfer(
                address(this),
                Collection["Rare"].price * amount
            );
        } else if (id <= 18) {
            require(
                balanceOf(msg.sender, id) < Collection["Common"].maxPerWallet,
                "You have the limit of this NFTS"
            );
            require(
                totalSupply(id) <= Collection["Common"].maxSupply + amount,
                "Cannot mint that ammount of nfts"
            );
            require(
                IERC20(tokenAddress).balanceOf(msg.sender) >=
                    Collection["Common"].price * amount,
                "Insuficent amount"
            );
            IERC20(tokenAddress).transferFrom(
                msg.sender,
                address(this),
                Collection["Common"].price * amount
            );
        }
        _mint(msg.sender, id, amount, "");
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
