﻿############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 01/02/2024        #
############################

<#
.SYNOPSIS
    This script reads the MAC address of the network adapters and writes them to a CSV file.
.DESCRIPTION
    This script reads the MAC address of the network adapters and writes them to a CSV file.
    The script can also show the MAC address of a specific computer and clean up the CSV file.
.EXAMPLE
    Get-Mac.ps1
.NOTES
File: Get-Mac.ps1
Author: Elias De Hondt
Version: 1.0
#>

# Import the csv file
$csvfile = "..\Data\MacTable.csv"

function Delete-LinesCsv($property, $value, $csvfile) {
    Import-Csv $csvfile | ? { $_.$property -ne $value } | Export-Csv ($csvfile + ".new") -force
    Move-Item ($csvfile + ".new") $csvfile -Force
}

function Write-Mac() {
    $adapters = Get-CimInstance Win32_NetworkAdapter | ? { $_.AdapterType -eq "Ethernet 802.3" -and $_.PhysicalAdapter -eq $true }
    foreach ($adapter in $adapters) {
        $date = (Get-Date).ToString() 
        Delete-LinesCsv mac $adapter.MacAddress $csvfile
        Write-Host ("Schrijf: " + $date + "," + $adapter.SystemName + "," + $adapter.Name + "," + $adapter.MacAddress)
        Add-Content $csvfile ($date + "," + $adapter.SystemName + "," + $adapter.Name + "," + $adapter.MacAddress)
    }
}

function Get-Mac($computername) {
    Import-Csv $csvfile | ? {$_.computername -like $computername}
}

function Clean-Mac([int]$maxtimespan) {
    Import-Csv $csvfile | ? { ((Get-Date) - (Get-Date $_.date)).days -le $maxtimespan } | Export-Csv ($csvfile + ".new")
    Move-Item ($csvfile + ".new") $csvfile -Force
}

if ( $args.count -eq 0 ) { Write-Mac }
if ( $args[0] -eq "-show" -and $args.count -eq 2) { Get-Mac $args[1] }
if ( $args[0] -eq "-clean" -and $args.count -eq 2 ) { Clean-Mac $args[1] }