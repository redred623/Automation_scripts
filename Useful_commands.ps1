#useful commands with filters and other bits useful to run in the future

#allows you to filter off of a specific employee number. 

get-aduser -filter * -Properties employeenumber | Where-Object {$_.employeenumber -eq 726547}

#allows you check last boot time for a computer remotely

Get-CimInstance -ClassName win32_operatingsystem -ComputerName *computer name* | select csname, lastbootuptime

#allows you to get the members of a distribution group. Need to create a variable called members. 
#Members needs to be a list of emails seperated by commas 
$members = @(
'email@domain',
'email2@domain'
)

$members | foreach-object{
    >> $name = $_
    >> Get-DistributionGroupMember $name | select name, @{name = 'group'; expression = {$name}}
    >> } | Export-Csv -Path '*csv file path*' -NoTypeInformation

#allows you to create a standard distribution group 

New-DistributionGroup -name '*name of group'`
 -alias '*email address alias*' -ManagedBy *insert email* `
 -Members *insert members* -MemberJoinRestriction Closed `
 -Notes 'This will be to send automatic reporting to the management team at *location*. 
 Managed by *insert name*'

<#
name is the name you can search for in shell and AD, 
alias is the name shown to the user and on the admin gui
moderateby allows that user to control messages but does not add them to the recipient list, 
managedby allows that user to be an owner (you can use -copyownertomember to make them member as well)
members allows you to add multiple members to the group. Do not need to be a string seperated by commas
notes, adds to the description of the group
#>


#Find all members of an AD group. 

Get-ADGroupMember "**insert name**" -Recursive | foreach-object {get-aduser $_.samaccountname -properties emailaddress,employeenumber,department,description| select name,samaccountname,emailaddress,employeenumber,department,description} |  Export-Csv -NoTypeInformation -Path '**insert file path**'

#find out what distribution groups a user is apart of of. Takes a little while to run. 

$Username = "Jeff.Collins@globomantics.org"

$DistributionGroups = Get-DistributionGroup -resultsize unlimited | where { (Get-DistributionGroupMember -Identity $_.Name -resultsize unlimited  ).primarysmtpaddress -contains "$Username"}

#create ad security group with global scope from a csv with columns 'name' and 'description' 

Import-Csv -Path '**insert file path**' | foreach {New-ADGroup -Name $_.name  -GroupCategory Security -GroupScope Global -Path "**create OU path**" -Description $_.description}

#find a user based on first name and last name

$list | foreach {Get-ADUser -Filter "name -like '$($_.substring(0,3))*$($_.substring($_.length-3))'"} | select name,userprincipalname
