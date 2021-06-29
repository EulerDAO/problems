// SPDX-License-Identifier: MIT

pragma solidity ^0.8.5;

contract SqrtProblem {
    bytes4 constant digest = bytes4(keccak256("sqrt(uint256)"));
    function check(
        bool ok,
        bytes calldata i,
        bytes calldata o
    ) external view {
        require(bytes4(i[:4]) == digest);
        uint256 x = abi.decode(i[4:], (uint256));
        if (!ok) {
            return;
        }
        try this.decode(o) returns (uint256 y) {
            if (y > 0xffffffffffffffffffffffffffffffff) {
                return;
            }
            if (y * y > x) {
                return;
            }
            if (y < 0xffffffffffffffffffffffffffffffff) {
                if ((y + 1)**2 <= x) {
                    return;
                }
            }
            revert();
        } catch {
            return;
        }
    }

    function decode(bytes calldata data) external pure returns (uint256) {
        return abi.decode(data, (uint256));
    }
}
