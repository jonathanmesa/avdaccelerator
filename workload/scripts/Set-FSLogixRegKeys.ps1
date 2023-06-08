# Define Parameters
param(
    [string]$volumeShare
)

# Set the registry path for FSLogix Profiles
$registryPath = 'HKEY_LOCAL_MACHINE\Software\FSLogix\Profiles'

# Set VHDLocations to the provided volume share
Write-Host "Setting VHDLocations to $volumeShare"
& reg.exe add $registryPath /v VHDLocations /t REG_MULTI_SZ /d $volumeShare /f

# Set DeleteLocalProfileWhenVHDShouldApply to 1
Write-Host "Enabling DeleteLocalProfileWhenVHDShouldApply"
& reg.exe add $registryPath /v DeleteLocalProfileWhenVHDShouldApply /t REG_DWORD /d 1 /f

# Set FlipFlopProfileDirectoryName to 1
Write-Host "Enabling FlipFlopProfileDirectoryName"
& reg.exe add $registryPath /v FlipFlopProfileDirectoryName /t REG_DWORD /d 1 /f

# Set Enabled to 1 to enable FSLogix Profiles
Write-Host "Enabling FSLogix Profiles"
& reg.exe add $registryPath /v Enabled /t REG_DWORD /d 1 /f

# Output completion message
Write-Host "FSLogix Profiles configuration completed."

