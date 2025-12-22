"""
Minimum Spanning Tree (MST)
Kruskal's and Prim's algorithms
"""

import heapq

# ============================================================================
# UNION-FIND DATA STRUCTURE
# ============================================================================

class UnionFind:
    """
    Union-Find (Disjoint Set) data structure
    Used in Kruskal's algorithm to detect cycles
    """
    
    def __init__(self, n):
        """Initialize n sets"""
        self.parent = list(range(n))
        self.rank = [0] * n
    
    def find(self, x):
        """Find root with path compression"""
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])  # Path compression
        return self.parent[x]
    
    def union(self, x, y):
        """Union two sets using union by rank"""
        root_x = self.find(x)
        root_y = self.find(y)
        
        if root_x == root_y:
            return False  # Already in same set (creates cycle!)
        
        # Union by rank
        if self.rank[root_x] < self.rank[root_y]:
            self.parent[root_x] = root_y
        elif self.rank[root_x] > self.rank[root_y]:
            self.parent[root_y] = root_x
        else:
            self.parent[root_y] = root_x
            self.rank[root_x] += 1
        
        return True  # Successfully merged

# ============================================================================
# KRUSKAL'S ALGORITHM
# ============================================================================

def kruskal(edges, num_vertices):
    """
    Kruskal's Algorithm - MST using Union-Find
    Greedy: Add smallest edge that doesn't create cycle
    Time: O(E log E) for sorting + O(E α(V)) for Union-Find
    Space: O(V)
    """
    print(f"\n🌳 Kruskal's Algorithm for MST")
    print(f"   Edges: {edges}")
    
    # Sort edges by weight
    sorted_edges = sorted(edges, key=lambda x: x[2])
    print(f"   Sorted edges by weight: {sorted_edges}")
    
    mst_edges = []
    mst_weight = 0
    uf = UnionFind(num_vertices)
    
    print(f"\n   Processing edges:")
    for u, v, weight in sorted_edges:
        if uf.union(u, v):
            mst_edges.append((u, v, weight))
            mst_weight += weight
            print(f"      ✅ Added edge {u}→{v} (weight: {weight}), total: {mst_weight}")
        else:
            print(f"      ❌ Skip edge {u}→{v} (weight: {weight}) - would create cycle")
    
    print(f"\n✓ MST weight: {mst_weight}")
    print(f"  MST edges: {mst_edges}")
    return mst_edges, mst_weight

# ============================================================================
# PRIM'S ALGORITHM
# ============================================================================

def prim(graph, start=0):
    """
    Prim's Algorithm - MST using priority queue
    Greedy: Start from vertex, always add minimum edge from MST to non-MST
    Time: O((V + E) log V) with heap
    Space: O(V)
    """
    print(f"\n🌳 Prim's Algorithm for MST (starting from vertex {start})")
    
    n = len(graph)
    mst_edges = []
    mst_weight = 0
    visited = [False] * n
    # Priority queue: (weight, from, to)
    pq = [(0, -1, start)]  # (weight, parent, vertex)
    
    print(f"   Initial queue: {[(w, to) for w, _, to in pq]}")
    
    while pq:
        weight, from_vertex, vertex = heapq.heappop(pq)
        
        if visited[vertex]:
            continue
        
        visited[vertex] = True
        mst_weight += weight
        
        if from_vertex != -1:
            mst_edges.append((from_vertex, vertex, weight))
            print(f"   ✅ Added edge {from_vertex}→{vertex} (weight: {weight}), total: {mst_weight}")
        
        # Add edges to unvisited neighbors
        for neighbor, edge_weight in graph[vertex]:
            if not visited[neighbor]:
                heapq.heappush(pq, (edge_weight, vertex, neighbor))
    
    print(f"\n✓ MST weight: {mst_weight}")
    print(f"  MST edges: {mst_edges}")
    return mst_edges, mst_weight

# ============================================================================
# KRUSKAL VS PRIM
# ============================================================================

def compare_kruskal_prim():
    """
    Comparison of Kruskal's and Prim's algorithms
    """
    print("\n" + "=" * 70)
    print("Kruskal vs Prim")
    print("=" * 70)
    
    print("\n{'Aspect':<25} {'Kruskal':<30} {'Prim'}")
    print("─" * 85)
    print(f"{'Approach':<25} {'Edge-based (greedy)':<30} {'Vertex-based (greedy)'}")
    print(f"{'Time (dense)':<25} {'O(E log E)':<30} {'O(V²)'}")
    print(f"{'Time (sparse)':<25} {'O(E log E)':<30} {'O(E log V)'}")
    print(f"{'Data structure':<25} {'Union-Find':<30} {'Priority Queue'}")
    print(f"{'Best for':<25} {'Sparse graphs':<30} {'Dense graphs'}")
    print(f"{'Works with':<25} {'Any graph (connected)':<30} {'Connected graph'}")
    
    print("\n💡 Use Kruskal when:")
    print("   • Graph is sparse (E << V²)")
    print("   • Need to work with edge list")
    print("   • Want simpler implementation")
    
    print("\n💡 Use Prim when:")
    print("   • Graph is dense (E ≈ V²)")
    print("   • Already have adjacency list")
    print("   • Need MST starting from specific vertex")

# ============================================================================
# EXAMPLE 1: Kruskal's Algorithm
# ============================================================================

print("=" * 70)
print("Example 1: Kruskal's Algorithm")
print("=" * 70)

# Graph: 0-1(10), 0-2(6), 0-3(5), 1-3(15), 2-3(4)
edges1 = [
    (0, 1, 10),
    (0, 2, 6),
    (0, 3, 5),
    (1, 3, 15),
    (2, 3, 4)
]

kruskal(edges1, 4)

# ============================================================================
# EXAMPLE 2: Prim's Algorithm
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Prim's Algorithm")
print("=" * 70)

# Same graph as adjacency list
graph2 = [
    [(1, 10), (2, 6), (3, 5)],   # 0
    [(0, 10), (3, 15)],           # 1
    [(0, 6), (3, 4)],             # 2
    [(0, 5), (1, 15), (2, 4)]     # 3
]

prim(graph2, 0)

# ============================================================================
# EXAMPLE 3: Network Design
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Network Design (Connecting Cities)")
print("=" * 70)

# Cities and cable costs
# City 0↔1(2), 0↔2(4), 0↔3(1), 1↔2(3), 1↔4(5), 2↔3(6), 2↔4(7), 3↔4(8)
edges3 = [
    (0, 1, 2),
    (0, 2, 4),
    (0, 3, 1),
    (1, 2, 3),
    (1, 4, 5),
    (2, 3, 6),
    (2, 4, 7),
    (3, 4, 8)
]

print("Problem: Connect all cities with minimum cable cost")
kruskal(edges3, 5)

# ============================================================================
# EXAMPLE 4: Union-Find Demo
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Union-Find Data Structure")
print("=" * 70)

uf = UnionFind(5)
print(f"\nInitial: {uf.parent}")

print(f"\nUnion(0, 1): {uf.union(0, 1)}")
print(f"  Parent: {uf.parent}, Rank: {uf.rank}")

print(f"\nUnion(2, 3): {uf.union(2, 3)}")
print(f"  Parent: {uf.parent}, Rank: {uf.rank}")

print(f"\nUnion(1, 2): {uf.union(1, 2)}")
print(f"  Parent: {uf.parent}, Rank: {uf.rank}")

print(f"\nFind(0): {uf.find(0)}")
print(f"Find(3): {uf.find(3)}")
print(f"Find(4): {uf.find(4)}")

print(f"\nUnion(0, 3): {uf.union(0, 3)} (already connected, returns False)")
print(f"  Parent: {uf.parent}")

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Algorithm':<25} {'Time':<25} {'Space':<20}")
print("─" * 70)
print(f"{'Kruskal':<25} {'O(E log E)':<25} {'O(V)'}")
print(f"{'Prim (with heap)':<25} {'O(E log V)':<25} {'O(V)'}")
print(f"{'Prim (with array)':<25} {'O(V²)':<25} {'O(V)'}")
print(f"{'Union-Find (amortized)':<25} {'O(α(V))':<25} {'O(V)'}")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ MST connects all vertices with minimum total edge weight")
print("✓ Kruskal: Sort edges, add smallest that doesn't create cycle")
print("✓ Prim: Start from vertex, always add minimum edge from MST")
print("✓ Both are greedy algorithms - optimal solution")
print("✓ Union-Find efficiently detects cycles in Kruskal's")
print("✓ Applications: Network design, cluster analysis, spanning trees")
print("✓ Key insight: Greedy choice (minimum edge) is always in MST")
