"""
Graph Representation
Different ways to represent graphs in code
"""

# ============================================================================
# ADJACENCY MATRIX
# ============================================================================

class GraphAdjMatrix:
    """
    Graph using Adjacency Matrix
    Good for: Dense graphs, quick edge lookups
    Space: O(V²), Time to check edge: O(1)
    """
    
    def __init__(self, num_vertices, directed=False):
        """
        Initialize graph with V vertices
        directed: True for directed graph, False for undirected
        """
        self.num_vertices = num_vertices
        self.directed = directed
        # Create V×V matrix initialized to 0
        self.matrix = [[0] * num_vertices for _ in range(num_vertices)]
        print(f"📊 Created {num_vertices}×{num_vertices} adjacency matrix")
        print(f"   Type: {'Directed' if directed else 'Undirected'}")
    
    def add_edge(self, from_vertex, to_vertex, weight=1):
        """Add edge from from_vertex to to_vertex"""
        if from_vertex < 0 or from_vertex >= self.num_vertices:
            print(f"   ❌ Invalid vertex: {from_vertex}")
            return
        
        if to_vertex < 0 or to_vertex >= self.num_vertices:
            print(f"   ❌ Invalid vertex: {to_vertex}")
            return
        
        self.matrix[from_vertex][to_vertex] = weight
        print(f"   ➕ Edge: {from_vertex} → {to_vertex} (weight: {weight})")
        
        # If undirected, add reverse edge
        if not self.directed:
            self.matrix[to_vertex][from_vertex] = weight
            print(f"   ➕ Edge: {to_vertex} → {from_vertex} (weight: {weight})")
    
    def has_edge(self, from_vertex, to_vertex):
        """Check if edge exists - O(1) time!"""
        if 0 <= from_vertex < self.num_vertices and 0 <= to_vertex < self.num_vertices:
            return self.matrix[from_vertex][to_vertex] != 0
        return False
    
    def get_neighbors(self, vertex):
        """Get all neighbors of a vertex"""
        neighbors = []
        for i in range(self.num_vertices):
            if self.matrix[vertex][i] != 0:
                neighbors.append((i, self.matrix[vertex][i]))
        return neighbors
    
    def print_matrix(self):
        """Print the adjacency matrix"""
        print(f"\n📊 Adjacency Matrix ({self.num_vertices}×{self.num_vertices}):")
        print("   ", end="")
        for i in range(self.num_vertices):
            print(f"{i:4}", end="")
        print()
        
        for i in range(self.num_vertices):
            print(f"{i:2} ", end="")
            for j in range(self.num_vertices):
                print(f"{self.matrix[i][j]:4}", end="")
            print()

# ============================================================================
# ADJACENCY LIST
# ============================================================================

class GraphAdjList:
    """
    Graph using Adjacency List
    Good for: Sparse graphs, space efficient
    Space: O(V + E), Time to check edge: O(degree)
    """
    
    def __init__(self, num_vertices, directed=False):
        """Initialize graph with V vertices"""
        self.num_vertices = num_vertices
        self.directed = directed
        # List of lists - each vertex has list of (neighbor, weight) tuples
        self.adj_list = [[] for _ in range(num_vertices)]
        print(f"📋 Created adjacency list for {num_vertices} vertices")
        print(f"   Type: {'Directed' if directed else 'Undirected'}")
    
    def add_edge(self, from_vertex, to_vertex, weight=1):
        """Add edge from from_vertex to to_vertex"""
        if from_vertex < 0 or from_vertex >= self.num_vertices:
            print(f"   ❌ Invalid vertex: {from_vertex}")
            return
        
        if to_vertex < 0 or to_vertex >= self.num_vertices:
            print(f"   ❌ Invalid vertex: {to_vertex}")
            return
        
        # Add to adjacency list
        self.adj_list[from_vertex].append((to_vertex, weight))
        print(f"   ➕ Edge: {from_vertex} → {to_vertex} (weight: {weight})")
        
        # If undirected, add reverse edge
        if not self.directed:
            self.adj_list[to_vertex].append((from_vertex, weight))
            print(f"   ➕ Edge: {to_vertex} → {from_vertex} (weight: {weight})")
    
    def has_edge(self, from_vertex, to_vertex):
        """Check if edge exists - O(degree) time"""
        for neighbor, _ in self.adj_list[from_vertex]:
            if neighbor == to_vertex:
                return True
        return False
    
    def get_neighbors(self, vertex):
        """Get all neighbors of a vertex - O(degree) time"""
        return self.adj_list[vertex]
    
    def print_adj_list(self):
        """Print the adjacency list"""
        print(f"\n📋 Adjacency List:")
        for i in range(self.num_vertices):
            neighbors = [f"{v}(w:{w})" for v, w in self.adj_list[i]]
            if neighbors:
                print(f"   {i}: {', '.join(neighbors)}")
            else:
                print(f"   {i}: (no neighbors)")

# ============================================================================
# EDGE LIST
# ============================================================================

class GraphEdgeList:
    """
    Graph using Edge List
    Good for: Kruskal's algorithm, when you need to iterate edges
    Space: O(E), Time to check edge: O(E)
    """
    
    def __init__(self, num_vertices, directed=False):
        """Initialize graph with V vertices"""
        self.num_vertices = num_vertices
        self.directed = directed
        # List of (from, to, weight) tuples
        self.edges = []
        print(f"📝 Created edge list for {num_vertices} vertices")
        print(f"   Type: {'Directed' if directed else 'Undirected'}")
    
    def add_edge(self, from_vertex, to_vertex, weight=1):
        """Add edge from from_vertex to to_vertex"""
        if from_vertex < 0 or from_vertex >= self.num_vertices:
            print(f"   ❌ Invalid vertex: {from_vertex}")
            return
        
        if to_vertex < 0 or to_vertex >= self.num_vertices:
            print(f"   ❌ Invalid vertex: {to_vertex}")
            return
        
        # Add edge
        self.edges.append((from_vertex, to_vertex, weight))
        print(f"   ➕ Edge: {from_vertex} → {to_vertex} (weight: {weight})")
        
        # If undirected, add reverse edge
        if not self.directed:
            self.edges.append((to_vertex, from_vertex, weight))
            print(f"   ➕ Edge: {to_vertex} → {from_vertex} (weight: {weight})")
    
    def has_edge(self, from_vertex, to_vertex):
        """Check if edge exists - O(E) time"""
        for u, v, _ in self.edges:
            if u == from_vertex and v == to_vertex:
                return True
        return False
    
    def get_all_edges(self):
        """Get all edges - O(1) to iterate"""
        return self.edges
    
    def print_edges(self):
        """Print all edges"""
        print(f"\n📝 Edge List ({len(self.edges)} edges):")
        for u, v, w in self.edges:
            print(f"   {u} → {v} (weight: {w})")

# ============================================================================
# EXAMPLE 1: Social Network (Undirected Graph)
# ============================================================================

print("=" * 70)
print("Example 1: Social Network (Undirected Graph)")
print("=" * 70)
print("\nGraph: Friends connections")
print("0 ↔ 1, 0 ↔ 2, 1 ↔ 2, 1 ↔ 3, 2 ↔ 3")

# Adjacency Matrix
print("\n--- Adjacency Matrix ---")
graph_matrix = GraphAdjMatrix(4, directed=False)
graph_matrix.add_edge(0, 1)
graph_matrix.add_edge(0, 2)
graph_matrix.add_edge(1, 2)
graph_matrix.add_edge(1, 3)
graph_matrix.add_edge(2, 3)
graph_matrix.print_matrix()

print("\n✓ Check edge 0→1:", graph_matrix.has_edge(0, 1))
print("✓ Check edge 0→3:", graph_matrix.has_edge(0, 3))
print("✓ Neighbors of 1:", graph_matrix.get_neighbors(1))

# Adjacency List
print("\n--- Adjacency List ---")
graph_list = GraphAdjList(4, directed=False)
graph_list.add_edge(0, 1)
graph_list.add_edge(0, 2)
graph_list.add_edge(1, 2)
graph_list.add_edge(1, 3)
graph_list.add_edge(2, 3)
graph_list.print_adj_list()

print("\n✓ Check edge 0→1:", graph_list.has_edge(0, 1))
print("✓ Check edge 0→3:", graph_list.has_edge(0, 3))
print("✓ Neighbors of 1:", graph_list.get_neighbors(1))

# Edge List
print("\n--- Edge List ---")
graph_edges = GraphEdgeList(4, directed=False)
graph_edges.add_edge(0, 1)
graph_edges.add_edge(0, 2)
graph_edges.add_edge(1, 2)
graph_edges.add_edge(1, 3)
graph_edges.add_edge(2, 3)
graph_edges.print_edges()

# ============================================================================
# EXAMPLE 2: Directed Graph (Web Links)
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Web Links (Directed Graph)")
print("=" * 70)
print("\nGraph: Web pages and links")
print("0 → 1, 0 → 2, 1 → 2, 2 → 3, 3 → 0")

graph_directed = GraphAdjList(4, directed=True)
graph_directed.add_edge(0, 1)
graph_directed.add_edge(0, 2)
graph_directed.add_edge(1, 2)
graph_directed.add_edge(2, 3)
graph_directed.add_edge(3, 0)
graph_directed.print_adj_list()

print("\n✓ Check edge 0→2:", graph_directed.has_edge(0, 2))
print("✓ Check edge 2→0:", graph_directed.has_edge(2, 0))  # Should be False

# ============================================================================
# EXAMPLE 3: Weighted Graph (City Map)
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: City Map (Weighted Graph)")
print("=" * 70)
print("\nGraph: Cities and distances")
print("0 → 1 (distance: 5)")
print("0 → 2 (distance: 3)")
print("1 → 2 (distance: 2)")
print("1 → 3 (distance: 7)")
print("2 → 3 (distance: 4)")

graph_weighted = GraphAdjList(4, directed=False)
graph_weighted.add_edge(0, 1, 5)
graph_weighted.add_edge(0, 2, 3)
graph_weighted.add_edge(1, 2, 2)
graph_weighted.add_edge(1, 3, 7)
graph_weighted.add_edge(2, 3, 4)
graph_weighted.print_adj_list()

# ============================================================================
# COMPARISON: When to Use Each
# ============================================================================

print("\n" + "=" * 70)
print("Comparison: When to Use Each Representation")
print("=" * 70)

print("\n{'Representation':<20} {'Space':<15} {'Check Edge':<15} {'Best For'}")
print("─" * 75)
print(f"{'Adjacency Matrix':<20} {'O(V²)':<15} {'O(1)':<15} {'Dense graphs, quick lookups'}")
print(f"{'Adjacency List':<20} {'O(V + E)':<15} {'O(degree)':<15} {'Sparse graphs, common choice'}")
print(f"{'Edge List':<20} {'O(E)':<15} {'O(E)':<15} {'Kruskal's, iterate all edges'}")

print("\n💡 Key Insights:")
print("   • Dense graph (E ≈ V²): Use adjacency matrix")
print("   • Sparse graph (E << V²): Use adjacency list")
print("   • Need to iterate edges: Use edge list")
print("   • Most algorithms use adjacency list (best balance)")

# ============================================================================
# COMPLEXITY SUMMARY
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Summary")
print("=" * 70)

print(f"\n{'Operation':<25} {'Adj Matrix':<20} {'Adj List':<20} {'Edge List'}")
print("─" * 85)
print(f"{'Space':<25} {'O(V²)':<20} {'O(V + E)':<20} {'O(E)'}")
print(f"{'Check edge':<25} {'O(1)':<20} {'O(degree)':<20} {'O(E)'}")
print(f"{'Get neighbors':<25} {'O(V)':<20} {'O(degree)':<20} {'O(E)'}")
print(f"{'Add edge':<25} {'O(1)':<20} {'O(1)':<20} {'O(1)'}")
print(f"{'Iterate all edges':<25} {'O(V²)':<20} {'O(V + E)':<20} {'O(E)'}")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Adjacency Matrix: Fast edge lookups, but space-expensive")
print("✓ Adjacency List: Space-efficient, most common choice")
print("✓ Edge List: Best for algorithms that iterate all edges")
print("✓ Choose based on your graph density and operations needed")
print("✓ Most graph algorithms use adjacency list representation")
