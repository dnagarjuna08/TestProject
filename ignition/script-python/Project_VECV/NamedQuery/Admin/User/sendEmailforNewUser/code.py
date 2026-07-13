def sendMail(firstName, lastName, email, serviceRequest, userName, passwordExpiry, CreatedBy):
    subject = "MES ID CREATED"
    
    # Fetching the creator's name
    queryUser = "SELECT CONCAT(FirstName, ' ', LastName) AS userName FROM MST_User WHERE MST_User_Id = " + str(CreatedBy)
    createdByNameResult = system.db.runQuery(queryUser)
    createdByName = createdByNameResult[0][0] if createdByNameResult else "Unknown"
    
    # Construct the email body with advanced CSS and highlighted notes
    body = (
        "<html>"
        "<head>"
        "<style>"
        "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }"
        ".header { font-size: 20px; font-weight: bold; color: #444; margin-bottom: 20px; }"
        "table { width: 100%; border-collapse: collapse; margin: 20px 0; box-shadow: 0 2px 5px rgba(0,0,0,0.1); transition: box-shadow 0.3s ease; }"
        "table:hover { box-shadow: 0 4px 10px rgba(0,0,0,0.2); }"
        "th, td { border: 1px solid #ddd; padding: 15px; text-align: left; transition: background-color 0.3s ease; }"
        "th { background-color: #d4edda; font-size: 16px; color: #333; }"  # Light green header
        "tr:hover td { background-color: #f9f9f9; }"
        "td { font-size: 14px; }"
        "a { color: #007BFF; text-decoration: none; transition: color 0.3s ease; }"
        "a:hover { color: #0056b3; text-decoration: underline; }"
        ".note { background-color: #fff3cd; color: #856404; font-size: 12px; font-weight: bold; padding: 10px; border-radius: 5px; margin-top: 20px; }"
        "</style>"
        "</head>"
        "<body>"
        "<p class='header'>Dear " + firstName + " " + lastName + ",</p>"
        "<p>Your ID has been created in MES.</p>"
        "<p>Below are the details of your account:</p>"
        "<table>"
        "<tr><th>Field</th><th>Value</th></tr>"
        "<tr><td>SR Number</td><td>" + serviceRequest + "</td></tr>"
        "<tr><td>Created By</td><td>" + createdByName + "</td></tr>"
        "<tr><td>Username</td><td>" + userName + "</td></tr>"
        "<tr><td>Email</td><td>" + email + "</td></tr>"
        "<tr><td>Password Expiry</td><td>" + passwordExpiry + "</td></tr>"
        "</table>"
        "<p>An OTP will be sent to your registered email ID (<b>" + email + "</b>) for authentication.</p>"
        "<p>You can access the MES Application by clicking on the link below with your registered username:</p>"
        '<p><a href="http://10.109.1.71:8088/data/perspective/client/VECV_Ignition_V1_1_1">MES Application</a></p>'
        "<div class='note'>"
        "For any support, contact Aniket Sagar on "
        '<a href="mailto:asagar3@vecv.in">asagar3@vecv.in</a> or 7903511741.'
        "</div>"
        "<p>Best Regards,<br>"
        "MES ADMIN</p>"
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