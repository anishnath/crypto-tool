-- Module with Private Members

-- Demonstrates how to create truly private members in Lua modules

-- Method 1: Using local variables (closure-based privacy)
local function createBankAccount(initialBalance)
    -- Private variables
    local balance = initialBalance
    local transactions = {}
    
    -- Private function
    local function recordTransaction(type, amount)
        table.insert(transactions, {
            type = type,
            amount = amount,
            balance = balance,
            timestamp = os.time()
        })
    end
    
    -- Public interface
    local account = {}
    
    function account.deposit(amount)
        if amount <= 0 then
            return false, "Amount must be positive"
        end
        balance = balance + amount
        recordTransaction("deposit", amount)
        return true, balance
    end
    
    function account.withdraw(amount)
        if amount > balance then
            return false, "Insufficient funds"
        end
        balance = balance - amount
        recordTransaction("withdraw", amount)
        return true, balance
    end
    
    function account.getBalance()
        return balance
    end
    
    function account.getTransactionHistory()
        -- Return copy, not original
        local copy = {}
        for i, t in ipairs(transactions) do
            copy[i] = {
                type = t.type,
                amount = t.amount,
                balance = t.balance
            }
        end
        return copy
    end
    
    return account
end

-- Usage
local myAccount = createBankAccount(1000)
print("Initial balance:", myAccount.getBalance())
myAccount.deposit(500)
print("After deposit:", myAccount.getBalance())
myAccount.withdraw(200)
print("After withdraw:", myAccount.getBalance())
-- print(balance)  -- Error: balance is not accessible

-- Method 2: Module with private state
local Counter = {}

do
    -- Private state (in do...end block)
    local instances = 0
    local totalCount = 0
    
    function Counter.new()
        local count = 0  -- Private to each instance
        instances = instances + 1
        
        local counter = {}
        
        function counter.increment()
            count = count + 1
            totalCount = totalCount + 1
            return count
        end
        
        function counter.getValue()
            return count
        end
        
        return counter
    end
    
    function Counter.getTotalInstances()
        return instances
    end
    
    function Counter.getTotalCount()
        return totalCount
    end
end

local c1 = Counter.new()
local c2 = Counter.new()
c1.increment()
c1.increment()
c2.increment()

print("\nCounter instances:", Counter.getTotalInstances())
print("Total count:", Counter.getTotalCount())

-- Method 3: Module with private configuration
local Database = {}

do
    -- Private configuration
    local config = {
        host = "localhost",
        port = 5432,
        database = "mydb"
    }
    
    local connection = nil
    
    -- Private function
    local function validateConfig()
        return config.host ~= nil and config.port ~= nil
    end
    
    -- Public functions
    function Database.configure(options)
        for key, value in pairs(options) do
            if config[key] ~= nil then
                config[key] = value
            end
        end
    end
    
    function Database.connect()
        if not validateConfig() then
            error("Invalid configuration")
        end
        connection = {
            host = config.host,
            port = config.port,
            connected = true
        }
        print("Connected to " .. config.host .. ":" .. config.port)
        return connection
    end
    
    function Database.disconnect()
        if connection then
            connection.connected = false
            connection = nil
            print("Disconnected")
        end
    end
    
    function Database.isConnected()
        return connection ~= nil and connection.connected
    end
end

Database.configure({host = "192.168.1.1", port = 3306})
Database.connect()
print("Connected?", Database.isConnected())
Database.disconnect()

-- Method 4: Class with private methods
local Person = {}
Person.__index = Person

do
    -- Private validation function
    local function validateAge(age)
        return type(age) == "number" and age >= 0 and age <= 150
    end
    
    local function validateName(name)
        return type(name) == "string" and #name > 0
    end
    
    function Person.new(name, age)
        if not validateName(name) then
            error("Invalid name")
        end
        if not validateAge(age) then
            error("Invalid age")
        end
        
        local self = setmetatable({}, Person)
        self.name = name
        self.age = age
        return self
    end
    
    function Person:birthday()
        if validateAge(self.age + 1) then
            self.age = self.age + 1
        end
    end
end

function Person:introduce()
    return "I'm " .. self.name .. ", " .. self.age .. " years old"
end

local person = Person.new("Alice", 25)
print("\n" .. person:introduce())
person:birthday()
print(person:introduce())

-- Method 5: Module with truly private data
local SecureStorage = {}

do
    -- Private storage (completely inaccessible from outside)
    local storage = {}
    local accessLog = {}
    
    local function log(action, key)
        table.insert(accessLog, {
            action = action,
            key = key,
            time = os.time()
        })
    end
    
    function SecureStorage.set(key, value)
        storage[key] = value
        log("set", key)
    end
    
    function SecureStorage.get(key)
        log("get", key)
        return storage[key]
    end
    
    function SecureStorage.delete(key)
        storage[key] = nil
        log("delete", key)
    end
    
    function SecureStorage.has(key)
        return storage[key] ~= nil
    end
    
    function SecureStorage.getAccessLog()
        -- Return copy
        local copy = {}
        for i, entry in ipairs(accessLog) do
            copy[i] = {action = entry.action, key = entry.key}
        end
        return copy
    end
end

SecureStorage.set("password", "secret123")
SecureStorage.set("apiKey", "abc-def-ghi")
print("\nPassword:", SecureStorage.get("password"))
print("Has apiKey?", SecureStorage.has("apiKey"))
SecureStorage.delete("password")
print("Has password?", SecureStorage.has("password"))
