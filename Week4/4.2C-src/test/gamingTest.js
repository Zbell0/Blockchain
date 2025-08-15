const Gaming = artifacts.require("./Gaming.sol");

contract("Gaming", async (accounts) => {
  let gaming;
  const owner = accounts[0];
  const player1 = accounts[1];

  before(async () => {
    gaming = await Gaming.deployed();
    await gaming.fundGame({
      from: owner,
      value: web3.utils.toWei("10", "ether"),
    });
  });

  it("Should record player losses", async () => {
    await gaming.setTestMysteryNumber(11, { from: owner }); // Player will lose
    const initialBalance = await web3.eth.getBalance(player1);
    const initialBalanceInEther = Number(
      web3.utils.fromWei(initialBalance, "ether")
    );

    const gameRound = await gaming.winOrLose(10, true, {
      from: player1,
      value: web3.utils.toWei("1", "ether"),
    });

    const postBalance = await web3.eth.getBalance(player1);
    const postBalanceInEther = Number(web3.utils.fromWei(postBalance, "ether"));

    const playerStats = await gaming.players(player1);
    assert.equal(playerStats[1].toNumber(), 1, "The player should have 1 loss");

    assert.isAtLeast(
      initialBalanceInEther,
      postBalanceInEther + 1,
      "Player account should have decreased by the amount of the wager"
    );
  });

  it("Should record player wins", async () => {
    await gaming.setTestMysteryNumber(12, { from: owner }); // Player will win
    const gameRound = await gaming.winOrLose(10, false, {
      from: player1,
      value: web3.utils.toWei("1", "ether"),
    });

    const playerStats = await gaming.players(player1);
    assert.equal(playerStats[0].toNumber(), 1, "The player should have 1 win");
  });

  it("Should withdraw funds and increase owner balance by 10 ether", async () => {
    // Get the initial balance of the owner
    const initialBalance = await web3.eth.getBalance(owner);
    const initialBalanceInEther = Number(
      web3.utils.fromWei(initialBalance, "ether")
    );

    // Call the withdrawFunds function
    await gaming.withdrawFunds({ from: owner });

    // Get the final balance of the owner
    const finalBalance = await web3.eth.getBalance(owner);
    const finalBalanceInEther = Number(
      web3.utils.fromWei(finalBalance, "ether")
    );

    // Calculate the balance increase
    const balanceIncrease = finalBalanceInEther - initialBalanceInEther;

    // Verify the owner's balance has increased by approximately 10 ether
    assert.isAtLeast(
      balanceIncrease,
      9.5, // Allow for some gas costs
      "Owner balance should have increased by approximately 10 ether"
    );
  });
});
