# Function Arguments
# Information can be passed into functions as arguments.

# 1. Positional Arguments
def describe_pet(animal_type, pet_name):
    print(f"I have a {animal_type} named {pet_name}.")

describe_pet("hamster", "Harry")

# 2. Keyword Arguments
describe_pet(pet_name="Harry", animal_type="hamster")

# 3. Default Arguments
def describe_pet_default(pet_name, animal_type="dog"):
    print(f"I have a {animal_type} named {pet_name}.")

describe_pet_default("Willie")
describe_pet_default("Harry", "hamster")

# 4. Arbitrary Arguments (*args)
def make_pizza(*toppings):
    print(f"\nMaking a pizza with: {', '.join(toppings)}")

make_pizza("pepperoni")
make_pizza("mushrooms", "green peppers", "extra cheese")

# 5. Arbitrary Keyword Arguments (**kwargs)
def build_profile(first, last, **user_info):
    profile = {}
    profile['first_name'] = first
    profile['last_name'] = last
    for key, value in user_info.items():
        profile[key] = value
    return profile

user_profile = build_profile('albert', 'einstein', location='princeton', field='physics')
print(f"\nUser Profile: {user_profile}")
