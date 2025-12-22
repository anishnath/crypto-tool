"""
Depth-First Search (DFS)
Deep traversal algorithm using recursion or stack
"""

from collections import deque

# ============================================================================
# RECURSIVE DFS
# ============================================================================

def dfs_recursive(graph, start, visited=None, result=None):
    """
    Depth-First Search (Recursive)
    Visits nodes as deep as possible before backtracking
    Time: O(V + E), Space: O(V) for recursion stack
    """
    if visited is None:
        visited = [False] * len(graph)
        result = []
        print(f"\n🌲 DFS (Recursive) starting from vertex {start}")
    
    visited[start] = True
    result.append(start)
    print(f"   ✅ Visiting: {start}")
    print(f"   Result so far: {result}")
    
    # Visit all unvisited neighbors
    for neighbor in graph[start]:
        if not visited[neighbor]:
            print(f"      → Exploring {neighbor}")
            dfs_recursive(graph, neighbor, visited, result)
            print(f"      ← Backtracked from {neighbor}")
    
    return result

# ============================================================================
# ITERATIVE DFS (Using Stack)
# ============================================================================

def dfs_iterative(graph, start):
    """
    Depth-First Search (Iterative)
    Uses stack instead of recursion
    Time: O(V + E), Space: O(V)
    """
    print(f"\n🌲 DFS (Iterative) starting from vertex {start}")
    
    visited = [False] * len(graph)
    result = []
    stack = [start]
    
    print(f"   Stack initialized: {stack}")
    
    while stack:
        vertex = stack.pop()
        
        if not visited[vertex]:
            visited[vertex] = True
            result.append(vertex)
            print(f"   ✅ Visiting: {vertex}")
            print(f"   Result so far: {result}")
            
            # Push neighbors in reverse order (for same order as recursive)
            for neighbor in reversed(graph[vertex]):
                if not visited[neighbor]:
                    stack.append(neighbor)
                    print(f"      ➕ Added {neighbor} to stack")
            
            print(f"   Stack: {stack}")
    
    print(f"\n✓ DFS complete! Order: {result}")
    return result

# ============================================================================
# DFS WITH PARENT AND DISCOVERY/FINISH TIME
# ============================================================================

def dfs_with_timestamps(graph, start):
    """
    DFS that tracks discovery time, finish time, and parent
    Useful for advanced graph algorithms
    """
    print(f"\n🌲 DFS with timestamps from vertex {start}")
    
    visited = [False] * len(graph)
    parent = [-1] * len(graph)
    discovery_time = [-1] * len(graph)
    finish_time = [-1] * len(graph)
    time = [0]  # Use list to modify in recursion
    
    def dfs_visit(vertex):
        visited[vertex] = True
        discovery_time[vertex] = time[0]
        time[0] += 1
        print(f"   ⏱️ Discovered {vertex} at time {discovery_time[vertex]}")
        
        for neighbor in graph[vertex]:
            if not visited[neighbor]:
                parent[neighbor] = vertex
                dfs_visit(neighbor)
        
        finish_time[vertex] = time[0]
        time[0] += 1
        print(f"   ⏱️ Finished {vertex} at time {finish_time[vertex]}")
    
    dfs_visit(start)
    
    print(f"\n✓ DFS with timestamps complete!")
    print(f"   Discovery times: {discovery_time}")
    print(f"   Finish times: {finish_time}")
    print(f"   Parents: {parent}")
    
    return discovery_time, finish_time, parent

# ============================================================================
# CYCLE DETECTION IN UNDIRECTED GRAPH
# ============================================================================

def has_cycle_undirected(graph):
    """
    Detect cycle in undirected graph using DFS
    Returns: True if cycle exists, False otherwise
    """
    print(f"\n🔍 Detecting cycle in undirected graph")
    
    visited = [False] * len(graph)
    
    def dfs(vertex, parent):
        visited[vertex] = True
        print(f"   Visiting {vertex} (parent: {parent})")
        
        for neighbor in graph[vertex]:
            if not visited[neighbor]:
                if dfs(neighbor, vertex):
                    return True
            elif neighbor != parent:
                # Found back edge (not to parent) = cycle!
                print(f"   ⚠️ Cycle detected! Edge {vertex} → {neighbor} creates cycle")
                return True
        
        return False
    
    # Check all components
    for vertex in range(len(graph)):
        if not visited[vertex]:
            if dfs(vertex, -1):
                print("   ✓ Cycle found!")
                return True
    
    print("   ✓ No cycle found")
    return False

# ============================================================================
# CYCLE DETECTION IN DIRECTED GRAPH
# ============================================================================

def has_cycle_directed(graph):
    """
    Detect cycle in directed graph using DFS
    Uses WHITE/GRAY/BLACK coloring
    """
    print(f"\n🔍 Detecting cycle in directed graph")
    
    # 0 = WHITE (unvisited), 1 = GRAY (being explored), 2 = BLACK (finished)
    color = [0] * len(graph)
    
    def dfs(vertex):
        color[vertex] = 1  # Mark as GRAY (being explored)
        print(f"   Marking {vertex} as GRAY (exploring)")
        
        for neighbor in graph[vertex]:
            if color[neighbor] == 1:  # Back edge to GRAY = cycle!
                print(f"   ⚠️ Cycle detected! Back edge {vertex} → {neighbor}")
                return True
            elif color[neighbor] == 0:  # WHITE (unvisited)
                if dfs(neighbor):
                    return True
        
        color[vertex] = 2  # Mark as BLACK (finished)
        print(f"   Marking {vertex} as BLACK (finished)")
        return False
    
    # Check all vertices
    for vertex in range(len(graph)):
        if color[vertex] == 0:
            if dfs(vertex):
                print("   ✓ Cycle found!")
                return True
    
    print("   ✓ No cycle found")
    return False

# ============================================================================
# CONNECTED COMPONENTS (DFS-based)
# ============================================================================

def connected_components_dfs(graph):
    """
    Find all connected components using DFS
    Returns: list of components
    """
    print(f"\n🔗 Finding connected components (DFS)")
    
    visited = [False] * len(graph)
    components = []
    
    def dfs(vertex, component):
        visited[vertex] = True
        component.append(vertex)
        for neighbor in graph[vertex]:
            if not visited[neighbor]:
                dfs(neighbor, component)
    
    for vertex in range(len(graph)):
        if not visited[vertex]:
            component = []
            dfs(vertex, component)
            components.append(component)
            print(f"   Component {len(components)}: {component}")
    
    print(f"\n✓ Found {len(components)} component(s)")
    return components

# ============================================================================
# PATH FINDING (DFS)
# ============================================================================

def find_path_dfs(graph, start, end):
    """
    Find any path from start to end using DFS
    Returns: path as list, or None if no path
    """
    print(f"\n🗺️ Finding path from {start} to {end} (DFS)")
    
    visited = [False] * len(graph)
    path = []
    
    def dfs(vertex):
        visited[vertex] = True
        path.append(vertex)
        
        if vertex == end:
            return True
        
        for neighbor in graph[vertex]:
            if not visited[neighbor]:
                if dfs(neighbor):
                    return True
        
        # Backtrack
        path.pop()
        return False
    
    if dfs(start):
        print(f"   ✓ Path found: {' → '.join(map(str, path))}")
        return path
    else:
        print(f"   ❌ No path from {start} to {end}")
        return None

# ============================================================================
# EXAMPLE 1: Recursive vs Iterative DFS
# ============================================================================

print("=" * 70)
print("Example 1: Recursive vs Iterative DFS")
print("=" * 70)

# Graph: Tree structure
#       0
#      / \
#     1   2
#    /|   |\
#   3 4   5 6
graph1 = [
    [1, 2],      # 0
    [0, 3, 4],   # 1
    [0, 5, 6],   # 2
    [1],         # 3
    [1],         # 4
    [2],         # 5
    [2]          # 6
]

print("\n--- Recursive DFS ---")
dfs_recursive(graph1, 0)

print("\n--- Iterative DFS ---")
dfs_iterative(graph1, 0)

# ============================================================================
# EXAMPLE 2: Cycle Detection (Undirected)
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Cycle Detection (Undirected Graph)")
print("=" * 70)

# Graph with cycle: 0-1-2-0
graph_with_cycle = [
    [1, 2],   # 0
    [0, 2],   # 1
    [0, 1]    # 2
]

print("\nGraph: 0-1, 0-2, 1-2 (triangle - has cycle)")
has_cycle_undirected(graph_with_cycle)

# Graph without cycle: Tree
print("\nGraph: Tree (no cycle)")
has_cycle_undirected(graph1)

# ============================================================================
# EXAMPLE 3: Cycle Detection (Directed)
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Cycle Detection (Directed Graph)")
print("=" * 70)

# Directed graph with cycle: 0→1→2→0
graph_directed_cycle = [
    [1],      # 0
    [2],      # 1
    [0]       # 2
]

print("\nGraph: 0→1→2→0 (has cycle)")
has_cycle_directed(graph_directed_cycle)

# Directed acyclic graph
graph_dag = [
    [1, 2],   # 0
    [3],      # 1
    [3],      # 2
    []        # 3
]

print("\nGraph: DAG (no cycle)")
has_cycle_directed(graph_dag)

# ============================================================================
# EXAMPLE 4: Connected Components
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Connected Components")
print("=" * 70)

graph3 = [
    [1, 2],   # 0
    [0, 2],   # 1
    [0, 1],   # 2
    [4],      # 3
    [3]       # 4
]

connected_components_dfs(graph3)

# ============================================================================
# EXAMPLE 5: DFS with Timestamps
# ============================================================================

print("\n" + "=" * 70)
print("Example 5: DFS with Timestamps")
print("=" * 70)

dfs_with_timestamps(graph1, 0)

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Operation':<30} {'Time':<20} {'Space':<20}")
print("─" * 70)
print(f"{'DFS traversal':<30} {'O(V + E)':<20} {'O(V)':<20}")
print(f"{'Cycle detection (undirected)':<30} {'O(V + E)':<20} {'O(V)':<20}")
print(f"{'Cycle detection (directed)':<30} {'O(V + E)':<20} {'O(V)':<20}")
print(f"{'Connected components':<30} {'O(V + E)':<20} {'O(V)':<20}")
print(f"{'Path finding':<30} {'O(V + E)':<20} {'O(V)':<20}")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ DFS visits nodes as deep as possible before backtracking")
print("✓ Can be implemented recursively or iteratively (stack)")
print("✓ Time: O(V + E), Space: O(V)")
print("✓ Perfect for: Maze solving, topological sort, cycle detection")
print("✓ Key insight: Stack/recursion naturally explores depth first")
print("✓ Cycle detection: Back edge detection distinguishes cycles")
print("✓ Recursive DFS: More intuitive, uses call stack")
print("✓ Iterative DFS: More control, uses explicit stack")
