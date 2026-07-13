"""
	Written By: Amitkumar Ravat
	Written Date: 05/06/2024
	Purpose: Function to show loader. 
"""
def openLoader(isVisible):
	popupPath = 'Project_VECV/Templates/Loader'
	if isVisible:
		system.perspective.openPopup('loaderPopUp', popupPath,showCloseIcon = False, overlayDismiss = True, modal = True)
	else:
		system.perspective.closePopup('loaderPopUp')
	return 0