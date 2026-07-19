# create-user.ps1
param (
    [string]$UserPrincipalName,
    [string]$DisplayName,
    [string]$MailNickname,
    [string]$Password
)

# Build the Graph API Body payload
$body = @{
    accountEnabled    = $true
    displayName       = $DisplayName
    mailNickname      = $MailNickname
    userPrincipalName = $UserPrincipalName
    passwordProfile   = @{
        forceChangePasswordNextSignIn = $true
        password                      = $Password
    }
} | ConvertTo-Json

# Send request using the access token implicitly provided by the Azure login context
# Get the access token from the current Azure context
$token = (Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com").Token

# Ensure the token is a string and not null
if ([string]::IsNullOrEmpty($token)) {
    throw "Failed to retrieve access token. Ensure you are logged in to Azure."
}

$headers = @{
    Authorization = "Bearer $token"
    "Content-Type" = "application/json"
}

Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/users" -Method Post -Headers $headers -Body $body
Write-Output "Successfully requested creation for $UserPrincipalName"
