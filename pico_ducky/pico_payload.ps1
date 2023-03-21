<# 
 ____  _             ____             _                 _ 
|  _ \(_) ___ ___   |  _ \ __ _ _   _| | ___   __ _  __| |
| |_) | |/ __/ _ \  | |_) / _` | | | | |/ _ \ / _` |/ _` |
|  __/| | (_| (_) | |  __/ (_| | |_| | | (_) | (_| | (_| |
|_|   |_|\___\___/  |_|   \__,_|\__, |_|\___/ \__,_|\__,_|
                                |___/                     

.DESCRIPTION
    This PowerShell script that waits for the F drive to become available,
    and then sends or deletes the file named 'payload.dd' as soon as it becomes available, 
    and displays a confirmation message:
#>
    param(
        [Parameter(Mandatory=$true)]
        [string]$action,
        [string]$filename
    
    ) 


$current_location = Get-Location
$pico_drive = "F:\"
$payload_fname = "payload.dd"
$payload_fPath = $pico_drive + $payload_fname
$payload_script = "D:\mr_robot\pico_ducky\pico_payload.ps1"

function copy_payload_to_drive() { copy $payload_to_send $payload_to_be_replaced -Force  }

function send_payload() {
# Send payload to pico-circuit python

figlet "Sending Payload"

$payload_to_be_replaced = $payload_fPath

$payload_to_send = $filename.Replace(".\","")
$file_fpath   = "$current_location\$payload_to_send"

Write-Output "[PAYLOAD] Name : $payload_to_send"
Write-Output "[PAYLOAD] Location : $file_fpath"
Write-Output "[REPLACE] $payload_to_be_replaced"

copy_payload_to_drive # copy payload to the pico_drive [F:/]

    if(Test-Path $payload_to_be_replaced) 
    {         
          Write-Output "Payload.dd already exists! Replacing $payload_to_be_replaced"          
          Write-Host "Successfully Replaced the existing Payload : $payload_to_send to F:\"
    }else { 
            Write-Output "[Missing] Payload Location $payload_to_be_replaced doesnot exists" 
            Write-Output "Unable to copy payload to Location $payload_to_be_replaced" 
          }

}
function delete_payload() {

# Delete F:\payload.dd file

if (Test-Path -Path $filePath) 
    {
       Remove-Item $filePath
       Write-Host "$payload_fPath file deleted from F drive."
       dir $pico_drive
     } else { Write-Host "payload.dd file not found in F drive." }


}
function wait_for_drive_to_become_available() {
   # Wait for F drive to become available
   do {
          Write-Host "Waiting for F drive to become available..."
          Start-Sleep -Seconds 2
      } until (Get-PSDrive F -ErrorAction SilentlyContinue)
}
function edit_payload() { powershell_ise.exe $payload_script }
function start_payload() {

    # Wait for F drive to become available
    # wait_for_drive_to_become_available

    # execute below switches when F drive to becomes available

    

    switch($action) 
    {
        "send"   { send_payload  }
        "delete" { delete_payload } 
        "list"   { Write-Output "No Code Written to list payloads" }
        "edit"   { edit_payload }
        Default  { Write-Output "Invalid Argument Received" }
    }

}

start_payload # Start Payload Operations 