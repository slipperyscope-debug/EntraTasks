# scripts/Create-EntraUser.ps1
# Adding a comment
param (
    [Parameter(Mandatory=$true)]
    [string]$UserPrincipalName,
    
    [Parameter(Mandatory=$true)]
    [string]$DisplayName,
    
    [Parameter(Mandatory=$true)]
    [string]$MailNickname,
    
    [Parameter(Mandatory=$true)]
    [string]$GivenName,
    
    [Parameter(Mandatory=$true)]
    [string]$SurName
)

# Connect implicitly using the context established by the GitHub runner log-in step
Write-Host "Connecting to Microsoft Graph..."
Connect-MgGraph -Identity

# Generate a strong temporary password dynamically
$PasswordProfile = @{
    Password = [System.Web.Security.Membership]::GeneratePassword(16, 2)
    ForceChangePasswordNextSignIn = $true
}

# Define parameters matching Microsoft Graph user criteria
$UserParams = @{
    UserPrincipalName = $UserPrincipalName
    DisplayName       = $DisplayName
    MailNickname      = $MailNickname
    GivenName         = $GivenName
    SurName           = $SurName
    AccountEnabled    = $true
    PasswordProfile   = $PasswordProfile
}

Write-Host "Attempting to create user: $UserPrincipalName"
$NewUser = New-MgUser @UserParams

Write-Host "Successfully created user!"
Write-Host "Object ID: $($NewUser.Id)"
