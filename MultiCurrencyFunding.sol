// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import the ERC20 interface to interact with stablecoins (e.g., USDC)
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title Multi-Currency Funding
/// @notice Accepts contributions in ETH or a stablecoin like USDC
contract MultiCurrencyFunding {
    /// @notice Address of the contract owner
    address public owner;

    /// @notice ERC20 stablecoin contract address (e.g., USDC)
    address public stablecoin;
    
    /// @notice Funding balances per currency
    mapping(address => uint256) public ethContributions;
    mapping(address => uint256) public stablecoinContributions;

    /// @notice Track total funds raised in ETH and stablecoin
    uint256 public totalEth;
    uint256 public totalStablecoin;

    /// @notice Sets the owner and stablecoin address when deploying
    /// @param _stablecoin ERC20 stablecoin contract address
    constructor(address _stablecoin) {
        owner = msg.sender;
        stablecoin = _stablecoin;
    }

    /// @notice Fund the project with ETH
    function fundWithEth() external payable {
        require(msg.value > 0, "Must send ETH");
        ethContributions[msg.sender] += msg.value;
        totalEth += msg.value;
    }

    /// @notice Fund the project with USDC
    /// @param amount The amount of USDC to contribute (in token decimals)
    function fundWithUsdc(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");

        // Cast stablecoin address to ERC20 interface
        IERC20 token = IERC20(stablecoin);

        // Transfer USDC tokens from sender to this contract
        bool success = token.transferFrom(msg.sender, address(this), amount);
        require(success, "USDC transfer failed");

        // Record contribution
        stablecoinContributions[msg.sender] += amount;
        totalStablecoin += amount;
    }

    /// @notice Withdraw all ETH funds to the owner
    function withdrawEth() external {
        require(msg.sender == owner, "Only owner can withdraw ETH");
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH to withdraw");

        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "ETH withdrawal failed");
    }

    /// @notice Withdraw all USDC funds to the owner
    function withdrawUsdc() external {
        require(msg.sender == owner, "Only owner can withdraw USDC");

        IERC20 token = IERC20(stablecoin);

        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "No USDC to withdraw");

        bool success = token.transfer(owner, balance);
        require(success, "USDC withdrawal failed");
    }

    /// @notice Returns the ETH and USDC funded by a given contributor
    /// @param contributor Address to query
    /// @return ethAmount Amount of ETH contributed (in wei)
    /// @return stablecoinAmount Amount of USDC contributed (in token units)
    function getContributions(address contributor) external view returns (uint256 ethAmount, uint256 stablecoinAmount) {
        ethAmount = ethContributions[contributor];
        stablecoinAmount = stablecoinContributions[contributor];
    }
}
