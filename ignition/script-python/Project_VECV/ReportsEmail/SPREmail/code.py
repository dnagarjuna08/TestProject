def ProdStatus():
    try:
		from datetime import datetime, timedelta
		
		# Current datetime
		now = datetime.now()
		
		# Calculate date ranges
		fromDate_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
		from_date_month = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
		today_start = now.replace(hour=7, minute=30, second=59, microsecond=0)
		yesterday_start = fromDate_start - timedelta(days=1)
		today_end = today_start - timedelta(seconds=1) + timedelta(days=1)
		
		# Format datetime objects
		fromDate = yesterday_start.strftime('%Y-%m-%d %H:%M:%S')
		toDate = today_start.strftime('%Y-%m-%d %H:%M:%S')
		from_date_month_str = from_date_month.strftime('%Y-%m-%d %H:%M:%S')  
		current_month = from_date_month.strftime('%B')  
		
		# Fetch email addresses
		try:
		    queryEmail = 'SELECT EmailID FROM MESPRODDB.dbo.MST_EmailUsers WHERE Priority=1 AND IsActive=1 AND IsDeleted=0'
		    emails = system.db.runQuery(queryEmail)  
		    #email_list = 'asagar3@vecv.in'
		    email_list = [email[0] for email in emails]  # Assuming emails is a list of tuples  
		    #email_list='asagar3@vecv.in'
		except Exception as e:
		    system.util.getLogger("SPR REPORT").error("Failed to Fetch email " + str(e))
		    return
		
		# Check if email list is empty
		if not email_list:
		    system.util.getLogger("SPR REPORT").error("No Active Users for sending mail")
		    return
		
		# Workstations in order
		workstation_order = [
		    (291, "Drive Head LD Quality Gate"),
		    (377, "Drive Head HD Quality Gate"),
		    (306, "HUB Quality Gate"),
		    (280, "Main Line Quality Gate-1"),
		    (331, "Main Line Quality Gate-2"),
		    (332, "PDI"),
		]
		
		# Flow structure for table layout
		flow_structure = [
		    ["Drive Head LD Quality Gate", "Drive Head HD Quality Gate"],
		    ["HUB Quality Gate"],
		    ["Main Line Quality Gate-1", "Main Line Quality Gate-2", "PDI"],
		]
		
		# Initialize email body
		email_body = (
		    "<p>Dear All,</p>"
		    "<p>Please find below the <b>SPR Report</b> for date " + fromDate + ": All Shifts</p>"
		    "<div style='display: flex; justify-content: space-between;'>"
		)
		
		# Function to generate an HTML table
		def generate_table(results, table_name):
		    row_count = results.getRowCount()
		    column_names = results.getColumnNames()
		
		    # Mapping for display (DB column names → Display names)
		    column_mapping = {
		        "Shift": "SHIFT",
		        "SerialCount": "Total Production",
		        "DefectCount": "Defect Count",
		        "DefectSerialCount": "Defect Serial Count"
		    }
		
		    # Remove "SNo" and "SortOrder" from columns
		    filtered_columns = [col for col in column_names if col not in ["SNo", "SortOrder"]]
		
		    # Add SPR column to display
		    display_columns = [column_mapping.get(col, col) for col in filtered_columns] + ["SPR (%)"]
		
		    html_table = (
		        "<div style='margin-top: 10px; width: 90%;'>"
		        "<div style='background-color: yellow; font-weight: bold; padding: 5px; text-align: center;'>"
		        + table_name +
		        "</div>"
		        "<table style='border-collapse: collapse; width: 100%; font-family: Arial, sans-serif; font-size: 16px;'>"
		    )
		
		    # Header Row
		    html_table += "<thead><tr style='background-color: #0096FF; color: white;'>"
		    html_table += "".join(
		        "<th style='border: 1px solid #ddd; padding: 5px;'>" + col + "</th>" for col in display_columns
		    )
		    html_table += "</tr></thead><tbody>"
		
		    # Data Rows
		    for row_idx in range(row_count):
		        html_table += "<tr>"
		        total_production = 0
		        defect_serial_count = 0
		
		        for db_col in filtered_columns:  # Use original DB column names
		            value = str(results.getValueAt(row_idx, db_col))
		
		            # Capture values for SPR calculation
		            if db_col == "SerialCount":
		                total_production = int(value) if value.isdigit() else 0
		            if db_col == "DefectSerialCount":
		                defect_serial_count = int(value) if value.isdigit() else 0
		
		            # Style last row green & default alignment
		            if row_idx == row_count - 1:  # Total row
		                value = "<td style='border: 1px solid #ddd; padding: 5px; background-color: #4CAF50; color: white; text-align: center;'>" + value + "</td>"
		            else:
		                value = "<td style='border: 1px solid #ddd; padding: 5px; text-align: center;'>" + value + "</td>"
		            html_table += value
		
		        # **Correct SPR Calculation**
		        if total_production > 0:
		            spr = spr = ((total_production - defect_serial_count) / float(total_production)) * 100
		            print(spr)
		        else:
		            spr = 100  # If no production, assume 100% (as there are no defects)
		
		        # **Red Highlighting for SPR < 100%**
		        spr_color = "red" if spr < 100 else "white"
		        spr_cell = "<td style='border: 1px solid #ddd; padding: 5px; background-color: " + spr_color + "; text-align: center;'>" + str(round(spr, 2)) + "</td>"
		
		        html_table += spr_cell
		        html_table += "</tr>"
		
		    html_table += "</tbody></table></div>"
		    return html_table
		
		# Loop through the structure and add tables
		for flow in flow_structure:
		    email_body += "<div style='width: 90%;'>"  
		    for idx, table_name in enumerate(flow):
		        workstation = next((ws for ws, name in workstation_order if name == table_name), None)
		        if workstation:
		            try:
		                results = system.db.runNamedQuery(
		                    "Project_VECV/Report/getQualityDefectCount",
		                    {"MST_WorkStation_Id": workstation, "date": fromDate}
		                )
		                email_body += generate_table(results, table_name)
		                if idx != len(flow) - 1:
		                    email_body += "<div style='text-align: center; font-size: 50px; margin: 10px; display: flex; justify-content: center;'>&#8595;</div>"
		            except Exception as e:
		                system.util.getLogger("ProdStatusEmail").error("Error fetching Data " + str(e))
		    email_body += "</div>"  
		
		email_body += "</div>"
		
		try:
		      resultsDaySpr = system.db.runNamedQuery(
		          "Project_VECV/Report/getDaySPR",
		          {"date": fromDate}
		      )
		  
		      print(resultsDaySpr.getColumnNames())  # Debugging check
		  
		      row_count = resultsDaySpr.getRowCount()
		      total_row_count = 0  # Counter to track "Total" rows
		  
		      email_body += "<div style='margin-top: 10px; width: 90%;'>"
		      email_body += "<div style='background-color: yellow; font-weight: bold; padding: 5px; text-align: center;'>Day SPR Report</div>"
		      email_body += "<table style='border-collapse: collapse; width: 100%; font-family: Arial, sans-serif; font-size: 16px;'>"
		      email_body += "<thead><tr style='background-color: #0096FF; color: white;'>"
		      email_body += "<th style='border: 1px solid #ddd; padding: 5px;'>SHIFT</th>"
		      email_body += "<th style='border: 1px solid #ddd; padding: 5px;'>Total Production</th>"
		      email_body += "<th style='border: 1px solid #ddd; padding: 5px;'>Defect Serial Count</th>"
		      email_body += "<th style='border: 1px solid #ddd; padding: 5px;'>SPR (%)</th></tr></thead><tbody>"
		  
		      for row_idx in range(row_count):
		          shift = resultsDaySpr.getValueAt(row_idx, "Shift")
		  
		          # Skip the second occurrence of "Total"
		          if shift == "Total":
		              total_row_count += 1
		              if total_row_count > 1:
		                  continue
		  
		          total_production = resultsDaySpr.getValueAt(row_idx, "SerialCount")
		          defect_serial_count = resultsDaySpr.getValueAt(row_idx, "DefectSerialCount")
		          spr = 100 if total_production == 0 else ((total_production - defect_serial_count) / float(total_production)) * 100
		          spr_color = "red" if spr < 100 else "transparent"
		  
		          email_body += "<tr>"
		          email_body += "<td style='border: 1px solid #ddd; padding: 5px; text-align: center;'>" + str(shift) + "</td>"
		          email_body += "<td style='border: 1px solid #ddd; padding: 5px; text-align: center;'>" + str(total_production) + "</td>"
		          email_body += "<td style='border: 1px solid #ddd; padding: 5px; text-align: center;'>" + str(defect_serial_count) + "</td>"
		          email_body += "<td style='border: 1px solid #ddd; padding: 5px; background-color: " + spr_color + "; text-align: center;'>" + str(round(spr, 2)) + "</td>"
		          email_body += "</tr>"
		  
		      email_body += "</tbody></table></div>"
		  
		except Exception as e:
		  print("Error:", str(e))  

        # Footer section
		email_body += (
		    "<p style='background-color: #D3D3D3; font-size: small;'>"
		    "<b>Click <a href='http://10.109.1.71:8088/data/perspective/client/VECV_Ignition_V1_1_1/DefectStatus'><u>HERE</u></a> to view this report in MES PLATFORM</b>"
		    "</p>"
		    "<p style='background-color: #D3D3D3; font-size: small;'>"
		    "<b>Click <a href='https://isupport.vecv.net/MDLServiceMgmt/SR_LogServiceCatalog.aspx?es=IfFNluw5HyCtQkeT7wQi8eZB4Ve2VK1WrmItHTyquJCWYFOue%2bscW7q4hr8fsypB0j410plSUDEj4%2bnn%2bnV82Cwl63oy%2f0Ek38ThogbDjo81XZ1pfJKCh8vzszs8hYT1U7o58v6t7ZCerta3PXRaCg%3d%3d'><u>HERE</u></a> to Raise request for MES user ID</b>"
		    "</p>"
		    "<p style='background-color: yellow; font-size: small;'><b>This is an autogenerated email, please do not reply.</b></p>"
		    "<p style='background-color: yellow; font-size: small;'><b>For support, contact Aniket Sagar at <a href='mailto:asgar3@vecv.in'>asgar3@vecv.in</a> or 7903511741.</b></p>"
		    "<p style='font-style: italic;'><b>Regards,<br>MES ADMIN</b></p>"
		)
		
		# Send email
		system.net.sendEmail(
		    smtpProfile="SMTPEmail",
		    fromAddr="mes_email_admin@vecv.in",
		    subject="MES || AXLE SHOP || SPR Report (" + fromDate + " All Shifts)",
		    body=email_body,
		    html=1,
		    to=email_list
		)

    except Exception as e:
        system.util.getLogger("SPR").error("Failed to send email " + str(e))
        
       