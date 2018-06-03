pragma solidity ^0.4.18;

import "./SafeMath.sol";
import "./ERC20.sol";

contract Crowdsale {
    using SafeMath for uint256;

    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 fundAmount, uint tokens);
    event FundWithdraw(address indexed beneficiary, uint256 fundAmount);

    ERC20 public ERCtoken;
    address public wallet;
    uint256 public rate;
    uint256 public fundRaised;

    mapping(address => uint256) deposited;
    uint256 public fundGoal;

    uint256 startTime;
    uint256 endTime;

    function Crowdsale(address sendWallet, address token, uint256 tokenRate,
        uint256 goal, uint256 start, uint256 end) public {
            
        require(sendWallet != address(0));
        require(token != address(0));
        require(tokenRate >= 1);
        require(goal >= 1);
        
        require(end > start);

        wallet = sendWallet;
        ERCtoken = ERC20(token);
        rate = tokenRate;
        fundGoal = goal;
        fundRaised = goal;
        startTime = start;
        endTime = end;

        assert(ERCtoken.totalSupply() > tokenRate * goal);
    }

    function fundRaised() public returns (uint256) {
        return fundRaised;
    }

    function fundGoal() public returns (uint256) {
        return fundGoal;
    }

    function () external payable {
        buyTokens(msg.sender, msg.value);
    }

    function buyTokens(address beneficiary, uint256 fundAmount) payable public onlyWhileOpen {
        require(beneficiary != address(0));
        require(fundAmount != 0);

        // 转换为代币
        uint256 tokens = fundAmount.mul(rate);

        fundRaised = fundRaised.add(fundAmount);
        deposited[msg.sender] = deposited[msg.sender].add(fundAmount);

        ERCtoken.transfer(beneficiary, tokens);
        TokenPurchase(msg.sender, beneficiary, fundAmount, tokens);
    }

    function withdraw() onlyWhileClose public {
        assert(!goalReached());

        uint amount = deposited[msg.sender];
        deposited[msg.sender] = 0;
        if (amount > 0) {
            if (msg.sender.send(amount)) {
                fundRaised = fundRaised.sub(amount);
                FundWithdraw(msg.sender, amount);
            } else {
                deposited[msg.sender] = amount;
            }
        }
    }

    function collect() onlyWhileClose public {
        require(wallet == msg.sender);
        assert(goalReached());

        wallet.transfer(fundRaised);
        FundWithdraw(msg.sender, fundRaised);
    }

    modifier onlyWhileOpen {
        require(active());
        _;
    }

    modifier onlyWhileClose {
        require(!active());
        _;
    }

    function active() internal view returns (bool) {
        return (block.timestamp >= startTime && block.timestamp <= endTime);
    }

    function goalReached() internal view returns (bool) {
        return fundRaised >= fundGoal;
    }
}

contract RYUCrowdsale is Crowdsale {
    
    uint256 public constant RYU_RATE = 1;
    uint256 public constant RYU_GOAL = 2 ether;

    function RYUCrowdsale(address wallet, address token, uint256 durationMinutes) public 
        Crowdsale(wallet, token, RYU_RATE, RYU_GOAL, now, (now + durationMinutes * 1 minutes)) {
    }
}