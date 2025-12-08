# Return Values
# A function can return data as a result.

# 1. Returning a Simple Value
def get_formatted_name(first_name, last_name):
    full_name = f"{first_name} {last_name}"
    return full_name.title()

musician = get_formatted_name('jimi', 'hendrix')
print(musician)

# 2. Returning a Dictionary
def build_person(first_name, last_name, age=None):
    person = {'first': first_name, 'last': last_name}
    if age:
        person['age'] = age
    return person

musician = build_person('jimi', 'hendrix', age=27)
print(musician)

# 3. Returning Multiple Values (Tuples)
def get_min_max(numbers):
    return min(numbers), max(numbers)

min_val, max_val = get_min_max([1, 5, 2, 9, 3])
print(f"Min: {min_val}, Max: {max_val}")
