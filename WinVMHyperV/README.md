# Create Windows 11 VM on Hyper-V

>[!Note]
>This sample is part of the blog post [How to run a Windows 11 VM on Hyper-V](https://techcommunity.microsoft.com/t5/itops-talk-blog/how-to-run-a-windows-11-vm-on-hyper-v/ba-p/3713948)

By default, a regular Hyper-V cannot run Windows 11 as a guest. To satisfy the Windows 11 requirements, some configurations need to be in place for the VM to run Windows 11. These are:

- Gen 2 VM: A TPM and secure boot are required for Windows 11. On Hyper-V, these are only available on Gen 2 VMs.
- UEFI, Secure Boot capable: Gen 2 VMs have UEFI, which replaces the traditional BIOS on regular Gen 1 VMs. Among other things, it allows for Secure boot which is a security standard developed by members of the PC industry to help make sure that a device boot using only software that is trusted by the Original Equipment Manufacturer (OEM). By default, Secure Boot is enabled on Gen 2 VMs, and the Microsoft Windows template is selected to allow Windows to be installed.
- TPM 2.0: Since Windows Server 2016, Hyper-V allows VMs to have a virtual TPM chip (You might remember that Shielded VMs uses this feature). This option needs to be enabled.

The [CreateWin11VM.ps1](CreateWin11VM.ps1) file on this folder contains a script for creating a new VM that is Windows 11 capable. Feel free to use this script - or suggest an improvement!

## What the script does?

The PowerShell script starts by asking some information about the VM you want to create, such as VM name, which virtual switch to use, where is the Windows 11 ISO file, and where you want to host this VM. Next, it creates the VM with its basic configuration. The memory configuration is set up to 4GB, which is the minimal requirement for Windows 11, but you can change that if you want. There's also a regular 127GB expanding VHD for VM disk.

After creating the VM, the script sets up some additional config, such as providing 4 virtual processors (which you can change if you need), and also removes the option of automatic check points (which is a personal preference). Next, it adds a new DVD drive, and adds the ISO file to it. It then sets up the boot order to get the DVD first in line to boot. Notice you’ll still need to press any key once the VM comes up to enter the Windows installation.

Finally, the script changes the security settings of the VM. Unlike the GUI, on PowerShell you must specify the VM Key Protector configuration – or at least inform that a new one is needed, which is the case of the script. After that we enable the virtual TPM.