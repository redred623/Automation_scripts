#this function takes either sam or distinguished name of an AD group and finds all the groups nested into it
#It puts all of the groups into a hash table and then the hash table can be used. 

function getchildgroups($groupname) {
    
    # Get intiial group details and members
    $childgroup = get-adgroup $groupname -properties member
    
    # Only continue if this hgroup has members
    if (($childgroup.member).count -gt 0) {
 
        # Loop through each member of the group
        foreach ($memberobject in $childgroup.member) {
 
            try {
                $object = get-adobject $memberobject -properties objectclass,samaccountname,groupType;

                # If the member of the group is another group
                if ($object.objectclass -eq "group")  {
                    # add to group
                    if($object.sAMAccountName -notin $group_list.Keys){
                    $group_list[$object.sAMAccountName] = $object.groupType

                        if($childgroup.SamAccountName -ne $object.sAMAccountName)
                        { 
                            getchildgroups($object.sAMAccountName)
                                    }
                
            }}} 
            
            catch {}
    }

 }}


#create dictionary to stop looping and keep track of names.
$script:group_list = @{}

# Run the function with your group name either SAM or distinguished 
getchildgroups("AP-ENT-MMM-CTXPlanningAnalytics-User")

$group_list


Foreach($group in $group_list.GetEnumerator()) {
        if($group.Value -ne -2147483640) {Write-Output "$($group.key) is not a universial group"}
        else{
            try{Enable-DistributionGroup -Identity $group; Set-DistributionGroup -HiddenFromAddressListsEnabled:$true -Identity [string]$group; Write-Output "$group mailbox succesfully created"}
            catch {Write-Output "$group already has a mailbox"} }
        }

        