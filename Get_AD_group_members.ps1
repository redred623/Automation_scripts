#this script will select name,samaccount name, email, EEID, department, and title. 
#note: this will include all members of all groups nested into this group. If you only want the direct members in the group remove '-recursive' from get-adgroupmember 

#type out the file path here between the single quotes
$path = '\\*computername*\c$\test.csv'

#find the group name in AD and put it here between single quotes
$name= '**'

Get-ADGroupMember $name -Recursive | foreach-object {get-aduser $_.samaccountname -properties emailaddress,employeenumber,department,title| select name,samaccountname,emailaddress,employeenumber,department,title} |  Export-Csv -NoTypeInformation -Path $path
