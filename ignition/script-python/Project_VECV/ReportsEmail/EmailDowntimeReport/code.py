def send_downtime_report():
    try:
        from datetime import datetime, timedelta
        
        # Current datetime
        now = datetime.now()
        print(now)
        
        # Calculate today_start, yesterday_start, and today_end
        today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
        yesterday_start = today_start - timedelta(days=1)
        formatted_yesterday_start = yesterday_start.strftime('%d/%m/%Y')
        today_end = today_start - timedelta(seconds=1) + timedelta(days=1)
        print(yesterday_start)
        
        # Format datetime objects to the desired format
        fromDate = yesterday_start.strftime('%Y-%m-%d %H:%M:%S')
        toDate = today_start.strftime('%Y-%m-%d %H:%M:%S')
        
        try:
            # Query for email addresses (optional, if sending to specific emails)
            queryEmail = 'select EmailID from MESPRODDB.dbo.MST_EmailUsers where Priority=1 and IsActive=1 and IsDeleted=0'
            emails = system.db.runQuery(queryEmail)
            email_list = [email[0] for email in emails]
        except Exception as e:
            print("Error in email extraction")
        
        # Fallback fixed email (if dynamic extraction fails or isn't required)
        #email_list = ['asagar3@vecv.in']
        
        # Fetch the downtime report results for both queries
        query_path1 = 'Project_VECV/Report/DownTimeReport/EmailQueryLineStoppageTime'
        query_path2 = 'Project_VECV/Report/DownTimeReport/EmailQueryStationStoppage'
        params = {"startDate": yesterday_start}
        
        results = system.db.runNamedQuery(query_path1, params)
        results2 = system.db.runNamedQuery(query_path2, params)
        
        # If results are empty, log and exit
        if results is None or results.getRowCount() == 0:
            print("No data found for downtime report (Line Stoppage).")
        if results2 is None or results2.getRowCount() == 0:
            print("No data found for downtime report (Station Stoppage).")
        
        # Prepare email content for both tables
        css_style = """
        <style>
            table {
                border-collapse: collapse;
                width: 100%;
                font-family: Arial, sans-serif;
            }
            th, td {
                border: 1px solid #ddd;
                text-align: left;
                padding: 8px;
            }
            th {
                background-color: #87CEEB;
                color: #333;
                text-align: center;
            }
            tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            tr:hover {
                background-color: #f1f1f1;
            }
            .highlight {
                background-color: #d4edda;  /* Green color */
                color: #155724;
            }
            .table1 {
                width: auto; /* Makes Table 1 fit its content */
            }
            .table2 {
                width: 100%;
            }
            .footer {
                background-color: #D3D3D3;
                font-size: small;
                padding: 10px;
            }
            .footer a {
                color: #007bff;
                text-decoration: none;
            }
            .footer a:hover {
                text-decoration: underline;
            }
            .footer p {
                margin: 5px 0;
            }
            .highlight-row {
                background-color: #d4edda;
                color: #155724;
            }
            .highlight-col {
                background-color: #d4edda;
                color: #155724;
            }
        </style>
        """
        
        table_data = css_style
        table_data += "<h3>Total Line Stoppage Time</h3><table class='table1'><tr>"
        
        # Add column headers for first table
        column_names = results.getColumnNames()
        for col in column_names:
            table_data += "<th>" + col + "</th>"
        table_data += "</tr>"
        
        # Add rows of data for first table
        for row in range(results.getRowCount()):
            table_data += "<tr>"
            for col in column_names:
                value = results.getValueAt(row, col)
                table_data += "<td>" + str(value) + "</td>"
            table_data += "</tr>"
        
        table_data += "</table>"
        
        # Add content for the second table
        table_data += "<h4>Total Station Stoppage Time</h4><small> (As per Line Issue Buttons)</small><table class='table2'><tr>"
        
        # Add column headers for second table, excluding the "SortOrder" column
        column_names2 = results2.getColumnNames()
        for col_idx, col in enumerate(column_names2):
            if col != "SortOrder":  # Hide "Sort Order" column
                table_data += "<th>" + col + "</th>"
        table_data += "</tr>"
        
        # Add rows of data for second table, highlighting the last column and last row
        for row in range(results2.getRowCount()):
            table_data += "<tr>"
            for col_idx, col in enumerate(column_names2):
                if col != "SortOrder":  # Skip "Sort Order" column
                    value = results2.getValueAt(row, col)
                    # Highlight the last column and last row
                    if col_idx == len(column_names2) - 2 or row == results2.getRowCount() - 1:
                        table_data += "<td class='highlight'>" + str(value) + "</td>"
                    else:
                        table_data += "<td>" + str(value) + "</td>"
            table_data += "</tr>"
        
        table_data += "</table>"
        
        # Send the email with table data as the body
        subject = "MES || Downtime Report || Date: " + formatted_yesterday_start + " All Shifts"
        body = (
            "Dear All,<br><br>"
            "Please find below the <b>Downtime Report (in Minutes)</b> for date: "
            + str(formatted_yesterday_start)
            + ": All Shifts.<br><br>"
            + table_data 
        )
        
        # Add footer and links to the email (footer is normal text and will be placed after all the tables)
        body += (
            "<br><div class='footer'></br>"
            "<b><br>Click <a href='http://10.109.1.71:8088/data/perspective/client/VECV_Ignition_V1_1_1/DownTime_Report'><u>HERE</u></a> to view this report in MES PLATFORM</b>"
            "</div>"
            "<div class='footer'>"
            "<b>Click <a href='https://isupport.vecv.net/MDLServiceMgmt/SR_LogServiceCatalog.aspx?es=IfFNluw5HyCtQkeT7wQi8eZB4Ve2VK1WrmItHTyquJCWYFOue%2bscW7q4hr8fsypB0j410plSUDEj4%2bnn%2bnV82Cwl63oy%2f0Ek38ThogbDjo81XZ1pfJKCh8vzszs8hYT1U7o58v6t7ZCerta3PXRaCg%3d%3d'><u>HERE</u></a> to Raise request for user ID creation in MES to view all reports</b>"
            "</div></br>"
            "<div style='background-color: yellow; font-size: small;'>"
            "<b>This is an autogenerated mail, please do not reply.</b>"
            "</div>"
            "<div style='background-color: yellow; font-size: small;'>"
            "<b><br>For any support, contact Aniket Sagar on <a href='mailto:asgar3@vecv.in'>asgar3@vecv.in</a> or 7903511741.</b>"
            "</div></br>"
            "<div style='font-style: italic;'><b>Regards,<br>MES ADMIN</b></div>"
        )
        
        # Send email using the specified method and SMTP profile
        try:
            system.net.sendEmail(
                smtpProfile="SMTPEmail",
                fromAddr="mes_email_admin@vecv.in",
                subject=subject,
                body=body,
                html=1,  # Ensures the email is sent as HTML
                to=email_list  # Send to extracted email list or fallback
            )
            # Log successful email sending
            print("DowntimeLine --> Email sent to all users")
        except Exception as e:
            print("DowntimeLine --> Failed to send email: " + str(e))

    except Exception as e:
        print("Error: " + str(e))