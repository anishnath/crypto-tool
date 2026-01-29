
import datetime

# Get current date and time
x = datetime.datetime.now()
print(x)

# Print specific attributes
print(f"Year: {x.year}")
print(f"Month: {x.strftime('%B')}") # Month name
