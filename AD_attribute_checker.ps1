#This takes 2 user samaccount names and compares all their attributes.
#This then exports out of the window a grid view which will show all the ones they did not have in common. 
$users = @('ketchalx' , 'glissrox')
$user_1 =  Get-ADUser -Identity $users[0] -Properties * 
$user_2 = Get-ADUser -Identity $users[1] -Properties * 
$Usercomparison = @()
$user_1.getenumerator() | ForEach-Object {
    If ("$($user_2.($_.Key))" -eq "$($_.value)") {} 
    Else {
        $UserObj = New-Object PSObject -Property ([ordered]@{
        Property = $_.key
        $user_1.name = "$($_.value)"
        $user_2.name = "$($User_2.($_.Key))" } ) 
        $UserComparison += $UserObj} 
                                        }
$Usercomparison | Out-GridView
Read-Host -Prompt "Press Enter to Close the window."
        

