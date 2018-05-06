import pynini as pn
import sys


# Helper function to return all outputs of the fiven fst in sorted order
def sorted_outputs(fst):
    return sorted([p[1] for p in fst.paths()])


# Create an acceptor for digits 1..9
a_1_to_9 = pn.u(*"123456789").optimize()

# Create an acceptor for digits 0..9
a_0_to_9 = (a_1_to_9 | pn.a("0")).optimize()

# First, let's define the factorizer.
# Factorizer converts numbers to their factorized form, using ^ characters
# to denote powers of ten:
#
# 0    -> 0
# 1    -> 1
# 10   -> 1^
# 23   -> 2^ 3
# 203 ->  2^^ 3
# TODO: currently only works for 0..99
factorizer = (((a_1_to_9 + pn.t("", "^ ")) | "") + a_0_to_9).optimize()

# You can debug the factorizer by generating random paths through it
# print(list(pn.randgen(factorizer, 5).paths()))

# Now, let's define number-to-string mappings

map_1_to_9 = {"1": "one", "2": "two", "3": "three", "4": "four", "5": "five",
              "6": "six", "7": "seven", "8": "eight", "9": "nine"}
t_1_to_9 = pn.string_map(map_1_to_9).optimize()

# TODO: define the similar mappings for teens (10..19) and tens (20, 30, 40, etc)
# map_10_to_19
# map_20_to_90

# Now, define a FST that uses the mapper FSTs to transform factorized form to 
# verbalized form:
# 0    -> zero
# 1^   -> ten
# 1^ 1 -> eleven
# 9^ 1 -> ninety one
# 1^^ 9^ 1 -> ['one hundred ninety one', 'hundred ninety one']
# TODO: currently only works for single digits (and doesn't work for zero)
factorized_to_words = t_1_to_9

numbers_to_words = factorizer * factorized_to_words

# Test, for your convinience
# If you have completed the above FSTs, the following asserts should not fail
# Feel free to comment them out while developing the program
assert (sorted_outputs("1" * numbers_to_words) == ["one"])
assert (sorted_outputs("0" * numbers_to_words) == ["zero"])
assert (sorted_outputs("10" * numbers_to_words) == ["ten"])
assert (sorted_outputs("11" * numbers_to_words) == ["eleven"])
assert (sorted_outputs("21" * numbers_to_words) == ["twenty one"])
assert (sorted_outputs("121" * numbers_to_words) == ["hundred twenty one", "one hundred twenty one"])
assert (sorted_outputs("12.23" * numbers_to_words) == ["twelwe point two three"])

# Now, the interactive program
while True:
    try:
        number = raw_input("Please enter a number (Ctrl-D to exit): ")
        print("Result in factorized form")
        print((number * factorizer).stringify())
        print("Result in words")
        print(sorted_outputs(number * numbers_to_words))
    except EOFError:
        print("")
        break
