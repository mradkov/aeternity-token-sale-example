# Aeternity Token Sale Example

This repository provides an example of a contribution campaign/token sale conducted on top of aeternity blockchain.

The tokens examples are following the [AEX-9](https://github.com/aeternity/AEXs/blob/master/AEXS/aex-9.md) standard for fungible tokens on aeternity.

# Documentation

## Contracts

### Token Sale contract

The `token-sale.aes` contract is implementing the interface of an aex9 fungible token. Since we only need to call `entrypoint mint()` in order to issue new tokens for people that contributed to the campaign we are only using this interface:

```sophia
contract FungibleTokenFullInterface =
  entrypoint mint                 : (address, int)          => unit
```

The contract also has few more functions - `contribute`, `set_token` and `withdraw` which respectively do the following:

`set_token` - this should be called in order to specify the address of the token contract which would be issued during the contribution campaign.

`contribute` - allows people to send value in AE tokens and calls the `mint` function on the specified token contract in the state of the contract, issuing new tokens amount according to the price ratio speicified in the token sale.

`withdraw` - allows the `owner` of the `token-sale` contract to withdraw the collected amount of AE.

### Fungible token contract

This is a slightly modified version of the `mintable` aex9 contract. The difference is we have specified a new role - `minter` who is allowed to issue new tokens, increasing the `total_supply`. 

In this case the `minter` is our `token-sale` contract.
