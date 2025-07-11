# version-trimming
This repo is about trimmimng the versions of sharepoint site files.

# SharePoint Online File Version Trimming Script

This PowerShell script connects to a SharePoint Online site, checks all document libraries, and trims file version history by keeping only the most recent 30 versions per file. It helps reduce storage usage and maintain a clean versioning structure.

## ✅ Features

- Connects securely to SharePoint Online using PnP PowerShell
- Loops through all **visible** document libraries in the site
- For each file, checks the number of versions
- Deletes older versions beyond the latest 30
- Skips files with no versions or missing versioning info
- Outputs progress to the console

---

## ⚙️ Prerequisites

- Install the [PnP PowerShell](https://pnp.github.io/powershell/) module:
  
  ```powershell
  Install-Module PnP.PowerShell -Scope CurrentUser
## You must have appropriate permissions to:

- Read from and modify document libraries
- Delete file versions

### Also, Versioning must be enabled on SharePoint libraries.

## 🔐 Authentication
The script uses:

### "Connect-PnPOnline -Url "<SiteURL>" -UseWebLogin"

You will be prompted to sign in via the browser.
This uses your current credentials (MFA supported).

## 📄 Script Behavior
- Loads the PnP PowerShell module.

- Connects to a specified SharePoint Online site.

- Fetches all document libraries that are not hidden.

- For each document library:
  Retrieves all files.
  
  For each file:
  - Checks if it has a valid version history.

  - Skips files without versions.

  - Keeps only the latest 30 versions.

  - Deletes older versions in descending order (oldest first).

- Applies the deletions using Invoke-PnPQuery.

## ⚠️ Notes
This script deletes older versions permanently. Deleted versions cannot be recovered unless retention policies or backups exist.

You can adjust the version limit (30) by changing the line:

### "if ($Versions.Count -gt 30)"
### The script uses:

- Get-PnPList to list document libraries

- Get-PnPListItem to fetch files

- Get-PnPFile -AsListItem to access version data

- Get-PnPProperty to expand the Versions property
