def ProdStatus():
	try:

		from java.util import Date
		from java.util import Calendar
		from java.text import SimpleDateFormat
		from datetime import datetime, timedelta
		
		
		
		cal = Calendar.getInstance()
		cal.add(Calendar.DATE, -1)
		
		# Format the date to dd-MM-yy
		yesterday = cal.getTime()
		date_format = SimpleDateFormat("yyyy-MM-dd")
		today = date_format.format(yesterday)
		
		# Print or return the result
		print(today)
		now = datetime.now()
		
		
		# Calculate today_start, yesterday_start, and today_end
		fromDate_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
		from_date_month = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
		today_start = now.replace(hour=7, minute=30, second=59, microsecond=0)
		yesterday_start = fromDate_start - timedelta(days=1)
		today_end = today_start - timedelta(seconds=1) + timedelta(days=1)
		
		#Format datetime objects to the desired format
		fromDate = yesterday_start.strftime('%Y-%m-%d %H:%M:%S')
		toDate = today_start.strftime('%Y-%m-%d %H:%M:%S')
		from_date_month_str = from_date_month.strftime('%Y-%m-%d %H:%M:%S')  # Format monthly start date
		current_month = from_date_month.strftime('%B')  # Get the current month name (e.g., January, February)
		
		# Fetch email addresses
		try:
		    queryEmail = 'SELECT EmailID FROM MESPRODDB.dbo.MST_EmailUsers WHERE Priority=1 AND IsActive=1 AND IsDeleted=0'
		    emails = system.db.runQuery(queryEmail)  # Run the query directly to get the list of emails
		    email_list = [email[0] for email in emails]  # Assuming emails is a list of tuples
		    #email_list='asagar3@vecv.in'
		except Exception as e:
		    print("ProdStatusEmail").error("Failed to Fetch email " + str(e))
		    return
		
		# If no email addresses, log and exit
		if not email_list:
		    print("ProdStatusEmail").error("No Active Users for sending mail " + str(e))
		    return
		
		# Define WorkStations and order of tables
		workstation_order = [
		    (278, "Drive Head Washing Machine"),
		    (291, "Drive Head LD Quality Gate"),
		    (377, "Drive Head HD Quality Gate"),
		    (268, "HUB Washing Machine"),
		    (306, "HUB Quality Gate"),
		    (374, "Main Line Washing Machine"),
		    (280, "Main Line Quality Gate-1"),
		    (331, "Main Line Quality Gate-2"),
		    (324, "OIL Filling"),
		    (332, "PDI"),
		]
		
		# Define flow structure (grouped as columns, with a flow downward)
		flow_structure = [
		    ["Drive Head Washing Machine", "Drive Head LD Quality Gate", "Drive Head HD Quality Gate"],
		    ["HUB Washing Machine", "HUB Quality Gate"],
		    ["Main Line Washing Machine", "Main Line Quality Gate-1", "Main Line Quality Gate-2", "OIL Filling", "PDI"],
		]
		
		# Initialize email body
		email_body = (
		    "<p>Dear All,</p>"
		    "<p>Please find below the <b>Production Status Report</b> for date " + today + ": All Shifts</p>"
		    "<div style='display: flex; justify-content: space-between;'>"  # Start the flex layout
		)
		
		# Helper function to generate a compact HTML table and style last row and column
		def generate_table(results, table_name):
		    row_count = results.getRowCount()
		    column_names = results.getColumnNames()
		
		    html_table = (
		        "<div style='margin-top: 10px; width: 90%;'>"  # Increase width to 90% for the table
		        "<div style='background-color: yellow; font-weight: bold; padding: 5px; text-align: center;'>"
		        + table_name +
		        "</div>"
		        "<table style='border-collapse: collapse; width: 100%; font-family: Arial, sans-serif; font-size: 16px;'>"
		    )
		    html_table += "<thead><tr style='background-color: #0096FF; color: white;'>"
		    html_table += "".join(
		        "<th style='border: 1px solid #ddd; padding: 5px;'>" + col + "</th>" for col in column_names
		    )
		    html_table += "</tr></thead><tbody>"
		
		    for row_idx in range(row_count):
		        html_table += "<tr>"
		        for col_idx, col in enumerate(column_names):
		            value = str(results.getValueAt(row_idx, col))  # Get the value
		
		            # Style last row and last column in green
		            if row_idx == row_count - 1:  # Last row
		                value = "<td style='border: 1px solid #ddd; padding: 5px; background-color: #4CAF50; color: white; text-align: center;'>" + value + "</td>"
		            elif col_idx == len(column_names) - 1:  # Last column
		                value = "<td style='border: 1px solid #ddd; padding: 5px; background-color: #4CAF50; color: white; text-align: center;'>" + value + "</td>"
		            else:
		                value = "<td style='border: 1px solid #ddd; padding: 5px; text-align: center;'>" + value + "</td>"
		            html_table += value
		        html_table += "</tr>"
		
		    html_table += "</tbody></table></div>"
		    return html_table
		
		# Loop through the flow structure and generate tables
		for flow in flow_structure:
		    email_body += "<div style='width: 90%;'>"  # Set width for each column to 90%
		    for idx, table_name in enumerate(flow):
		        workstation = next(
		            (ws for ws, name in workstation_order if name == table_name), None
		        )
		        if workstation:
		            try:
		                results = system.db.runNamedQuery(
		                    "Project_VECV/Report/ProductionStatus/getData2",
		                    {"Date": today,"workstation":workstation}
		                )
		                email_body += generate_table(results, table_name)
		                # Add down arrow between tables, except the last one
		                if idx != len(flow) - 1:
		                    email_body += (
		                        "<div style='text-align: center; font-size: 50px; margin: 10px; display: flex; justify-content: center;'>"
		                        "&#8595;"  # Big down arrow symbol centered between tables
		                        "</div>"
		                    )
		            except Exception as e:
		                system.util.getLogger("ProdStatusEmail").error("Error fetching Data " + str(e))
		    email_body += "</div>"  # Close the column div
		
		# End the flex container
		email_body += "</div>"
		
		# Add the "MONTHLY Production - <Month>" in the header of the table
		#monthly_header = "<div style='margin-top: 30px; text-align: center; font-size: 18px; font-weight: bold;'>Monthly Production - " + current_month + "</div>"
		
		# Add the "MONTHLY Production" table below all tables (without affecting footer)
		#email_body += monthly_header  # Insert the bold header for the monthly production table
		#email_body += "<div style='margin-top: 30px;'>"
		try:
		    monthly_results = system.db.runNamedQuery(
		        "Project_VECV/Report/ProductionStatus/getData",
		        {"WorkStation": 332, "FromDate": from_date_month_str, "ToDate": toDate}
		    )
		    monthly_results2 = system.db.runNamedQuery(
		                                "Project_VECV/Report/ProductionStatus/getData",
		                                {"WorkStation": 331, "FromDate": from_date_month_str, "ToDate": toDate}
		                            )
		    email_body += generate_table(monthly_results2, "MONTHLY Production (LAQG02) -> "+current_month)
		    email_body += generate_table(monthly_results, "MONTHLY Production (PDI) -> "+current_month)
		except Exception as e:
		    system.util.getLogger("ProdStatusEmail").error("Error fetching monthly date" + str(e))
		
		email_body += "</div>"  # Close the div for the monthly production table
		
		# Add footer and links to the email (footer is normal text and will be placed after all the tables)
		email_body += (
		    "<p style='background-color: #D3D3D3; font-size: small;'>"
		    "<b>Click <a href='http://10.109.1.71:8088/data/perspective/client/VECV_Ignition_V1_1_1/ProductionStatus'><u>HERE</u></a> to view this report in MES PLATFORM</b>"
		    "</p>"
		    "<p style='background-color: #D3D3D3; font-size: small;'>"
		    "<b>Click <a href='https://isupport.vecv.net/MDLServiceMgmt/SR_LogServiceCatalog.aspx?es=IfFNluw5HyCtQkeT7wQi8eZB4Ve2VK1WrmItHTyquJCWYFOue%2bscW7q4hr8fsypB0j410plSUDEj4%2bnn%2bnV82Cwl63oy%2f0Ek38ThogbDjo81XZ1pfJKCh8vzszs8hYT1U7o58v6t7ZCerta3PXRaCg%3d%3d'><u>HERE</u></a> to Raise request for user ID creation in MES to view all reports</b>"
		    "</p>"
		    "<p style='background-color: yellow; font-size: small;'>"
		    "<b>This is autogenerated mail, please do not reply.</b>"
		    "</p>"
		    "<p style='background-color: yellow; font-size: small;'>"
		    "<b>For any support, contact Aniket Sagar on <a href='mailto:asgar3@vecv.in'>asgar3@vecv.in</a> or 7903511741.</b>"
		    "</p>"
		    "<p style='font-style: italic;'><b>Regards,<br>MES ADMIN</b></p>"
		)
		
		# Send email
		try:
		    system.net.sendEmail(
		        smtpProfile="SMTPEmail",
		        fromAddr="mes_email_admin@vecv.in",
		        subject="MES || AXLE SHOP || Production Status Report (" + today + " All Shifts)",
		        body=email_body,
		        html=1,
		        to=email_list
		    )
		    print("ProdStatusEmail-->send email to all users")
		except Exception as e:
		    print(e)
	
	except Exception as e:
	    print(e)