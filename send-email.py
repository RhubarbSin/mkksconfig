#!/usr/bin/python
import sys
import smtplib
import string
from subprocess import Popen, PIPE

stdout = Popen('ifconfig', shell=True, stdout=PIPE).stdout
output = stdout.read()

HOST = '10.1.0.1'
SUBJECT = "Linux installation complete"
if len(sys.argv) != 2:
    # default value for use in old kickstarts
    TO = "kickstart@example.com"
else:
    # new kickstarts specify address
    TO = sys.argv[1]
FROM = "donotreply@example.com"
BODY = string.join((
        "From: %s" % FROM,
        "To: %s" % TO,
        "Subject: %s" % SUBJECT ,
        "",
        output
        ), "\r\n")
server = smtplib.SMTP(HOST)
server.sendmail(FROM, [TO], BODY)
server.quit()
