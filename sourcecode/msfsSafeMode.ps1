# safeModeSwitch for Microsoft Flight Simulator 2020
# Created and released by @teezythakidd
# This script serves the purpose of allowing fellow Flight Simmers (that use MSFS 2020) to choose whether they want to start the sim in Safe Mode or Normal Mode.
# See the README for more info.

# Version 2.6.1
# --- Removed duplicate array
# --- Cleaned up response/feedback logic
# Version 2.6
# --- Resolved an issue when launching the script via Desktop shortcut by adding various instances of *[System.Windows.Forms.MessageBox]*.
# --- Code updated (slightly) for executable beta ;) TIL about ps2exe! 
# Version 2.5
# --- Improved logic and error handling a LOT. Script now prints debugging info to terminal (when run in PS, PS ISE, or VS Code).
# --- Now using gamelaunchhelper.exe for the launch instead of FlightSimulator.exe
# --- Resolved issue where the sim would launch when the auto-start chechbox was not checked.
# Version 2.4.2
# --- Added logic for a custom icon for the form that is currently disabled, but "ready". Mostly.
# Version 2.4.1
# --- Minor UI tweaks/improvements.
# Version 2.4
# --- Introduction of v2 of the UI - much nicer to look at, although extremely basic.
# --- Window size, button placement and text alignment(s) adjusted.
# Version 2.3
# --- Functional enhancements. Minor UI corrections.
# Version 2.2
# --- Fixed window sizing. Button alignment and radio button label clipping to be fixed in a future build of the script...
# Version 2.1
# --- Returned the missing assemblies (System.Windows.Forms, System.Drawing). Prompt now appears without incident at the center of the screen, but realizing that the sizing is still incorrect. Will fix in next release.
# Version 2.0
# --- Made it... work. Updated $storePath, still need to verify $steamPath but I only have the MS version! Please submit a Pull request with this value if you don't mind :)
# --- Also adjusted the form configuration so that it opens at the center of the screen and fits all of the text (increased form MinimumSize to 400x250, Size properties to buttons added to avoid more cut-off text).
# --- Blah blah blah...
# Version 1.0
# --- Initial release.

# Add required assemblies
Add-Type -AssemblyName 'System.Windows.Forms'
Add-Type -AssemblyName 'System.Drawing'

# Define paths for MSFS based on the version selected
$storePath = "C:\XboxGames\Microsoft Flight Simulator\Content\"  # Example path for the MS Store version
$steamPath = "C:\Program Files (x86)\Steam\steamapps\common\MicrosoftFlightSimulator\"  # Example path for the Steam version
$gameLaunchHelperExe = "gamelaunchhelper.exe"  # The correct executable for launching MSFS

# Create the form (application window)
$form = New-Object System.Windows.Forms.Form
$form.Text = 'msfs2020-safeModeSwitch'
$form.Size = New-Object System.Drawing.Size(500, 250)  # Increased window size for better text fit

# Set a fixed window size (width x height)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog  # Makes the window non-resizable
$form.MaximizeBox = $false  # Disables the maximize button
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen  # Centers the form

# Icon for form - DISABLED FOR NOW.
# Set the form's icon (replace 'icon.ico' with the path to your own .ico file)
# $iconPath = "C:\............."  # Provide the full path to the icon file
# $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath)

# Create a label that asks the user the question
$label = New-Object System.Windows.Forms.Label
$label.AutoSize = $true  # Ensures the label resizes to fit the text
$label.Text = 'Do you want to open Microsoft Flight Simulator 2020 in Safe Mode or Normal Mode?'
$label.Location = New-Object System.Drawing.Point(35, 20)  # Adjusted label position for new form size
$form.Controls.Add($label)

# Center the buttons
$buttonWidth = 100
$buttonSpacing = 10
$totalButtonWidth = 3 * $buttonWidth + 2 * $buttonSpacing  # Total width of all buttons

# Create Safe Mode button
$safeButton = New-Object System.Windows.Forms.Button
$safeButton.Text = 'Safe Mode'
$safeButton.Location = New-Object System.Drawing.Point(90, 50)  # Adjusted button position
$safeButton.Size = New-Object System.Drawing.Size(100, 30)  # Adjusted button size for better fit
$form.Controls.Add($safeButton)

# Create Normal Mode button
$normalButton = New-Object System.Windows.Forms.Button
$normalButton.Text = 'Normal Mode'
$normalButton.Location = New-Object System.Drawing.Point(200, 50)  # Adjusted button position
$normalButton.Size = New-Object System.Drawing.Size(100, 30)  # Adjusted button size for better fit
$form.Controls.Add($normalButton)

# Create Cancel button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = 'Cancel'
$cancelButton.Location = New-Object System.Drawing.Point(310, 50)  # Adjusted button position
$cancelButton.Size = New-Object System.Drawing.Size(100, 30)  # Adjusted button size for better fit
$form.Controls.Add($cancelButton)

# Create radio buttons for version selection
$storeRadio = New-Object System.Windows.Forms.RadioButton
$storeRadio.Text = 'Microsoft Store version'
$storeRadio.Checked = $true
$storeRadio.Location = New-Object System.Drawing.Point(50, 95)  # Adjusted radio button position
$storeRadio.Size = New-Object System.Drawing.Size(150,30) # FINALLY ADJUSTED RADIO BUTTON **LABEL** POSITION
$form.Controls.Add($storeRadio)
# ---
$steamRadio = New-Object System.Windows.Forms.RadioButton
$steamRadio.Text = 'Steam version'
$steamRadio.Location = New-Object System.Drawing.Point(50, 120)  # Adjusted radio button position
$steamRadio.Size = New-Object System.Drawing.Size(150,30) # FINALLY ADJUSTED RADIO BUTTON **LABEL** POSITION
$form.Controls.Add($steamRadio)

# Create a checkbox for auto-starting MSFS
$autoStartCheckbox = New-Object System.Windows.Forms.CheckBox
$autoStartCheckbox.Text = 'Check the box to auto-start MSFS 2020 after making your selection.'
$autoStartCheckbox.Location = New-Object System.Drawing.Point(50, 155)  # Adjusted checkbox position
$autoStartCheckbox.Size = New-Object System.Drawing.Size(600, 30)  # Width is adjusted to fit the text
$form.Controls.Add($autoStartCheckbox)

# Event handler for Safe Mode button
$safeButton.Add_Click({
    $selectedPath = If ($storeRadio.Checked) { $storePath } else { $steamPath }
    $msfsExePath = Join-Path $selectedPath $gameLaunchHelperExe

    if (Test-Path $msfsExePath) {
        # Create the "running.lock" file for Safe Mode
        $runningLockPath = Join-Path $selectedPath 'running.lock'
        New-Item -Path $runningLockPath -ItemType File -Force | Out-Null
        [System.Windows.Forms.MessageBox]::Show('Safe Mode is activated. "running.lock" file created.', "Confirmation", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

        if ($autoStartCheckbox.Checked) {
            Start-Process $msfsExePath
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Error: The MSFS executable was not found at the specified path.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }

    $form.Close()
})

# Event handler for Normal Mode button
$normalButton.Add_Click({
    $selectedPath = If ($storeRadio.Checked) { $storePath } else { $steamPath }
    $msfsExePath = Join-Path $selectedPath $gameLaunchHelperExe

    if (Test-Path $msfsExePath) {
        # Delete the "running.lock" file for Normal Mode
        $runningLockPath = Join-Path $selectedPath 'running.lock'
        if (Test-Path $runningLockPath) {
            Remove-Item -Path $runningLockPath -Force
            [System.Windows.Forms.MessageBox]::Show('"running.lock" file deleted. Normal Mode activated.', "Confirmation", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } else {
            [System.Windows.Forms.MessageBox]::Show('No "running.lock" file found. Normal Mode activated.', "Confirmation", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }

        if ($autoStartCheckbox.Checked) {
            Start-Process $msfsExePath
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Error: The MSFS executable was not found at the specified path.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }

    $form.Close()
})

# Event handler for Cancel button
$cancelButton.Add_Click({
    $form.Close()
})

# Show the form (launch the window)
$form.ShowDialog()