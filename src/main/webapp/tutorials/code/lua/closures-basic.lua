-- Closures in Lua

-- Basic closure - function accessing outer variable
local function makeCounter()
    local count = 0  -- Upvalue
    
    return function()
        count = count + 1
        return count
    end
end

local counter1 = makeCounter()
print(counter1())  -- 1
print(counter1())  -- 2
print(counter1())  -- 3

local counter2 = makeCounter()  -- New closure, new count
print(counter2())  -- 1
print(counter2())  -- 2

-- Closure with multiple functions sharing state
local function createAccount(initialBalance)
    local balance = initialBalance
    
    local function deposit(amount)
        balance = balance + amount
        return balance
    end
    
    local function withdraw(amount)
        if amount > balance then
            print("Insufficient funds!")
            return balance
        end
        balance = balance - amount
        return balance
    end
    
    local function getBalance()
        return balance
    end
    
    return {
        deposit = deposit,
        withdraw = withdraw,
        getBalance = getBalance
    }
end

local account = createAccount(100)
print("Balance:", account.getBalance())
print("After deposit:", account.deposit(50))
print("After withdraw:", account.withdraw(30))
print("Final balance:", account.getBalance())

-- Closure capturing loop variable
local function createMultipliers()
    local multipliers = {}
    
    for i = 1, 5 do
        multipliers[i] = function(x)
            return x * i  -- Captures current i
        end
    end
    
    return multipliers
end

local mults = createMultipliers()
print("3 * 2 =", mults[2](3))
print("3 * 4 =", mults[4](3))

-- Closure for memoization
local function memoize(func)
    local cache = {}
    
    return function(x)
        if cache[x] == nil then
            cache[x] = func(x)
        end
        return cache[x]
    end
end

local function slowSquare(x)
    print("Computing square of", x)
    return x * x
end

local fastSquare = memoize(slowSquare)
print(fastSquare(5))  -- Computes
print(fastSquare(5))  -- Uses cache
print(fastSquare(3))  -- Computes
