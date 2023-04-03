<#
.SYNOPSIS
    This script generates a list of audit actions on a share with the username who made an event and a summary of event types by username.

.DESCRIPTION
    This script takes the share path as an external parameter and generates a list of audit actions on that share with the username who made an event. It also generates a summary of event types by username.

.PARAMETER sharePath
    The path to the share to audit.

.EXAMPLE
    .\smb_share_audit_log.ps1 -sharePath "C:\\Path\\To\\Share"

    This example runs the script with the share path "C:\\Path\\To\\Share".

.NOTES
    To enter the external parameter, you can use the TAB key to auto-complete the parameter name.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$sharePath
)

# Define the event IDs to filter
$eventIDs = 4663, 5140

# Get the security event log
$securityLog = Get-EventLog -LogName Security

# Filter the events by event ID and share path
$filteredEvents = $securityLog | Where-Object { $eventIDs -contains $_.EventID -and $_.Message -like "*$sharePath*" }

# Create an empty hashtable to store the summary of event types by username
$eventSummary = @{}

# Create an empty array to store the list of events
$eventList = @()

# Loop through each event and add it to the list of events
foreach ($event in $filteredEvents) {
    $username = $event.ReplacementStrings[1]
    $eventID = $event.EventID
    $content = $event.Message
    $dateTime = $event.TimeGenerated

    # Get the object name from the content
    if ($content -match "Object Name:\s+(.+?)\s") {
        $objectName = $Matches[1]
    } else {
        $objectName = "N/A"
    }

    # Get a short version of the content
    $shortContent = $content.Substring(0, [Math]::Min($content.Length, 100)) + "..."

    # Add the event to the list of events
    $eventList += [PSCustomObject]@{
        "Date and Time" = $dateTime;
        "Username" = $username;
        "Event ID" = $eventID;
        "Short Content" = $shortContent;
        "Object Name" = $objectName;
    }

    # Update the event summary hashtable
    if ($eventSummary.ContainsKey($username)) {
        if ($eventSummary[$username].ContainsKey($eventID)) {
            $eventSummary[$username][$eventID]["Count"] += 1
            if (-not ($eventSummary[$username][$eventID]["Content"] -contains $content)) {
                $eventSummary[$username][$eventID]["Content"] += $content
            }
        } else {
            $eventSummary[$username][$eventID] = @{
                "Count" = 1;
                "Content" = @($content)
            }
        }
    } else {
        $eventSummary[$username] = @{}
        $eventSummary[$username][$eventID] = @{
            "Count" = 1;
            "Content" = @($content)
        }
    }
}

# Output the list of events as a table
Write-Output "`nList of events:"
$eventList | Format-Table

# Output the summary of event types by username
Write-Output "`nSummary of event types by username:"
foreach ($entry in $eventSummary.GetEnumerator()) {
    Write-Output "`nUsername: $($entry.Key)"
    foreach ($eventEntry in $entry.Value.GetEnumerator()) {
        # Get a short description for each event type
        switch ($eventEntry.Key) {
            4663 { $eventTypeDescription = "Access object" }
            5140 { $eventTypeDescription = "Access share" }
            default { $eventTypeDescription = "Other" }
        }

        Write-Output "Event Type: $($eventTypeDescription) | Count: $($eventEntry.Value["Count"])"
    }
}