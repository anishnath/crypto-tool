"""
Dijkstra's Algorithm
Shortest path in weighted graphs (non-negative weights)
"""

import heapq

# ============================================================================
# DIJKSTRA'S ALGORITHM
# ============================================================================

def dijkstra(graph, start):
    """
    Dijkstra's Algorithm - Shortest path from start to all vertices
    Works only for graphs with non-negative edge weights
    Uses priority queue (min heap) for efficiency
    
    graph: adjacency list [(neighbor, weight), ...]
    start: starting vertex
    Returns: (distances, parents) - shortest distances and parent nodes
    Time: O((V + E) log V) with heap, O(V²) with array
    Space: O(V)
    """
    print(f"\n🛣️ Dijkstra's Algorithm starting from vertex {start}")
    
    n = len(graph)
    distances = [float('inf')] * n
    parents = [-1] * n
    visited = [False] * n
    
    distances[start] = 0
    # Priority queue: (distance, vertex)
    pq = [(0, start)]
    
    print(f"   Initial distances: {distances}")
    
    while pq:
        # Get vertex with minimum distance
        dist, vertex = heapq.heappop(pq)
        
        if visited[vertex]:
            continue
        
        visited[vertex] = True
        print(f"\n   ✅ Processing vertex {vertex} (distance: {dist})")
        
        # Update distances to neighbors
        for neighbor, weight in graph[vertex]:
            if not visited[neighbor]:
                new_dist = dist + weight
                if new_dist < distances[neighbor]:
                    distances[neighbor] = new_dist
                    parents[neighbor] = vertex
                    heapq.heappush(pq, (new_dist, neighbor))
                    print(f"      Neighbor {neighbor}: distance {new_dist} (via {vertex})")
    
    print(f"\n✓ Final distances: {distances}")
    print(f"  Parents: {parents}")
    return distances, parents

def dijkstra_shortest_path(graph, start, end):
    """
    Find shortest path from start to end using Dijkstra's
    Returns: (distance, path) or (None, None) if no path
    """
    print(f"\n🗺️ Finding shortest path from {start} to {end}")
    
    n = len(graph)
    distances = [float('inf')] * n
    parents = [-1] * n
    visited = [False] * n
    
    distances[start] = 0
    pq = [(0, start)]
    
    while pq:
        dist, vertex = heapq.heappop(pq)
        
        if visited[vertex]:
            continue
        
        if vertex == end:
            # Reconstruct path
            path = []
            current = end
            while current != -1:
                path.append(current)
                current = parents[current]
            path.reverse()
            print(f"   ✓ Shortest path: {' → '.join(map(str, path))}")
            print(f"   Distance: {dist}")
            return dist, path
        
        visited[vertex] = True
        
        for neighbor, weight in graph[vertex]:
            if not visited[neighbor]:
                new_dist = dist + weight
                if new_dist < distances[neighbor]:
                    distances[neighbor] = new_dist
                    parents[neighbor] = vertex
                    heapq.heappush(pq, (new_dist, neighbor))
    
    print(f"   ❌ No path from {start} to {end}")
    return None, None

# ============================================================================
# DIJKSTRA WITH PATH RECONSTRUCTION
# ============================================================================

def dijkstra_with_path(graph, start):
    """
    Dijkstra's that returns distances and paths to all vertices
    """
    distances, parents = dijkstra(graph, start)
    
    # Reconstruct all paths
    paths = {}
    for vertex in range(len(graph)):
        if distances[vertex] == float('inf'):
            paths[vertex] = None
        else:
            path = []
            current = vertex
            while current != -1:
                path.append(current)
                current = parents[current]
            path.reverse()
            paths[vertex] = path
    
    return distances, paths

# ============================================================================
# DIJKSTRA VS BELLMAN-FORD
# ============================================================================

def compare_dijkstra_bellmanford():
    """
    When to use Dijkstra vs Bellman-Ford
    """
    print("\n" + "=" * 70)
    print("Dijkstra vs Bellman-Ford")
    print("=" * 70)
    
    print("\n{'Aspect':<25} {'Dijkstra':<30} {'Bellman-Ford'}")
    print("─" * 85)
    print(f"{'Time Complexity':<25} {'O((V+E) log V)':<30} {'O(VE)'}")
    print(f"{'Works with negative weights':<25} {'No':<30} {'Yes'}")
    print(f"{'Detects negative cycles':<25} {'No':<30} {'Yes'}")
    print(f"{'Best for':<25} {'Non-negative weights':<30} {'Any weights'}")
    print(f"{'Data structure':<25} {'Priority Queue':<30} {'Array'}")
    
    print("\n💡 Use Dijkstra when:")
    print("   • All edge weights are non-negative")
    print("   • Need fastest algorithm for non-negative graphs")
    print("   • GPS navigation, network routing")
    
    print("\n💡 Use Bellman-Ford when:")
    print("   • Graph may have negative weights")
    print("   • Need to detect negative cycles")
    print("   • Currency arbitrage, routing protocols")

# ============================================================================
# EXAMPLE 1: Basic Dijkstra
# ============================================================================

print("=" * 70)
print("Example 1: Dijkstra's Algorithm")
print("=" * 70)

# Weighted graph: 0→1(4), 0→2(1), 1→3(1), 2→1(2), 2→3(5)
graph1 = [
    [(1, 4), (2, 1)],   # 0
    [(3, 1)],            # 1
    [(1, 2), (3, 5)],    # 2
    []                   # 3
]

dijkstra(graph1, 0)

# ============================================================================
# EXAMPLE 2: Shortest Path
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Shortest Path")
print("=" * 70)

# City map: cities and distances
# 0→1(5), 0→2(3), 1→2(2), 1→3(7), 2→3(4)
graph2 = [
    [(1, 5), (2, 3)],   # 0 (City A)
    [(2, 2), (3, 7)],   # 1 (City B)
    [(3, 4)],            # 2 (City C)
    []                   # 3 (City D)
]

dijkstra_shortest_path(graph2, 0, 3)

# ============================================================================
# EXAMPLE 3: Network Routing
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Network Routing (Routers)")
print("=" * 70)

# Router network with latencies
# 0→1(2), 0→2(6), 1→2(3), 1→3(7), 2→3(2), 2→4(4), 3→4(1)
graph3 = [
    [(1, 2), (2, 6)],    # Router 0
    [(2, 3), (3, 7)],    # Router 1
    [(3, 2), (4, 4)],    # Router 2
    [(4, 1)],            # Router 3
    []                   # Router 4
]

distances, paths = dijkstra_with_path(graph3, 0)
print("\nShortest paths from Router 0:")
for vertex in range(len(graph3)):
    if paths[vertex]:
        path_str = " → ".join(map(str, paths[vertex]))
        print(f"   To Router {vertex}: {path_str} (distance: {distances[vertex]})")

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Implementation':<30} {'Time':<25} {'Space'}")
print("─" * 80)
print(f"{'With Priority Queue (heap)':<30} {'O((V + E) log V)':<25} {'O(V)'}")
print(f"{'With Array':<30} {'O(V²)':<25} {'O(V)'}")
print(f"{'With Fibonacci Heap':<30} {'O(E + V log V)':<25} {'O(V)'}")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Dijkstra's finds shortest path in weighted graphs")
print("✓ Works only for non-negative edge weights")
print("✓ Uses greedy approach: always picks closest unvisited vertex")
print("✓ Priority queue makes it efficient: O((V+E) log V)")
print("✓ Perfect for: GPS navigation, network routing, game pathfinding")
print("✓ Key insight: Greedy choice (nearest vertex) is always optimal")
print("✓ Cannot handle negative weights - use Bellman-Ford instead")
