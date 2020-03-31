#Script for refresh remote apps on client computer from terminal server
Write-Host "STARTING REFRESH"
Start-Process --verbose rundll32 -ArgumentList "tsworkspace,TaskUpdateWorkspaces2"
Start-Process --verbose rundll32 -ArgumentList "tsworkspace,WorkspaceStatusNotify2"
Write-Host "FINISH WAIT 5 minutes"
Pause