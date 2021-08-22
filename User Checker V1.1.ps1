#this is code is meant to take to users and compare their membership. Then present a list of each group the other does not have. 

#first check is to make sure the inputted people actually exist in AD
Do {
    $first_user = Read-Host -Prompt "Please Enter User ID of First User"

    if (!(Get-ADUser -Filter "sAMAccountName -eq '$first_user'") ){ 
        
        Clear-Host; Write-Host "User not found"; Start-Sleep -Seconds 1;
    
    }

    }until(Get-ADUser -Filter "sAMAccountName -eq '$first_user'")

Do {
    $second_user = Read-Host -Prompt "Please Enter User ID of Second User"
    if (!(Get-ADUser -Filter "sAMAccountName -eq '$second_user'") )
    { Clear-Host; Write-Host "User not found"; Start-Sleep -Seconds 1 }
    
}

Until(Get-ADUser -Filter "sAMAccountName -eq '$second_user'")

#pull all the groups of each user

$first_user_member = Get-ADUser $first_user -properties memberof | Select-Object memberof
$second_user_member = Get-ADUser $second_user -properties memberof | Select-Object memberof

#compare each group
$comparasion = Compare-Object $first_user_member.memberof $second_user_member.memberof

#create 2 new variables which indicates which group is unique to both an exclude equals 
$first_user_groups = $comparasion | Where-Object { $_.sideindicator -eq "<=" }
$second_user_groups = $comparasion | Where-Object { $_.sideindicator -eq "=>" }

#use the dn to get the actual name of the group and then sort it from ascending
$second_name = $second_user_groups | ForEach-Object { Get-ADObject -Identity $_.inputobject } | Select-Object name |Sort-object -Property name
$first_name = $first_user_groups | ForEach-Object { Get-ADObject -Identity $_.inputobject } | Select-Object name | sort-object -Property name

#count the amount of groups that each has and find if the second name or first name should be the maxiumum
[int]$max = $first_name.count 
if ([int]$second_name.count -gt [int]$firstName.count) { $max = $second_name.count; }

#add each to a table where it can present the data until the max is reached
$Results = for ( $i = 0; $i -le $max; $i++) {
    [PSCustomObject]@{
        "$first_user"  = $first_Name[$i].name
        "$second_user" = $second_Name[$i].name
    }
}

#return results
$Results |  format-table


#let user read results until they decide to exit. 
read-Host "press any key to escape..."
exit 