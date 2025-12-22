"""
Breadth-First Search (BFS)
Level-wise graph traversal algorithm
"""

from collections import deque

# ============================================================================
# BFS IMPLEMENTATION
# ============================================================================

def bfs(graph, start):
    """
    Breadth-First Search
    Visits nodes level by level, uses queue
    Time: O(V + E), Space: O(V)
    
    graph: adjacency list representation
    start: starting vertex
    Returns: list of visited vertices in BFS order
    """
    print(f"\n🔍 BFS starting from vertex {start}")
    
    visited = [False] * len(graph)
    result = []
    queue = deque([start])
    visited[start] = True
    
    print(f"   Queue initialized: {list(queue)}")
    
    while queue:
        # Dequeue vertex
        vertex = queue.popleft()
        result.append(vertex)
        print(f"   ✅ Visiting: {vertex}")
        print(f"   Result so far: {result}")
        
        # Enqueue all unvisited neighbors
        for neighbor in graph[vertex]:
            if not visited[neighbor]:
                visited[neighbor] = True
                queue.append(neighbor)
                print(f"      ➕ Added {neighbor} to queue")
        
        print(f"   Queue: {list(queue)}")
    
    print(f"\n✓ BFS complete! Order: {result}")
    return result

# ============================================================================
# BFS WITH DISTANCE/PARENT TRACKING
# ============================================================================

def bfs_with_distance(graph, start):
    """
    BFS that tracks distance from start and parent of each vertex
    Useful for shortest path problems
    """
    print(f"\n🔍 BFS with distance tracking from vertex {start}")
    
    visited = [False] * len(graph)
    distance = [-1] * len(graph)  # -1 means unreachable
    parent = [-1] * len(graph)     # -1 means no parent
    
    queue = deque([start])
    visited[start] = True
    distance[start] = 0
    parent[start] = -1  # Start has no parent
    
    print(f"   Distance[{start}] = 0, Parent[{start}] = -1")
    
    while queue:
        vertex = queue.popleft()
        print(f"\n   ✅ Processing vertex {vertex} (distance: {distance[vertex]})")
        
        for neighbor in graph[vertex]:
            if not visited[neighbor]:
                visited[neighbor] = True
                distance[neighbor] = distance[vertex] + 1
                parent[neighbor] = vertex
                queue.append(neighbor)
                print(f"      Neighbor {neighbor}: distance = {distance[neighbor]}, parent = {vertex}")
    
    print(f"\n✓ BFS complete!")
    print(f"   Distances: {distance}")
    print(f"   Parents: {parent}")
    return distance, parent

# ============================================================================
# SHORTEST PATH (Unweighted Graph)
# ============================================================================

def shortest_path_bfs(graph, start, end):
    """
    Find shortest path from start to end using BFS
    Works only for unweighted graphs
    Returns: list of vertices in shortest path, or None if no path
    """
    print(f"\n🗺️ Finding shortest path from {start} to {end}")
    
    if start == end:
        return [start]
    
    visited = [False] * len(graph)
    parent = [-1] * len(graph)
    queue = deque([start])
    visited[start] = True
    
    # BFS to find end
    found = False
    while queue:
        vertex = queue.popleft()
        
        if vertex == end:
            found = True
            break
        
        for neighbor in graph[vertex]:
            if not visited[neighbor]:
                visited[neighbor] = True
                parent[neighbor] = vertex
                queue.append(neighbor)
    
    if not found:
        print(f"   ❌ No path from {start} to {end}")
        return None
    
    # Reconstruct path
    path = []
    current = end
    while current != -1:
        path.append(current)
        current = parent[current]
    
    path.reverse()
    print(f"   ✓ Shortest path: {' → '.join(map(str, path))}")
    print(f"   Path length: {len(path) - 1} edges")
    return path

# ============================================================================
# LEVEL-WISE TRAVERSAL
# ============================================================================

def bfs_levels(graph, start):
    """
    BFS that groups vertices by level
    Returns: list of lists, each inner list is a level
    """
    print(f"\n📊 BFS Level-wise from vertex {start}")
    
    visited = [False] * len(graph)
    levels = []
    queue = deque([(start, 0)])  # (vertex, level)
    visited[start] = True
    
    current_level = -1
    
    while queue:
        vertex, level = queue.popleft()
        
        # Start new level
        if level > current_level:
            current_level = level
            levels.append([])
            print(f"\n   Level {level}:")
        
        levels[level].append(vertex)
        print(f"      {vertex}", end=" ")
        
        # Add neighbors to next level
        for neighbor in graph[vertex]:
            if not visited[neighbor]:
                visited[neighbor] = True
                queue.append((neighbor, level + 1))
    
    print(f"\n\n✓ Levels: {levels}")
    return levels

# ============================================================================
# CONNECTED COMPONENTS (BFS-based)
# ============================================================================

def connected_components_bfs(graph):
    """
    Find all connected components using BFS
    Returns: list of components, each component is a list of vertices
    """
    print(f"\n🔗 Finding connected components")
    
    visited = [False] * len(graph)
    components = []
    
    for vertex in range(len(graph)):
        if not visited[vertex]:
            # New component found, BFS to find all vertices in it
            component = []
            queue = deque([vertex])
            visited[vertex] = True
            
            while queue:
                v = queue.popleft()
                component.append(v)
                
                for neighbor in graph[v]:
                    if not visited[neighbor]:
                        visited[neighbor] = True
                        queue.append(neighbor)
            
            components.append(component)
            print(f"   Component {len(components)}: {component}")
    
    print(f"\n✓ Found {len(components)} component(s)")
    return components

# ============================================================================
# EXAMPLE 1: Basic BFS
# ============================================================================

print("=" * 70)
print("Example 1: Basic BFS")
print("=" * 70)

# Graph: 0-1, 0-2, 1-3, 1-4, 2-5, 2-6 (undirected)
graph1 = [
    [1, 2],      # 0
    [0, 3, 4],   # 1
    [0, 5, 6],   # 2
    [1],         # 3
    [1],         # 4
    [2],         # 5
    [2]          # 6
]

print("\nGraph structure:")
print("0 ↔ 1, 0 ↔ 2")
print("1 ↔ 3, 1 ↔ 4")
print("2 ↔ 5, 2 ↔ 6")

bfs_result = bfs(graph1, 0)

# ============================================================================
# EXAMPLE 2: Shortest Path
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Shortest Path (Unweighted Graph)")
print("=" * 70)

# Graph: Social network
# 0 ↔ 1, 0 ↔ 2, 1 ↔ 3, 2 ↔ 3, 3 ↔ 4
graph2 = [
    [1, 2],      # 0
    [0, 3],      # 1
    [0, 3],      # 2
    [1, 2, 4],   # 3
    [3]          # 4
]

print("\nFinding shortest path from 0 to 4")
shortest_path_bfs(graph2, 0, 4)

# ============================================================================
# EXAMPLE 3: Level-wise Traversal
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Level-wise BFS")
print("=" * 70)

bfs_levels(graph1, 0)

# ============================================================================
# EXAMPLE 4: Connected Components
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Connected Components")
print("=" * 70)

# Graph with two components: {0,1,2} and {3,4}
graph3 = [
    [1, 2],      # 0
    [0, 2],      # 1
    [0, 1],      # 2
    [4],         # 3
    [3]          # 4
]

connected_components_bfs(graph3)

# ============================================================================
# EXAMPLE 5: BFS with Distance
# ============================================================================

print("\n" + "=" * 70)
print("Example 5: BFS with Distance Tracking")
print("=" * 70)

bfs_with_distance(graph1, 0)

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Operation':<30} {'Time':<20} {'Space':<20}")
print("─" * 70)
print(f"{'BFS traversal':<30} {'O(V + E)':<20} {'O(V)':<20}")
print(f"{'Shortest path (unweighted)':<30} {'O(V + E)':<20} {'O(V)':<20}")
print(f"{'Connected components':<30} {'O(V + E)':<20} {'O(V)':<20}")
print(f"{'Level-wise traversal':<30} {'O(V + E)':<20} {'O(V)':<20}")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ BFS visits nodes level by level (breadth first)")
print("✓ Uses queue (FIFO) data structure")
print("✓ Time: O(V + E), Space: O(V)")
print("✓ Finds shortest path in unweighted graphs")
print("✓ Guarantees minimum number of edges to reach any node")
print("✓ Perfect for: GPS navigation, web crawling, level-order problems")
print("✓ Key insight: Queue ensures we visit closer nodes before distant ones")
