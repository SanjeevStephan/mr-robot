<#
.DOCS
    - https://datasheets.raspberrypi.com/pico/getting-started-with-pico.pdf
    - https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html#raspberry-pi-pico
    - https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html#resetting-flash-memory

.DOWNLOADS
    - https://datasheets.raspberrypi.com/soft/flash_nuke.uf2

.LINKS 
    - https://github.com/dbisu/pico-ducky
    - https://github.com/hak5/usbrubberducky-payloads

.PYLOADS
    - https://github.com/hak5/usbrubberducky-payloads/blob/master/payloads/library/prank/Hacker_Typer/payload.txt

.YOUTUBE
    - bad USBs are SCARY!! 
        (build one with a Raspberry Pi Pico for $8) ( https://www.youtube.com/watch?v=e_f9p-_JWZw ) 

    - Bad USB Using Raspberry Pi Pico! 
        ( https://www.youtube.com/watch?v=xzbBJbIhzj8 )
#>


   param(
       [Parameter(Mandatory=$true)]
       [string]$Action
   )

   #$debug = "Received, $Action! Welcome to PowerShell!"
   $what_to_return = "GoodBye! Pico"


figlet "Raspberry Pico"

#$script_location            = Get-Location
$script_name                 = "setup_pico_ducky.ps1"
$pico_payload                = "pico_payload.ps1"

$script_location             = "D:\mr_robot\pico_ducky"
$script_fpath                = "$script_location\$script_name"
$pico_payload_fpath          = "$script_location\$pico_payload"


$pico_drive                   = "F:\"
$pico_lib                     = "F:\lib"
$uf2_directory                = "flash_files"
$uf2_circuit_py               = "adafruit-circuitpython-raspberry_pi_pico-en_US-8.0.4.uf2"
$uf2_reset_pico               = "flash_nuke.uf2"
$uf2_default_info             = "INFO_UF2.TXT"
$uf2_circuit_py_at_pico       = $pico_drive + "code.py"
$adafruit_hid_lib             = "lib\" + "adafruit_hid"
$circuitpython_bundle_dirname = "adafruit-circuitpython-bundle-8.x-mpy-20230319"
$circuitpython_dir_path       = "$script_location\$circuitpython_bundle_dirname"

$setup_help_fname             = "help.md"

$local_adafruit_hid           = "$circuitpython_dir_path\$adafruit_hid_lib"
$local_asyncio_lib            = "$circuitpython_dir_path\lib\asyncio"
$local_adafruit_wsgi_lib      = "$circuitpython_dir_path\lib\adafruit_wsgi"
$local_adafruit_debouncer_mpy = "$circuitpython_dir_path\lib\adafruit_debouncer.mpy"
$local_adafruit_ticks_mpy     = "$circuitpython_dir_path\lib\adafruit_ticks.mpy"


$pico_ducky_location          = "$script_location\dbisu-pico-ducky-github-repository"
$pico_ducky_boot              = "boot.py"
$pico_duckyinpython           = "duckyinpython.py"
$pico_ducky_code              = "code.py"
$pico_ducky_webapp            = "webapp.py"    
$pico_duck_wsgiserver         = "wsgiserver.py" 


$script_info = @{
    "script_name" = "setup_pico_ducky.ps1"
    "script_type" = "powershell script"
    "executable_type"="command line argument"
    "script_help"   = "setup_help.txt"
}

$setup_var = @{

"pico_drive"                   = "$pico_drive"
"pico_lib"                     = "$pico_lib"
"uf2_circuit_py"               = "$uf2_circuit_py"
"uf2_reset_pico"               = "$uf2_reset_pico"
"uf2_default_info"             = "$uf2_default_info"

"setup_help_file"              = "$setup_help_fname"

"uf2_circuit_py_fpath"          = "$script_location\$uf2_directory\$uf2_circuit_py"
"uf2_reset_pico_fpath"          = "$script_location\$uf2_directory\$uf2_reset_pico"

"adafruit_hid_lib"             = "$adafruit_hid_lib"
"circuitpython_bundle_dirname" = "$circuitpython_bundle_dirname"
"circuitpython_dir_path"       = "$circuitpython_dir_path"
"local_adafruit_hid"           = "$local_adafruit_hid"
"local_asyncio_lib"            = "$local_asyncio_lib"
"local_adafruit_wsgi_lib"      = "$local_adafruit_wsgi_lib"
"local_adafruit_debouncer_mpy" = "$local_adafruit_debouncer_mpy"
"local_adafruit_ticks_mpy"     = "$local_adafruit_ticks_mpy"

"pico_ducky_boot"              = "$pico_ducky_location\$pico_ducky_boot"
"pico_duckyinpython"           = "$pico_ducky_location\$pico_duckyinpython "
"pico_ducky_code"              = "$pico_ducky_location\$pico_ducky_code"
"pico_ducky_webapp"            = "$pico_ducky_location\$pico_ducky_webapp"    
"pico_duck_wsgiserver"         = "$pico_ducky_location\$pico_duck_wsgiserver" 
}


function script_info() {

$script_info.GetEnumerator() | Sort-Object | Format-Table @{label="Script Info"; expression={$_.Key}}, @{label="Description"; expression={$_.Value}} -AutoSize
$setup_var.GetEnumerator() | Sort-Object | Format-Table @{label="Script Paths"; expression={$_.Key}}, @{label="Description"; expression={$_.Value}} -AutoSize

}
function setup_help() {
$help_file_path = "$script_location\$setup_help_fname"
cat $help_file_path  
}

function copy_necessary_library() {

        copy $local_adafruit_hid $pico_lib -Force -Recurse # Start Copying files to F:\lib
        copy $local_asyncio_lib $pico_lib -Force -Recurse # Start Copying files to F:\lib
        copy $local_adafruit_wsgi_lib $pico_lib -Force -Recurse # Start Copying files to F:\lib
        copy $local_adafruit_debouncer_mpy $pico_lib -Force
        copy $local_adafruit_ticks_mpy $pico_lib -Force

        Write-Output "[Copied] $local_adafruit_hid to $pico_drive Successfully"
        Write-Output "[Copied] $local_asyncio_lib to $pico_drive Successfully"
        Write-Output "[Copied] $local_adafruit_wsgi_lib to $pico_drive Successfully"
        Write-Output "[Copied] $local_adafruit_debouncer_mpy to $pico_drive Successfully"
        Write-Output "[Copied] $local_adafruit_ticks_mpy to $pico_drive Successfully"
}
function copy_additonal_files() {
        copy $setup_var["pico_ducky_boot"] $setup_var["pico_drive"] -Force
        copy $setup_var["pico_ducky_code"] $setup_var["pico_drive"] -Force
        copy $setup_var["pico_ducky_webapp"] $setup_var["pico_drive"] -Force
        copy $setup_var["pico_duck_wsgiserver"] $setup_var["pico_drive"] -Force
        copy $setup_var["pico_duckyinpython"] $setup_var["pico_drive"] -Force

        Write-Output "[Copied] $pico_ducky_boot to $pico_drive Successfully"
        Write-Output "[Copied] $pico_duckyinpython to $pico_drive Successfully"
        Write-Output "[Copied] $pico_ducky_code to $pico_drive Successfully"
        Write-Output "[Copied] $pico_ducky_webapp to $pico_drive Successfully"
        Write-Output "[Copied] $pico_duck_wsgiserver to $pico_drive Successfully"

}
function copy_adafruit_circuitpython_raspberry_pi_pico_uf2() { copy $setup_var["uf2_circuit_py_fpath"] $setup_var["pico_drive"] }
function copy_flash_nuke_uf2() { copy $setup_var["uf2_reset_pico_fpath"] $setup_var["pico_drive"] }

function did_u_want_to_copy_necessary_files() {
    Write-Output "[Input] Did you want to copy necessary files to CIRCUIT_PYTHON (y/n) : "
          
    $choice = read_pico("Press 'y' or 'n'")
    if($choice -eq "y") {}
    else { Write-Output "Until NeXt time! ./~superuser"}

}

function convert_to_circuit_py() {
# Copy [uf2] to the pico at F:/
figlet "Convert to Circuit-Py"

    if(Test-Path $pico_drive)  # if F:\ available -> proceed
    {

        copy_adafruit_circuitpython_raspberry_pi_pico_uf2 # copy adafruit-circuitpython-raspberry_pi_pico-en_US-8.0.4.uf2 to [F:\] pico root dir
        Write-Output "[Copied] $uf2_circuit_py Successfully Copied to Pico $pico_drive"
        Write-Output "[Converting] Pico to Circuit-Python..please wait.. "
        Start-Sleep 15
        Write-Output "Awaken from Sleep"

        # checks if 'code.py' is available at F:\ exists -> proceed
        if (Test-Path $uf2_circuit_py_at_pico) 
        { 
            Write-Output "----------------------------"
            cat $uf2_circuit_py_at_pico # Reading the 'code.py' located at path [F:\code.py]
            Write-Output "----------------------------"
            Write-Output "[Converted] Pico has been Successfully Converted to Circuit-Python"

            did_u_want_to_copy_necessary_files # ask the superuser if he want to copy the necessary files to pico


        }
        else { Write-Output "Unable to copy file to pico"} 
    } else { Write-Output "[Not-Found] Pico Drive $pico_drive unavailable"}

}
function verify_n_copy_lib() {
figlet "Setup Pico"
#figlet "Copying Pico HID"

Write-Output "Executed from Location : $script_location"

$choice = read_pico("Copy Necessary files to CIRCUIT_PYTHON (y/n) :")
Write-Output "YOu have selected $choice ! Very Well"


if (Test-Path $pico_lib)  # checks for F:\lib | if exists -> proceed
    { 
       Write-Output "[Copying] Adafruit HID Files to $pico_lib"

       if(Test-Path $local_adafruit_hid) # checks for local lib\adafruit_hid directory | if exists -> proceed
       {
        Write-Output "[OK] circuitpython Location : $circuitpython_dir_path"
        Write-Output "[OK] local_adafruit_hid Location : $local_adafruit_hid"
         
         copy_necessary_library #copy all the necessary library to the F:\lib (pico-drive)
         copy_additonal_files   #copy all the additional files from 'pico-ducky' to F:\ (pico-drive) 

            if(Test-Path "$pico_drive\$adafruit_hid_lib") # checks for pico F:\lib\adafruit_hid directory | if exists -> proceed
            {    
                # if lib\adafruit_hid\keyboard.mpy that means the files have successfullly been copied
                Write-Output "[OK] $pico_drive$adafruit_hid_lib already exists"
                if(Test-Path "$pico_drive\$adafruit_hid_lib\keyboard.mpy") {Write-Output "[Copied] $adafruit_hid_lib Files Successfully Copied to $pico_drive" }
                else { Write-Output "[Failed] $adafruit_hid_lib Files Failed to Copy "}

            } else { Write-Output "[Missing] $adafruit_hid_lib doesn't exits"} # F:\lib\adafruit_hid directory doesn't exists
            

       } else { Write-Output "[Missing] $circuitpython_dir_path doesn't exists"} # D:\OTG\pico_rubber_ducky\adafruit-circuitpython-bundle-8.x-mpy-20230319 directory doesn't exists
   
    }
else { Write-Output "[Missing] No 'lib' directory found at $pico_drive"} # F:\lib doesn't exists



}

function rest_pico() {
figlet "Reset Pico"
$flash_nuke_uf2_path = $setup_var["pico_drive"] + $setup_var["uf2_default_info"]
Write-Output "Steps to Reset Pico"
Write-Output "1.hold down the BOOTSEL button when you plug in your Pico"
Write-Output "at first it will appear as a drive onto which you can drag or simply press 'y' to copy a new UF2 file [$uf2_reset_pico]"

$choice = Read-Host "[INPUT] Did you see an empty drive with name 'RPI-RP2' (y/n) : "

    if($choice -eq 'y') {

        copy_flash_nuke_uf2 # copy flash_nuke.uf2 files to the pico root directory [F:/]

        Write-Output "[Reset] Please Wait...while the pico is resetting.."
        Start-Sleep 15
        Write-Output "Awaken from Sleep"

        if (Test-Path $flash_nuke_uf2_path) 
        { 
            Write-Output "----------------------------"
            cat $flash_nuke_uf2_path # Reading the 'INFO_UF2.TXT' located at path [F:\INFO_UF2.TXT]
            Write-Output "----------------------------"
            Write-Output "Pico has been Successfully Reset"
        }
        else { Write-Output "Unable to reset pico"}
    } else { Write-Output "Please Try Again..and re-run the setup" }

}
function edit_pico() {
figlet "Edit Pico"
powershell_ise.exe $script_fpath
}


function debug($msg){ Write-Output "[DEBUG] $msg"}
function read_pico($msg) { return Read-Host "pico@raspberrypi~/ : $msg" }

function Start_Pico($action) {
    
    # script_info # show script info

    clear # Clear the screen to make the terminal look nice 

    switch($action) {
        "convert" { convert_to_circuit_py }
        "copy"    { verify_n_copy_lib }
        "reset"   { rest_pico }
        "info"    { script_info }
        "help"    { setup_help  }
        "edit"    { edit_pico }
        "payload" { Write-Output "try -> .\pico_payload.ps1" }
        Default { 
                script_info # show script info
                setup_help  # shoe script help
                Write-Output "Invalid Argument Received"
                }
    }

}

#Write-Output $debug

Start_Pico($Action)
#copy_uf2 # copy the uf2 file to pico
return $what_to_return