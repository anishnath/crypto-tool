"""
Heap Applications
Practical problems solved with heaps
"""

import heapq  # Python's built-in heap (min heap)

# ============================================================================
# APPLICATION 1: K LARGEST ELEMENTS
# ============================================================================

def k_largest_elements(arr, k):
    """
    Find K largest elements
    Real-world: Top K products, highest scores, trending items
    Time: O(n log k), Space: O(k)
    """
    print(f"\n🔝 Finding {k} largest elements from {arr}")
    
    # Use min heap of size k
    # Keep only k largest by removing smallest
    min_heap = []
    
    for num in arr:
        heapq.heappush(min_heap, num)
        
        # If heap size exceeds k, remove smallest
        if len(min_heap) > k:
            removed = heapq.heappop(min_heap)
            print(f"   Removed {removed}, heap: {min_heap}")
    
    result = sorted(min_heap, reverse=True)
    print(f"   Result: {result}")
    return result

# ============================================================================
# APPLICATION 2: K SMALLEST ELEMENTS
# ============================================================================

def k_smallest_elements(arr, k):
    """
    Find K smallest elements
    Real-world: Lowest prices, nearest neighbors
    Time: O(n log k), Space: O(k)
    """
    print(f"\n🔻 Finding {k} smallest elements from {arr}")
    
    # Use max heap of size k (negate values)
    max_heap = []
    
    for num in arr:
        heapq.heappush(max_heap, -num)  # Negate for max heap
        
        if len(max_heap) > k:
            heapq.heappop(max_heap)
    
    result = sorted([-x for x in max_heap])
    print(f"   Result: {result}")
    return result

# ============================================================================
# APPLICATION 3: MERGE K SORTED LISTS
# ============================================================================

def merge_k_sorted_lists(lists):
    """
    Merge K sorted lists
    Real-world: Merge log files, combine sorted data streams
    Time: O(N log k), Space: O(k)
    where N = total elements, k = number of lists
    """
    print(f"\n🔀 Merging {len(lists)} sorted lists")
    
    # Min heap: (value, list_index, element_index)
    min_heap = []
    
    # Add first element from each list
    for i, lst in enumerate(lists):
        if lst:
            heapq.heappush(min_heap, (lst[0], i, 0))
    
    result = []
    
    while min_heap:
        val, list_idx, elem_idx = heapq.heappop(min_heap)
        result.append(val)
        
        # Add next element from same list
        if elem_idx + 1 < len(lists[list_idx]):
            next_val = lists[list_idx][elem_idx + 1]
            heapq.heappush(min_heap, (next_val, list_idx, elem_idx + 1))
    
    print(f"   Result: {result}")
    return result

# ============================================================================
# APPLICATION 4: RUNNING MEDIAN
# ============================================================================

class MedianFinder:
    """
    Find median from data stream
    Real-world: Real-time analytics, monitoring systems
    Time: O(log n) per add, O(1) for median
    """
    
    def __init__(self):
        # Max heap for smaller half (negate values)
        self.small = []
        # Min heap for larger half
        self.large = []
    
    def add_num(self, num):
        """Add number to stream"""
        # Add to appropriate heap
        if not self.small or num <= -self.small[0]:
            heapq.heappush(self.small, -num)
        else:
            heapq.heappush(self.large, num)
        
        # Balance heaps (size difference at most 1)
        if len(self.small) > len(self.large) + 1:
            val = -heapq.heappop(self.small)
            heapq.heappush(self.large, val)
        elif len(self.large) > len(self.small):
            val = heapq.heappop(self.large)
            heapq.heappush(self.small, -val)
    
    def find_median(self):
        """Get current median"""
        if len(self.small) > len(self.large):
            return -self.small[0]
        else:
            return (-self.small[0] + self.large[0]) / 2

# ============================================================================
# APPLICATION 5: TOP K FREQUENT ELEMENTS
# ============================================================================

def top_k_frequent(nums, k):
    """
    Find K most frequent elements
    Real-world: Trending topics, popular products
    Time: O(n log k), Space: O(n)
    """
    print(f"\n📊 Finding {k} most frequent elements from {nums}")
    
    # Count frequencies
    from collections import Counter
    count = Counter(nums)
    
    # Min heap of (frequency, element)
    min_heap = []
    
    for num, freq in count.items():
        heapq.heappush(min_heap, (freq, num))
        
        if len(min_heap) > k:
            heapq.heappop(min_heap)
    
    result = [num for freq, num in sorted(min_heap, reverse=True)]
    print(f"   Result: {result}")
    return result

# ============================================================================
# APPLICATION 6: TASK SCHEDULER
# ============================================================================

def task_scheduler(tasks, n):
    """
    Schedule tasks with cooling period
    Real-world: CPU scheduling, rate limiting
    Time: O(m log k), Space: O(k)
    where m = total time, k = unique tasks
    """
    print(f"\n⏰ Scheduling tasks {tasks} with cooldown {n}")
    
    from collections import Counter
    count = Counter(tasks)
    
    # Max heap of frequencies (negate for max heap)
    max_heap = [-freq for freq in count.values()]
    heapq.heapify(max_heap)
    
    time = 0
    
    while max_heap:
        temp = []
        
        # Process up to n+1 tasks (one cycle)
        for i in range(n + 1):
            if max_heap:
                freq = heapq.heappop(max_heap)
                if freq < -1:  # Still has tasks remaining
                    temp.append(freq + 1)
            
            time += 1
            
            # If heap empty and no pending tasks, done
            if not max_heap and not temp:
                break
        
        # Add back tasks with remaining frequency
        for freq in temp:
            heapq.heappush(max_heap, freq)
    
    print(f"   Total time: {time}")
    return time

# ============================================================================
# APPLICATION 7: KTH LARGEST IN STREAM
# ============================================================================

class KthLargest:
    """
    Find Kth largest element in stream
    Real-world: Leaderboards, ranking systems
    """
    
    def __init__(self, k, nums):
        self.k = k
        self.min_heap = nums
        heapq.heapify(self.min_heap)
        
        # Keep only k largest
        while len(self.min_heap) > k:
            heapq.heappop(self.min_heap)
    
    def add(self, val):
        """Add value and return kth largest"""
        heapq.heappush(self.min_heap, val)
        
        if len(self.min_heap) > self.k:
            heapq.heappop(self.min_heap)
        
        return self.min_heap[0]

# ============================================================================
# APPLICATION 8: MEETING ROOMS II
# ============================================================================

def min_meeting_rooms(intervals):
    """
    Find minimum meeting rooms needed
    Real-world: Resource allocation, scheduling
    Time: O(n log n), Space: O(n)
    """
    print(f"\n🏢 Finding minimum meeting rooms for {intervals}")
    
    if not intervals:
        return 0
    
    # Sort by start time
    intervals.sort()
    
    # Min heap of end times
    min_heap = []
    
    for start, end in intervals:
        # If earliest meeting ended, reuse room
        if min_heap and min_heap[0] <= start:
            heapq.heappop(min_heap)
        
        # Add current meeting's end time
        heapq.heappush(min_heap, end)
    
    rooms = len(min_heap)
    print(f"   Minimum rooms needed: {rooms}")
    return rooms

# ============================================================================
# EXAMPLES
# ============================================================================

print("=" * 70)
print("Heap Applications")
print("=" * 70)

# Example 1: K Largest
print("\n" + "=" * 70)
print("Example 1: K Largest Elements")
print("=" * 70)
k_largest_elements([3, 2, 1, 5, 6, 4], 2)

# Example 2: K Smallest
print("\n" + "=" * 70)
print("Example 2: K Smallest Elements")
print("=" * 70)
k_smallest_elements([3, 2, 1, 5, 6, 4], 2)

# Example 3: Merge K Sorted Lists
print("\n" + "=" * 70)
print("Example 3: Merge K Sorted Lists")
print("=" * 70)
lists = [[1, 4, 5], [1, 3, 4], [2, 6]]
merge_k_sorted_lists(lists)

# Example 4: Running Median
print("\n" + "=" * 70)
print("Example 4: Running Median")
print("=" * 70)
mf = MedianFinder()
print("Adding numbers and finding median:")
for num in [1, 2, 3, 4, 5]:
    mf.add_num(num)
    print(f"  Added {num}, median: {mf.find_median()}")

# Example 5: Top K Frequent
print("\n" + "=" * 70)
print("Example 5: Top K Frequent Elements")
print("=" * 70)
top_k_frequent([1, 1, 1, 2, 2, 3], 2)

# Example 6: Task Scheduler
print("\n" + "=" * 70)
print("Example 6: Task Scheduler")
print("=" * 70)
task_scheduler(['A', 'A', 'A', 'B', 'B', 'B'], 2)

# Example 7: Kth Largest in Stream
print("\n" + "=" * 70)
print("Example 7: Kth Largest in Stream")
print("=" * 70)
kth = KthLargest(3, [4, 5, 8, 2])
print("Initial array: [4, 5, 8, 2], k=3")
for val in [3, 5, 10, 9, 4]:
    result = kth.add(val)
    print(f"  Added {val}, 3rd largest: {result}")

# Example 8: Meeting Rooms
print("\n" + "=" * 70)
print("Example 8: Meeting Rooms")
print("=" * 70)
min_meeting_rooms([[0, 30], [5, 10], [15, 20]])

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Heaps excel at 'top K' problems")
print("✓ Use min heap for K largest (keep smallest at top)")
print("✓ Use max heap for K smallest (keep largest at top)")
print("✓ Two heaps for running median (small + large)")
print("✓ Heap for merging K sorted lists")
print("✓ Priority queue for scheduling")
print("✓ O(n log k) is better than O(n log n) when k << n")
