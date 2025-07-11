# Load PnP PowerShell module
Import-Module PnP.PowerShell

# Connect to SharePoint Online
Connect-PnPOnline -Url "https://bcstechinternational.sharepoint.com/sites/Versioning" -UseWebLogin

# Get all document libraries in the site
$Libraries = Get-PnPList | Where-Object { $_.BaseType -eq "DocumentLibrary" -and $_.Hidden -eq $false }

foreach ($Library in $Libraries) {
    Write-Host "Processing Library: $($Library.Title)"

    # Get all files in the library
    $Files = Get-PnPListItem -List $Library.Title -Fields FileRef, FileLeafRef

    foreach ($File in $Files) {
        $FileUrl = $File["FileRef"]

        # Get the file as a list item
        $FileItem = Get-PnPFile -Url $FileUrl -AsListItem -ErrorAction SilentlyContinue

        # Skip if the file item is null
        if ($null -eq $FileItem) {
            Write-Host "Skipping: $FileUrl (Not a valid file or missing versions)" -ForegroundColor Yellow
            continue
        }

        # Get file versions
        $Versions = Get-PnPProperty -ClientObject $FileItem -Property Versions -ErrorAction SilentlyContinue

        # Skip if there are no versions
        if ($null -eq $Versions -or $Versions.Count -eq 0) {
            Write-Host "Skipping: $FileUrl (No versions to trim)" -ForegroundColor Yellow
            continue
        }

        # Trim versions if there are more than 30
        if ($Versions.Count -gt 30) {
            $ExcessVersions = $Versions.Count - 30
            Write-Host "Trimming $ExcessVersions versions from $FileUrl" -ForegroundColor Green

            for ($i = $Versions.Count - 1; $i -ge 30; $i--) {
                $Versions[$i].DeleteObject()
            }
            Invoke-PnPQuery
        }
    }
}

Write-Host "Version trimming completed for all document libraries in the site." -ForegroundColor Cyan
