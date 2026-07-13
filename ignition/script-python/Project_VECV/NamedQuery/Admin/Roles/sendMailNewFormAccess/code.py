def sendMail(MST_Form_Id, CreatedBy, mst_user_id, count):
    import system
    import datetime 

    # Get current date and time
    current_date = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    # Prepare list of form IDs for the query
    formIdString = "(" + ", ".join(map(str, MST_Form_Id)) + ")"

    # Query to get form names
    queryForm = "select concat(f.FormName,' ','(',m.ModuleName,')') from MST_Form as f inner join MST_Module as m on m.MST_Module_Id=f.MST_Module_Id where f.MST_Form_Id in" + formIdString
    formNames = system.db.runQuery(queryForm)

    # Concatenate form names into a single string
    formNameStr = "<br>".join([str(row[0]) for row in formNames])

    # Query to get user name
    queryUser = "SELECT CONCAT(FirstName, ' ', LastName) AS userName FROM MST_User WHERE MST_User_Id = " + str(CreatedBy)
    createdByNameResult = system.db.runQuery(queryUser)
    createdByName = createdByNameResult[0][0] if createdByNameResult else "Unknown"

    # Query to get recipient email
    queryRecipient = "SELECT Email FROM MST_User WHERE MST_User_Id = " + str(mst_user_id)
    emailResult = system.db.runQuery(queryRecipient)
    email = emailResult[0][0] if emailResult else None

    if not email:
        print("Recipient email not found for MST_User_Id: " + str(mst_user_id))
        return

    # Construct email subject and body
    subject = "MES Form Access Notification"
    body = (
        "<html>"
        "<head>"
        "<style>"
        "table {"
        "    border-collapse: separate;"
        "    border-spacing: 0 10px;"  # Added padding between rows
        "    width: 100%;"
        "    font-family: Arial, sans-serif;"
        "    border: 2px solid #4CAF50;"
        "    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);"
        "}"
        "th {"
        "    padding: 15px;"
        "    background-color: #4CAF50;"
        "    color: white;"
        "    text-transform: uppercase;"
        "    font-size: 16px;"
        "    text-align: left;"  # Header alignment
        "    border-right: 2px solid #ffffff;"
        "}"
        "td {"
        "    padding: 15px;"
        "    text-align: left;"
        "    font-size: 15px;"
        "    color: #333;"
        "    border-right: 2px solid #4CAF50;"  # Column separator
        "    border-bottom: 1px solid #ddd;"
        "    vertical-align: top;"  # Align data at the top
        "    transition: transform 0.3s ease, background-color 0.3s ease;"
        "}"
        "tr:nth-child(even) {"
        "    background-color: #f9f9f9;"
        "}"
        "tr:hover {"
        "    background-color: #D3D3D3;"
        "    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);"
        "    transform: scale(1.02);"
        "    transition: transform 0.3s ease, background-color 0.3s ease;"
        "}"
        "td:first-child {"
        "    font-weight: bold;"
        "    color: #007bff;"
        "}"
        "td:nth-child(2), td:nth-child(3) {"
        "    font-weight: bold;"
        "    background-color: #e6f7ff;"
        "    border-left: 2px solid #4CAF50;"
        "}"
        ".note {"
        "    background-color: yellow;"
        "    padding: 10px;"
        "    font-weight: bold;"
        "    font-size: 12px;"
        "    border: 1px solid #ccc;"
        "    border-radius: 5px;"
        "    margin-top: 20px;"
        "}"
        ".highlight {"
        "    font-weight: bold;"
        "    font-size: 16px;"
        "    color: #007bff;"
        "    background-color: #e6f7ff;"
        "    padding: 10px;"
        "    text-align: center;"
        "    border: 2px solid #4CAF50;"
        "    border-radius: 5px;"
        "    margin-top: 20px;"
        "}"
        "</style>"
        "</head>"
        "<body>"
        "<p>Dear User,</p>"
        "<p>Your MES Forms access has been updated. Now you have access to the following forms:</p>"
        "<table>"
        "<tr>"
        "<th>Form Name</th>"
        "<th>Granted By</th>"
        "<th>Access Date</th>"
        "</tr>"
        "<tr>"
        "<td>" + formNameStr + "</td>"
        "<td>" + createdByName + "</td>"
        "<td>" + current_date + "</td>"
        "</tr>"
        "</table>"
        "<div class='highlight'>"
        "Total Forms Accessed: " + str(len(MST_Form_Id)) + "<br>"
        "</div>"
        "<p class='note'>For any support, contact Aniket Sagar at "
        "<a href='mailto:asagar3@vecv.in'>asagar3@vecv.in</a> or call 7903511741.</p>"
        "<p><strong>Best regards,</strong><br>MES Application Team</p>"
        "</body>"
        "</html>"
    )

    # Send email
    try:
        system.net.sendEmail(
            smtpProfile="SMTPEmail",
            fromAddr="mes_email_admin@vecv.in",
            subject=subject,
            body=body,
            html=1,
            to=email
        )
        # Log successful email sending
        print("Email sent successfully to " + email)
        system.util.getLogger("formMail").info("Email sent to " + str(email))
    except Exception as e:
        print("Failed to send email: " + str(e))
        system.util.getLogger("formMail").error("Failed to send email to " + str(email) + ": " + str(e))