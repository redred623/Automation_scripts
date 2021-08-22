#The idea of this function is to put an email address in and see if there are any expand events on that email.
#you can use this to validate if an email is setup correctly and validate whether people are recieving the emails that they need to
#for instance: AP-ENT-MMM-CTXPlanningAnalytics-User. We needed to make sure that people who were not recieving email were able to after running the fix script. 



function date_loop { 
    param (
        [Int32]$days_to_loop,
        [string]$group_email,
        [string]$target_recipient    
    )
    process{ 
    #intialize a $date_list variable which will house the dictionaries used to build the csv
    $script:date_list = @{}
    #loop through x, x amount of times using it to look back x days
    For ($x = 0; $x -ge -$days_to_loop; $x--) {
        #get date from $x value and add date to $date_list
        $date = (Get-Date).addDays($x).ToString("MM-dd-yyyy")
        #get the next day to create a range
        $date_end = (Get-Date).addDays($x + 1).ToString("MM-dd-yyyy")

        $logg_hit_servers = Get-TransportService 
        #get all expand emails that include our group for the given day
        $logg_hit = $logg_hit_servers | Get-MessageTrackingLog -Recipients $group_email -EventId expand -Start $date -End $date_end
        #check to see if $logg_hit is null, if it is, do something
        if (!$logg_hit) 
            
        { $date_list[$date] = 'no emails' }
        #if an email was found on that day, do something
        else {
            
            $date_list += $date = @{} 
            $date_list[$date]['recipients'] = @()
            $date_list[$date]['EmailCount'] = $logg_hit | measure | select count
            #for each email we will find out who was the recipient in that email. 
            $logg_hit | select messageid | ForEach-Object {
                
                $recipients = $logg_hit_servers | Get-MessageTrackingLog -MessageId $_.messageid.ToString() -EventId expand | select recipients

                #count how many people are in the recipient field
                $count = $recipients.recipients | measure 
    
                # if more than 1, do something many times
                if ($count.emailcount -ge 2) { 
                    $recipients.recipients | ForEach-Object {
                            $ErrorActionPreference = 'SilentlyContinue'
                            if($_ -eq $target_recipient) {$date_list[$date]['TargetRecipient'] = "Yes"
                            if ($_ -notin $date_list[$date]['recipients']) 
                            { $date_list[$date]['recipients'] += $_ } 
                            
                        } 
                            
                    
                }
    
                # if 1, do something once
                else {
                    if ($recipient -notin $date_list[$date]['recipients']) 
                            
                    { $date_list[$date]['recipients'] += $recipient }
                }
            }
        }
    }
   } 
    return $date_list 
}
}

function csv_builder{

param($original_dict)
#build csv from data in dict
process{
$original_dict.GetEnumerator() | ForEach-Object {

    $_ | Select-Object -Property @(
       @{Name = 'Date'; Expression = {$_.key} }
       #this may be invoking the count method need to verify 
       @{Name = 'Number of Emails'; Expression = {$_.emailcount} }
       @{Name = 'Recipients' ; Expression = {$_.value.recipients} } 
       @{Name = 'Target Present'; Expression = {$_.targetrecipient} }
    ) | Export-Csv -Append -Path '\\noahpadgel\c$\test_1.csv' -NoTypeInformation


} }

}

#build hash table with all dates entered into it
    $valid_token = $false
    do {
        $group_email = Read-Host "enter group name"
        if($group_email -match "^.*@martinmarietta.com"){$valid_token = $true}
        else{clear-host; write-host "please enter a valid MM email address"}} 
        
    until($valid_token -eq $true)
    
    [int]$amount_of_days_to_loop = read-host "enter 0 - 90 days to loop"
    $dict_dates = date_loop -days_to_loop $amount_of_days_to_loop -group_email $group_email -target_recipient 'noah.padgett@martinmarietta.com'
    #next part of code is create a csv for each entry in the file

    csv_builder -original_dict $dict_dates