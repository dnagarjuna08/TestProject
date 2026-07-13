"""
	Written By: Gaurav Amrutkar
	Written Date: 05/04/2024
	Purpose: Call popup meesage handler and pass payload. 
"""
def showAlert(state, title, message, showCloseBtn, btnTextPrimary, btnTextSecondary, btnIconPrimary, btnIconSecondary, btnIconAlignment, btnActionPrimary, btnActionSecondary, btnActionClose, colName, folder, id, levelId):
	
	params = {"state":state, "title":title, "message":message, "showCloseBtn":showCloseBtn, "btnTextPrimary":btnTextPrimary, "btnTextSecondary":btnTextSecondary, "btnIconPrimary":btnIconPrimary, "btnIconSecondary":btnIconSecondary, "btnIconAlignment":btnIconAlignment, "btnActionPrimary":btnActionPrimary, "btnActionSecondary":btnActionSecondary, "btnActionClose":btnActionClose, "colName":colName, "folder":folder, "id":id,"levelId":levelId}
	system.perspective.openPopup(id="alertDialog", view="Project_VECV/PopUp/Alerts/alert", params=params, showCloseIcon=False, draggable=False, resizable=False, modal=False, overlayDismiss=True, btnActionPrimary="closePopup")
	
def showAlertUD(state, title, message, showCloseBtn, btnTextPrimary, btnTextSecondary, btnIconPrimary, btnIconSecondary, btnIconAlignment, btnActionPrimary, btnActionSecondary, btnActionClose, colName, folder, id, levelId):
		
		params = {"state":state, "title":title, "message":message, "showCloseBtn":showCloseBtn, "btnTextPrimary":btnTextPrimary, "btnTextSecondary":btnTextSecondary, "btnIconPrimary":btnIconPrimary, "btnIconSecondary":btnIconSecondary, "btnIconAlignment":btnIconAlignment, "btnActionPrimary":btnActionPrimary, "btnActionSecondary":btnActionSecondary, "btnActionClose":btnActionClose, "colName":colName, "folder":folder, "id":id,"levelId":levelId}
		system.perspective.openPopup(id="alertDialog", view="Project_VECV/PopUp/Alerts/alert_UD", params=params, showCloseIcon=False, draggable=False, resizable=False, modal=False, overlayDismiss=True, btnActionPrimary="closePopup")	


def confirmation(message):
	params = {"message":message}
	system.perspective.openPopup(id="confirmation", view="Project_VECV/PopUp/ConfirmationPopup", params=params, showCloseIcon=False, draggable=False, resizable=False, modal=False, overlayDismiss=True)

	
def showAlertOnDWI(state, title, message, showCloseBtn, btnTextPrimary, btnTextSecondary, btnIconPrimary, btnIconSecondary, btnIconAlignment, btnActionPrimary, btnActionSecondary, btnActionClose, colName, folder, id, levelId, originatingComponent):
		
	params = {"state":state, "title":title, "message":message, "showCloseBtn":showCloseBtn, "btnTextPrimary":btnTextPrimary, "btnTextSecondary":btnTextSecondary, "btnIconPrimary":btnIconPrimary, "btnIconSecondary":btnIconSecondary, "btnIconAlignment":btnIconAlignment, "btnActionPrimary":btnActionPrimary, "btnActionSecondary":btnActionSecondary, "btnActionClose":btnActionClose, "colName":colName, "folder":folder, "id":id,"levelId":levelId,'originatingComponent':originatingComponent}
	system.perspective.openPopup(id="alertDialogOnDWI", view="Project_VECV/PopUp/DWI/alertmessage", params=params, showCloseIcon=False, draggable=False, resizable=False, modal=False, overlayDismiss=True, btnActionPrimary="closePopup")	
	