#! /usr/bin/env python

import smtplib, ssl

port = 465 
#input password for the service account you have created. 
password = input("Type password here:>>>  ")

context = ssl.create_default_context()

email = ""
send_to_email = ""
server = smtplib.SMTP_SSL("smtp.gmail.com", 465)
server.ehlo()
server.login(email, password)


sender_email = "my@gmail.com"

subject = 'Hello'

Email_text = """\
Subject: {}\n\n
Hello, 

This is an automated message. 

This message is sent from Python.

""".format(subject)
#This just sends one email but increasing the range in this loop will send multiples. 

for x in range(0,1):
    server.sendmail(sender_email, send_to_email, Email_text)
server.close()
