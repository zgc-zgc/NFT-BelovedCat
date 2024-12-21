//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract BelovedCat is ERC721 {
    error BelovedCat__TokenDoesNotExist(uint256 tokenId);
    error BelovedCat__NotOwner(address caller);
    error BelovedCat__AlreadyMinted();

    enum CatType {
        BuBu,
        XiaoHei
    }

    uint256 private tokenCounter;

    mapping(uint256 => CatType) public s_belovedCat;

    string constant SVG_START =
        '<svg width="400" height="400" viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg">';
    string constant SVG_END = "</svg>";
    string constant BASE_IMAGE_URI = "data:image/svg+xml;base64,";
    string constant BASE_JSON_URI = "data:application/json;base64,";

    string constant STYLE_BLACK =
        "<style>.circle{fill:#000000;}.text{fill:#FFFFFF;font-family:Arial,sans-serif;font-size:64px;font-weight:bold;}</style>";
    string constant STYLE_WHITE =
        "<style>.circle{fill:#FFFFFF;stroke:#000000;stroke-width:2;}.text{fill:#000000;font-family:Arial,sans-serif;font-size:64px;font-weight:bold;}</style>";

    string constant CIRCLE_ELEMENT = '<circle class="circle" cx="200" cy="200" r="180"/>';

    constructor() ERC721("BelovedCat", "BCAT") {
        tokenCounter = 0;
    }

    function getBelovedCat(uint256 tokenId) public view returns (CatType) {
        if (_ownerOf(tokenId) == address(0)) revert BelovedCat__TokenDoesNotExist(tokenId);
        return s_belovedCat[tokenId];
    }

    function changeBelovedCat(uint256 tokenId) public {
        if (_ownerOf(tokenId) == address(0)) revert BelovedCat__TokenDoesNotExist(tokenId);
        if (_ownerOf(tokenId) != msg.sender) revert BelovedCat__NotOwner(msg.sender);

        if (s_belovedCat[tokenId] == CatType.BuBu) {
            s_belovedCat[tokenId] = CatType.XiaoHei;
        } else {
            s_belovedCat[tokenId] = CatType.BuBu;
        }
    }

    function generateCatSvg(uint256 tokenId) public view returns (string memory) {
        if (_ownerOf(tokenId) == address(0)) revert BelovedCat__TokenDoesNotExist(tokenId);

        string memory style = s_belovedCat[tokenId] == CatType.XiaoHei ? STYLE_BLACK : STYLE_WHITE;
        string memory name = s_belovedCat[tokenId] == CatType.XiaoHei ? "Xiao Hei" : "Bu Bu";
        string memory text =
            string(abi.encodePacked('<text class="text" x="200" y="220" text-anchor="middle">', name, "</text>"));

        string memory rawSvg = string(abi.encodePacked(SVG_START, style, CIRCLE_ELEMENT, text, SVG_END));

        return string(abi.encodePacked(BASE_IMAGE_URI, Base64.encode(bytes(rawSvg))));
    }

    function generateMetadata(uint256 tokenId) public view returns (string memory) {
        if (_ownerOf(tokenId) == address(0)) revert BelovedCat__TokenDoesNotExist(tokenId);

        string memory imageUri = generateCatSvg(tokenId);
        string memory name = s_belovedCat[tokenId] == CatType.XiaoHei ? "Xiao Hei" : "Bu Bu";
        string memory catType = s_belovedCat[tokenId] == CatType.XiaoHei ? "Black" : "White";

        return string(
            abi.encodePacked(
                BASE_JSON_URI,
                Base64.encode(
                    bytes(
                        string(
                            abi.encodePacked(
                                '{"name":"',
                                name,
                                " #",
                                Strings.toString(tokenId),
                                '","description":"A beloved cat","image":"',
                                imageUri,
                                '","attributes":[{"trait_type":"Type","value":"',
                                catType,
                                ' Cat"},{"trait_type":"Name","value":"',
                                name,
                                '"}]}'
                            )
                        )
                    )
                )
            )
        );
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (_ownerOf(tokenId) == address(0)) revert BelovedCat__TokenDoesNotExist(tokenId);
        return generateMetadata(tokenId);
    }

    function mint() public {
        _safeMint(msg.sender, tokenCounter);
        s_belovedCat[tokenCounter] = CatType.BuBu;
        tokenCounter += 1;
    }

    function mintSpecficTokenId(uint256 tokenId) public {
        if (_ownerOf(tokenId) != address(0)) revert BelovedCat__AlreadyMinted();
        _safeMint(msg.sender, tokenId);
        s_belovedCat[tokenCounter] = CatType.BuBu;
    }

    function getTokenCounter() public view returns (uint256) {
        return tokenCounter;
    }
}
