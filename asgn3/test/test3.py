# Find square root of real or complex numbers
# Import the complex math module
import cmath
num = eval(input())
while num > 5:
	num_sqrt = cmath.sqrt(num)
else:
	num_sqrt = num_sqrt + 5
print(num_sqrt)
