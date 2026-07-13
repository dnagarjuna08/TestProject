def getColumnDictObjects():
	""" 
	Returns:
		A dictionary of dictionary objects for displaying embedded icons and labels in a Perspective table
	"""
	return {
		"selected": 		{"enabled":True, "value":True, "path":"material/check_box", "style":{"backgroundColor":"", "color":"var(--callToAction)", "cursor":"pointer"}},
		"notSelected": 		{"enabled":True, "value":False, "path":"material/check_box_outline_blank", "style":{"backgroundColor":"", "color":"var(--label)", "cursor":"pointer"}},
		"selectDisabled": 	{"enabled":False, "value":False, "path":"material/check_box_outline_blank", "style":{"backgroundColor":"", "color":"var(--neutral-50)", "cursor":"not-allowed"}}
		}
#	return {
#		"selected": 		{"enabled":True, "value":True, "path":"material/check_box", "style":{"backgroundColor":"", "color":"var(--callToAction)", "cursor":"pointer"}},
#		"notSelected": 		{"enabled":True, "value":False, "path":"material/check_box_outline_blank", "style":{"backgroundColor":"", "color":"var(--label)", "cursor":"pointer"}},
#		"selectDisabled": 	{"enabled":False, "value":False, "path":"material/check_box_outline_blank", "style":{"backgroundColor":"", "color":"var(--neutral-50)", "cursor":"not-allowed"}}
#		}
	
def getGroupStyle(group):
	"""
	Returns:
		A style object
	"""
	idx = int(str(ord(group))[-1])
	colors = {
		0: {"background-color": "var(--qual-1)", "color":"var(--white)"}, #
		1: {"background-color": "var(--qual-2)", "color":"var(--label)"},
		2: {"background-color": "var(--qual-3)", "color":"var(--white)"}, #
		3: {"background-color": "var(--qual-4)", "color":"var(--white)"}, #
		4: {"background-color": "var(--qual-5)", "color":"var(--label)"},
		5: {"background-color": "var(--qual-6)", "color":"var(--white)"}, #
		6: {"background-color": "var(--qual-7)", "color":"var(--white)"}, #
		7: {"background-color": "var(--qual-8)", "color":"var(--white)"}, #
		8: {"background-color": "var(--qual-9)", "color":"var(--label)"},
		9: {"background-color": "var(--qual-10)", "color":"var(--label)"},
	}
	return colors[idx]
	
def incrementGroup(group):
    # Function to increment an alpha string (e.g., 'A' -> 'B', 'AA' -> 'AB', etc.)
    if not group:
        return 'A'

    lastChar = group[-1]
    if lastChar == 'Z':
        return increment_alpha(group[:-1]) + 'A'
    else:
        return group[:-1] + chr(ord(lastChar) + 1)

def decrementGroup(group):
    # Function to decrement an alpha string (e.g., 'B' -> 'A', 'AB' -> 'AA', etc.)
    if not group:
        return ''

    lastChar = group[-1]
    if lastChar == 'A':
        return decrement_alpha(group[:-1]) + 'Z'
    else:
        return group[:-1] + chr(ord(lastChar) - 1)