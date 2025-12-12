-- Short-circuit evaluation with 'and' and 'or'

-- 'and' returns first falsy value or last value
print("=== AND operator ===")
print("true and 5:", true and 5)      -- 5
print("false and 5:", false and 5)    -- false
print("nil and 5:", nil and 5)        -- nil
print("5 and 10:", 5 and 10)          -- 10

-- 'or' returns first truthy value or last value
print("\n=== OR operator ===")
print("true or 5:", true or 5)        -- true
print("false or 5:", false or 5)      -- 5
print("nil or 5:", nil or 5)          -- 5
print("5 or 10:", 5 or 10)            -- 5

-- Practical use: Default values
print("\n=== Default Values ===")
local name = nil
local displayName = name or "Guest"
print("Display name:", displayName)   -- "Guest"

local score = 0
local finalScore = score or 100
print("Final score:", finalScore)     -- 0 (not 100! 0 is truthy)

-- Ternary-like expression
print("\n=== Ternary-like ===")
local age = 20
local status = (age >= 18) and "Adult" or "Minor"
print("Status:", status)  -- "Adult"
