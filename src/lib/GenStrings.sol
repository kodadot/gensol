// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

/**
 * @dev Creating strings from bytes.
 */
library GenStrings {
    bytes16 private constant HEX_DIGITS = "0123456789abcdef";

    function toHexString(bytes32 _bytes) internal pure returns (string memory) {
        bytes memory _string = new bytes(66);
        _string[0] = "0";
        _string[1] = "x";
        for (uint256 i = 0; i < 32; i++) {
            _string[i * 2 + 2] = HEX_DIGITS[uint8(_bytes[i] >> 4)];
            _string[1 + i * 2 + 2] = HEX_DIGITS[uint8(_bytes[i] & 0x0f)];
        }
        return string(_string);
    }
}
