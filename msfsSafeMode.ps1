# safeModeSwitch for Microsoft Flight Simulator 2020
# Created and released by Montel G.
# This script serves the purpose of allowing fellow Flight Simmers (that use MSFS 2020) to choose whether they want to start the sim in Safe Mode or Normal Mode.
# See the README for more info.


#Version 2.1 - 29 Nov 2024
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

# Create the form (application window)
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Microsoft Flight Simulator 2020'

# Set a fixed window size (width x height)
$form.Size = New-Object System.Drawing.Size(400, 250)

# Set minimum size to ensure the form cannot be resized smaller than this
$form.MinimumSize = New-Object System.Drawing.Size(400, 250)

# Create a label that asks the user the question
$label = New-Object System.Windows.Forms.Label
$label.Text = 'Do you want to open Microsoft Flight Simulator 2020 in Safe Mode or Normal Mode?'
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(50, 20)
$form.Controls.Add($label)

# Create Safe Mode button
$safeButton = New-Object System.Windows.Forms.Button
$safeButton.Text = 'Safe Mode'
$safeButton.Location = New-Object System.Drawing.Point(50, 60)
$safeButton.Size = New-Object System.Drawing.Size(100, 30)  # Ensures button is large enough to fit text
$form.Controls.Add($safeButton)

# Create Normal Mode button
$normalButton = New-Object System.Windows.Forms.Button
$normalButton.Text = 'Normal Mode'
$normalButton.Location = New-Object System.Drawing.Point(160, 60)
$normalButton.Size = New-Object System.Drawing.Size(100, 30)  # Ensures button is large enough to fit text
$form.Controls.Add($normalButton)

# Create Cancel button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = 'Cancel'
$cancelButton.Location = New-Object System.Drawing.Point(270, 60)
$cancelButton.Size = New-Object System.Drawing.Size(100, 30)  # Ensures button is large enough to fit text
$form.Controls.Add($cancelButton)

# Create radio buttons for version selection
$storeRadio = New-Object System.Windows.Forms.RadioButton
$storeRadio.Text = 'Microsoft Store version'
$storeRadio.Checked = $true
$storeRadio.Location = New-Object System.Drawing.Point(50, 100)
$form.Controls.Add($storeRadio)

$steamRadio = New-Object System.Windows.Forms.RadioButton
$steamRadio.Text = 'Steam version'
$steamRadio.Location = New-Object System.Drawing.Point(50, 120)
$form.Controls.Add($steamRadio)

# Create a checkbox for auto-starting MSFS
$autoStartCheckbox = New-Object System.Windows.Forms.CheckBox
$autoStartCheckbox.Text = 'Auto-start MSFS after OK'
$autoStartCheckbox.Location = New-Object System.Drawing.Point(50, 160)
$form.Controls.Add($autoStartCheckbox)

# Center the form on the screen
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

# Event handler for Safe Mode button
$safeButton.Add_Click({
    $selectedPath = If ($storeRadio.Checked) { $storePath } else { $steamPath }
    $runningLockPath = Join-Path $selectedPath 'running.lock'

    # Check if the path contains spaces or special characters and wrap it in quotes
    if ($runningLockPath -match " ") {
        $runningLockPath = "`"$runningLockPath`""
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