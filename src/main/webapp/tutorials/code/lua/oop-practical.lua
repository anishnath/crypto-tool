-- Practical OOP Example: Task Management System

-- Task class
Task = {}
Task.__index = Task

function Task:new(title, priority)
    local instance = setmetatable({}, self)
    instance.title = title or "Untitled"
    instance.priority = priority or "medium"
    instance.completed = false
    instance.created_at = os.time()
    return instance
end

function Task:complete()
    self.completed = true
    self.completed_at = os.time()
end

function Task:get_status()
    return self.completed and "✓ Done" or "○ Pending"
end

function Task:get_info()
    return string.format("[%s] %s - Priority: %s", 
                        self:get_status(), self.title, self.priority)
end

-- TaskList class
TaskList = {}
TaskList.__index = TaskList

function TaskList:new(name)
    local instance = setmetatable({}, self)
    instance.name = name or "My Tasks"
    instance.tasks = {}
    return instance
end

function TaskList:add_task(task)
    table.insert(self.tasks, task)
end

function TaskList:remove_task(index)
    if self.tasks[index] then
        table.remove(self.tasks, index)
        return true
    end
    return false
end

function TaskList:get_pending()
    local pending = {}
    for _, task in ipairs(self.tasks) do
        if not task.completed then
            table.insert(pending, task)
        end
    end
    return pending
end

function TaskList:get_completed()
    local completed = {}
    for _, task in ipairs(self.tasks) do
        if task.completed then
            table.insert(completed, task)
        end
    end
    return completed
end

function TaskList:display()
    print(string.format("\n=== %s ===", self.name))
    if #self.tasks == 0 then
        print("No tasks yet!")
    else
        for i, task in ipairs(self.tasks) do
            print(string.format("%d. %s", i, task:get_info()))
        end
    end
    print(string.format("Total: %d | Pending: %d | Completed: %d", 
                       #self.tasks, 
                       #self:get_pending(), 
                       #self:get_completed()))
end

-- Practical usage
print("=== Task Management System ===")

-- Create task list
local my_list = TaskList:new("Work Tasks")

-- Add tasks
local task1 = Task:new("Write documentation", "high")
local task2 = Task:new("Fix bug #123", "high")
local task3 = Task:new("Update README", "low")
local task4 = Task:new("Code review", "medium")

my_list:add_task(task1)
my_list:add_task(task2)
my_list:add_task(task3)
my_list:add_task(task4)

-- Display all tasks
my_list:display()

-- Complete some tasks
print("\n--- Completing tasks ---")
task1:complete()
task3:complete()

-- Display updated list
my_list:display()

-- Show pending tasks
print("\n=== Pending Tasks ===")
for i, task in ipairs(my_list:get_pending()) do
    print(string.format("%d. %s", i, task:get_info()))
end

-- Show completed tasks
print("\n=== Completed Tasks ===")
for i, task in ipairs(my_list:get_completed()) do
    print(string.format("%d. %s", i, task:get_info()))
end

-- Remove a task
print("\n--- Removing task 2 ---")
my_list:remove_task(2)
my_list:display()

-- Another practical example: Simple inventory system
print("\n\n=== Inventory System ===")

Item = {}
Item.__index = Item

function Item:new(name, quantity, price)
    local instance = setmetatable({}, self)
    instance.name = name
    instance.quantity = quantity or 0
    instance.price = price or 0
    return instance
end

function Item:add_stock(amount)
    self.quantity = self.quantity + amount
end

function Item:remove_stock(amount)
    if self.quantity >= amount then
        self.quantity = self.quantity - amount
        return true
    end
    return false
end

function Item:get_value()
    return self.quantity * self.price
end

function Item:display()
    print(string.format("%s: %d units @ $%.2f = $%.2f", 
                       self.name, self.quantity, self.price, self:get_value()))
end

-- Create inventory
local apple = Item:new("Apple", 50, 0.50)
local banana = Item:new("Banana", 30, 0.30)
local orange = Item:new("Orange", 20, 0.60)

apple:display()
banana:display()
orange:display()

print("\n--- After sales ---")
apple:remove_stock(10)
banana:remove_stock(5)

apple:display()
banana:display()

print(string.format("\nTotal inventory value: $%.2f", 
                   apple:get_value() + banana:get_value() + orange:get_value()))
