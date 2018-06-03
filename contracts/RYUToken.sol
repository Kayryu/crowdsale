pragma solidity ^0.4.18;

import "./SafeMath.sol";
import "./ERC20.sol";

contract Owned {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address public owner;

    function Owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != 0x0);
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract ERC20Imp is ERC20 {
    using SafeMath for uint256;

    uint256 public totalSupply;
    mapping(address => uint256) internal balances;
    mapping (address => mapping (address => uint256)) internal allowed;

    function totalSupply() public view returns (uint supply) {
        return totalSupply;
    } 

    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0));
        require(value <= balances[msg.sender]);

        // SafeMath.sub 在余额不足时抛出异常
        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value);
        Transfer(msg.sender, to, value);
        return true;
    }

    function balanceOf(address owner) public view returns (uint256 balance) {
        return balances[owner];
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(to != address(0));
        require(value <= balances[from]);
        require(value <= allowed[from][msg.sender]);

        balances[from] = balances[from].sub(value);
        balances[to] = balances[to].add(value);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
        Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowed[msg.sender][spender] = value;
        Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return allowed[owner][spender];
    }
}

contract RYUToken is ERC20Imp, Owned {
    string public name = "Ryu Token";
    string public symbol = "RYU";
    uint8 public decimals = 18;
    uint256 private TOTAL_SUPPLY = 1000 * (10 ** uint256(decimals));

    function RYUToken() public {
        totalSupply = TOTAL_SUPPLY;
        balances[msg.sender] = TOTAL_SUPPLY;
    }
}