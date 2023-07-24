// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract MyToken is ERC1155, Ownable, ERC1155Supply {
    struct args {
        uint8 maxPerWallet;
        uint8 maxSupply;
        uint256 price;
    }
    mapping(string => args) private Collection;

    constructor() ERC1155("https://ipfs.io/ipfs/bafybeich7u4lv2zue2cqsxgqhtukdpwknjlftzng4on7tzx2tzyaw4caj4/") {
        Collection["Legendary"] = args(1, 10, 0.1 ether);
        Collection["Rare"] = args(5, 50, 0.05 ether);
        Collection["Common"] = args(10, 100, 0.02 ether);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount
    ) public payable {
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
                msg.value >= Collection["Legendary"].price * amount,
                "Insuficent amount"
            );
        } else if (id <= 12) {
            require(
                balanceOf(msg.sender, id) <
                    Collection["Rare"].maxPerWallet,
                "You have the limit of this NFTS"
            );
            require(
                totalSupply(id) <= Collection["Rare"].maxSupply + amount,
                "Cannot mint that ammount of nfts"
            );
            require(
                msg.value >= Collection["Rare"].price * amount,
                "Insuficent amount"
            );
        } else if (id <= 18) {
            require(
                balanceOf(msg.sender, id) <
                    Collection["Common"].maxPerWallet,
                "You have the limit of this NFTS"
            );
            require(
                totalSupply(id) <= Collection["Common"].maxSupply + amount,
                "Cannot mint that ammount of nfts"
            );
            require(
                msg.value >= Collection["Common"].price * amount,
                "Insuficent amount"
            );
        }

        _mint(account, id, amount, "");
    }

    function uri(uint256 _id) public view virtual override returns(string memory){
        require(exists(_id),"Invalid ID");
        return string(abi.encodePacked(super.uri(_id), Strings.toString(_id), ".json"));
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
