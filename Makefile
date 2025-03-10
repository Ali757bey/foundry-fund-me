-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil zktest

DEFAULT_ZKSYNC_LOCAL_KEY := 0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110
DEV_ACCOUNT := devKey
ANVIL_ACCOUNT := defaultWallet

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install cyfrin/foundry-devops@0.2.2 --no-commit && forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 --no-commit && forge install foundry-rs/forge-std@v1.8.2 --no-commit

# Update Dependencies
update:; forge update

build:; forge build

zkbuild :; forge build --zksync

test :; forge test

zktest :; foundryup-zksync && forge test --zksync && foundryup

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

zk-anvil :; npx zksync-cli dev start

deploy:
	@forge script script/DeployFundMe.s.sol:DeployFundMe $(NETWORK_ARGS)

NETWORK_ARGS := --rpc-url http://127.0.0.1:8545 --account $(ANVIL_ACCOUNT) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --account $(DEV_ACCOUNT) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

deploy-sepolia:
	@make deploy ARGS="--network sepolia"

# As of writing, the Alchemy zkSync RPC URL is not working correctly 
deploy-zk:
	forge create src/FundMe.sol:FundMe --rpc-url http://127.0.0.1:8011 --private-key $(DEFAULT_ZKSYNC_LOCAL_KEY) --constructor-args $(shell forge create test/mock/MockV3Aggregator.sol:MockV3Aggregator --rpc-url http://127.0.0.1:8011 --private-key $(DEFAULT_ZKSYNC_LOCAL_KEY) --constructor-args 8 200000000000 --legacy --zksync | grep "Deployed to:" | awk '{print $$3}') --legacy --zksync

deploy-zk-sepolia:
	forge create src/FundMe.sol:FundMe --rpc-url ${ZKSYNC_SEPOLIA_RPC_URL} --account default --constructor-args 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF --legacy --zksync


# Get the correct sender based on the network
ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
    SENDER_ADDRESS := $(shell cast wallet address --account $(DEV_ACCOUNT))
else
    SENDER_ADDRESS := $(shell cast wallet address --account $(ANVIL_ACCOUNT))
endif
 
fund:
	@forge script script/Interactions.s.sol:FundFundMe --sender $(SENDER_ADDRESS) $(NETWORK_ARGS)

fund-sepolia:
	@make fund ARGS="--network sepolia"

withdraw:
	@forge script script/Interactions.s.sol:WithdrawFundMe --sender $(SENDER_ADDRESS) $(NETWORK_ARGS)

withdraw-sepolia:
	@make withdraw ARGS="--network sepolia"	