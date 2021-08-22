#put the dl's email
$distribution_email = '*insert email*'

#just get a list of martin marietta emails and have a collumn called 'email', no spaces or colons. Save it as a csv
$path_csv = '\\computername\c$\... .csv' 

#put a path name for a couple of files to be created that will show the before and after in case you need to roll back. 
$path_of_bfr = '\\computername\c$\..._before.csv'
$path_of_aft = '\\computername\c$\..._after.csv

#just get a list of martin marietta emails and have a collumn called 'email', no spaces or colons. Save it as a csv


Get-DistributionGroupMember -Identity $distribution_email  -ResultSize unlimited | Export-Csv -Path $path_bfr

import-csv $path_csv | foreach {Add-DistributionGroupMember -Member $_.email -Identity $distribution_groupname}

Get-DistributionGroupMember -Identity $distribution_email -ResultSize unlimited | Export-Csv -Path $path_aftr