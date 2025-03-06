# Foundry Fund Me

This repository is a part of my Solidity learning journey using Foundry.

- [Foundry Fund Me](#foundry-fund-me)
  - [**Getting Started**](#getting-started)
    - [**Requirements**](#requirements)
    - [**Quickstart**](#quickstart)
  - [**Usage**](#usage)
    - [**Deploying Locally**](#deploying-locally)
    - [**Testing**](#testing)
      - [**Test Coverage**](#test-coverage)
  - [**Local zkSync Setup**](#local-zksync-setup)
    - [**Additional Requirements**](#additional-requirements)
    - [**Start a Local zkSync Node**](#start-a-local-zksync-node)
    - [**Deploy to zkSync**](#deploy-to-zksync)
  - [**Deployment to a Testnet or Mainnet**](#deployment-to-a-testnet-or-mainnet)
    - [**Setting Up Accounts**](#setting-up-accounts)
    - [**Encrypting Your Keys Using ERC2335**](#encrypting-your-keys-using-erc2335)
    - [**Deploying**](#deploying)
  - [**Scripts**](#scripts)
    - [**Funding \& Withdrawing**](#funding--withdrawing)
      - [**Fund the Contract**](#fund-the-contract)
      - [**Withdraw Funds**](#withdraw-funds)
      - [**Check Contract Balance**](#check-contract-balance)
  - [**Estimating Gas Costs**](#estimating-gas-costs)
  - [**Code Formatting**](#code-formatting)
  - [**Additional Information**](#additional-information)
  - [**Thank You!**](#thank-you)

---

## **Getting Started**

### **Requirements**
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  ```bash
  git --version
  ```
- [Foundry](https://getfoundry.sh/)
  ```bash
  forge --version
  ```

### **Quickstart**
```bash
git clone https://github.com/Ali757bey/foundry-fund-me.git
cd foundry-fund-me
make
```

---

## **Usage**

### **Deploying Locally**
Instead of manually running the `forge` script command, you can use the `Makefile` for an easier deployment process.

```bash
make deploy
```

This will execute the deployment command using the predefined settings in the `Makefile`.

### **Testing**
This project includes unit and forked testing.

Run all tests:
```bash
forge test
```

Run a specific test:
```bash
forge test --match-test testFunctionName
```

Run forked tests:
```bash
forge test --fork-url $SEPOLIA_RPC_URL
```

#### **Test Coverage**
```bash
forge coverage
```

---

## **Local zkSync Setup**
This project supports local zkSync development.

### **Additional Requirements**
- [zkSync Foundry Plugin](https://github.com/matter-labs/foundry-zksync)
- [npm & npx](https://docs.npmjs.com/)

### **Start a Local zkSync Node**
```bash
npx zksync-cli dev config
npx zksync-cli dev start
```

### **Deploy to zkSync**
```bash
make deploy-zk
```

---

## **Deployment to a Testnet or Mainnet**

### **Setting Up Accounts**
To deploy and interact with contracts, you need **two accounts**:

1. **Anvil Account (for local testing)**
   - Used when deploying contracts locally with Anvil.
   - The account is defined in the Makefile as `ANVIL_ACCOUNT`.

2. **Testnet/Mainnet Account**
   - Used for deploying on networks like Sepolia or Mainnet.
   - The account is defined in the Makefile as `DEV_ACCOUNT`.

To dynamically select the correct account based on the network, the Makefile uses:
```make
ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
    SENDER_ADDRESS := $(shell cast wallet address --account DEV_ACCOUNT)
else
    SENDER_ADDRESS := $(shell cast wallet address --account ANVIL_ACCOUNT)
endif
```
This ensures the correct wallet is used for **both** local Anvil testing and real network deployment.

### **Encrypting Your Keys Using ERC2335**

You should never store your private keys in a `.env` file. Instead, encrypt your keys using **ERC2335**.

For example, let's say your private key is:
```plaintext
0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```
(Key 0 from Anvil)

To securely import it, use the following command:
```bash
cast wallet import nameOfAccountGoesHere --interactive
```

You will be prompted to enter your private key and create a password to secure it. This process only needs to be done once.

Once configured, deploy using:
```bash
make deploy-sepolia
```

This will execute the necessary deployment command using the settings in your `Makefile`, prompting you for your password before proceeding.

To check configured wallets, use:
```bash
cast wallet list
```

To clear your terminal history and remove sensitive traces, use:
```bash
history -c
```

🚀 **Stay safe! Never expose your private key in plaintext!**

### **Deploying**
Instead of manually entering the full deployment command, simply run:
```bash
make deploy-sepolia
```

This will deploy the contract using your pre-configured settings from the `Makefile`.

---

## **Scripts**
### **Funding & Withdrawing**
After deploying, you can interact with the contract.

#### **Fund the Contract**
To send ETH to the `FundMe` contract, run:
```bash
make fund
```
For Sepolia, use:
```bash
make fund-sepolia
```

#### **Withdraw Funds**
To withdraw funds from the contract, use:
```bash
make withdraw
```
For Sepolia, use:
```bash
make withdraw-sepolia
```

#### **Check Contract Balance**
To check the contract balance based on the network:

For **Anvil (local network)**:
```bash
cast balance <FUNDME_CONTRACT_ADDRESS>
```

For **Sepolia (or other testnets/mainnet)**:
```bash
cast balance <FUNDME_CONTRACT_ADDRESS> --rpc-url $SEPOLIA_RPC_URL
```
This ensures you’re checking the balance on the correct network.

---

## **Estimating Gas Costs**
```bash
forge snapshot
```
A `.gas-snapshot` file will be generated.

---

## **Code Formatting**
Ensure your Solidity code is formatted properly:
```bash
forge fmt
```

---

## **Additional Information**
This repository follows best practices for Solidity smart contract development and uses Foundry for testing and deployment.

---

## **Thank You!**
If you found this useful, feel free to connect!

[![Twitter](https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/ali757bey)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/isaiahfletcher)
