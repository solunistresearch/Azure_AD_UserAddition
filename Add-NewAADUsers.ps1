Connect-MgGraph

# Specify the URL of the CSV file in your GitHub repository
$GitHubURL = "https://raw.githubusercontent.com/solunistresearch/Azure_AD_UserAddition/main/NewAADUsers.csv"

# Create password profile
$PasswordProfile = @{
    Password                             = "P@ssw0rd!"
    ForceChangePasswordNextSignIn        = $true
    ForceChangePasswordNextSignInWithMfa = $true
}

try {
    # Download the CSV file from the GitHub repository
    $CSVFileContents = Invoke-RestMethod -Uri $GitHubURL

    # Convert the CSV file contents to PowerShell objects
    $AADUsers = $CSVFileContents | ConvertFrom-Csv

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
}
catch {
    Write-Host ("Failed to download the CSV file from the GitHub repository. Error: {0}" -f $_.Exception.Message) -ForegroundColor Red
}
