# Connect to Power Apps
Add-PowerAppsAccount

# Prep file and data storage variable
$currentTime = $(get-date).ToString("yyyyMMddHHmmss");    
$outputFileName = "Power Apps $currentTime.csv"
$outputFilePath = Join-Path -Path .\ -ChildPath $outputFileName
$resultCollection = @()   
   
# Get all Power Apps
$apps = Get-AdminPowerApp 
foreach ($app in $apps) {  
    $app | Format-List
    $result = New-Object PSObject
    $result | Add-Member -MemberType NoteProperty -name "AppDisplayName" -value $app.DisplayName -Force
    $result | Add-Member -MemberType NoteProperty -name "AppID" -value $app.AppName -Force # ID is important because different apps may have the 
    $result | Add-Member -MemberType NoteProperty -Name "CreatedTime" -value $app.CreatedTime -Force
    $result | Add-Member -MemberType NoteProperty -Name "LastModifiedTime" -value $app.LastModifiedTime -Force
    $result | Add-Member -MemberType NoteProperty -name "Environment" -value $app.EnvironmentName -Force
    $resultCollection += $result 
}  

#Export the result Array to CSV file  
$resultCollection | Export-Csv $outputFilePath -NoTypeInformation 
