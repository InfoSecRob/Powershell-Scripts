################################################################################################################################################################ 
# Script creates a list of all groups in a tenant with their members.
# 
# Author:                 Rob Bruce 
# Version:                 1.0 
# Last Modified Date:     08-28-18 
# Last Modified By:       Rob Bruce
################################################################################################################################################################



#Connect to the tenant you want to enumerate groups from

Connect-MsolService

#Constants 
$OutputFile = "c:\temp\DistributionListMembers.csv"   #The CSV Output file that is created, change for your purposes

#Enumerate groups into a table

$groups = Get-MsolGroup -all

# Loop through each row and gather info
ForEach($group in $groups) {

    #Gather User info
    $objid = $group.'ObjectId'
    $dname = $group.'DisplayName'
    $gtype = $group.'GroupType'
    $desc = $group.'Description'

    
    write-host "Processing $($dname, $gtype)..."
        
        #Get members of this group 
	    $objDGMembers = Get-MsolGroupMember -GroupObjectId $($objid)
        
        #Iterate through each member 
	    Foreach ($objMember in $objDGMembers)
         {
        #Write to an output file
        Out-File -FilePath $OutputFile -InputObject "$($dname),$($gtype),$($objMember.DisplayName),$($objMember.EmailAddress),$($objMember.GroupMemberType)" -Encoding UTF8 -append 
		write-host "`t$($dname),$($gtype),$($objMember.DisplayName),$($objMember.EmailAddress),$($objMember.GroupMemberType)"
        }
    }