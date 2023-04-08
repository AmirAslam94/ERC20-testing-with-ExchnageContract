const Dex = artifacts.require('Dex');
const Token = artifacts.require('Token');
const truffleAssert = require('truffle-assertions');

contract("Dex" , accounts => {
    it("should only be possible for owner to add Tokens" , async () => {
        // await deployer.deploy(Token);
        let dex = await Dex.deployed();
        let  token = await Token.deployed();
        await truffleAssert.passes(
            dex.addToken(web3.utils.fromUtf8("eth"), token.address, {from: accounts[0]})
        )

    })

    it("check the token cap", async () => {
        let token = await Token.deployed();
        let cap = await token.cap();
        assert.equal(cap , 10*10**18)
    })

    it("check deposit amount correctly in our wwallet contract", async () => {
        let dex = await Dex.deployed();
        let  token = await Token.deployed();
        await token.minting(accounts[0], 1000);
        await token.approve(dex.address, 1000);
        await dex.deposite(500, web3.utils.fromUtf8("eth"));
        let balance = await dex.balances(accounts[0], web3.utils.fromUtf8("eth"));
        assert.equal(balance.toNumber(), 500);

    })

})
