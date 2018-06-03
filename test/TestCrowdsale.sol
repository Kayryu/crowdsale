pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RYUToken.sol";
import "../contracts/RYUCrowdsale.sol";

contract TestCrowdsale {

    function testInitERC20() {
        RYUToken token = new RYUToken();
        uint total = 1000 * (10 ** 18);
        Assert.equal(token.totalSupply(), total, "init ryu token");
    }

    function testInitCrowdsale() {
        RYUToken token = new RYUToken();
        uint256 raised = 2 ether;
        RYUCrowdsale crowdsale = new RYUCrowdsale(token, token, 60);
        Assert.equal(crowdsale.fundGoal(), raised, "init ryu crowdsale");
    }
}