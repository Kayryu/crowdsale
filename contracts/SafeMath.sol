pragma solidity ^0.4.18;

library SafeMath {
    function add(uint256 x, uint256 y) pure internal returns (uint256 z) {
        assert((z = x + y) >= x);
    }

    function sub(uint256 x, uint256 y) pure internal returns (uint256 z) {
        assert((z = x - y) <= x);
    }

    function mul(uint256 x, uint256 y) pure internal returns (uint256 z) {
        assert((z = x * y) >= x);
    }

    function div(uint256 x, uint256 y) pure internal returns (uint256 z) {
        z = x / y;
    }
}