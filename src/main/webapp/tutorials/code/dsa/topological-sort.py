"""
Topological Sorting
Ordering vertices in directed acyclic graph (DAG) such that
for every edge (u, v), u comes before v in ordering
"""

from collections import deque

# ============================================================================
# KAHN'S ALGORITHM (BFS-based)
# ============================================================================

def topological_sort_kahn(graph):
    """
    Kahn's Algorithm for Topological Sort
    Uses BFS approach with in-degree tracking
    Time: O(V + E), Space: O(V)
    
    graph: adjacency list representation of DAG
    Returns: topological order, or None if cycle exists
    """
    print(f"\n📑 Topological Sort (Kahn's Algorithm)")
    
    n = len(graph)
    in_degree = [0] * n
    
    # Calculate in-degrees
    for vertex in range(n):
        for neighbor in graph[vertex]:
            in_degree[neighbor] += 1
    
    print(f"   In-degrees: {in_degree}")
    
    # Start with vertices having in-degree 0
    queue = deque([i for i in range(n) if in_degree[i] == 0])
    result = []
    
    print(f"   Initial queue (in-degree 0): {list(queue)}")
    
    while queue:
        vertex = queue.popleft()
        result.append(vertex)
        print(f"   ✅ Processing {vertex}, result: {result}")
        
        # Reduce in-degree of neighbors
        for neighbor in graph[vertex]:
            in_degree[neighbor] -= 1
            print(f"      Neighbor {neighbor}: in-degree → {in_degree[neighbor]}")
            
            if in_degree[neighbor] == 0:
                queue.append(neighbor)
                print(f"         ➕ Added {neighbor} to queue")
    
    # Check for cycle
    if len(result) != n:
        print(f"\n   ⚠️ Cycle detected! Only {len(result)}/{n} vertices processed")
        return None
    
    print(f"\n✓ Topological order: {result}")
    return result

# ============================================================================
# DFS-BASED TOPOLOGICAL SORT
# ============================================================================

def topological_sort_dfs(graph):
    """
    Topological Sort using DFS
    Processes vertices in reverse finish time order
    Time: O(V + E), Space: O(V)
    """
    print(f"\n📑 Topological Sort (DFS-based)")
    
    n = len(graph)
    visited = [False] * n
    stack = []
    
    def dfs(vertex):
        visited[vertex] = True
        print(f"   Visiting {vertex}")
        
        for neighbor in graph[vertex]:
            if not visited[neighbor]:
                dfs(neighbor)
        
        # Push to stack when finished (all descendants processed)
        stack.append(vertex)
        print(f"   Finished {vertex}, added to stack")
    
    # DFS for all vertices
    for vertex in range(n):
        if not visited[vertex]:
            dfs(vertex)
    
    # Reverse stack to get topological order
    result = stack[::-1]
    print(f"\n✓ Topological order: {result}")
    return result

# ============================================================================
# COURSE SCHEDULE PROBLEM
# ============================================================================

def can_finish_courses(num_courses, prerequisites):
    """
    Course Schedule Problem
    Can you finish all courses given prerequisites?
    
    num_courses: total number of courses
    prerequisites: list of [course, prerequisite] pairs
    Returns: True if possible, False if cycle exists
    """
    print(f"\n🎓 Can finish {num_courses} courses?")
    print(f"   Prerequisites: {prerequisites}")
    
    # Build graph: prerequisite → course
    graph = [[] for _ in range(num_courses)]
    in_degree = [0] * num_courses
    
    for course, prereq in prerequisites:
        graph[prereq].append(course)
        in_degree[course] += 1
    
    print(f"   Graph: {graph}")
    print(f"   In-degrees: {in_degree}")
    
    # Kahn's algorithm
    queue = deque([i for i in range(num_courses) if in_degree[i] == 0])
    completed = 0
    
    while queue:
        course = queue.popleft()
        completed += 1
        print(f"   ✅ Completed course {course} ({completed}/{num_courses})")
        
        for next_course in graph[course]:
            in_degree[next_course] -= 1
            if in_degree[next_course] == 0:
                queue.append(next_course)
    
    can_finish = completed == num_courses
    print(f"\n✓ Result: {'Yes' if can_finish else 'No'} - {'All courses can be completed' if can_finish else 'Cycle detected, impossible'}")
    return can_finish

def find_course_order(num_courses, prerequisites):
    """
    Find course order (topological sort) if possible
    Returns: list of courses in order, or None if cycle
    """
    print(f"\n🎓 Finding course order for {num_courses} courses")
    
    graph = [[] for _ in range(num_courses)]
    in_degree = [0] * num_courses
    
    for course, prereq in prerequisites:
        graph[prereq].append(course)
        in_degree[course] += 1
    
    queue = deque([i for i in range(num_courses) if in_degree[i] == 0])
    result = []
    
    while queue:
        course = queue.popleft()
        result.append(course)
        
        for next_course in graph[course]:
            in_degree[next_course] -= 1
            if in_degree[next_course] == 0:
                queue.append(next_course)
    
    if len(result) != num_courses:
        print(f"   ❌ Cycle detected! Cannot complete all courses")
        return None
    
    print(f"   ✓ Course order: {result}")
    return result

# ============================================================================
# BUILD ORDER (Task Dependencies)
# ============================================================================

def build_order(projects, dependencies):
    """
    Build order problem: In what order should projects be built?
    
    projects: list of project names
    dependencies: list of (project, depends_on) pairs
    Returns: build order, or None if circular dependency
    """
    print(f"\n🔨 Build order for projects: {projects}")
    print(f"   Dependencies: {dependencies}")
    
    # Create mapping
    name_to_id = {name: i for i, name in enumerate(projects)}
    id_to_name = {i: name for i, name in enumerate(projects)}
    
    n = len(projects)
    graph = [[] for _ in range(n)]
    in_degree = [0] * n
    
    for project, depends_on in dependencies:
        proj_id = name_to_id[project]
        dep_id = name_to_id[depends_on]
        graph[dep_id].append(proj_id)
        in_degree[proj_id] += 1
    
    # Kahn's algorithm
    queue = deque([i for i in range(n) if in_degree[i] == 0])
    result = []
    
    while queue:
        proj_id = queue.popleft()
        result.append(id_to_name[proj_id])
        
        for next_id in graph[proj_id]:
            in_degree[next_id] -= 1
            if in_degree[next_id] == 0:
                queue.append(next_id)
    
    if len(result) != n:
        print(f"   ❌ Circular dependency detected!")
        return None
    
    print(f"   ✓ Build order: {' → '.join(result)}")
    return result

# ============================================================================
# EXAMPLE 1: Basic Topological Sort (Kahn's)
# ============================================================================

print("=" * 70)
print("Example 1: Topological Sort (Kahn's Algorithm)")
print("=" * 70)

# DAG: 0→1, 0→2, 1→3, 2→3
graph1 = [
    [1, 2],   # 0 → 1, 2
    [3],      # 1 → 3
    [3],      # 2 → 3
    []        # 3 (sink)
]

print("\nGraph: 0→1→3, 0→2→3")
print("Valid orders: [0,1,2,3], [0,2,1,3]")
topological_sort_kahn(graph1)

# ============================================================================
# EXAMPLE 2: Topological Sort (DFS-based)
# ============================================================================

print("\n" + "=" * 70)
print("Example 2: Topological Sort (DFS-based)")
print("=" * 70)

topological_sort_dfs(graph1)

# ============================================================================
# EXAMPLE 3: Course Schedule
# ============================================================================

print("\n" + "=" * 70)
print("Example 3: Course Schedule Problem")
print("=" * 70)

print("\n--- Can finish all courses? ---")
prerequisites1 = [[1, 0], [2, 1], [3, 2]]  # 0 → 1 → 2 → 3
can_finish_courses(4, prerequisites1)

print("\n--- Find course order ---")
find_course_order(4, prerequisites1)

print("\n--- Cycle detected ---")
prerequisites2 = [[1, 0], [0, 1]]  # Circular dependency
can_finish_courses(2, prerequisites2)

# ============================================================================
# EXAMPLE 4: Build Order
# ============================================================================

print("\n" + "=" * 70)
print("Example 4: Build Order (Project Dependencies)")
print("=" * 70)

projects = ['a', 'b', 'c', 'd', 'e', 'f']
dependencies = [
    ('d', 'a'),
    ('b', 'f'),
    ('d', 'b'),
    ('a', 'f'),
    ('c', 'd')
]

build_order(projects, dependencies)

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Algorithm':<30} {'Time':<20} {'Space':<20}")
print("─" * 70)
print(f"{'Kahn's Algorithm':<30} {'O(V + E)':<20} {'O(V)':<20}")
print(f"{'DFS-based':<30} {'O(V + E)':<20} {'O(V)':<20}")
print(f"{'Course Schedule':<30} {'O(V + E)':<20} {'O(V)':<20}")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Topological sort orders vertices in DAG (no cycles)")
print("✓ For edge (u, v), u comes before v in ordering")
print("✓ Multiple valid orders may exist")
print("✓ Kahn's: BFS-based, uses in-degree")
print("✓ DFS-based: Processes in reverse finish time")
print("✓ Applications: Build systems, course prerequisites, task scheduling")
print("✓ Cycle detection: If not all vertices processed, cycle exists")
print("✓ Key insight: Start with vertices having no dependencies (in-degree 0)")
