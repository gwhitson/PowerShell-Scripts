This is a template for a PowerShell modules repository. This is setup in a way such that you can copy this 
directory, edit information in the psm1 and psd1 files to correctly represent your module.

When all information is current, running the "local/buildmodule.ps1" script, copies the current state of 
the public and private folders as well as the psm1 and psd1 files and finally the README to a subfolder of 'build'
representative of the current module version number in the psd1 file.