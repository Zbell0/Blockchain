pragma solidity >=0.5.0 <0.6.0;

contract Gaming {
    /* Our Online gaming contract */
    address public owner;
    bool public online;

    struct Player{
        address playerAddress;
        string playerName;
        uint playerBalance;
        uint playerWins;
        uint playerLosses;
    }

    mapping(uint => Player) public players;
    
    
    constructor() public payable {
        owner = msg.sender;
        online = true;
        players[0] = Player(msg.sender, "Test Player", 0, 1, 2);
    }

    function mysteryNumber() internal view returns (uint) {
        uint randomNumber = uint(blockhash(block.number-1))%10 + 1;
        return randomNumber;
    }

    function determineWinner(uint number, uint display, bool guess) public pure returns (bool) {
        if (guess == true) {
            if (number > display) {
                return true;
            }
        } else if (guess == false) {
            if (number > display) {
                return false;
            }
        }
    }

    function winOrLose(uint display, bool guess, uint wager) external payable returns (bool) {
        /* Use true for a higher guess, false for a lower guess */
        require(online == true);
        require(msg.sender.balance > msg.value, "Insufficient funds");
        uint mysteryNumber_ = mysteryNumber();
        bool isWinner = determineWinner(mysteryNumber_, display, guess);
        if (isWinner == true) {
            /* Player won */
            msg.sender.transfer(wager * 2); // return the amount wagered plus the ether sent with the transaction
            return true;
        } else if (isWinner == false) {
            /* Player lost */
            return false;
        }
    }
}
