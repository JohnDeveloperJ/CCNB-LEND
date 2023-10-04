// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LiquidityProtocol {
    address public owner;
    uint256 public totalDeposits;
    uint256 public totalBorrowed;
    uint256 public interestRate;

    struct User {
        uint256 depositAmount;
        uint256 borrowedAmount;
    }

    mapping(address => User) public users;

    // Constructor initializes the contract with an owner and sets the interest rate.
    constructor(uint256 _interestRate) {
        owner = msg.sender;
        interestRate = _interestRate;
    }

    // Modifier to restrict certain functions to the owner only.
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // Deposit function allows users to add funds to the protocol.
    function deposit() external payable {
        User storage user = users[msg.sender];
        user.depositAmount += msg.value;
        totalDeposits += msg.value;
    }

    // Borrow function enables users to take out loans, provided they have enough collateral.
    function borrow(uint256 amount) external {
        User storage user = users[msg.sender];
        require(user.depositAmount >= amount, "Insufficient collateral");
        user.borrowedAmount += amount;
        totalBorrowed += amount;
    }

    // Repay function allows users to repay their loans.
    function repay(uint256 amount) external {
        User storage user = users[msg.sender];
        require(user.borrowedAmount >= amount, "Insufficient borrowed amount");
        user.borrowedAmount -= amount;
        totalBorrowed -= amount;
    }

    // CalculateInterest function applies interest to the total borrowed amount.
    function calculateInterest() external onlyOwner {
        uint256 interest = (totalBorrowed * interestRate) / 100;
        totalBorrowed += interest;
    }

    // GetBalance function returns the contract's current balance.
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
