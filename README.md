# 💰 Multi-Currency Funding Contract

This project includes two smart contracts written in Solidity:

1. `TestToken.sol` - A simple ERC20 token representing a stablecoin (e.g., USDC).
2. `MultiCurrencyFunding.sol` - A crowdfunding contract that accepts contributions in **ETH** and **ERC20 stablecoins** (like USDC), tracks funding in both currencies, and allows the contract owner to withdraw funds.

---

## 🔧 Contracts Overview

### 🪙 `TestToken.sol`
A basic ERC20 token (compliant with OpenZeppelin's standard) used for simulating a stablecoin like USDC. You can deploy this to a local or testnet environment with an initial supply.

**Key Features:**
- Inherits from OpenZeppelin's ERC20
- Allows minting of initial supply at deployment
- Used to test `fundWithUsdc()` function in the main funding contract

---

### 💼 `MultiCurrencyFunding.sol`

This contract allows users to **fund a project using either ETH or an ERC20 token**, and keeps track of the amount each contributor donates in both currencies.

**Key Features:**
- Accepts ETH and a configurable ERC20 token (e.g., USDC)
- Tracks contributions per user in each currency
- Lets the contract owner withdraw ETH and/or ERC20 funds
- Supports on-chain querying of individual or total contributions

---

## 🧪 How to Use

### 1. **Deploy the ERC20 Token (TestToken.sol)**

In Remix:
- Compile `TestToken.sol`
- Deploy it with an initial supply, e.g. `1000000000000000000000` (1,000 tokens with 18 decimals)
- Copy the deployed token contract address

---

### 2. **Deploy the MultiCurrencyFunding Contract**

In Remix:
- Compile `MultiCurrencyFunding.sol`
- Deploy it by passing the token contract address from step 1 as the `_stablecoin` parameter

---

### 3. **Fund with ETH**

Any wallet can fund the contract with ETH:
- Call `fundWithEth()` and enter amount in **value (ETH)** field
- ETH gets tracked under `ethContributions[address]`

---

### 4. **Fund with USDC (ERC20)**

Steps to fund using USDC:
1. **Approve the contract to spend your tokens**  
   In the TestToken contract, call:
2. **Call fundWithUsdc()** in the funding contract  
- Enter the amount (in token units, e.g. `500000000000000000` for 0.5 tokens if 18 decimals)
- Contract will pull tokens using `transferFrom` and record contribution

---

### 5. **Withdrawals (Only Owner)**

The deployer (owner) can:
- Withdraw all ETH via `withdrawEth()`
- Withdraw all stablecoin (e.g., USDC) via `withdrawUsdc()`

---

## 📊 View Contributions

Use these view functions to inspect contributions:
- `getContributions(address)` — Returns ETH and stablecoin amount funded by a contributor
- `totalEth` — Total ETH raised
- `totalStablecoin` — Total USDC raised
- `ethContributions(address)` — ETH by specific address
- `stablecoinContributions(address)` — USDC by specific address

---

## 🔐 Security Notes

- Only the owner can withdraw funds.
- ERC20 approval must be called before `fundWithUsdc()`.
- Uses OpenZeppelin’s secure ERC20 interface for token interactions.

---

## 🛠 Tech Stack

- Solidity ^0.8.20
- Remix IDE
- MetaMask for testing transactions
- OpenZeppelin Contracts

---

## 🤝 Use Cases

- Crowdfunding dApps that accept both ETH and stablecoins
- DAO funding campaigns with multi-currency support
- Web3 charity platforms accepting different token types

---

## 📜 License

MIT

---

## 👨‍💻 Author

Built with 💙 by [Fredrick Kabu]
