def delayTime(Sectime):
	import time
	 
	# Record the start time
	start_time = time.time()
	print start_time
	 
	# Run the loop for 5 seconds
	while True:
	    # Check the elapsed time
	    if time.time() - start_time > Sectime:
	        break
	end_time = time.time()
	print end_time