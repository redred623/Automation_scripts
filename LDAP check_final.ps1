
Get-DynamicDistributionGroup | select name,RecipientFilter,LDAPRecipientFilter,PrimarySmtpAddress | ForEach-Object {
    $Grp = $_
    $Grp_memebers_Max5 = Get-ADUser -LDAPFilter $Grp.LDAPRecipientFilter -ResultSetSize 5
    $Grp | select Name,@{name='Count';expression={ $Grp_memebers_Max5.count}},@{name='Members';expression={ $Grp_memebers_Max5}},@{name='LDAP Filter';expression={$Grp.LdapRecipientFilter}},@{name='Email';expression={$Grp.PrimarySmtpAddress}}
}  -OutVariable output | export-csv -path "\\martinmarietta.com\deptshares\ServiceDesk\Powershell Logs\Distrubition Group Activity\DD_member_check.CSV"




