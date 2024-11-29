# safeModeSwitch for Microsoft Flight Simulator 2020
# Created and released by Montel G.
# This script serves the purpose of allowing fellow Flight Simmers (that use MSFS 2020) to choose whether they want to start the sim in Safe Mode or Normal Mode.
# See the README for more info.

# Version 2.3 - 29 Nov 2024
# --- Functional enhancements. Minor UI corrections.
# Version 2.2 - 29 Nov 2024
# --- Fixed window sizing. Button alignment and radio button label clipping to be fixed in a future build of the script...
# Version 2.1 - 29 Nov 2024
# --- Returned the missing assemblies (System.Windows.Forms, System.Drawing). Prompt now appears without incident at the center of the screen, but realizing that the sizing is still incorrect. Will fix in next release.
# Version 2.0 - 29 Nov 2024
# --- Made it... work. Updated $storePath, still need to verify $steamPath but I only have the MS version! Please submit a Pull request with this value if you don't mind :)
# --- Also adjusted the form configuration so that it opens at the center of the screen and fits all of the text (increased form MinimumSize to 400x250, Size properties to buttons added to avoid more cut-off text).
# --- Blah blah blah...
# Version 1.0 - 29 Nov 2024
# --- Initial release.

# Add required assemblies
Add-Type -AssemblyName 'System.Windows.Forms'
Add-Type -AssemblyName 'System.Drawing'

# Define paths for MSFS based on the version selected
$storePath = "C:\XboxGames\Microsoft Flight Simulator\Content"  # Example path for the MS Store version
$steamPath = "C:\Program Files (x86)\Steam\steamapps\common\MicrosoftFlightSimulator"  # Example path for the Steam version

# Create the form (application window)
$form = New-Object System.Windows.Forms.Form
$form.Text = 'msfs2020-safeModeSwitch'
$form.Size = New-Object System.Drawing.Size(500, 300)  # Increased window size for better text fit
$form.MinimumSize = New-Object System.Drawing.Size(500, 300)  # Prevents the user from resizing smaller than this

# Set a fixed window size (width x height)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog  # Makes the window non-resizable
$form.MaximizeBox = $false  # Disables the maximize button
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen  # Centers the form

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
$storeRadio.Location = New-Object System.Drawing.Point(50, 110)  # Adjusted radio button position
$form.Controls.Add($storeRadio)

$steamRadio = New-Object System.Windows.Forms.RadioButton
$steamRadio.Text = 'Steam version'
$steamRadio.Location = New-Object System.Drawing.Point(50, 130)  # Adjusted radio button position
$form.Controls.Add($steamRadio)

# Create a checkbox for auto-starting MSFS
$autoStartCheckbox = New-Object System.Windows.Forms.CheckBox
$autoStartCheckbox.Text = 'Auto-start MSFS after OK'
$autoStartCheckbox.Location = New-Object System.Drawing.Point(50, 160)  # Adjusted checkbox position
$form.Controls.Add($autoStartCheckbox)

# Event handler for Safe Mode button
$safeButton.Add_Click({
    # Check if Microsoft Store or Steam is selected
    $selectedPath = If ($storeRadio.Checked) { $storePath } else { $steamPath }

    if (-not $selectedPath) {
        [System.Windows.Forms.MessageBox]::Show('Please select a valid version (Microsoft Store or Steam).')
        return
    }

    # Path to the "running.lock" file
    $runningLockPath = Join-Path $selectedPath 'running.lock'

    # Check if the path contains spaces or special characters and wrap it in quotes
    if ($runningLockPath -match " ") {
        $runningLockPath = "$runningLockPath"
    }

    # Create the "running.lock" file for Safe Mode
    New-Item -Path $runningLockPath -ItemType File -Force
    [System.Windows.Forms.MessageBox]::Show('Safe Mode is activated. "running.lock" file created.')

    # Check if Auto-start is enabled
    if ($autoStartCheckbox.Checked) {
        # Launch MSFS
        $msfsExePath = Join-Path $selectedPath 'MicrosoftFlightSimulator.exe'
        Start-Process $msfsExePath
    }

    $form.Close()
})

# Event handler for Normal Mode button
$normalButton.Add_Click({
    $selectedPath = If ($storeRadio.Checked) { $storePath } else { $steamPath }
    $runningLockPath = Join-Path $selectedPath 'running.lock'

    # Delete the "running.lock" file for Normal Mode if it exists
    if (Test-Path $runningLockPath) {
        Remove-Item -Path $runningLockPath -Force
        [System.Windows.Forms.MessageBox]::Show('"running.lock" file deleted. Normal Mode activated.')
    } else {
        [System.Windows.Forms.MessageBox]::Show('No "running.lock" file found. Normal Mode activated.')
    }

    # Check if Auto-start is enabled
    if ($autoStartCheckbox.Checked) {
        # Launch MSFS
        $msfsExePath = Join-Path $selectedPath 'MicrosoftFlightSimulator.exe'
        Start-Process $msfsExePath
    }

    $form.Close()
})

# Event handler for Cancel button
$cancelButton.Add_Click({
    $form.Close()
})

# Show the form (launch the window)
$form.ShowDialog()