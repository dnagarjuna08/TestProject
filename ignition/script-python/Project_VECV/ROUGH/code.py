route = '[default]Dewas/Legacy Axle/LEGACY AXLE MAIN LINE/LAML150'
results = system.tag.browse(route)

tagPath = []
for i in results.getResults():
    stringPath = str(i['fullPath'])
    tagPath.append(stringPath)

AllPath = []
values = []
for path in tagPath:
    results = system.tag.browse(path)
    for i in results.getResults():
        stringPath = str(i['fullPath'])
        AllPath.append(stringPath)
        values.append(0)

system.tag.writeBlocking(AllPath,values)
tagPath = route + '/CommonTags/OPList'
system.tag.writeBlocking(tagPath, [[]])
tagPath = route + '/CommonTags/StationInProgress'
system.tag.writeBlocking(tagPath, 0)
tagPath = route + '/CommonTags/SerialNumber'
system.tag.writeBlocking(tagPath, '')





body = "<HTML><BODY><H1>MES OTP Authentication</H1>"
body += "<P>Please enter Below OTP to Complete MES Authentication.</P></br><P><B>YREREU</B></P>"
body+="</br><P>If you did not requested for this OTP, Please ignore the mail or contact support</P></BODY></HTML>"

recipients = ["zzakrawat@vecv.in"]
system.net.sendEmail("","qdigitalization@vecvnet.com", "MES OTP Auth", body, 1, recipients, smtpProfile = 'SMTPEmail')
 
 