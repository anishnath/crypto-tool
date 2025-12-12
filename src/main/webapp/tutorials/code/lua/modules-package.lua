-- Package Management in Lua

-- package.path and package.cpath control where Lua looks for modules

-- View current package paths
print("=== Package Paths ===")
print("package.path:")
print(package.path)
print("\npackage.cpath:")
print(package.cpath)

-- package.path is for Lua modules (.lua files)
-- package.cpath is for C modules (.so, .dll files)

-- Adding custom paths
print("\n=== Adding Custom Paths ===")
local originalPath = package.path
package.path = package.path .. ";./mymodules/?.lua"
package.path = package.path .. ";./lib/?.lua"
print("Updated package.path:")
print(package.path)

-- Restore original path
package.path = originalPath

-- package.loaded table
-- Contains all loaded modules
print("\n=== Loaded Modules ===")
print("Loaded modules:")
for name, module in pairs(package.loaded) do
    print("  " .. name)
end

-- Check if a module is loaded
print("\nIs 'math' loaded?", package.loaded["math"] ~= nil)
print("Is 'mymodule' loaded?", package.loaded["mymodule"] ~= nil)

-- Unloading a module
print("\n=== Unloading Modules ===")
package.loaded["math"] = nil
print("Math module unloaded")
print("Is 'math' loaded?", package.loaded["math"] ~= nil)

-- Reload math
require("math")
print("Math module reloaded")
print("Is 'math' loaded?", package.loaded["math"] ~= nil)

-- package.preload table
-- Allows you to define modules without files
print("\n=== package.preload ===")
package.preload["myutil"] = function()
    local M = {}
    function M.greet(name)
        return "Hello, " .. name
    end
    return M
end

local myutil = require("myutil")
print(myutil.greet("World"))

-- package.searchers (or package.loaders in Lua 5.1)
-- Functions that search for modules
print("\n=== Package Searchers ===")
if package.searchers then
    print("Number of searchers:", #package.searchers)
else
    print("Using Lua 5.1 (package.loaders)")
end

-- Custom module loader
local function customLoader(moduleName)
    print("Custom loader searching for:", moduleName)
    if moduleName == "custom" then
        return function()
            local M = {}
            M.message = "Loaded by custom loader"
            return M
        end
    end
    return nil
end

-- Add custom loader (Lua 5.2+)
if package.searchers then
    table.insert(package.searchers, customLoader)
end

-- Module search order
print("\n=== Module Search Order ===")
print("1. package.preload")
print("2. Lua files in package.path")
print("3. C libraries in package.cpath")
print("4. All-in-one loaders")

-- LuaRocks integration
print("\n=== LuaRocks ===")
print("LuaRocks is Lua's package manager")
print("Install packages: luarocks install <package>")
print("Example: luarocks install luasocket")

-- Checking for optional dependencies
local function tryRequire(moduleName)
    local success, module = pcall(require, moduleName)
    if success then
        return module
    else
        return nil
    end
end

local socket = tryRequire("socket")
if socket then
    print("\nLuaSocket is available")
else
    print("\nLuaSocket is not installed")
end

-- Module versioning
local M = {}
M._VERSION = "1.0.0"
M._DESCRIPTION = "Example module with version"
M._LICENSE = "MIT"

print("\n=== Module Metadata ===")
print("Version:", M._VERSION)
print("Description:", M._DESCRIPTION)
print("License:", M._LICENSE)

-- Best practices for package management
print("\n=== Best Practices ===")
print("1. Use require() for loading modules")
print("2. Return a table from your modules")
print("3. Use local variables for private functions")
print("4. Include version information")
print("5. Handle missing dependencies gracefully")
print("6. Don't modify global state")
print("7. Use LuaRocks for third-party packages")

-- Example: Checking Lua version
print("\n=== Lua Version ===")
print("Lua version:", _VERSION)

-- Example: Module with dependencies check
local function createModuleWithDeps()
    local M = {}
    
    -- Check for required dependencies
    local success, json = pcall(require, "json")
    if not success then
        error("This module requires 'json' package. Install with: luarocks install json")
    end
    
    M.json = json
    return M
end

-- Conditional features based on available modules
local function createFlexibleModule()
    local M = {}
    
    -- Try to load optional dependency
    local hasSocket = pcall(require, "socket")
    
    if hasSocket then
        M.networkingAvailable = true
        print("Networking features enabled")
    else
        M.networkingAvailable = false
        print("Networking features disabled (socket not found)")
    end
    
    return M
end

local flexModule = createFlexibleModule()
print("Networking available?", flexModule.networkingAvailable)
