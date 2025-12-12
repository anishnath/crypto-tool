-- Encapsulation in Lua OOP

-- Basic encapsulation using closures
function BankAccount(initial_balance)
    local balance = initial_balance or 0  -- Private variable
    
    local self = {}
    
    -- Public method to deposit
    function self.deposit(amount)
        if amount > 0 then
            balance = balance + amount
            return true
        end
        return false
    end
    
    -- Public method to withdraw
    function self.withdraw(amount)
        if amount > 0 and amount <= balance then
            balance = balance - amount
            return true
        end
        return false
    end
    
    -- Public method to get balance (read-only access)
    function self.get_balance()
        return balance
    end
    
    return self
end

print("=== Bank Account Encapsulation ===")
local account = BankAccount(1000)
print("Initial balance:", account.get_balance())

account.deposit(500)
print("After deposit:", account.get_balance())

account.withdraw(200)
print("After withdrawal:", account.get_balance())

-- Cannot access balance directly
print("Direct access to balance:", account.balance)  -- nil

-- Encapsulation with metatables
function Person(name, age)
    local private = {
        name = name,
        age = age,
        ssn = "XXX-XX-XXXX"  -- Private field
    }
    
    local public = {}
    
    -- Getter methods
    function public.get_name()
        return private.name
    end
    
    function public.get_age()
        return private.age
    end
    
    -- Setter with validation
    function public.set_age(new_age)
        if new_age > 0 and new_age < 150 then
            private.age = new_age
            return true
        end
        return false
    end
    
    -- Method that uses private data
    function public.introduce()
        return string.format("Hi, I'm %s and I'm %d years old", 
                           private.name, private.age)
    end
    
    return public
end

print("\n=== Person Encapsulation ===")
local person = Person("Alice", 30)
print(person.introduce())
print("Name:", person.get_name())
print("Age:", person.get_age())

-- Cannot access private fields
print("Direct SSN access:", person.ssn)  -- nil

-- Setter validation
person.set_age(35)
print("After valid age update:", person.get_age())

person.set_age(-5)  -- Invalid
print("After invalid age update:", person.get_age())  -- Still 35

-- Advanced encapsulation with private methods
function Counter()
    local count = 0
    
    -- Private method
    local function validate(value)
        return type(value) == "number" and value >= 0
    end
    
    local self = {}
    
    function self.increment(value)
        value = value or 1
        if validate(value) then
            count = count + value
        end
    end
    
    function self.decrement(value)
        value = value or 1
        if validate(value) and count >= value then
            count = count - value
        end
    end
    
    function self.get_count()
        return count
    end
    
    function self.reset()
        count = 0
    end
    
    return self
end

print("\n=== Counter with Private Methods ===")
local counter = Counter()
counter.increment(5)
print("Count:", counter.get_count())

counter.increment(3)
print("Count:", counter.get_count())

counter.decrement(2)
print("Count:", counter.get_count())

counter.reset()
print("After reset:", counter.get_count())
