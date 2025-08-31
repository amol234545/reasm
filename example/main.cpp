extern "C" void printf(const char *, ...);

class BankAccount {
private:
    const char* owner;
    int balance;  // integer balance only

public:
    BankAccount(const char* name, int initialBalance)
        : owner(name), balance(initialBalance) {}

    void deposit(int amount) {
        if (amount > 0) {
            balance += amount;
            printf("Deposited: $%d", amount);
        } else {
            printf("Invalid deposit amount.");
        }
    }

    void withdraw(int amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            printf("Withdrew: $%d", amount);
        } else {
            printf("Insufficient funds or invalid amount.");
        }
    }

    void showBalance() const {
        printf("%s's balance: $%d", owner, balance);
    }
};

int main() {
    BankAccount account("Alice", 1000);  // initial balance is integer

    account.showBalance();
    account.deposit(250);
    account.withdraw(500);
    account.showBalance();

    return 0;
}
