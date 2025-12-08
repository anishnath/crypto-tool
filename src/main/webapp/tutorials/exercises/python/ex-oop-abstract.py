# Exercise: Notification System
# Create an abstract notification system with multiple implementations

from abc import ABC, abstractmethod

# 1. Create an abstract Notifier class with:
#    - Abstract method: send(message) - sends the notification
#    - Abstract property: name - returns the notifier name
#    - Concrete method: notify(message) - prints "[name] Sending..." then calls send()
# Your code here:


# 2. Create EmailNotifier class:
#    - __init__ takes email_address
#    - name property returns "Email"
#    - send() returns "Email sent to {email_address}: {message}"
# Your code here:


# 3. Create SMSNotifier class:
#    - __init__ takes phone_number
#    - name property returns "SMS"
#    - send() returns "SMS sent to {phone_number}: {message}"
# Your code here:


# 4. Create PushNotifier class:
#    - __init__ takes device_id
#    - name property returns "Push"
#    - send() returns "Push notification to device {device_id}: {message}"
# Your code here:


# 5. Create a notify_all function that takes a list of notifiers
#    and a message, and calls notify() on each one
# Your code here:



# Test your implementation:

# notifiers = [
#     EmailNotifier("user@example.com"),
#     SMSNotifier("+1234567890"),
#     PushNotifier("device-abc-123")
# ]

# notify_all(notifiers, "Your order has shipped!")

# Expected output:
# [Email] Sending...
# Email sent to user@example.com: Your order has shipped!
# [SMS] Sending...
# SMS sent to +1234567890: Your order has shipped!
# [Push] Sending...
# Push notification to device device-abc-123: Your order has shipped!

# Try to instantiate abstract class (should fail):
# try:
#     n = Notifier()
# except TypeError:
#     print("Cannot instantiate abstract Notifier (expected)")
