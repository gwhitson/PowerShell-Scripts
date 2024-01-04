$publ = "$($PSScriptRoot)\..\public"
$priv = "$($PSScriptRoot)\..\private"
$moduleInfoDir = "$($PSScriptRoot)\.."
$buildDir = "$($PSScriptRoot)\..\build"
$buildVer = (Import-PowerShellDataFile -Path "$($PSScriptRoot)\..\*.psd1").ModuleVersion

new-item -ItemType Directory -Path "$($buildDir)\$($buildVer)"

Copy-Item -Path $publ -Destination "$($buildDir)\$($buildVer)\public" -Recurse
Copy-Item -Path $priv -Destination "$($buildDir)\$($buildVer)\private" -Recurse
Copy-Item -Path "$($moduleInfoDir)\*.psm1" -Destination "$($buildDir)\$($buildVer)"
Copy-Item -Path "$($moduleInfoDir)\*.psd1" -Destination "$($buildDir)\$($buildVer)"
Copy-Item -Path "$($moduleInfoDir)\README.md" -Destination "$($buildDir)\$($buildVer)"