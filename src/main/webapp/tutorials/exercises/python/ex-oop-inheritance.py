# Exercise: Employee Hierarchy
# Create a class hierarchy for employees

# Base class - already provided
class Employee:
    def __init__(self, name, salary):
        self.name = name
        self.salary = salary

    def get_annual_salary(self):
        return self.salary * 12

    def describe(self):
        return f"{self.name}, Salary: ${self.salary:,}/month"


# 1. Create a Manager class that inherits from Employee
#    - Add a 'department' attribute in __init__
#    - Add a 'team' list to track direct reports
#    - Override describe() to include department and team size
#    - Add method: add_report(employee) - adds an employee to team
# Your code here:


# 2. Create a Developer class that inherits from Employee
#    - Add a 'programming_languages' list in __init__
#    - Override describe() to include languages
#    - Add method: add_language(language) - adds to the list
# Your code here:


# 3. Create a TechLead class that inherits from BOTH Developer and Manager
#    - Should have all capabilities of both classes
#    - Override describe() to show all info
# Your code here:



# Test your implementation:

# Create employees
# dev1 = Developer("Alice", 6000, ["Python", "JavaScript"])
# dev2 = Developer("Bob", 5500, ["Java"])
# mgr = Manager("Carol", 8000, "Engineering")
# lead = TechLead("David", 9000, "Platform", ["Python", "Go", "Rust"])

# Test Manager
# mgr.add_report(dev1)
# mgr.add_report(dev2)
# print(mgr.describe())

# Test Developer
# dev1.add_language("TypeScript")
# print(dev1.describe())

# Test TechLead (has both capabilities)
# lead.add_report(dev1)
# lead.add_language("Kotlin")
# print(lead.describe())
