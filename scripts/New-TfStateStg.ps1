# Set variables
$rgName = "rg-tfstate-ada"
$saName = "stgtfstateada001"
$containerName = "tfstatecontainer"
$location = "brazilsouth"
$sku = "Standard_LRS"
$subscriptionId = "XXXXXXXXXXXXX"

# Function to check Azure login
function Invoke-AzureLoginCheck {
    Write-Host "Checking Azure login status..."
    $account = az account show 2>$null
    if ($null -eq $account) {
        Write-Host "Not logged into Azure. Please log in..."
        az login
        if ($LASTEXITCODE -ne 0) { 
            Write-Host "Failed to log in to Azure"
            exit 1 
        }
    } else {
        Write-Host "Already logged into Azure."
    }
}

# Function to set the current subscription
function Set-Subscription {
    Write-Host "Setting subscription to: $subscriptionId..."
    az account set `
        --subscription $subscriptionId `
        --output jsonc 
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to set subscription"
        exit 1
    }
}

# Function to create a resource group
function New-ResourceGroup {
    Write-Host "Creating resource group: $rgName in $location..."
    az group create `
        --name $rgName `
        --location $location `
        --output jsonc 
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to create resource group"
        exit 1
    }
}

# Function to create a storage account
function New-StorageAccount {
    Write-Host "Creating storage account: $saName..."
    az storage account create `
        --resource-group $rgName `
        --name $saName `
        --sku $sku `
        --allow-blob-public-access false `
        --output jsonc 
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to create storage account"
        exit 1
    }
}

# Function to create a storage container
function New-StorageContainer {
    Write-Host "Creating storage container: $containerName..."
    az storage container create `
        --name $containerName `
        --account-name $saName `
        --output jsonc 
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to create storage container"
        exit 1
    }
}

# Function to enable soft delete and versioning for blobs
function Enable-BlobSoftDeleteAndVersioning {
    Write-Host "Enabling soft delete and versioning for blobs in storage account: $saName..."
    az storage account blob-service-properties update `
        --account-name $saName `
        --enable-delete-retention true `
        --delete-retention-days 7 `
        --enable-versioning true `
        --output jsonc
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to enable soft delete and versioning for blobs"
        exit 1
    }
}

# Run the script
Invoke-AzureLoginCheck
Set-Subscription
New-ResourceGroup
New-StorageAccount
Enable-BlobSoftDeleteAndVersioning
New-StorageContainer
Write-Host "Storage account and container successfully created."
