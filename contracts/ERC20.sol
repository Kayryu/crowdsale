pragma solidity ^0.4.18;

interface ERC20 {
    // 发行代币总额
    function totalSupply() public constant returns (uint256 supply);
    // 账户代币数量
    function balanceOf(address who) public constant returns (uint256 value);
    // 转账
    function transfer(address to, uint256 value) public returns (bool ok);
    // 授权转账
    function transferFrom( address from, address to, uint256 value) public returns (bool ok);
    // 授权
    function approve(address spender, uint256 value) public returns (bool ok);
    // 授权余额查询
    function allowance(address owner, address spender) public constant returns (uint256 remaining);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}