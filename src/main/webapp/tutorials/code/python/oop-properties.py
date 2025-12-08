# Python Properties
# The @property decorator allows you to define methods that can be accessed like attributes.
# This is useful for implementing getters and setters.

class Celsius:
    def __init__(self, temperature=0):
        self._temperature = temperature

    @property
    def temperature(self):
        print("Getting value...")
        return self._temperature

    @temperature.setter
    def temperature(self, value):
        print("Setting value...")
        if value < -273.15:
            raise ValueError("Temperature below -273.15 is not possible")
        self._temperature = value

    @temperature.deleter
    def temperature(self):
        print("Deleting value...")
        del self._temperature

# Usage
c = Celsius()

# Calls the getter
c.temperature = 37

# Calls the getter
print(c.temperature)

# Validation check
try:
    c.temperature = -300
except ValueError as e:
    print(e)
