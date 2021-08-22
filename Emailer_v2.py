#! /usr/bin/env python

import smtplib, ssl

def hello():
    print('hi') 
    people = 2
    return people

'''port = 465 
password = input("Type password here:>>>  ")

context = ssl.create_default_context()

email = "noahbulkemail@gmail.com"
send_to_email = "padgettnoah@gmail.com"
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

for x in range(0,1):
    server.sendmail(sender_email, send_to_email, Email_text)
server.close()'''


x = hello() 

print(x)