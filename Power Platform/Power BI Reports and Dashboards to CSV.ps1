# Prep file
$currentTime = $(get-date).ToString("yyyyMMddHHmmss");
$outputFileName = "Power BI Overview $currentTime.csv"
$outputFilePath = Join-Path -Path .\ -ChildPath $outputFileName
$resultCollection = @()  

Connect-PowerBIServiceAccount
$workspaces = Get-PowerBIWorkspace -Scope Organization -Include All -All
foreach ($wkspace in $workspaces) {
    #$wkspace | Format-List
    foreach ($report in $wkspace.Reports) {
        $result = New-Object PSObject
        $result | Add-Member -MemberType NoteProperty -name "WorkspaceName" -value $wkspace.Name -Force
        $result | Add-Member -MemberType NoteProperty -name "WorkspaceId" -value $wkspace.Id -Force
        $result | Add-Member -MemberType NoteProperty -name "WorkspaceType" -value $wkspace.Type -Force
        $result | Add-Member -MemberType NoteProperty -name "WorkspaceState" -value $wkspace.State -Force
        $result | Add-Member -MemberType NoteProperty -name "WorkspaceIsOrphaned" -value $wkspace.IsOrphaned -Force
        $result | Add-Member -MemberType NoteProperty -name "ReportOrDashboard" -value "Report" -Force
        $result | Add-Member -MemberType NoteProperty -name "Name" -value $report.Name -Force
        $result | Add-Member -MemberType NoteProperty -name "Id" -value $report.Id -Force
        # Add to collection
        $resultCollection += $result 
    }
    foreach ($dashbd in $wkspace.Dashboards) {
        $result = New-Object PSObject
        $result | Add-Member -MemberType NoteProperty -name "WorkspaceName" -value $wkspace.Name -Force
        $result | Add-Member -MemberType NoteProperty -name "WorkspaceId" -value $wkspace.Id -Force
        $result | Add-Member -MemberType NoteProperty -name "WorkspaceType" -value $wkspace.Type -Force
        $result | Add-Member -MemberType NoteProperty -name "WorkspaceState" -value $wkspace.State -Force
        $result | Add-Member -MemberType NoteProperty -name "WorkspaceIsOrphaned" -value $wkspace.IsOrphaned -Force
        $result | Add-Member -MemberType NoteProperty -name "ReportOrDashboard" -value "Dashboard" -Force
        $result | Add-Member -MemberType NoteProperty -name "Name" -value $dashbd.Name -Force
        $result | Add-Member -MemberType NoteProperty -name "Id" -value $dashbd.Id -Force
        # Add to collection
        $resultCollection += $result 
    }
}

# Export the results to a CSV file  
$resultCollection | Export-Csv $outputFilePath -NoTypeInformation
