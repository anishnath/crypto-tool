-- OOP Inheritance Hierarchy Example

-- Base class: Vehicle
Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle:new(brand, model, year)
    local instance = setmetatable({}, self)
    instance.brand = brand
    instance.model = model
    instance.year = year
    instance.speed = 0
    return instance
end

function Vehicle:accelerate(amount)
    self.speed = self.speed + amount
    print(string.format("%s %s accelerating to %d km/h", 
                       self.brand, self.model, self.speed))
end

function Vehicle:brake(amount)
    self.speed = math.max(0, self.speed - amount)
    print(string.format("%s %s slowing to %d km/h", 
                       self.brand, self.model, self.speed))
end

function Vehicle:get_info()
    return string.format("%d %s %s", self.year, self.brand, self.model)
end

-- Derived class: Car
Car = setmetatable({}, {__index = Vehicle})
Car.__index = Car

function Car:new(brand, model, year, doors)
    local instance = Vehicle.new(self, brand, model, year)
    setmetatable(instance, self)
    instance.doors = doors or 4
    instance.trunk_open = false
    return instance
end

function Car:open_trunk()
    self.trunk_open = true
    print("Trunk opened")
end

function Car:close_trunk()
    self.trunk_open = false
    print("Trunk closed")
end

function Car:get_info()
    return string.format("%s (%d doors)", 
                        Vehicle.get_info(self), self.doors)
end

-- Derived class: Motorcycle
Motorcycle = setmetatable({}, {__index = Vehicle})
Motorcycle.__index = Motorcycle

function Motorcycle:new(brand, model, year, engine_cc)
    local instance = Vehicle.new(self, brand, model, year)
    setmetatable(instance, self)
    instance.engine_cc = engine_cc or 250
    instance.wheelie = false
    return instance
end

function Motorcycle:do_wheelie()
    if self.speed > 20 then
        self.wheelie = true
        print("Doing a wheelie!")
    else
        print("Need more speed for a wheelie")
    end
end

function Motorcycle:get_info()
    return string.format("%s (%dcc)", 
                        Vehicle.get_info(self), self.engine_cc)
end

-- Derived class: Truck (from Car)
Truck = setmetatable({}, {__index = Car})
Truck.__index = Truck

function Truck:new(brand, model, year, cargo_capacity)
    local instance = Car.new(self, brand, model, year, 2)
    setmetatable(instance, self)
    instance.cargo_capacity = cargo_capacity or 1000
    instance.cargo_weight = 0
    return instance
end

function Truck:load_cargo(weight)
    if self.cargo_weight + weight <= self.cargo_capacity then
        self.cargo_weight = self.cargo_weight + weight
        print(string.format("Loaded %d kg. Total: %d/%d kg", 
                           weight, self.cargo_weight, self.cargo_capacity))
        return true
    else
        print("Cannot load: exceeds capacity")
        return false
    end
end

function Truck:unload_cargo(weight)
    if self.cargo_weight >= weight then
        self.cargo_weight = self.cargo_weight - weight
        print(string.format("Unloaded %d kg. Remaining: %d kg", 
                           weight, self.cargo_weight))
        return true
    else
        print("Cannot unload: not enough cargo")
        return false
    end
end

function Truck:get_info()
    return string.format("%s (Cargo: %d/%d kg)", 
                        Vehicle.get_info(self), 
                        self.cargo_weight, self.cargo_capacity)
end

-- Test the hierarchy
print("=== Vehicle Hierarchy Demo ===\n")

-- Create vehicles
local sedan = Car:new("Toyota", "Camry", 2023, 4)
local bike = Motorcycle:new("Harley", "Sportster", 2022, 883)
local pickup = Truck:new("Ford", "F-150", 2023, 1500)

-- Test Car
print("--- Car ---")
print(sedan:get_info())
sedan:accelerate(50)
sedan:open_trunk()
sedan:brake(20)
print()

-- Test Motorcycle
print("--- Motorcycle ---")
print(bike:get_info())
bike:accelerate(30)
bike:do_wheelie()  -- Too slow
bike:accelerate(20)
bike:do_wheelie()  -- Fast enough
print()

-- Test Truck
print("--- Truck ---")
print(pickup:get_info())
pickup:load_cargo(500)
pickup:load_cargo(800)
pickup:accelerate(40)
pickup:unload_cargo(300)
print(pickup:get_info())
print()

-- Demonstrate polymorphism
print("--- Polymorphism ---")
local vehicles = {sedan, bike, pickup}

for i, vehicle in ipairs(vehicles) do
    print(string.format("%d. %s", i, vehicle:get_info()))
end

print("\n--- All vehicles accelerating ---")
for _, vehicle in ipairs(vehicles) do
    vehicle:accelerate(30)
end
