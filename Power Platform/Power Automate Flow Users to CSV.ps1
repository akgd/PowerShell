# Prep file
$currentTime = $(get-date).ToString("yyyyMMddHHmmss");
$outputFileName = "Power Automate Flow Users $currentTime.csv"
$outputFilePath = Join-Path -Path .\ -ChildPath $outputFileName
$resultCollection = @()

$tenantId = "[YOUR TENANT ID]"
Connect-MgGraph –Scopes "User.Read.All" -TenantId $tenantId
Add-PowerAppsAccount

$userProps = @(
    'Id', 'DisplayName', 'Mail', 'UserPrincipalName', 'UserType', 'AccountEnabled', 'CreatedDateTime', 'CompanyName', 'Department', 'JobTitle'
)  
   
# Get Power Automate flows as admin 
$flows = Get-AdminFlow
$flows.Count
foreach ($flow in $flows) {
    # Only report on flows that are enabled
        foreach ($user in Get-AdminFlowOwnerRole -FlowName $flow.FlowName -EnvironmentName $flow.EnvironmentName) { 

            $user | Format-List

            $userProfile = Get-MgUser -UserId $user.PrincipalObjectId -Property $userProps -ExpandProperty Manager | Select-Object $userProps

            $result = New-Object PSObject
            $result | Add-Member -MemberType NoteProperty -name "GUID" -value $flow.FlowName -Force
            $result | Add-Member -MemberType NoteProperty -name "DisplayName" -value $flow.DisplayName -Force
            $result | Add-Member -MemberType NoteProperty -name "Enabled" -value $flow.Enabled -Force
            $result | Add-Member -MemberType NoteProperty -name "LastModTime" -value $flow.LastModifiedTime -Force
            $result | Add-Member -MemberType NoteProperty -name "CreatedTime" -value $flow.CreatedTime -Force
            $result | Add-Member -MemberType NoteProperty -name "Environment" -value $flow.EnvironmentName -Force
            $result | Add-Member -MemberType NoteProperty -name "UserDisplayName" -value $userProfile.DisplayName -Force
            $result | Add-Member -MemberType NoteProperty -name "UserPrincipalName" -value $userProfile.UserPrincipalName -Force
            $result | Add-Member -MemberType NoteProperty -name "UserCompany" -value $userProfile.CompanyName -Force
            $result | Add-Member -MemberType NoteProperty -name "UserDepartment" -value $userProfile.Department -Force
            $result | Add-Member -MemberType NoteProperty -name "UserPrincipleObjectId" -value $user.PrincipalObjectId -Force
            $result | Add-Member -MemberType NoteProperty -name "UserRoleType" -value $user.RoleType -Force

            $resultCollection += $result 
        }
}  

# Export the results to a CSV file  
$resultCollection | Export-Csv $outputFilePath -NoTypeInformation
