<#
.SYNOPSIS
ConfigureAudioCodesDHCPOption.ps1

.DESCRIPTION 
PowerShell script to configure AudioCodes DHCP Options on Windows Server 2008 or higher version.

.PARAMETER Server
The name(s) of the server(s) you are configuring.

.PARAMETER ProvisioningFQDN
The internal namespace you are using.

.EXAMPLE
.\ConfigureAudioCodesDHCPOption.ps1 -Server DHCPSRV1,DHCPSRV2 -ProvisioningFQDN ucprovisioning.mydomain.com

.NOTES
Written by: Luca Vitali

Find me on:
* My Blog:	https://lucavitali.wordpress.com/
* Twitter:	https://twitter.com/Luca_Vitali
* LinkedIn:	https://www.linkedin.com/in/lucavitali/

License: The MIT License (MIT)

Copyright (c) 2017 Luca Vitali

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Change Log:
V1.02, 23/04/2017 - Added support for Windows Server 2008 or higher
V1.01, 15/03/2017 - Bugfix
V1.00, 24/01/2017 - Initial version
#>

#requires -version 2

[CmdletBinding()]
param(
	[Parameter(Position=0,Mandatory=$true)]
	[string[]]$Server,

	[Parameter(Mandatory=$true)]
	[string]$ProvisioningFQDN

	)

	
#...................................
# Script
#...................................


Process 
{ 
    foreach ($i in $server)
    {
		Write-Host "Configuring AudioCodes User Class on Server $i"
		Add-DhcpServerv4Class -ComputerName $i -Name 420HD -Description "AudioCodes 420HD IP Phone" -Data "420HD" -Type User
		Add-DhcpServerv4Class -ComputerName $i -Name 430HD -Description "AudioCodes 430HD IP Phone" -Data "430HD" -Type User
		Add-DhcpServerv4Class -ComputerName $i -Name 440HD -Description "AudioCodes 440HD IP Phone" -Data "440HD" -Type User
        Add-DhcpServerv4Class -ComputerName $i -Name 445HD -Description "AudioCodes 445HD IP Phone" -Data "445HD" -Type User
		Add-DhcpServerv4Class -ComputerName $i -Name 450HD -Description "AudioCodes 450HD IP Phone" -Data "450HD" -Type User
		
		Write-Host "Configuring DHCP Provisioning Server 160 Option on Server $i"
		Add-DhcpServerv4OptionDefinition -ComputerName $i -Name "Provisioning Server" -OptionId 160 -Type "String" -Description "Provisioning Server"
    }

    foreach ($i in $server)
    {
        $ver = Get-DhcpServerVersion -ComputerName $i
        if (($ver.MajorVersion -eq 6 -and $ver.MinorVersion -eq 1) -or ($ver.MajorVersion -eq 5 -and $ver.MinorVersion -eq 7))
        {
            Write-Host "Configuring DHCP Option on Server $i"
            Set-DhcpServerv4OptionValue -ComputerName $i -OptionId 160 -UserClass "420HD"  -Value "http://$ProvisioningFQDN/420HD/420HD.img;420HD.cfg"
		    Set-DhcpServerv4OptionValue -ComputerName $i -OptionId 160 -UserClass "430HD"  -Value "http://$ProvisioningFQDN/430HD/430HD.img;430HD.cfg"
		    Set-DhcpServerv4OptionValue -ComputerName $i -OptionId 160 -UserClass "440HD"  -Value "http://$ProvisioningFQDN/440HD/440HD.img;440HD.cfg"
            Set-DhcpServerv4OptionValue -ComputerName $i -OptionId 160 -UserClass "445HD"  -Value "http://$ProvisioningFQDN/445HD/445HD.img;445HD.cfg"
		    Set-DhcpServerv4OptionValue -ComputerName $i -OptionId 160 -UserClass "450HD"  -Value "http://$ProvisioningFQDN/450HD/450HD.img;450HD.cfg"
        }
        
        Else
        {
		    Write-Host "Configuring DHCP Policy on Server $i"
		    Add-DhcpServerv4Policy -ComputerName $i -Name "420HD" -Condition OR -UserClass EQ,"420HD" -Description "AudioCodes 420HD IP Phone"
		    Add-DhcpServerv4Policy -ComputerName $i -Name "430HD" -Condition OR -UserClass EQ,"430HD" -Description "AudioCodes 430HD IP Phone"
		    Add-DhcpServerv4Policy -ComputerName $i -Name "440HD" -Condition OR -UserClass EQ,"440HD" -Description "AudioCodes 440HD IP Phone"
            Add-DhcpServerv4Policy -ComputerName $i -Name "445HD" -Condition OR -UserClass EQ,"445HD" -Description "AudioCodes 445HD IP Phone"
		    Add-DhcpServerv4Policy -ComputerName $i -Name "450HD" -Condition OR -UserClass EQ,"450HD" -Description "AudioCodes 450HD IP Phone"
		    Set-DhcpServerv4OptionValue -ComputerName $i -OptionId 160 -PolicyName "420HD"  -Value "http://$ProvisioningFQDN/420HD/420HD.img;420HD.cfg"
		    Set-DhcpServerv4OptionValue -ComputerName $i -OptionId 160 -PolicyName "430HD"  -Value "http://$ProvisioningFQDN/430HD/430HD.img;430HD.cfg"
		    Set-DhcpServerv4OptionValue -ComputerName $i -OptionId 160 -PolicyName "440HD"  -Value "http://$ProvisioningFQDN/440HD/440HD.img;440HD.cfg"
            Set-DhcpServerv4OptionValue -ComputerName $i -OptionId 160 -PolicyName "445HD"  -Value "http://$ProvisioningFQDN/445HD/445HD.img;445HD.cfg"
		    Set-DhcpServerv4OptionValue -ComputerName $i -OptionId 160 -PolicyName "450HD"  -Value "http://$ProvisioningFQDN/450HD/450HD.img;450HD.cfg"
        }    
     }
}

End {

    Write-Host "Finished processing all servers specified"

}
