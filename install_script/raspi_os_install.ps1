#Athors :
# - Olivier Palvadeau
#Description :
# A simple script to install a Raspberry OS image on an SD card.
# Currently only reset to normal usage (one NTFS partition) the SD card.
#
#Requires -RunAsAdministrator

more demoj-ascii.txt

Write-Host "`n---- Raspberry OS Installation ----`n"

#asking for the image path
$imgFile = Read-Host -Prompt "Input os image file path"

while (-not(Test-Path $imgFile -PathType leaf)) {
    Write-Host "File not found"
    $imgFile = Read-Host -Prompt "Input os image file path"
}
# Display all disks with numbers
Get-Disk | Select-Object -Property Number, FriendlyName, TotalSize, OperationalStatus | Out-String

#asking for a disk number
$diskNum = Read-Host -Prompt "Choose a disk number (carefully)"

while(-not($diskNum -match "^\d+$")){
    $diskNum = Read-Host -Prompt "Choose a disk number (carefully)"
}
$disk = Get-Disk $diskNum | Out-String

#can't select disk 0

if($diskNum -eq "0") {
    Write-Error "User disk selected"
    exit 1
}
Write-Host "Disk selected : $disk"
#wait for the user final decision.
$decision = Read-Host -Prompt "Are you sure to perform this action? All data from this disk will be erased. Y/n"
if(-not($decision -eq "Y")){
    Write-Host "Installation canceled."
    exit 0
}

#clear the disk and remove all partitions
Clear-Disk -Number $diskNum -RemoveData -RemoveOEM
Write-Host "Disk cleared"
#Creating a single partition with a letter E
New-Partition -DiskNumber $diskNum -UseMaximumSize
Get-Partition -DiskNumber $diskNum -PartitionNumber 1 | Format-Volume -FileSystem NTFS
Set-Partition -DiskNumber $diskNum -PartitionNumber 1 -NewDriveLetter E
Set-Partition -DiskNumber $diskNum -PartitionNumber 1 -IsActive $true


#TODO mount and copy the image file with ssh and auto login
# Mount-DiskImage -ImagePath is not working on windows because the raspberry image.img
# is easily readable a windows
# using WSL could be a solution 
#
