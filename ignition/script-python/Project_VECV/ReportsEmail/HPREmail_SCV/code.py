def send_production_report():
    try:
        from datetime import datetime, timedelta

        # Current datetime
        now = datetime.now()

        # Calculate today_start, yesterday_start, and today_end
        today_start = now.replace(hour=7, minute=30, second=0, microsecond=0)
        yesterday_start = today_start - timedelta(days=1)
        today_end = today_start - timedelta(seconds=1) + timedelta(days=1)

        # Format datetime objects to the desired format
        fromDate = yesterday_start.strftime('%Y-%m-%d %H:%M:%S')
        toDate = today_start.strftime('%Y-%m-%d %H:%M:%S')
        try:
        	queryEmail = 'select EmailID from MESPRODDB.dbo.MST_EmailUsers where Priority in (1,2) and IsActive=1 and IsDeleted=0'
        	emails = system.db.runQuery(queryEmail)  # Run the query directly to get the list of emails

        # Collect all email addresses into a list
        	email_list = [email[0] for email in emails]  # Assuming emails is a list of tuples, so we get the first element (EmailID)
        except Exception as e:
            system.util.getLogger("HPRMail").error("Error generating report: " + str(e))

        # If there are no email addresses, log and exit
        if not email_list:
            return

        # Other details
        line = "Legacy Axle"
        area = "Legacy Axle Main Line"
        station = "TAQG04"
        workstationID = 364

        query_path = "Project_VECV/Report/HPR_Report/getHPRtableData"  # Replace with the actual Named Query path
        params = {
            "FromDate": fromDate,
            "ToDate": toDate,
            "WorkStation": station
        }
        results = system.db.runNamedQuery(query_path, params)

        # Correct way to handle PyDataset: Use getRowCount() and getColumnNames() methods
        row_count = results.getRowCount()
        column_names = results.getColumnNames()

        # Create a new list of column names excluding 'SortOrder'
        column_names_filtered = [col for col in column_names if col != 'SortOrder']

        # Initialize variables for min and max counts
        max_count = -float('inf')
        min_count = float('inf')
        max_row = None
        min_row = None

        # First pass to determine the max and min counts, excluding the first and last rows
        for row_idx in range(1, row_count - 1):  # Exclude first and last rows for coloring
            count = results.getValueAt(row_idx, 'SerialNumberCount')
            if count > max_count:
                max_count = count
                max_row = row_idx
            if count < min_count:
                min_count = count
                min_row = row_idx

        # Construct HTML table with CSS for color, hover, and transition
        html = """
        <style>
            table {
                width: 100%;
                border-collapse: collapse;
                font-family: Arial, sans-serif;
            }
            th, td {
                padding: 8px;
                text-align: left;
                border: 1px solid #ddd;
            }
            th {
                background-color: #0096FF;
                color: white;
            }
            tr:nth-child(even) {
                background-color: #f2f2f2;
            }
            tr:hover {
                background-color: #ddd;
                transition: background-color 0.3s ease;
            }
            td {
                color: #333;
            }
            .high {
                background-color: #4CAF50;
                color: white;
            }
            .low {
                background-color: #f44336;
                color: white;
            }
        </style>
        <table>
            <thead>
                <tr>
                    <th>Start Time</th>
                    <th>End Time</th>
                    <th>Count</th>
                </tr>
            </thead>
            <tbody>
        """

        # Add rows to the table with high/low color marks, excluding first and last rows
        for row_idx in range(row_count):  # Include all rows
            start_time = results.getValueAt(row_idx, 'HourTime')
            end_time = results.getValueAt(row_idx, 'Time + 1 Hour')
            count = results.getValueAt(row_idx, 'SerialNumberCount')

            # Determine if the current row is the highest or lowest, excluding first and last rows
            row_class = ""
            if row_idx == max_row:
                row_class = "high"
            elif row_idx == min_row:
                row_class = "low"

            html += "<tr class='" + row_class + "'>"
            html += "<td>" + str(start_time) + "</td>"
            html += "<td>" + str(end_time) + "</td>"
            html += "<td>" + str(count) + "</td>"
            html += "</tr>"

        html += "</tbody></table>"

        # Prepare email subject and body
        subject = "MES || SCV AXLE SHOP || HPR Report (" + fromDate + " All Shifts)"
        body = (
            "<p>Dear All,</p>"
            "<p>Please Find Attached SCV AXLE SHOP HPR REPORT for date " + fromDate + " All Shifts</p>"
            + html +
            "<p style='background-color: #D3D3D3 ; font-size: small;'><B>Click <a href='http://10.109.1.71:8088/data/perspective/client/VECV_Ignition_V1_1_1/HPR'><u>HERE</u></a> to view this report in MES PLATFORM</B></p>"
            "<p style='background-color: #D3D3D3 ; font-size: small;'><B>Click <a href='https://isupport.vecv.net/MDLServiceMgmt/SR_LogServiceCatalog.aspx?es=IfFNluw5HyCtQkeT7wQi8eZB4Ve2VK1WrmItHTyquJCWYFOue%2bscW7q4hr8fsypB0j410plSUDEj4%2bnn%2bnV82Cwl63oy%2f0Ek38ThogbDjo81XZ1pfJKCh8vzszs8hYT1U7o58v6t7ZCerta3PXRaCg%3d%3d'><u>HERE</u></a> to Raise request for user ID creation in MES to view all reports</B></p>"
            "<p style='background-color: yellow; font-size: small;'><B>This is autogenerated mail please do not reply.</B></p>"
            "<p style='background-color: yellow; font-size: small;'><B>For any support contact Aniket Sagar on <a href='mailto:asgar3@vecv.in'>asgar3@vecv.in</a> or 7903511741.</B></p>"
            "<p style='font-style: italic; '><B></I>Regards,<br>MES ADMIN</I></B></p>"
        )

        # Send email to the list of email addresses
        try:
            system.net.sendEmail(
                smtpProfile="SMTPEmail", 
                fromAddr="mes_email_admin@vecv.in", 
                subject=subject, 
                body=body, 
                html=1, 
                to=email_list  # Send to the list of emails
            )
            # Log successful email sending
            system.util.getLogger("HPRMail-->send email to all users")
        except Exception as e:
            system.util.getLogger("HPRMail").error("Failed to send email " + str(e))

    except Exception as e:
        system.util.getLogger("HPRMail").error("Failed to send email " + str(e))