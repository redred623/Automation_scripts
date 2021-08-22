# Autmation_scripts
This houses all of my PowerShell and Python automation scripts. 

### Add_user_to_dl [powershell]

Takes a list of emails in csv format, column header called 'email', and adds them to an already created DL. 

### Computer_data_importer [python 3]

Takes information from spreadsheets about the current working state of Ivanti, SNOW, and Bomgar and compares computer list. 
Very specifically made and a tool meant to be used for a specific invesitgation case. 

### Emailer_v2 [python 3]

This script is a basic emailer, which uses a burner google account to email to an inbox multiple times. Prompts for credentials. 
Email address could be swapped out. 

### File_move_V1 [powershell]

This script moves files from a specific network path to a computer on the network. This script also allows you to view files
in a page view, full list, or by search. You can also specify path and it confirms that the file was sent. 

### Get_AD_group_members [powershell]
 
Basic script that takes the name of a CSV and an AD group name and exports all the members out to a csv. It also pulls all
supplied properties. 

### Group_list_generator [powershell]

This allows you to view all groups nested within another group. It then puts them all into a hashtable and work can be done from there.
This function specfically takes all non-mail enabled security groups found within a group and mail-enables them.

### LDAP Check_final [powershell]

Basic Script, meant to be scheduled. This script queries all dynamic DL's in an organization and sees if anyone is assigned to that group. 
Meant to help make determinations on whether to delete or keep a group. 

### Log_scriptV1.0 [powershell]

Takes the output of 'LDAP Check_final' and uses it to see if email is being sent from the DL's that actually have memebers.
Meant to better help make decisions on whether or not to keep a DL. 

### Useful_commands [powershell]

This is a file that houses many useful commands that I frequently use in powershell. Look to the comments in the file for more details.

### User_checker V1.1 [powershell]

A useful script which takes two, AD sam account names and lists which security groups that each have that the other user does not have.
Very helpful when security permissions are not lining up correctly. 

### V1_email_expand_tracker [powershell]

This is meant to track the success of group_list_generator. It accepts input from the user for email and days to loop and tracks
for any expand ID's. 
