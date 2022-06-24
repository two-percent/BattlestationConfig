# BattlestationConfig
######Setup scripts for personal battlestation preferences. Will include some more CTF-Style tooling, as a heads up.

Current baseline configuration for internal network testing, primarily focused on Windows Active Directory (AD). Blog post in progress detailing the thought process behind what's included, as well as some operational methodology.

<p align="center">
  <img width="100" height="100" src="https://mmilkovich.files.wordpress.com/2022/06/cropped-transparent-logo-3.png">
</p>

Current Modifications:
- Configuring Oh-My-Zsh
- Configuring terminal logging for regular and root users (personal script)
- Fully patching system
- Installations:
  - Sublime Text
  - Oh-My-Zsh (https://ohmyz.sh/)
  - CrackMapExec (https://github.com/byt3bl33d3r/CrackMapExec)
  - Bloodhound (https://github.com/BloodHoundAD/BloodHound)
  - LinPeas (https://github.com/carlospolop/PEASS-ng/tree/master/linPEAS) / Linux Exploit Suggester (https://github.com/mzet-/linux-exploit-suggester)
  - CompassSecurity Bloodhound Custom Queries (https://github.com/CompassSecurity/BloodHoundQueries)
  - Baseline PowerSpolit things (https://github.com/PowerShellMafia/PowerSploit/)
  - ScareCrow (https://github.com/optiv/ScareCrow)
  - Donut (https://github.com/TheWover/donut)
    - EXCELnt Donut (https://github.com/FortyNorthSecurity/EXCELntDonut)
  - Mimikittenz (https://github.com/orlyjamie/mimikittenz)
  - Responder (https://github.com/lgandx/Responder)

Planned tooling to add (including deployable tools):
- Aquatone (https://github.com/michenriksen/aquatone) # Requires install
- Sliver C2 (https://github.com/BishopFox/sliver) # Need to download latest releases
- Certipy (https://github.com/mubix/Certipy) # Requires install
- Burp Configuration Customizations # Need to create default config
- Docker (https://www.docker.com/) # https://docs.docker.com/engine/install/ubuntu/
- Go (https://go.dev/) # https://go.dev/doc/install
- Browser configurations to stop callouts # research into Firefox and Chrome silencing

Note: Need to create function for determining if directory exists, rather than constantly rewriting. Poor coding practice, oops.

Reboot Date - 2022-06-18 : Complete overhaul. https://youtu.be/araU0fZj6oQ?t=51