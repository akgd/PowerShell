# Power Platform connection
Add-PowerAppsAccount

# Prep file
$currentTime = $(get-date).ToString("yyyyMMddHHmmss");
$outputFileName = "Power Automate Flows $currentTime.csv"
$outputFilePath = Join-Path -Path .\ -ChildPath $outputFileName
$resultCollection = @()   
   
# Get Power Automate flows as admin 
$flows = Get-AdminFlow
$flows.Count
foreach ($flow in $flows) {
        $result = New-Object PSObject
        $result | Add-Member -MemberType NoteProperty -name "GUID" -value $flow.FlowName -Force
        $result | Add-Member -MemberType NoteProperty -name "DisplayName" -value $flow.DisplayName -Force
        $result | Add-Member -MemberType NoteProperty -name "Enabled" -value $flow.Enabled -Force
        $result | Add-Member -MemberType NoteProperty -name "LastModTime" -value $flow.LastModifiedTime -Force
        $result | Add-Member -MemberType NoteProperty -name "CreatedTime" -value $flow.CreatedTime -Force
        $result | Add-Member -MemberType NoteProperty -name "Environment" -value $flow.EnvironmentName -Force
        $resultCollection += $result
}  

# Export the results to a CSV file  
$resultCollection | Export-Csv $outputFilePath -NoTypeInformation
