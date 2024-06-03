############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 01/02/2024        #
############################

<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.NOTES
File: Example-Exam.ps1
Author: Elias De Hondt
Version: 1.0
#>

param ( # Parameters for the script
    [string]$csvfile="../Data/ViolationsElias.csv"
)

[string]$global:PrimaryColor = "#4f94f0"

try {
    $Violations = Import-Csv -Path $csvfile -Delimiter ","
} catch {
    ExitScript "Error: No CSV file" 1 $False
}

# Function to write a colored line
function WriteColoredLine {
    param (
        [string]$Text,
        [string]$ColorHex
    )
    
    $R = [Convert]::ToInt32($ColorHex.Substring(1, 2), 16)
    $G = [Convert]::ToInt32($ColorHex.Substring(3, 2), 16)
    $B = [Convert]::ToInt32($ColorHex.Substring(5, 2), 16)
    
    [string]$Local:AnsiSequence = [char]27 + "[38;2;" + $R + ";" + $G + ";" + $B + "m"
    [string]$Local:ResetSequence = [char]27 + "[0m"
    Write-Host "${AnsiSequence}${Text}${ResetSequence}"
}

# Function to read a colored line
function ReadColoredLine {
    param (
        [string]$Text,
        [string]$ColorHex
    )
    
    $R = [Convert]::ToInt32($ColorHex.Substring(1, 2), 16)
    $G = [Convert]::ToInt32($ColorHex.Substring(3, 2), 16)
    $B = [Convert]::ToInt32($ColorHex.Substring(5, 2), 16)
    
    [string]$Local:AnsiSequence = [char]27 + "[38;2;" + $R + ";" + $G + ";" + $B + "m"
    [string]$Local:ResetSequence = [char]27 + "[0m"
    Read-Host "${AnsiSequence}${Text}${ResetSequence}"
}

# Function to exit the script
function ExitScript([string]$Message="No Message", [int]$Code=0, [bool]$NoColor=$False) {
    # 1 = Error
    # 0 = Success
    Clear-Host
    if ($NoColor) {
        Write-Host $Message
    } else {
        if ($Code -eq 0) {
            WriteColoredLine -text $Message -colorHex "#00ff00"
        } elseif ($Code -eq 1) {
            WriteColoredLine -text $Message -colorHex "#ff0000"
        }
    }
    exit $Code
}

# Function to display a banner message
function BannerMessage([string]$Message="Message...", [string]$Color="#ffffff") {
    Clear-Host
    [int]$Local:Length = $Message.Length
    [string]$Local:Line1 = "*****"
    [string]$Local:Line2 = "*   "
    [string]$Local:Text = "*  " + $Message + "  *"

    for ($i = 0; $i -le $Length; $i++) {
        $Line1 += "*"
        $Line2 += " "

        if ($i -eq $Length) {
            $Line2 += "*"
        }
    }
    
    WriteColoredLine -text $Line1 -colorHex $Color
    WriteColoredLine -text $Line2 -colorHex $Color
    WriteColoredLine -text $Text -colorHex $Color
    WriteColoredLine -text $Line2 -colorHex $Color
    WriteColoredLine -text $Line1 -colorHex $Color
}

# Function to create a popup window object
function PopupWindowObject {
    param (
        [object]$Table,
        [string]$Title,
        [array]$ColumnNames
    )

    WriteColoredLine -text "*`n* Opening popup window:" -colorHex $PrimaryColor

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $Local:Form = New-Object System.Windows.Forms.Form
    $Local:Form.Text = $Title
    $Local:Form.Size = New-Object System.Drawing.Size(500, 550)
    $Local:Form.StartPosition = "CenterScreen"
    $Local:Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $Local:Form.MaximizeBox = $False
    $Local:Form.MinimizeBox = $False
    $Local:Form.ControlBox = $True
    $Local:Form.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)

    $Local:ListView = New-Object System.Windows.Forms.ListView
    $Local:ListView.Location = New-Object System.Drawing.Point(10, 50)
    $Local:ListView.Size = New-Object System.Drawing.Size(460, 400)
    $Local:ListView.View = [System.Windows.Forms.View]::Details
    $Local:ListView.FullRowSelect = $True
    $Local:ListView.GridLines = $False
    $Local:ListView.BackColor = [System.Drawing.Color]::White
    $Local:ListView.ForeColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $Local:ListView.Font = New-Object System.Drawing.Font("Arial", 10)
    $Local:ListView.HeaderStyle = [System.Windows.Forms.ColumnHeaderStyle]::Clickable

    for ($i = 0; $i -lt $ColumnNames.Length; $i++) {
        $Local:ColumnHeader = New-Object System.Windows.Forms.ColumnHeader
        $Local:ColumnHeader.Text = $ColumnNames[$i]
        $Local:ColumnHeader.Width = -2
        $Local:ListView.Columns.Add($Local:ColumnHeader) | Out-Null
    }

    function Update-ListView {
        param (
            [string]$FilterText
        )

        $ListView.BeginUpdate()
        $ListView.Items.Clear()
        $FilteredTable = $Table | Where-Object {
            $matches = $false
            foreach ($column in $ColumnNames) {
                if ($_.($column) -like "*$FilterText*") {
                    $matches = $true
                    break
                }
            }
            $matches
        }

        $rowIndex = 0
        foreach ($row in $FilteredTable) {
            $ListViewItem = New-Object System.Windows.Forms.ListViewItem
            $ListViewItem.Text = $row.$($ColumnNames[0])
            for ($j = 1; $j -lt $ColumnNames.Length; $j++) {
                $ListViewItem.SubItems.Add($row.$($ColumnNames[$j])) | Out-Null
            }

            # Alternate row color
            if ($rowIndex % 2 -eq 0) {
                $ListViewItem.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
            } else {
                $ListViewItem.BackColor = [System.Drawing.Color]::White
            }

            $ListView.Items.Add($ListViewItem) | Out-Null
            $rowIndex++
        }
        $ListView.EndUpdate()
    }

    Update-ListView ""

    $Local:Footer = New-Object System.Windows.Forms.LinkLabel
    $Local:Footer.Location = New-Object System.Drawing.Point(10, 460)
    $Local:Footer.Size = New-Object System.Drawing.Size(460, 40)
    [string]$Local:CurrentDate = Get-Date -Format "yyyy"
    $Local:Footer.Text = "Designed by the EliasDH Team `n" + $CurrentDate + " EliasDH. All rights reserved."
    $Local:Footer.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $Local:Footer.LinkColor = [System.Drawing.ColorTranslator]::FromHtml($PrimaryColor)
    $Local:Footer.Links.Add(35, 7, "https://eliasdh.com") | Out-Null
    $Local:Footer.Font = New-Object System.Drawing.Font("Arial", 8)

    $Local:Footer.add_LinkClicked({
        param (
            $sender, 
            $element
        )
        [System.Diagnostics.Process]::Start($element.Link.LinkData.ToString()) | Out-Null
    })

    $Local:SearchBox = New-Object System.Windows.Forms.TextBox
    $Local:SearchBox.Location = New-Object System.Drawing.Point(10, 10)
    $Local:SearchBox.Size = New-Object System.Drawing.Size(360, 30)
    $Local:SearchBox.BackColor = [System.Drawing.Color]::White
    $Local:SearchBox.ForeColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $Local:SearchBox.Font = New-Object System.Drawing.Font("Arial", 10)
    $Local:SearchBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
    $Local:SearchBox.add_TextChanged({
        Update-ListView $SearchBox.Text
    })

    $Local:ExportButton = New-Object System.Windows.Forms.Button
    $Local:ExportButton.Location = New-Object System.Drawing.Point(380, 10)
    $Local:ExportButton.Size = New-Object System.Drawing.Size(90, 30)
    $Local:ExportButton.Text = "Export All"
    $Local:ExportButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml($PrimaryColor)
    $Local:ExportButton.ForeColor = [System.Drawing.Color]::White
    $Local:ExportButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $Local:ExportButton.Font = New-Object System.Drawing.Font("Arial", 10)
    $Local:ExportButton.add_Click({
        $CsvContent = $Table | Export-Csv -NoTypeInformation -Force -Path "$env:USERPROFILE\Desktop\export.csv"
        [System.Windows.Forms.MessageBox]::Show("Data exported to Desktop\export.csv", "Export Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    })

    $Local:Form.Controls.Add($ListView)
    $Local:Form.Controls.Add($Footer)
    $Local:Form.Controls.Add($SearchBox)
    $Local:Form.Controls.Add($ExportButton)
    $Local:Form.ShowDialog()
}

# Function to get a list of unique street names
function Get-ListOfUniqueStreetNames([object]$Table) {
    $Local:UniqueStreetNames = $Table | Select-Object -Property office_location -Unique | Sort-Object -Property office_location

    [array]$Local:UniqueStreetNamesTable = @()
    [int]$Local:i = 0
    
    foreach ($Item in $UniqueStreetNames) { # Loop through the unique street names
        $UniqueStreetNamesTable += [pscustomobject]@{ # Create a custom object
            Id = [int]$i;
            StreetName = [string]$Item.office_location;
        }
        if ($i -eq 0) {
            [array]$UniqueStreetNamesTable = @()
        }
        $i++
    }
    return $UniqueStreetNamesTable
}

# Function to get the total amount of violations per street
function Get-TotalAmountOfViolationsPerStreet([object]$Table, [object]$UniqueStreetNamesTable) {
    [array]$Local:TotalAmountPerStreet = @()

    foreach ($Item in $UniqueStreetNamesTable) {
        $TotalAmount = 0

        foreach ($Row in $Table) {
            if ($Row.office_location -eq $item.StreetName) {
                $TotalAmount += $Row.violations
            }
        }

        $TotalAmountPerStreet += [pscustomobject]@{
            Id = [int]$item.Id;
            StreetName = [string]$item.StreetName;
            AmountOfViolations = [int]$TotalAmount;
        }
    }
    return $TotalAmountPerStreet
}

# Function to show data for a specific date
function Show-DataForASpecificDate {
    param (
        [object]$Table
    )
    
    [bool]$Local:Validated = $false
    do {
        BannerMessage "Get specific data from date" $PrimaryColor
        [string]$Local:SelectedDay = ReadColoredLine -text "* Select a day (dd)" -colorHex $PrimaryColor
        [string]$Local:SelectedMonth = ReadColoredLine -text "* Select a month (mm)" -colorHex $PrimaryColor
        [string]$Local:SelectedYear = ReadColoredLine -text "* Select a year (yyyy)" -colorHex $PrimaryColor

        if ($SelectedDay -ne "" -and $SelectedMonth -ne "" -and $SelectedYear -ne "") {
            $Local:Validated = $True
        }
    } until($Validated)

    [array]$Local:SelectedRows = @()
    [int]$i = 1

    foreach ($Row in $Table) {
        # Making this extra complicated to utilize string functionality.

        [string]$Local:Day = $Row.date_determination.Substring(0,2)
        [string]$Local:Month = $Row.date_determination.Substring(3,2)
        [string]$Local:Year = $Row.date_determination.Substring(6,4)

        if ($SelectedDay -eq $Day -and $SelectedMonth -eq $Month -and $SelectedYear -eq $Year) {
            $SelectedRows += [pscustomobject]@{
                Id = [int]$i;
                DateDetermination = [string]$Row.date_determination;
                OfficeLocation = [string]$Row.office_location;
                Violations = [int]$Row.violations;
                PeopleInvolved = [int]$Row.people_involved;
            }
            $i++
        }
    }

    if ($Validated -and $SelectedRows.Length -gt 0) {
        [array]$Local:ColumnNames = @("Id", "DateDetermination", "OfficeLocation", "Violations", "PeopleInvolved")
        [string]$Local:Title = "Data for " + $SelectedDay + "/" + $SelectedMonth + "/" + $SelectedYear
        PopupWindowObject $SelectedRows $Title $ColumnNames
    } else {
        ExitScript "No records were found." 1
    }
}

# Function to start the script
function Main {
    BannerMessage "Example Exam" $PrimaryColor

    [array]$Local:UniqueStreetNamesTable = Get-ListOfUniqueStreetNames $violations
    [array]$Local:TotalAmountPerStreet = Get-TotalAmountOfViolationsPerStreet $violations $UniqueStreetNamesTable

    [array]$Local:ColumnNames = @("Id", "StreetName", "AmountOfViolations")
    [string]$Local:Title = "Total amount of violations per street"
    PopupWindowObject $TotalAmountPerStreet $Title $ColumnNames

    Show-DataForASpecificDate $violations
}

Main # Start the script