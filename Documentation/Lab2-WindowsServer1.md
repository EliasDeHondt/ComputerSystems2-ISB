![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍Lab2 Windows Server 1🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [🖖Introduction](#🖖introduction)
3. [📝Assignment](#📝assignment)
4. [✨Steps](#✨steps)
    1. [👉Step 0: Requirements](#👉step-0-requirements)
    2. [👉Step 1: General Configuration](#👉step-1-general-configuration)
    3. [👉Step 2: AD & DNS Installation](#👉step-2-ad--dns-installation)
    4. [👉Step 3: Start-Up Console & AD](#👉step-3-start-up-console--ad)
    5. [👉Step 4: Create OU & Users](#👉step-4-create-ou--users)
    6. [👉Step 5: Create Shares](#👉step-5-create-shares)
    7. [👉Step 6: Remote Desktop](#👉step-6-remote-desktop)
5. [📦Extra](#📦extra)
6. [🔗Links](#🔗links)

---

## 🖖Introduction

This lab is about the basic configuration of a Windows 2022 server. We will see how to configure the basics of these items. After this lab you will have a basic understanding of these items. And you will be able to configure them in a basic way.

### 📝Assignment 
> NOTE This is in Dutch

- DOEL: Basis Configuratie van een Windows 2022 server.
- REF: Windows Server slides op Canvas.

0. INSTALLATIE
    - Download Windows Server 2022 64-bit (English) van Microsoft DreamSpark.
    - Installeer deze in VirtualBox (met Dekstop Experience).
    - Maak hiervan een Kloon in VirtualBox.

1. ALGEMENE INSTELLINGEN
    - Let op dat je eerst volgende instellingen aanpast bij je virtuele machine:
        - Extra netwerkkaart toevoegen in je virtuele machine (1 NAT + 1 host-only, waarom?).
        - Verander de naam van de server naar `WINSERVER` via Sever Manager -> Local Server.
        - Geef de host-only adapter (waarom deze en niet de NAT adapter?) een vast IP adres (waarom?) kies het adres rekening houdend met de DHCP range van het host-only netwerk in VirtualBox (waarom?).
        - De Folder settings aanpassen zodat je alle extensies ziet.

2. INSTALLATIE AD EN DNS
    - Start de server manager op.
    - Installeer volgende Roles:
        - Active Directory Domain Services, DNS server.
        - Voer de post-deployment configuratie uit: promote server to domain controller (new forest).
        - Kies als domein naam `lastname.local`.

3. OPSTARTEN CONSOLE EN ACTIVE DIRECTORY
    - Start `Group Policy Management` (via Server Manager -> Tools).
	    - Klik in de linkerkolom de Forest en Domains open.
	    - Ga bij jou domain name (bv `lastname.local`) op `Default Domain Policy` staan.
	    - Klik hierop met rechtermuisknop.
	    - Bekijk nu de `Default Domain Policy` door `Edit` te kiezen.
	    - Je komt in de Group Policy Management Editor terecht.
    - Group Policy Management Editor:
        - Ga naar `Computer Configuration` -> `Policies` -> `Windows Settings` -> `Security Settings`.
        - Zorg hier dat gebruikers ook als paswoord gewoon hun gebruikersnaam kunnen ingeven.
        - Dus een eenvoudig paswoord zonder al te veel vereisten.
    - Ga nu naar AD Users and Computers (via Server Manager -> Tools).
        - Probeer hier een copy te doen van het administrator account.
        - Als login naam en paswoord geef je `cisco` in.
        - Als het systeem een melding geeft, gebruik je het commando `gpupdate /force`.
        - Test of je met de user `cisco` kan inloggen.

4. AANMAAK OU EN USERS
    - Ga terug staan op je domain name (bv `lastname.local`). Rechtermuisklik op Domain Name en kies `New Organizational` Unit (OU).
    - Maak volgende structuur rechtermuiskliksgewijze aan:
        - OU `Admins` met user `cisco`.
        - OU `Docenten` met user `docent1`.
        - OU `Studenten` met sub OU's `INF1` en `INF2` met users `student1` en `student2` respectievelijk. 
    - Vergelijk gebruik ADUC (Active Directory Users and Computers) en ADAC (Server Manager -> Tools Menu -> Active Directory Administration Center).

5. AANMAAK SHARES
    - Maak een group `StudentenGroep` en `DocentenGroep` (Global, Security) aan in de resp. OU's, waarin alle studenten/docenten zitten.
    - Maak volgende shares aan op de server. (Geef Domain Administrators telkens Full Control):
        - `C:\Shares\Throughput` `Studenten Read`, `Docenten Modify`.
        - `C:\Shares\home\student1` homedirectory voor `student1`.
        - `C:\Shares\home\student2` homedirectory voor `student2`.
    - Maak een map `C:\Shares\examens` aan waar `studenten` hun examen in kunnen `droppen`, maar niet elkaars oplossing kunnen lezen en waar `docenten/administrator` wel in kan `lezen`.
    - Hiervoor moet je wel in de `Domain Controller Policy` toelaten dat gebruikers lokaal kunnen aanloggen.

6. REMOTE DESKTOP
    - Kan je op je laptop een remote desktop RDP verbinding maken?
    - Wat moet je hiervoor aanzetten op je Windows Server?
    - Log via RDP in met de user `cisco`.

## ✨Steps

### 👉Step 0: Requirements
- Install VirtualBox/VMware
- Download Windows Server 2022 64-bit (English) from Microsoft DreamSpark.
- Install Windows Server 2022 in VirtualBox (with Dekstop Experience).
- Add an extra network card to your virtual machine (So you need two in total).
    - 1 NAT (External network **internet**)
    - 1 Host-Only (Internal network **local**)

### 👉Step 1: General Configuration
- Change the name of the server to `WINSERVER` via Sever Manager -> Local Server.
- Rename the network adapters.
    - NAT: `NAT`
    - Host-Only: `Host-Only`

![x](/Images/Lab2-WindowsServer1-1.png)

- Give the `Host-Only` adapter a static IP address. in my case `192.168.19.10`.
- Change the Folder settings so you can see all extensions.

![x](/Images/Lab2-WindowsServer1-2.png)

### 👉Step 2: AD & DNS Installation

- Start the server manager.
- Install the following Roles:
    - Active Directory Domain Services
    - DNS server

![x](/Images/Lab2-WindowsServer1-3.png)

- Follow the post-deployment configuration: Promote server to domain controller (`new forest`).

![x](/Images/Lab2-WindowsServer1-4.png)

- Choose the domain name `lastname.local`. In my case `dehondt.local`.

![x](/Images/Lab2-WindowsServer1-5.png)

### 👉Step 3: Start-Up Console & AD

- Press `Windows + R` and type `gpmc.msc` to open the Group Policy Management.
- Click on the `Default Domain Policy` -> `Forest` -> `Domains` -> `lastname.local` -> `Default Domain Policy` -> `Edit`.

![x](/Images/Lab2-WindowsServer1-6.png)

- Go to `Computer Configuration` -> `Policies` -> `Windows Settings` -> `Security Settings` -> `Account Policies` -> `Password Policy`.
- Change the password policy to `Password must meet complexity requirements: Disabled`.

![x](/Images/Lab2-WindowsServer1-7.png)

- Change the password policy to `Minimum password length: 0`.

![x](/Images/Lab2-WindowsServer1-8.png)

- Press `Windows + R` and type `dsa.msc` to open the Active Directory Users and Computers.
- Create a copy of the administrator account and name it `cisco`.

![x](/Images/Lab2-WindowsServer1-9.png)

- If the system gives a notification open the command prompt and type `gpupdate /force` to update the group policy.

![x](/Images/Lab2-WindowsServer1-10.png)

### 👉Step 4: Create OU & Users

- Press `Windows + R` and type `dsa.msc` to open the Active Directory Users and Computers.
- Right-click on the domain name `lastname.local` and choose `New` -> `Organizational Unit`.

![x](/Images/Lab2-WindowsServer1-11.png)

- Create the following structure:
    - OU `Admins` with user `cisco`.
    - OU `Docenten` with user `docent1`.
    - OU `Studenten` with sub OU's `INF1` and `INF2` with users `student1` and `student2` respectively.

![x](/Images/Lab2-WindowsServer1-12.png)

### 👉Step 5: Create Shares

- Press `Windows + R` and type `dsa.msc` to open the Active Directory Users and Computers.
- Create a group `StudentenGroep` and `DocentenGroep` (Global, Security) in the resp. OU's, where all `studenten/docenten` are in.

![x](/Images/Lab2-WindowsServer1-13.png)

![x](/Images/Lab2-WindowsServer1-14.png)

![x](/Images/Lab2-WindowsServer1-15.png)

- Create the directorys: (Give Domain Administrators Full Control)
    - `C:\shares\throughput`:
        - Permission: `StudentenGroep` -> `Read & Execute`.
        - Permission: `DocentenGroep` -> `Modify`.
    - `C:\shares\home\student1`:
         - Permission: `student1` -> `Modify`.
    - `C:\shares\home\student2`:
        - Permission: `student2` -> `Modify`.
    - `C:\shares\examens`:
        - Permission: `DocentenGroep` -> `Read & Execute`.
        - Permission: `StudentenGroep`:
            - Type: `Allow`.
            - Applies to: `This folder, subfolders and files`.
            - Basic permissions: `Traverse folder/execute file`, `List folder/read data`, `Read attributes`, `Read extended attributes`, `Create files/write data`, `Write attributes`, `Write extended attributes`.

![x](/Images/Lab2-WindowsServer1-16.png)

- e.g: for `C:\shares\throughput`:

![x](/Images/Lab2-WindowsServer1-17.png)

![x](/Images/Lab2-WindowsServer1-18.png)

![x](/Images/Lab2-WindowsServer1-19.png)

- Create the following shares on the server. (Give Domain Administrators Full Control):
    - `\\WINSERVER\throughput`:
        - Name the share `throughput`.
    - `\\WINSERVER\student1`:
        - Name the share `student1`.
    - `\\WINSERVER\student2`:
        - Name the share `student2`.
    - `\\WINSERVER\examens`:
        - Name the share `examens`.
        

![x](/Images/Lab2-WindowsServer1-20.png)

![x](/Images/Lab2-WindowsServer1-21.png)

- Make sure that all user accounts can log in into the domain controller for testing purposes.

![x](/Images/Lab2-WindowsServer1-22.png)

- Test if you can access the shares from your local machine.
    - Make sure that all permissions are properly configured.

### 👉Step 6: Remote Desktop

- Make sure that you can make a remote desktop RDP connection from your laptop. With the user `cisco`.
- Go to `Server Manager` -> `Local Server` -> `Remote Desktop` -> `Enable Remote Desktop`.

![x](/Images/Lab2-WindowsServer1-23.png)

![x](/Images/Lab2-WindowsServer1-24.png)

## 📦Extra

- - It is possible to save your remote connection:
    - Open the `Remote Desktop Connection` and fill in the IP address of the server.
    - Click on `Show Options`.
    - Fill in the username and the IP.
    - Click on `Save As` and save the connection.
    - Nem the file `WINSERVER.rdp`.
    - Code:
        ```rdp
        screen mode id:i:1
        use multimon:i:0
        desktopwidth:i:1920
        desktopheight:i:1080
        session bpp:i:32
        winposstr:s:0,1,182,126,1593,881
        compression:i:1
        keyboardhook:i:2
        audiocapturemode:i:0
        videoplaybackmode:i:1
        connection type:i:7
        networkautodetect:i:1
        bandwidthautodetect:i:1
        displayconnectionbar:i:1
        enableworkspacereconnect:i:0
        disable wallpaper:i:0
        allow font smoothing:i:0
        allow desktop composition:i:0
        disable full window drag:i:1
        disable menu anims:i:1
        disable themes:i:0
        disable cursor setting:i:0
        bitmapcachepersistenable:i:1
        full address:s:192.168.19.10
        audiomode:i:0
        redirectprinters:i:1
        redirectcomports:i:0
        redirectsmartcards:i:1
        redirectclipboard:i:1
        redirectposdevices:i:0
        autoreconnection enabled:i:1
        authentication level:i:2
        prompt for credentials:i:0
        negotiate security layer:i:1
        remoteapplicationmode:i:0
        alternate shell:s:
        shell working directory:s:
        gatewayhostname:s:
        gatewayusagemethod:i:4
        gatewaycredentialssource:i:4
        gatewayprofileusagemethod:i:0
        promptcredentialonce:i:0
        gatewaybrokeringtype:i:0
        use redirection server name:i:0
        rdgiskdcproxy:i:0
        kdcproxyname:s:
        redirectlocation:i:0
        redirectwebauthn:i:1
        enablerdsaadauth:i:0
        ```

- Create a script so the group policies updates automatically:
    - Create a new file `updateGPO.bat`.
    - Add the following code to the file:
    ```bat
    @echo off
    gpupdate /force
    ```

- Create a script so the shares are created automatically:
    - Create a new file `createShares.bat`.
    - Add the following code to the file:
    ```bat
    @echo off
    net share throughput=C:\shares\throughput /GRANT:StudentenGroep,READ /GRANT:DocentenGroep,CHANGE
    net share homestudent1=C:\shares\home\student1 /GRANT:student1,CHANGE
    net share homestudent2=C:\shares\home\student2 /GRANT:student2,CHANGE
    net share examens=C:\shares\examens /GRANT:DocentenGroep,READ /GRANT:StudentenGroep,CHANGE
    ```

- Create a script so the users are created automatically:
    - Create a new file `createUsers.bat`.
    - Add the following code to the file:
    ```bat
    @echo off
    dsadd user "CN=student1,OU=INF1,OU=Studenten,DC=dehondt,DC=local" -pwd "password" -mustchpwd yes -disabled no
    dsadd user "CN=student2,OU=INF2,OU=Studenten,DC=dehondt,DC=local" -pwd "password" -mustchpwd yes -disabled no
    dsadd user "CN=docent1,OU=Docenten,DC=dehondt,DC=local" -pwd "password" -mustchpwd yes -disabled no
    dsadd user "CN=cisco,OU=Admins,DC=dehondt,DC=local" -pwd "password" -mustchpwd yes -disabled no
    ```

- Create a script so the groups are created automatically:
    - Create a new file `createGroups.bat`.
    - Add the following code to the file:
    ```bat
    @echo off
    dsadd group "CN=StudentenGroep,OU=Studenten,DC=dehondt,DC=local"
    dsadd group "CN=DocentenGroep,OU=Docenten,DC=dehondt,DC=local"
    ```

- Create a script so the OU's are created automatically:
    - Create a new file `createOUs.bat`.
    - Add the following code to the file:
    ```bat
    @echo off
    dsadd ou "OU=Admins,DC=dehondt,DC=local"
    dsadd ou "OU=Docenten,DC=dehondt,DC=local"
    dsadd ou "OU=Studenten,DC=dehondt,DC=local"
    dsadd ou "OU=INF1,OU=Studenten,DC=dehondt,DC=local"
    dsadd ou "OU=INF2,OU=Studenten,DC=dehondt,DC=local"
    ```

- Create a script so the roles are installed automatically:
    - Create a new file `installRoles.bat`.
    - Add the following code to the file:
    ```bat
    @echo off
    dism /online /enable-feature /featurename:ADDS /all
    dism /online /enable-feature /featurename:DNS /all
    ```

- Create a script so the server is renamed automatically:
    - Create a new file `renameServer.bat`.
    - Add the following code to the file:
    ```bat
    @echo off
    netdom renamecomputer %computername% /NewName:WINSERVER /Force /Reboot
    ```

- Create a script so the network adapters are renamed automatically:
    - Create a new file `renameNetworkAdapters.bat`.
    - Add the following code to the file:
    ```bat
    @echo off
    netsh interface set interface name="Ethernet" newname="NAT"
    netsh interface set interface name="Ethernet 2" newname="Host-Only"
    ```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com