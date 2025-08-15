pragma solidity >=0.5.0 <0.6.0;

contract Gaming {
    /* Our Online gaming contract */
    address owner;
    bool online;

    uint private testMysteryNumber;
    bool private testing = false;

    struct Player {
        uint wins;
        uint losses;
    } 

    mapping (address => Player) public players;
    
    
    constructor() public payable {
        owner = msg.sender;
        online = true;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    event GameFunded(address funder, uint amount);
    event playerWon(address player, uint mysteryNumber);
    event playerLost(address player, uint mysteryNumber);

    // Add this function to manually set the mystery number for testing
    function setTestMysteryNumber(uint number) public {
        testMysteryNumber = number;
        testing = true;
    }

    // Modify the mysteryNumber function like this:
    function mysteryNumber() private view returns (uint) {
        if (testing) {
            return testMysteryNumber;
        }
        uint randomNumber = uint(blockhash(block.number - 1)) % 10 + 1;
        return randomNumber;
    }

    

    function determineWinner(uint number, uint display, bool guess) public pure returns (bool) {
        if (guess == true) {
            return number < display;
        } else {
            return number > display;
        }
    }

    function winOrLose(uint display, bool guess) external payable returns (bool, uint) {
        
        require(online == true, "The game is not online");
        require(msg.sender.balance > msg.value, "Insufficient funds");
        uint mysteryNumber_ = mysteryNumber();
        bool isWinner = determineWinner(mysteryNumber_, display, guess);
        if (isWinner == true) {
            /* Player won */
            msg.sender.transfer(msg.value * 2); 
            players[msg.sender].wins++;
            emit playerWon(msg.sender, mysteryNumber_);
            return (true, mysteryNumber_);
        } else if (isWinner == false) {
            /* Player lost */
            players[msg.sender].losses++;
            emit playerLost(msg.sender, mysteryNumber_);
            return (false, mysteryNumber_);
        }
    }

    function withdrawFunds() public isOwner {
        msg.sender.transfer(address(this).balance);
    }

    function fundGame() public isOwner payable {
        emit GameFunded(msg.sender, msg.value);
    }

    function() external payable {
    }

}
