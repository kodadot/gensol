// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

/**
 * @dev Splitting amount of tokens / values to
 */
//  https://stackoverflow.com/questions/69864342/splitting-eth-when-transferring
library Split {
    // example I want 90% of 1000
    function calculateAmount(uint256 amount, uint256 percentage) internal pure returns (uint256) {
        assert(percentage <= 100);
        if (percentage == 0) {
            return 0;
        }
        if (percentage == 100) {
            return amount;
        }
        return amount * percentage / 100;

    }
}
