import pynini as pn
import sys


# Helper function to return all outputs of the given fst in sorted order
def sorted_outputs(fst):
    return sorted([p[1] for p in fst.paths()])

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

# You can debug the factorizer by generating random paths through it
# print(list(pn.randgen(factorizer, 5).paths()))

# Now, let's define number-to-string mappings

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


a1_9 = pn.u(*"123456789").optimize()
a0_9 = (a1_9 | pn.a("0")).optimize()

f1 = (((a1_9 + pn.t("", "^ ")) | "") + a0_9).optimize()
f2 = ((a1_9 + pn.t("", "^^ ")) + ((a0_9 + pn.t("", "^ "))) + a0_9).optimize()
f = (f2 | f1).optimize()
f = pn.u(f, f + "." + a0_9.plus)

map1_9 = {"1": "one", "2": "two", "3": "three", "4": "four", "5": "five", 
          "6": "six", "7": "seven", "8": "eight", "9": "nine"}
map10_19 = {"1^ 0": "ten", "1^ 1": "eleven", "1^ 2": "twelve", "1^ 3": "thirteen", 
            "1^ 4": "fourteen", "1^ 5": "fifteen", "1^ 6": "sixteen", "1^ 7": "seventeen",
           "1^ 8": "eighteen", "1^ 9": "nineteen"}
map20_90 = {"2^": "twenty", "3^": "thirty", "4^": "fourty", "5^": "fifty", "6^": "sixty",
           "7^": "seventy", "8^": "eighty", "9^": "ninety"}

t1_9 = pn.string_map(map1_9).optimize()
t10_19 = pn.string_map(map10_19).optimize()
t20_90 = pn.string_map(map20_90).optimize()

t1_19 = (t1_9 | t10_19)

tens = (t20_90 + " " + pn.t("0",""))
t20_99 = ( tens | (t20_90 + " " +  t1_9))
          
t1_99 = pn.u(t1_19, t20_99)
          
t100 = pn.t("^^", " hundred")
hundred = pn.u(t1_9 + t100, (t1_9 + t100 + pn.t(" 0^", "")), (pn.t("1", "") + pn.t("^^", "hundred"))) 
hundreds = pn.u((t1_9 + t100 + pn.t(" 0^ 0", "")), pn.t("1^^ 0^ 0", "hundred"))
          
final = pn.u(t1_99, hundreds, hundred + " " + t1_99, pn.t("0", "zero"))

penultimate = final + pn.t(".", " point") + (pn.t("", " ") + pn.u(t1_9, pn.t("0", "zero"))).plus
ultimate = pn.u(final, penultimate)

numbers_to_words = f * ultimate


# Test, for your convinience
# If you have completed the above FSTs, the following asserts should not fail
# Feel free to comment them out while developing the program
assert (sorted_outputs("1" * numbers_to_words) == ["one"])
assert (sorted_outputs("0" * numbers_to_words) == ["zero"])
assert (sorted_outputs("10" * numbers_to_words) == ["ten"])
assert (sorted_outputs("11" * numbers_to_words) == ["eleven"])
assert (sorted_outputs("21" * numbers_to_words) == ["twenty one"])
assert (sorted_outputs("121" * numbers_to_words) == ["hundred twenty one", "one hundred twenty one"])
assert (sorted_outputs("12.23" * numbers_to_words) == ["twelve point two three"])


invert_ultimate = pn.invert(ultimate)

invert_ultimate = pn.invert(ultimate) * pn.invert(f)




# Now, the interactive program
while True:
    try:
        number = raw_input("Please enter a number or '-r' for inverted behaviour (Ctrl-C to exit): ")
        if number.startswith("-r"):
            number = raw_input("Please write out a number (Ctrl-C to exit): ")
            print("Result in numbers")
            print(sorted_outputs(number * invert_ultimate))
        else:
            print("Result in factorized form")
            print((number * f).stringify())
            print("Result in words")
            print(sorted_outputs(number * numbers_to_words))        
    except EOFError:
        print("")
        break
