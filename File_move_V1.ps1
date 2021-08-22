#File Transfer Script
function load_files {
    #path = "\\ralldmsapp01\ldshares\ldpackages"
    $x = 0

    #creates list with each file list under an ID that is unique to its name. 
    $list_apps = Get-Childitem -Path $valid_path -ErrorAction SilentlyContinue | ForEach-Object {
        $x += 1
        $_ | Select-Object name, @{name = "ID"; expression = { $x } }
    }
    return $list_apps
}

function main_dir {
    #loads the list of the files into a variable
    $list_apps = load_files
    write-host '--------Type the ID of the folder you want to copy---------'
    #formats the list to fit better onto the screen
    $list_apps | Format-Table 
    #accept input from the user, it needs to be a int so we silence all errors until it is an integer. Load current error action into a variable.
    $old_error_action = $ErrorActionPreference
    do {
        $ErrorActionPreference = 'silentlycontinue'
        [int]$file_id = Read-Host "Choose ID>>> " 
    }until ($file_id.GetTypeCode() -eq "int32")
    #return error action back to its previous value
    $ErrorActionPreference = $old_error_action
    #create path from selection
    $file_path = $list_apps | Where-Object { $_.id -eq $file_id } 
    $script:full_path = "$valid_path\$($file_path.name)"
    #ask from comp name and build path to its support folder then validate if the computer path will work. 
    $comp_name = Read-Host "Computer Name>>> "
    $script:comp_path = "\\$($comp_name)\c$\Support"
    do {
        $valid_path = Test-Path -path $comp_path
        if ($valid_path -eq $false) { "Computer is not on network, does not have a support folder, or does not exist. Try again."; $comp_name = Read-Host "Computer Name>>> "; $script:comp_path = "\\$($comp_name)\c$\Support" }
    } until ($valid_path -eq $True)
    #return these values
    return $full_path, $comp_path


}

function search_dir {
    $list_apps = load_files
    do {
        write-host "--------Search for file---------"
        $search_sel = Read-Host -prompt ">>> " 
        $selected_list = $list_apps | ForEach-Object {
            $name = $_.name.ToUpper()
            if ($name.contains($search_sel.ToUpper()))
            {
                $_
            }
        }
        $selected_list | Format-Table
        $numbers = $selected_list.id
        write-host "Please select your folder/file or type 'search' to search again"
        $token = read-host ">>> "
        try { $token = [Int32]$token }
        catch {}
        if ($token -eq 'search') { clear-host }
        elseif ($token.GetTypeCode() -eq "Int32") {
            if ($token -in $numbers) {
                $file_path = $list_apps | Where-Object { $_.id -eq [int]$token } 
                $script:full_path = "$valid_path\$($file_path.name)"
                $comp_name = Read-Host "Computer Name>>> "
                $script:comp_path = "\\$($comp_name)\c$\Support"
                do {
                    $valid_path = Test-Path -path $comp_path
                    if ($valid_path -eq $false) { "Computer is not on network or does not exist. Try again."; $comp_name = Read-Host "Computer Name>>> "; $script:comp_path = "\\$($comp_name)\c$\Support" }
                } until ($valid_path -eq $True)
                $search_selection = $true
                return $full_path, $comp_path
            }
            else {
                clear-host; "Number is out of range please select a number presented on screen"; Start-Sleep -seconds 2; clear-host
            }
        }
    }until ($search_selection -eq $true)



}

function list_dir { 
    $list_apps = load_files
    #To page, we set a limit of 1 - 40 
    #page limit is 40, can be changed to better fit 
    $page_min = 1
    $page_max = 40
    #gets the max amount of entries in the directory and caps the pages to not go past it. 
    $list_max = $list_apps | Measure-Object
    $page_size = 40
    $valid_token = $false
    $page_count = 1
    do {
        write-host "--------Type the ID of the folder you want to copy---------`n Page $page_count"
        $list_display = $list_apps | Where-Object -FilterScript { $_.id -le $page_max -and $_.id -ge $page_min }
        $list_display | Format-Table 
        $ID = Read-Host "Enter an ID or enter '>' for next page and '<' for previous page"
        try { $ID = [Int32]$ID }
        catch {}
        if ($ID.GetTypeCode() -eq 'Int32') {
            if ($ID -le $list_max.count -and $ID -ge $page_min) {
                $file_path = $list_apps | Where-Object { $_.id -eq [int]$ID } 
                $script:full_path = "$valid_path\$($file_path.name)"
                $comp_name = Read-Host "Computer Name>>> "
                $script:comp_path = "\\$($comp_name)\c$\Support"
                do {
                    $valid_path = Test-Path -path $comp_path
                    if ($valid_path -eq $false) { "Computer is not on network or does not exist. Try again."; $comp_name = Read-Host "Computer Name>>> "; $script:comp_path = "\\$($comp_name)\c$\Support" }
                } until ($valid_path -eq $True)
                $valid_token = $true
                return $full_path, $comp_path
            }
            else {
                clear-host; "Number is out of range please select a number between $page_min and $($list_max.count)"; Start-Sleep -seconds 2; clear-host
            }

        }
        elseif ($ID -eq '>') {
            if (($page_max + $page_size) -le $list_max.count) {
                $page_min += $page_size
                $page_max += $page_size
                $page_count += 1
                Clear-Host 
            }
            elseif ($page_max -eq $list_max.count) { Clear-Host }
            elseif ($list_max.count -le $page_max) { Clear-Host }
            else {
                $final_page_size = $list_max.count - $page_max
                $page_min += $final_page_size
                $page_max += $final_page_size
                $page_count += 1
                Clear-Host
            }
        }
        elseif ($ID -eq '<') {
            if ($page_min -eq 1) { Clear-Host }
            elseif ($page_max -eq $list_max.count) {
                $final_page_size = $list_max.count % $page_size
                $page_min -= $final_page_size
                $page_max -= $final_page_size
                $page_count -= 1
                Clear-Host
            }
            else { 
                $page_min -= $page_size
                $page_max -= $page_size
                $page_count -= 1
                Clear-Host 
            }
        }
        else { clear-host; "Please enter a valid choice"; Start-Sleep -seconds 2; clear-host }
    } until ($valid_token -eq $true)


}
function Directory_Main {
    <#
    .Description
    This is the main directory sorter for the code and makes sure user choices are correct
    #>

    # Version Number
    "File Mover Version $version"
    #Use Ldap Share or allow user to choose another. Validates that path works before continuing to next step. 
    "Current Directory is $path_share `nIf you would like to change directories press Y if not press N to continue"
    $escape_key = Read-Host "Choose Y or N>>> "
    if ($escape_key.ToUpper() -eq 'Y') {
        do {
            $Path_share = Read-Host "Type Directory>>> ";  
            $valid_path_token = Test-Path -path $Path_share; 
            if ($valid_path_token -eq $True) {
                $script:valid_path = $path_share
                $escape_key = 'N'
                
            }
            else {
                "Directory does not exist or you are not connected to the network" 
            }
         
        } until ($escape_key.ToUpper() -eq 'N') 
    }
    
    if ($null -eq $valid_path) { $script:valid_path = $path_share }
    # start selection process for rest of script. 
    $list_in_order = @(
        "-------------------------------",
        "Please Choose an option",
        "1 - See Whole List",
        "2 - Search for a Specific Folder or File",
        "3 - Show Page by Page",
        "-------------------------------"
    )
    $possible_choices = @(1, 2, 3)
    $valid_token = $false

    do {
        foreach ($statement in $list_in_order) { Write-Host $statement }
        [int]$main_input = Read-Host "Please Select Option>>> "
        if ($main_input -cnotin $possible_choices) {
            clear-host; "Please enter a valid choice"; Start-Sleep -seconds 2; clear-host
        }
        if ($main_input -in $possible_choices) { $valid_token = $True }
    }Until ($valid_token -eq $True)

    if ($main_input -eq 1) { main_dir }

    if ($main_input -eq 2) { search_dir }

    if ($main_input -eq 3) { list_dir }






}




$version = "1.0"
$script:path_share = "\\ralldmsapp01\ldshares\LDPackages"

Directory_Main



#main_dir
#-recurse copys all the files in and folders in the selected folder. 
Copy-Item $full_path $comp_path -Recurse

Clear-Host
Write-Host "File Transfer Complete" 
Read-Host "Press any key to exist.."
exit