# ConfigureAudioCodesDHCPOption
ConfigureAudioCodesDHCPOption.ps1

This PS script works on a list of DHCP Servers (Windows Server 2008, 2008R2, 2012, 2012R2 or 2016) to:

- create AudioCodes User Class for 420HD, 430HD, 440HD and 450HD models
- create Provisioning Server Option 160
- create and configure DHCP Policy based on User Class to assign different configuration file and firmware image to the correct model

These steps are described in AudioCodes IP Phone Documents (like this one http://www.audiocodes.com/filehandler.ashx?fileid=3885776) in chapter "Automatic Mass Provisioning of IP Phones using DHCP"

EXAMPLE
.\ConfigureAudioCodesDHCPOption.ps1 -Server DHCPSRV1,DHCPSRV2 -ProvisioningFQDN ucprovisioning.mydomain.com

Change Log:
V1.02, 23/04/2017 - Added support for Windows Server 2008 and 2008R2
V1.01, 15/03/2017 - Bugfix
V1.00, 24/01/2017 - Initial version
