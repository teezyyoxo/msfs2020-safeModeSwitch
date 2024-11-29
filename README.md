# msfs2020-safeModeSwitch
Simple PowerShell script to force the option of running MSFS202 in Safe Mode or Normal Mode by either adding or removing the running.lock file in the sim's active directory.

## YPMV! - Your Path May Vary
**Make sure you update the $storePath and/or $steamPath variable(s) in the script as needed!**


# Context/Backstory
Like most of us, I have a ton of things in my Community folder. 442GB, in fact.
On occasion, the sim will CTD and prompt to open in Safe Mode or Normal Mode on the next launch as a result. 
Being that my PC gets relatively good frame rates in Safe Mode (or in any of the Activities in Normal Mode, specifically), I've learned to not have any inhibitions or reservations about doing flights in Safe Mode here and there. Especially if I have very little patience for my PC's tendencies to be a bit dramatic in terms of impact from the sim on that particular day.

That said, I did some research to understand how MSFS2020's Safe Mode worked, and as it turns out, the sim will place a **running.lock** file to the game's running directory (which, for me, is **C:\XboxGames\Microsoft Flight Simulator\Content**). 
On the next launch of the sim with this .lock file in place, the user will be presented with the following dialog box:
![Problem z Microsoft Flight Simulator 2020 - Microsoft Community](https://filestore.community.support.microsoft.com/api/images/a29118b5-b472-4454-b175-b0a42233d7ac?upload=true)
**[What does booting in Safe Mode do?](https://flightsimulator.zendesk.com/hc/en-us/articles/4405893759378-Safe-Mode-FAQ)**
Safe Mode in Microsoft Flight Simulator disables temporarily: third-party content from the Marketplace and mods from the community folder.
This can allow for an optimal experience with the base sim; minimal lagging or frame drops, screen tearing, and so on.

# It really isn't that bad.
Aside from missing custom/third-party scenery, aircraft, and other random add-ons (P42 simFX, RealTurb CAT, to name a few) there really is no downside to running the sim in Safe Mode, and all fellow simmers deserve an easily-accessible option for choosing how to launch the sim.
On the bright side, anyway, the following still work (for me) in Safe Mode with no *observed* limitations, whatsoever:
 - SimConnect
	 - LittleNavMap, Navigraph Charts, etc -- with real-time aircraft position tracking
	 - FBW's flyPad and Remote MCDU server
	 - VATSIM
	 - FSLTL
		 - Though unconfirmed if the JustFlight models will work as I do not have them and use only the FSLTL models.
 - FSUIPC
 - NVIDIA Freestyle/Game Filters
 - Reshade
 - Other things, probably, but this is pretty much all of *my* "necessities" for a flight.

# HOW TO SET UP
1. Download the script (.ps1 file) and save it somewhere like your Desktop or a dedicated script/junk folder for MSFS.
2. On an empty spot on your Desktop, right-click and select New > Shortcut.
3. In "Type the location of the item:", copy and paste the path to the script you downloaded. The path should end with .ps1.
4. Give the shortcut a name. "Flight Simulator Launcher (2020)" will suffice, but this particular specification is not mission-critical.
# HOW TO USE
1. Open the shortcut.
2. Et voila! Such a beautiful, well-constructed interface worth millions of dollars. **Make any selections you like**.![enter image description here](https://github.com/teezyyoxo/msfs2020-safeModeSwitch/blob/main/uiV1-sample.png?raw=true)
3. Keep calm, and keep the blue side up. Happy flying in whatever mode you choose!

# Changelog
##  Version 2.1 - 29 Nov 2024
Returned the missing assemblies (System.Windows.Forms, System.Drawing). Prompt now appears without incident at the center of the screen, but realizing that the sizing is still incorrect. Will fix in next release.
## Version 2.0 - 29 Nov 2024
Made it... work. Updated $storePath, still need to verify $steamPath but I only have the MS version! Please submit a Pull request with this value if you don't mind :)
 Also adjusted the form configuration so that it opens at the center of the screen and fits all of the text (increased form MinimumSize to 400x250, Size properties to buttons added to avoid more cut-off text).
 Blah blah blah...
## Version 1.0 - 29 Nov 2024
Initial release.
