# Exercise: Temperature Converter
# Create a Temperature class using properties for unit conversion

class Temperature:
    """
    Store temperature internally as Celsius.
    Provide properties for accessing/setting in different units.
    """

    def __init__(self, celsius=0):
        # Store as celsius (with validation via setter)
        # Your code here:
        pass

    # 1. Create a celsius property (getter)
    #    Returns the internal _celsius value
    # Your code here:


    # 2. Create a celsius setter
    #    Validate: must be >= -273.15 (absolute zero)
    #    Raise ValueError if invalid
    # Your code here:


    # 3. Create a fahrenheit property (getter)
    #    Formula: F = C * 9/5 + 32
    # Your code here:


    # 4. Create a fahrenheit setter
    #    Convert to celsius and store
    #    Formula: C = (F - 32) * 5/9
    # Your code here:


    # 5. Create a kelvin property (getter only, read-only)
    #    Formula: K = C + 273.15
    # Your code here:


    # 6. Create a __str__ method
    #    Return: "{celsius}°C / {fahrenheit}°F / {kelvin}K"
    # Your code here:



# Test your implementation:

# t = Temperature(0)
# print(t)  # 0°C / 32.0°F / 273.15K

# t.celsius = 100
# print(t)  # 100°C / 212.0°F / 373.15K

# t.fahrenheit = 68
# print(t)  # 20.0°C / 68.0°F / 293.15K

# Try invalid temperature
# try:
#     t.celsius = -300
# except ValueError as e:
#     print(f"Error: {e}")

# Kelvin should be read-only
# try:
#     t.kelvin = 300  # Should fail!
# except AttributeError:
#     print("Kelvin is read-only (as expected)")
