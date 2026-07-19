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
$token = (Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com").Token
$headers = @{
    Authorization = "Bearer $token"
    "Content-Type" = "application/json"
}

Invoke-RestMethod -Uri "https://microsoft.com" -Method Post -Headers $headers -Body $body
Write-Output "Successfully requested creation for $UserPrincipalName"
