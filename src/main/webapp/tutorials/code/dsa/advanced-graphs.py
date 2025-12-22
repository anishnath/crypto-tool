"""
Advanced Graph Algorithms
Floyd-Warshall, Strongly Connected Components, Articulation Points & Bridges
"""

# ============================================================================
# FLOYD-WARSHALL ALGORITHM
# ============================================================================

def floyd_warshall(graph):
    """
    Floyd-Warshall Algorithm - All-pairs shortest path
    Works with negative weights (but no negative cycles)
    
    graph: adjacency matrix, graph[i][j] = weight or inf if no edge
    Returns: distance matrix with shortest distances between all pairs
    Time: O(V³), Space: O(V²)
    """
    print(f"\n🎯 Floyd-Warshall Algorithm (All-pairs shortest path)")
    
    n = len(graph)
    dist = [row[:] for row in graph]  # Copy matrix
    
    print(f"   Initial distance matrix:")
    print_matrix(dist)
    
    # For each intermediate vertex k
    for k in range(n):
        print(f"\n   Using vertex {k} as intermediate:")
        for i in range(n):
            for j in range(n):
                if dist[i][k] != float('inf') and dist[k][j] != float('inf'):
                    new_dist = dist[i][k] + dist[k][j]
                    if new_dist < dist[i][j]:
                        old = dist[i][j]
                        dist[i][j] = new_dist
                        print(f"      dist[{i}][{j}] = {old} → {new_dist} (via {k})")
    
    print(f"\n✓ Final distance matrix:")
    print_matrix(dist)
    return dist

def print_matrix(matrix):
    """Helper to print matrix"""
    n = len(matrix)
    print("   ", end="")
    for j in range(n):
        print(f"{j:8}", end="")
    print()
    for i in range(n):
        print(f"{i:2} ", end="")
        for j in range(n):
            val = matrix[i][j]
            if val == float('inf'):
                print("     inf", end="")
            else:
                print(f"{val:8.1f}", end="")
        print()

# ============================================================================
# STRONGLY CONNECTED COMPONENTS (KOSARAJU'S)
# ============================================================================

def kosaraju(graph):
    """
    Kosaraju's Algorithm - Find strongly connected components
    Uses two DFS passes
    
    graph: adjacency list (directed graph)
    Returns: list of components, each component is list of vertices
    Time: O(V + E), Space: O(V)
    """
    print(f"\n🔗 Kosaraju's Algorithm (Strongly Connected Components)")
    
    n = len(graph)
    
    # Step 1: DFS to get finish times (order)
    visited = [False] * n
    finish_order = []
    
    def dfs1(vertex):
        visited[vertex] = True
        for neighbor in graph[vertex]:
            if not visited[neighbor]:
                dfs1(neighbor)
        finish_order.append(vertex)
        print(f"   Finished vertex {vertex}")
    
    print(f"   Step 1: First DFS (get finish order)")
    for i in range(n):
        if not visited[i]:
            dfs1(i)
    
    print(f"   Finish order: {finish_order[::-1]}")
    
    # Step 2: Build transpose graph
    transpose = [[] for _ in range(n)]
    for u in range(n):
        for v in graph[u]:
            transpose[v].append(u)
    
    print(f"   Step 2: Transpose graph created")
    
    # Step 3: DFS on transpose in reverse finish order
    visited = [False] * n
    components = []
    
    def dfs2(vertex, component):
        visited[vertex] = True
        component.append(vertex)
        for neighbor in transpose[vertex]:
            if not visited[neighbor]:
                dfs2(neighbor, component)
    
    print(f"   Step 3: Second DFS on transpose")
    for vertex in reversed(finish_order):
        if not visited[vertex]:
            component = []
            dfs2(vertex, component)
            components.append(component)
            print(f"      Component: {component}")
    
    print(f"\n✓ Found {len(components)} strongly connected component(s): {components}")
    return components

# ============================================================================
# ARTICULATION POINTS
# ============================================================================

def find_articulation_points(graph):
    """
    Find articulation points (cut vertices) using DFS
    An articulation point is a vertex whose removal increases number of components
    
    graph: adjacency list (undirected graph)
    Returns: list of articulation points
    Time: O(V + E), Space: O(V)
    """
    print(f"\n🎯 Finding Articulation Points (Cut Vertices)")
    
    n = len(graph)
    visited = [False] * n
    disc = [-1] * n  # Discovery time
    low = [-1] * n   # Lowest discovery time reachable
    parent = [-1] * n
    time = [0]
    articulation_points = []
    
    def dfs(vertex):
        visited[vertex] = True
        disc[vertex] = time[0]
        low[vertex] = time[0]
        time[0] += 1
        children = 0
        
        for neighbor in graph[vertex]:
            if not visited[neighbor]:
                parent[neighbor] = vertex
                children += 1
                dfs(neighbor)
                
                # Update low value of vertex
                low[vertex] = min(low[vertex], low[neighbor])
                
                # Check if vertex is articulation point
                # Case 1: Root with 2+ children
                if parent[vertex] == -1 and children > 1:
                    articulation_points.append(vertex)
                    print(f"   Articulation point: {vertex} (root with {children} children)")
                # Case 2: Not root and low[neighbor] >= disc[vertex]
                elif parent[vertex] != -1 and low[neighbor] >= disc[vertex]:
                    articulation_points.append(vertex)
                    print(f"   Articulation point: {vertex} (low[{neighbor}]={low[neighbor]} >= disc[{vertex}]={disc[vertex]})")
            elif neighbor != parent[vertex]:
                low[vertex] = min(low[vertex], disc[neighbor])
    
    for i in range(n):
        if not visited[i]:
            dfs(i)
    
    print(f"\n✓ Articulation points: {articulation_points}")
    return articulation_points

# ============================================================================
# BRIDGES
# ============================================================================

def find_bridges(graph):
    """
    Find bridges (cut edges) using DFS
    A bridge is an edge whose removal increases number of components
    
    graph: adjacency list (undirected graph)
    Returns: list of bridges (edges)
    Time: O(V + E), Space: O(V)
    """
    print(f"\n🌉 Finding Bridges (Cut Edges)")
    
    n = len(graph)
    visited = [False] * n
    disc = [-1] * n
    low = [-1] * n
    parent = [-1] * n
    time = [0]
    bridges = []
    
    def dfs(vertex):
        visited[vertex] = True
        disc[vertex] = time[0]
        low[vertex] = time[0]
        time[0] += 1
        
        for neighbor in graph[vertex]:
            if not visited[neighbor]:
                parent[neighbor] = vertex
                dfs(neighbor)
                
                low[vertex] = min(low[vertex], low[neighbor])
                
                # Bridge found: low[neighbor] > disc[vertex]
                if low[neighbor] > disc[vertex]:
                    bridges.append((vertex, neighbor))
                    print(f"   Bridge: {vertex} - {neighbor} (low[{neighbor}]={low[neighbor]} > disc[{vertex}]={disc[vertex]})")
            elif neighbor != parent[vertex]:
                low[vertex] = min(low[vertex], disc[neighbor])
    
    for i in range(n):
        if not visited[i]:
            dfs(i)
    
    print(f"\n✓ Bridges: {bridges}")
    return bridges

# ============================================================================
# EXAMPLE 1: Floyd-Warshall
# ============================================================================

print("=" * 70)
print("Example 1: Floyd-Warshall (All-pairs shortest path)")
print("=" * 70)

import math

# Graph as adjacency matrix
# 0→1(3), 0→2(8), 1→2(2), 2→3(1)
graph1 = [
    [0, 3, 8, math.inf],
    [math.inf, 0, 2, math.inf],
    [math.inf, math.inf, 0, 1],
    [math.inf, math.inf, math.inf, 0]
]

floyd_warshall(graph1)

# ============================================================================
# EXAMPLE 2: Strongly Connected Components
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Strongly Connected Components")
print("=" * 70)

# Directed graph: 0→1, 1→2, 2→0, 1→3, 3→4, 4→3
graph2 = [
    [1],      # 0
    [2, 3],   # 1
    [0],      # 2
    [4],      # 3
    [3]       # 4
]

kosaraju(graph2)

# ============================================================================
# EXAMPLE 3: Articulation Points
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Articulation Points")
print("=" * 70)

# Undirected graph: 0-1, 1-2, 2-3, 0-3
graph3 = [
    [1, 3],   # 0
    [0, 2],   # 1
    [1, 3],   # 2
    [0, 2]    # 3
]

find_articulation_points(graph3)

# ============================================================================
# EXAMPLE 4: Bridges
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Bridges")
print("=" * 70)

# Undirected graph: 0-1, 1-2, 1-3, 3-4
graph4 = [
    [1],      # 0
    [0, 2, 3], # 1
    [1],      # 2
    [1, 4],   # 3
    [3]       # 4
]

find_bridges(graph4)

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Algorithm':<35} {'Time':<20} {'Space'}")
print("─" * 75)
print(f"{'Floyd-Warshall':<35} {'O(V³)':<20} {'O(V²)'}")
print(f"{'Kosaraju (SCC)':<35} {'O(V + E)':<20} {'O(V)'}")
print(f"{'Articulation Points':<35} {'O(V + E)':<20} {'O(V)'}")
print(f"{'Bridges':<35} {'O(V + E)':<20} {'O(V)'}")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Floyd-Warshall: All-pairs shortest path in O(V³)")
print("✓ Kosaraju's: Find strongly connected components using two DFS")
print("✓ Articulation Points: Critical vertices in network")
print("✓ Bridges: Critical edges in network")
print("✓ Applications: Network vulnerability, critical infrastructure analysis")
print("✓ Key insight: DFS with discovery/low times reveals critical structures")
