
import time

# Get seconds since epoch (Jan 1, 1970)
seconds = time.time()
print(f"Seconds since epoch: {seconds}")

# Calculate execution time
start = time.time()
# ... do something ...
for i in range(1000):
    pass
end = time.time()

print(f"Execution time: {end - start} seconds")
