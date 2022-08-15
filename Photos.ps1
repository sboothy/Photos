Install-Module -Name ExchangeOnlineManagement -RequiredVersion 2.0.5 -Scope CurrentUser
Connect-ExchangeOnline
Import-Module SqlServer

$File = Import-CSV -Path "C:\Temp\Pics.csv" 

$File | ConvertFrom-Csv

forEach ($Pic in $File){
    #Put pic on LochNET
    Copy-Item $Pic.FilePath -Destination "\\lochnet.hwlochner.com@SSL\DavWWWRoot\Directory Images\Employees"

    #Put pic on O365
    Set-UserPhoto -identity $Pic.Email -PictureData ([System.IO.File]::ReadAllBytes($Pic.FilePath)) -confirm:$false

    #Add Employee Number to array to search for the Employee in Vision later
    $Path = $Pic.FilePath
    $EMNumber = $Path.Substring($Path.length - 9)
    $EmNumber = $EMNumber.Substring(0,$EMNumber.Length-4)

    $Pic | Add-Member -NotePropertyName "EMNumber" -NotePropertyValue $EMNumber -force
  
}

#Remove-UserPhoto -identity sbooth@hwlochner.com

#/Directory Images/Employees/
