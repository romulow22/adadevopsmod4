# Set environment variables for AzureRM provider
$env:TF_VAR_client_id = ""
$env:TF_VAR_client_certificate_path = "C:\\Users\\client.pfx"
$env:TF_VAR_tenant_id = ""
$env:TF_VAR_subscription_id = ""

# Print environment variables to verify
Write-Output "TF_VAR_client_id=$env:TF_VAR_client_id"
Write-Output "TF_VAR_client_certificate_path=$env:TF_VAR_client_certificate_path"
Write-Output "TF_VAR_tenant_id=$env:TF_VAR_tenant_id"
Write-Output "TF_VAR_subscription_id=$env:TF_VAR_subscription_id"