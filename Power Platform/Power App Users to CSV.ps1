# DESCRIPTION: This script outputs users with access to specific Power Apps to a CSV file.
# REQUIRED ROLES: Power Platform Admin
# REQUIRED MODULES: Microsoft.PowerApps.Administration.PowerShell 

# Connect to Power Apps
Add-PowerAppsAccount

# Prep file and data storage variable
$currentTime = $(get-date).ToString("yyyyMMddHHmmss");    
$outputFileName = "Power Apps Users $currentTime.csv"
$outputFilePath = Join-Path -Path .\ -ChildPath $outputFileName
$resultCollection = @()   
   
# Get all Power Apps
$apps = Get-AdminPowerApp 
foreach ($app in $apps) {  
    # Loop through and get each app user and their role
    foreach ($user in Get-PowerAppRoleAssignment -Appname $app.Appname) { 
            $result = New-Object PSObject
            $result | Add-Member -MemberType NoteProperty -name "AppDisplayName" -value $app.DisplayName -Force
            $result | Add-Member -MemberType NoteProperty -name "AppID" -value $app.AppName -Force # ID is important because different apps may have the same name
            $result | Add-Member -MemberType NoteProperty -name "UserDisplayName" -value $user.PrincipalDisplayName-Force
            $result | Add-Member -MemberType NoteProperty -name "UserEmail" -value $user.PrincipalEmail-Force
            $result | Add-Member -MemberType NoteProperty -name "RoleType" -value $user.RoleType-Force
            $result | Add-Member -MemberType NoteProperty -Name "CreatedTime" -value $app.CreatedTime -Force
            $result | Add-Member -MemberType NoteProperty -Name "LastModifiedTime" -value $app.LastModifiedTime -Force
            $result | Add-Member -MemberType NoteProperty -name "Environment" -value $app.EnvironmentName -Force
            $resultCollection += $result 
    }
}  

#Export the result Array to CSV file  
$resultCollection | Export-Csv $outputFilePath -NoTypeInformation  

