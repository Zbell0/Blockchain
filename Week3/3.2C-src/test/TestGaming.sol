pragma solidity >=0.5.0 <0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Gaming.sol";

contract TestGaming {
    uint public initialBalance = 10 ether;
    Gaming gaming;

    function beforeAll() public {
        gaming = Gaming(DeployedAddresses.Gaming());
    }

    function testPlayerWonGuessLowerThanDisplay() public {
        bool expected = true;
        bool result = gaming.determineWinner(3, 5, true);

        Assert.equal(expected, result, "Player should win if guessing lower and mystery number is indeed lower");
    }

    function testPlayerWonGuessHigherThanDisplay() public {
        bool expected = true;
        bool result = gaming.determineWinner(7, 5, false);

        Assert.equal(expected, result, "Player should win if guessing higher and mystery number is indeed higher");
    }

    function testPlayerLostGuessHigherThanDisplay() public {
        bool expected = false;
        bool result = gaming.determineWinner(3, 5, false);

        Assert.equal(expected, result, "Player should lose if guessing higher but mystery number is lower");
    }

    function testPlayerLostGuessLowerThanDisplay() public {
        bool expected = false;
        bool result = gaming.determineWinner(7, 5, true);

        Assert.equal(expected, result, "Player should lose if guessing lower but mystery number is higher");
    }
}