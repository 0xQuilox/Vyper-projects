# pragma version ^0.4.0
# @license MIT

struct Person:
    favorite_number: uint256
    name: String[100]

my_name: public(String[100])
my_favorite_number: public(uint256) = 7
list_of_numbers: public(uint256[5]) = [0, 0, 0, 0, 0]
list_of_people: public(Person[5])
index: public(uint256)
name_to_favorite_number: public(HashMap[String[100], uint256])

@deploy
def __init__():
    self.my_favorite_number = 7
    self.index = 0
    self.my_name = "Patrick!"

@external
def store(new_number: uint256):
    self.my_favorite_number = new_number

@external
@view
def retrieve() -> uint256:

    return self.my_favorite_number
