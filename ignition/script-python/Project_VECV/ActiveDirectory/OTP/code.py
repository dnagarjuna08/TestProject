def getOTP():
	"""
	Written By: AmitKumar ravat
	Written Date: 25/08/2024
	Purpose:			 
			Get OTP value. 
	"""
	import random
	import string
	length=6
	# Define the characters that can be used in the OTP
	characters = string.ascii_letters + string.digits
	# Generate a random OTP
	otp = ''.join(random.choice(characters) for _ in range(length))
	return otp.upper()