#Set-Location -Path "C:\Script\microsoft.graph.authentication.2.0.0-rc3"
#Import-Module -Name ".\Microsoft.Graph.Authentication.dll"

# Connect to Microsoft Graph with user read/write permissions
# Connect-MgGraph -Scope User.ReadWrite.All

Connect-MgGraph

# Specify the path of the CSV file
$CSVFilePath = "C:\temp\NewAADUsers.csv"

# Create password profile
$PasswordProfile = @{
    Password                             = "P@ssw0rd!"
    ForceChangePasswordNextSignIn        = $true
    ForceChangePasswordNextSignInWithMfa = $true
}

# Import data from CSV file
$AADUsers = Import-Csv -Path $CSVFilePath

# Loop through each row containing user details in the CSV file
foreach ($User in $AADUsers) {
    $UserParams = @{
        DisplayName       = $User.DisplayName
        MailNickName      = $User.MailNickName
        UserPrincipalName = $User.UserPrincipalName
        Department        = $User.Department
        JobTitle          = $User.JobTitle
        Mobile            = $User.Mobile
        Country           = $User.Country
        EmployeeId        = $User.EmployeeId
        PasswordProfile   = $PasswordProfile
        AccountEnabled    = $true
    }

    try {
        $null = New-MgUser @UserParams -ErrorAction Stop
        Write-Host ("Successfully created the account for {0}" -f $User.DisplayName) -ForegroundColor Green
    }
    catch {
        Write-Host ("Failed to create the account for {0}. Error: {1}" -f $User.DisplayName, $_.Exception.Message) -ForegroundColor Red
    }
}