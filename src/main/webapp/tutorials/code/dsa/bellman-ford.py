"""
Bellman-Ford Algorithm
Shortest path with negative weights and cycle detection
"""

# ============================================================================
# BELLMAN-FORD ALGORITHM
# ============================================================================

def bellman_ford(edges, num_vertices, start):
    """
    Bellman-Ford Algorithm
    Finds shortest path even with negative weights
    Detects negative cycles
    
    edges: list of (from, to, weight) tuples
    num_vertices: number of vertices
    start: starting vertex
    Returns: (distances, has_negative_cycle, parents)
    Time: O(VE), Space: O(V)
    """
    print(f"\n⚖️ Bellman-Ford Algorithm starting from vertex {start}")
    print(f"   Edges: {edges}")
    
    distances = [float('inf')] * num_vertices
    parents = [-1] * num_vertices
    distances[start] = 0
    
    print(f"   Initial distances: {distances}")
    
    # Relax edges V-1 times
    for i in range(num_vertices - 1):
        print(f"\n   Iteration {i + 1}/{num_vertices - 1}:")
        updated = False
        for u, v, w in edges:
            if distances[u] != float('inf') and distances[u] + w < distances[v]:
                old_dist = distances[v]
                distances[v] = distances[u] + w
                parents[v] = u
                updated = True
                print(f"      Relax {u}→{v}: {old_dist} → {distances[v]}")
        
        if not updated:
            print(f"      No updates, early termination possible")
            break
    
    # Check for negative cycles (one more relaxation)
    print(f"\n   Checking for negative cycles:")
    has_negative_cycle = False
    for u, v, w in edges:
        if distances[u] != float('inf') and distances[u] + w < distances[v]:
            has_negative_cycle = True
            print(f"      ⚠️ Negative cycle detected! Edge {u}→{v} can still be relaxed")
            break
    
    if not has_negative_cycle:
        print(f"      ✓ No negative cycle found")
    
    print(f"\n   Final distances: {distances}")
    print(f"   Parents: {parents}")
    
    return distances, has_negative_cycle, parents

# ============================================================================
# BELLMAN-FORD WITH PATH RECONSTRUCTION
# ============================================================================

def bellman_ford_shortest_path(edges, num_vertices, start, end):
    """
    Find shortest path from start to end using Bellman-Ford
    Returns: (distance, path, has_cycle) or (None, None, True) if negative cycle
    """
    distances, has_cycle, parents = bellman_ford(edges, num_vertices, start)
    
    if has_cycle:
        print(f"\n   ❌ Cannot find shortest path - negative cycle exists!")
        return None, None, True
    
    if distances[end] == float('inf'):
        print(f"\n   ❌ No path from {start} to {end}")
        return None, None, False
    
    # Reconstruct path
    path = []
    current = end
    while current != -1:
        path.append(current)
        current = parents[current]
    path.reverse()
    
    print(f"\n   ✓ Shortest path: {' → '.join(map(str, path))}")
    print(f"   Distance: {distances[end]}")
    
    return distances[end], path, False

# ============================================================================
# NEGATIVE CYCLE DETECTION
# ============================================================================

def detect_negative_cycle(edges, num_vertices):
    """
    Detect if graph has negative cycle reachable from any vertex
    Returns: True if negative cycle exists
    """
    print(f"\n🔍 Detecting negative cycles")
    
    # Try from each vertex (in case graph is not connected)
    for start in range(num_vertices):
        distances = [float('inf')] * num_vertices
        distances[start] = 0
        
        # Run V-1 iterations
        for _ in range(num_vertices - 1):
            for u, v, w in edges:
                if distances[u] != float('inf') and distances[u] + w < distances[v]:
                    distances[v] = distances[u] + w
        
        # Check for negative cycle
        for u, v, w in edges:
            if distances[u] != float('inf') and distances[u] + w < distances[v]:
                print(f"   ⚠️ Negative cycle detected! Reachable from vertex {start}")
                return True
    
    print(f"   ✓ No negative cycles found")
    return False

# ============================================================================
# CURRENCY ARBITRAGE EXAMPLE
# ============================================================================

def currency_arbitrage(rates):
    """
    Currency Arbitrage Problem
    Given exchange rates, find if arbitrage opportunity exists
    Uses Bellman-Ford with log transformation
    """
    print(f"\n💰 Currency Arbitrage Detection")
    print(f"   Exchange rates: {rates}")
    
    # Convert to graph: -log(rate) to find negative cycles
    edges = []
    num_currencies = len(rates)
    
    for i in range(num_currencies):
        for j in range(num_currencies):
            if i != j and rates[i][j] > 0:
                # Negative log because we want to find negative cycles
                weight = -1 * (rates[i][j] * 100)  # Simplified for demo
                edges.append((i, j, weight))
    
    # Check for negative cycle
    has_cycle = detect_negative_cycle(edges, num_currencies)
    
    if has_cycle:
        print(f"   💵 Arbitrage opportunity exists!")
    else:
        print(f"   ✓ No arbitrage opportunity")
    
    return has_cycle

# ============================================================================
# EXAMPLE 1: Basic Bellman-Ford
# ============================================================================

print("=" * 70)
print("Example 1: Bellman-Ford Algorithm")
print("=" * 70)

# Graph: 0→1(4), 0→2(5), 1→2(-3), 1→3(1), 2→3(2)
edges1 = [
    (0, 1, 4),
    (0, 2, 5),
    (1, 2, -3),
    (1, 3, 1),
    (2, 3, 2)
]

bellman_ford(edges1, 4, 0)

# ============================================================================
# EXAMPLE 2: Negative Weights
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Graph with Negative Weights")
print("=" * 70)

# Graph: 0→1(1), 1→2(-2), 2→3(3), 0→3(4)
edges2 = [
    (0, 1, 1),
    (1, 2, -2),
    (2, 3, 3),
    (0, 3, 4)
]

bellman_ford_shortest_path(edges2, 4, 0, 3)

# ============================================================================
# EXAMPLE 3: Negative Cycle Detection
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Negative Cycle Detection")
print("=" * 70)

# Graph with negative cycle: 0→1(1), 1→2(-2), 2→0(-1)
edges3 = [
    (0, 1, 1),
    (1, 2, -2),
    (2, 0, -1)  # Creates negative cycle
]

bellman_ford(edges3, 3, 0)

# ============================================================================
# EXAMPLE 4: Currency Arbitrage
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Currency Arbitrage")
print("=" * 70)

# Simplified currency rates (USD, EUR, GBP)
# rates[i][j] = how many of currency j you get for 1 of currency i
rates = [
    [1.0, 0.85, 0.75],   # USD
    [1.18, 1.0, 0.88],   # EUR
    [1.33, 1.14, 1.0]    # GBP
]

currency_arbitrage(rates)

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Operation':<30} {'Time':<20} {'Space'}")
print("─" * 70)
print(f"{'Bellman-Ford':<30} {'O(VE)':<20} {'O(V)'}")
print(f"{'Negative cycle detection':<30} {'O(VE)':<20} {'O(V)'}")
print(f"{'Shortest path':<30} {'O(VE)':<20} {'O(V)'}")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Bellman-Ford works with negative weights")
print("✓ Detects negative cycles in O(VE) time")
print("✓ Slower than Dijkstra but more versatile")
print("✓ Relaxes edges V-1 times, then checks for cycles")
print("✓ Applications: Currency arbitrage, routing protocols")
print("✓ Key insight: After V-1 iterations, if we can still relax, negative cycle exists")
print("✓ Use when: Graph may have negative weights or need cycle detection")
