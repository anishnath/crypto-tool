-- Private Variables with Closures

-- Creating private state
local function createBankAccount(initialBalance)
    -- Private variables (not accessible from outside)
    local balance = initialBalance
    local transactions = {}
    
    -- Private function
    local function recordTransaction(type, amount)
        table.insert(transactions, {
            type = type,
            amount = amount,
            balance = balance
        })
    end
    
    -- Public interface
    return {
        deposit = function(amount)
            if amount <= 0 then
                return false, "Amount must be positive"
            end
            balance = balance + amount
            recordTransaction("deposit", amount)
            return true, balance
        end,
        
        withdraw = function(amount)
            if amount <= 0 then
                return false, "Amount must be positive"
            end
            if amount > balance then
                return false, "Insufficient funds"
            end
            balance = balance - amount
            recordTransaction("withdraw", amount)
            return true, balance
        end,
        
        getBalance = function()
            return balance
        end,
        
        getTransactionHistory = function()
            return transactions
        end
    }
end

local account = createBankAccount(1000)
print("Initial balance:", account.getBalance())

account.deposit(500)
print("After deposit:", account.getBalance())

account.withdraw(200)
print("After withdraw:", account.getBalance())

-- Try to access private variable (won't work!)
-- print(account.balance)  -- nil
-- print(account.transactions)  -- nil

-- Print transaction history
print("\nTransaction History:")
for i, trans in ipairs(account.getTransactionHistory()) do
    print(string.format("%d. %s: $%d (Balance: $%d)", 
        i, trans.type, trans.amount, trans.balance))
end

-- Creating a module with private state
local function createCounter()
    local count = 0
    local maxCount = 0
    
    return {
        increment = function()
            count = count + 1
            if count > maxCount then
                maxCount = count
            end
            return count
        end,
        
        decrement = function()
            count = count - 1
            return count
        end,
        
        reset = function()
            count = 0
            return count
        end,
        
        getValue = function()
            return count
        end,
        
        getMax = function()
            return maxCount
        end
    }
end

local counter = createCounter()
counter.increment()
counter.increment()
counter.increment()
print("Current:", counter.getValue())
print("Max reached:", counter.getMax())

counter.decrement()
counter.decrement()
print("After decrement:", counter.getValue())
print("Max still:", counter.getMax())

-- Object with private methods
local function createUser(username, password)
    -- Private function to hash password
    local function hashPassword(pwd)
        -- Simple hash (in real code, use proper hashing!)
        return "hashed_" .. pwd
    end
    
    local hashedPassword = hashPassword(password)
    
    return {
        getUsername = function()
            return username
        end,
        
        checkPassword = function(pwd)
            return hashPassword(pwd) == hashedPassword
        end,
        
        changePassword = function(oldPwd, newPwd)
            if not hashPassword(oldPwd) == hashedPassword then
                return false, "Incorrect password"
            end
            hashedPassword = hashPassword(newPwd)
            return true, "Password changed"
        end
    }
end

local user = createUser("alice", "secret123")
print("Username:", user.getUsername())
print("Check password:", user.checkPassword("secret123"))
print("Check wrong password:", user.checkPassword("wrong"))
