-- Custom Iterator Examples in Lua

-- Custom iterator for key-value pairs in reverse order
function reverse_pairs(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end
    
    local i = #keys + 1
    return function()
        i = i - 1
        if i > 0 then
            local k = keys[i]
            return k, t[k]
        end
    end
end

print("=== Reverse iteration ===")
local data = {a = 1, b = 2, c = 3, d = 4}
for k, v in reverse_pairs(data) do
    print(k, v)
end

-- Custom iterator for array in reverse
function reverse_ipairs(t)
    local i = #t + 1
    return function()
        i = i - 1
        if i > 0 then
            return i, t[i]
        end
    end
end

print("\n=== Reverse array ===")
local arr = {10, 20, 30, 40, 50}
for i, v in reverse_ipairs(arr) do
    print(i, v)
end

-- Custom iterator with step
function step_iterator(t, step)
    step = step or 1
    local i = 0
    return function()
        i = i + step
        if t[i] then
            return i, t[i]
        end
    end
end

print("\n=== Every 2nd element ===")
local numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
for i, v in step_iterator(numbers, 2) do
    print(i, v)
end

-- Custom iterator for tree traversal
function tree_iterator(tree)
    local stack = {tree}
    
    return function()
        if #stack > 0 then
            local node = table.remove(stack)
            if node.children then
                for i = #node.children, 1, -1 do
                    table.insert(stack, node.children[i])
                end
            end
            return node.value
        end
    end
end

print("\n=== Tree traversal ===")
local tree = {
    value = "root",
    children = {
        {value = "child1"},
        {value = "child2", children = {
            {value = "grandchild1"},
            {value = "grandchild2"}
        }}
    }
}

for value in tree_iterator(tree) do
    print(value)
end
