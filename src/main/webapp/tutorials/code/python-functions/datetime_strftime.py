
import datetime

x = datetime.datetime.now()

# Format date as string
print("Week day, full version:", x.strftime("%A"))
print("Month name, full version:", x.strftime("%B"))
print("Day of month:", x.strftime("%d"))
print("Year, full version:", x.strftime("%Y"))
print("Hour 00-23:", x.strftime("%H"))
print("Minute 00-59:", x.strftime("%M"))
print("Second 00-59:", x.strftime("%S"))
print("Format date & time:", x.strftime("%c"))
