![logo](/Images/logo.png)
# 💙🤍Lab1 Apache🤍💙

This is a lab for Apache server. The goal of this lab is to install and configure an Apache server on a Windows system with a minimal number of activated modules (so as efficiently as possible), and to understand the options of Apache.

---

## 📘Table of Contents

1. [Introduction](#introduction)
2. [Assignment](#assignment)
3. [Steps](#steps)


---

## 🖖Introduction

This is a lab for Apache server. The goal of this lab is to install and configure an Apache server on a Windows system with a minimal number of activated modules (so as efficiently as possible), and to understand the options of Apache. And to understand the options of Apache.

### 📝Assignment 
> NOTE This is in Dutch

- NODIG:
    - Windows 7,8,...
    - Apache server 2.4.x for windows 

- DOEL:
    - Installeren en configureren van een Apache server op een windows systeem met een minimaal aantal geactiveerde modules (dus zo efficient mogelijk), Begrijpen van de opties van Apache. 

- REF:
    - http://httpd.apache.org/docs/2.4/mod/directives.html
    - http://httpd.apache.org/docs/2.4/mod/
    - https://winaero.com/create-symbolic-link-windows-10-powershell/

- OPGAVE:
    1. Installatie Apache Webserver op Windows:
        - Kijk na of er geen andere web server meer draait. Stop bv. IIS in cmd.exe met: `net stop w3svc`.
        - Installeer apache 2.4.x:
            http://httpd.apache.org/docs/2.4/platform/windows.html download Windows httpd van `Apache Lounge` lees de ReadMe voor de installatie! Kies als installatielocatie `c:\apache24` installeer Apache als een service (Zorg er voor dat deze niet telkens automatisch opstart! Hoe?) test met in cmd.exe: `net start apache2.4`.

    2. Backup originele httpd.conf en opkuisen configuratie:
        - Stop de service met: `net stop apache2.4`.
        - Ga naar de directory `c:/apache24/conf/`.
        - Hernoem `httpd.conf` naar `httpd.conf.backup`.
        - Maak een nieuw, leeg bestand `c:/apache24/conf/httpd.conf` aan.
        - Stel nu in je nieuwe `httpd.conf` je `ServerName` in. Deze moet gelijk zijn aan de naam die je terugkrijgt wanneer je in `cmd.exe` (of `powershell.exe`) het commando hostname uitvoert.
        - Stel als ServerRoot `c:/apache24` in.
        - Maak onder `ServerRoot` een directory `web/kdg` aan en stel deze in als `DocumentRoot`.


    3. Opstartfouten oplossen:
        - Probeer de server op te starten in `cmd.ex`e met: `c:\apache24\bin\httpd -f c:/apache24/conf/httpd.conf`.
        - Deze geeft onder andere als fout dat er geen Listening Sockets zijn: Laat de server luisteren op poort 80.
        - Start de server opnieuw op.
        - Surf nu naar `http://127.0.0.1/` in een browser. Je krijgt de foutmelding `Internal server error` Bekijk de logfile, welk foutmelding vind je terug? Zoek vie het Internet hoe de deze fout kan oplossen. Bekijk wat deze module doet op de apache website (zie REF 3) Na het toevoegen van de LoadModule, stop/start Apache `Not Found` betekent hier dat je server al werkt!

    4. Bekijken website:
        - Maak een eenvoudig html bestand `web/kdg/index.html` met een persoonlijke tekst.
        - Surf naar `http://localhost/index.html` werkt `http://localhost` ook? `(Nee)`.
        - Voeg `DirectoryIndex index.html` toe aan je config file Herstart de webserver. Welke foutmelding geeft dit?
        - Zoek zelf op via de apache website welke module je hiervoor moet activeren (zie REF 2) Voeg deze module toe met LoadModule in je config.
        - Test nu uit op `http://127.0.0.1`.

    5. Directory Auto Index:
        - Als de HTML niet ge nterpreteerd wordt, dien je de mime module te laden.
        - Voeg nu de module autoindex toe.
        - Maak onder DocumenRoot een Directory `test` aan en definieer deze als volgt in je `httpd.conf`.
        ```html
        <Directory C:/apache24/web/kdg/test>
            Options Indexes
        </Directory>
        ```
        - Bekijk de directory op `http://127.0.0.1/test/`.

    6. Symbolische link en server info:
        - Maak nu een link aan van `c:\apache24\web\kdg\test\link` naar de directory logs in `ServerRoot` Je kan dit in Powershell doen (zie referentie) Zorg dat je links `http://localhost/test/link/` kan gebruiken.
        - Activeer de module info. Als deze draait, kan je op `http://127.0.0.1/server-info` alle apache instellingen opvragen.
        - Bekijk als inspiratie `conf/extra/httpd-info.conf`

    7. Port based Virtual hosts:
        - Maak een 2de website die beschikbaar is via poort 8080 met als DocumentRoot `c:/apache24/htdocs`. 
        - `http://localhost` en `http://<jou_host_naam>` verwijzen naar `c:/apache24/web/kdg`.
        - `http://localhost:8080` en `http://<jou_host_naam>:8080` verwijzen naar `C:/apache24/htdocs`.
        - Denk eraan dat je apache moet vertellen om op 2 poorten te luisteren!

    8. Authenticatie:
        - Maak apache accounts `student1` en `student2` aan. Geef ze hetzelfde paswoord als de gebruikersnaam. 
        - Gebruik het bestand `c:/apache24/web/users` om de paswoorden in op te slaan. 
        - Stop `student1` en `student2` in de groep `studenten`, dit sla je op in `c:/apache24/web/group`.

        - Maak apache accounts `docent1` en `docent2` aan. Geef ze hetzelfde paswoord als de gebruikersnaam. 
        - Stop `docent1` en `docent2` in de groep `docenten`.

        - Beveilig je 2de website zodat enkel docenten hierop kunnen (hiervoor moet je de juiste authenticatieinstellingen doorvoeren in de virtual host). Laad de juiste modules voor authenticatie in.

    9. .htaccess:
        Maak onder DocumenRoot een Directory "test2" aan en plaats hierin een index.html bestand.
        Laat in deze directory enkel een override van authenticatie toe.
        Bekijk de directory op `http://localhost/test2/`
        Plaats nu in deze directory een .htaccess en zorg ervoor dat enkel studenten toegang hebben.
        Test opnieuw met `http://localhost/test2/`
        Heb je hiervoor de webserver moeten herstarten? Waarom wel/niet?

    10. UserDir:
        Voorzie de nodige modules voor gebruikersdirectories.
        Zorg ervoor dat alle Windows gebruikers die gedefinieerd zijn op jou PC een eigen website kunnen aanmaken.
        Hiervoor moeten ze een directory "www" aanmaken in hun home directory `c:/Users/<username>/www`. 

    11. Redirect:
        Zoek op internet hoe je een redirect kan implementeren in apache. 
        Gebruikers die surfen naar `http://jouw_server/google` moeten automatisch doorgestuurd worden naar `http://google.com` 

    12. Op IP filteren:
        Laat enkel de locale machine toe om de server info te bekijken.
        Start een virtuele machine op (Kies in Virtual Box een Host-only netwerk adapter)
        Test of deze virtuele guest machine toegang heeft.

## ✨Steps

### 👉 Step 1: Installation of Apache Webserver on Windows 2.4

- Download from this URL: [httpd.apache.org](https://httpd.apache.org/docs/2.4/platform/windows.html).
- Unzip all in `c:\apache24`.
- Open a command prompt and run `cd c:\apache24\bin`.
- Run `httpd -k install "Apache24 Webserver"` to install Apache as a service.
- Prevent Apache from starting automatically by running `sc config "Apache2.4" start= demand`.
- Start the service by running `net start apache2.4`.

### 👉 Step 2: Backup original httpd.conf and clean up configuration
- Stop the service by running `net stop apache2.4`.
- Go to the directory `cd ../conf/`.
- Rename `httpd.conf` to `httpd.conf.backup` (`ren httpd.conf httpd.conf.backup`).
- Create a new, empty file `httpd.conf` (`type nul > httpd.conf`).
- Set your `ServerName` in your new `httpd.conf`. This must be equal to the name you get when you run the `hostname` command in `cmd.exe` (or `powershell.exe`). e.g `ServerName LAPTOP`.
- Set `ServerRoot` to `c:/apache24`.
- Create a directory `web/kdg` under `ServerRoot` and set it as `DocumentRoot`. e.g. `DocumentRoot "c:/apache24/web/kdg"`.
    - `cd ../`
    - `mkdir web`
    - `cd web`
    - `mkdir kdg`

### 👉 Step 3: To resolve startup errors
- In the configuration file we need to open a port for the server to listen on. We do this by adding `Listen 80` to the `httpd.conf` file.
- Add `LoadModule authz_core_module modules/mod_authz_core.so` to the `httpd.conf` file.
- Start the server by running `c:\apache24\bin\httpd -f c:/apache24/conf/httpd.conf`.

### 👉 Step 4: View website
- Create a simple html file `web/kdg/index.html` with a personal text.
    ```html
    <!DOCTYPE html>
    <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Hello World Page</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f0f0f0;
                    text-align: center;
                    margin-top: 50px;
                }
                .container {
                    width: 50%;
                    margin: 0 auto;
                    background-color: #4F94F0;
                    padding: 20px;
                    border-radius: 10px;
                    box-shadow: 0 0 10px rgba(0,0,0,0.1);
                }
                h1 {
                    color: #333;
                }
                .eliasdh {
                    color: #ffffff;
                    text-decoration: none;
                    font-weight: bold;
                }
                .eliasdh:hover {
                    color: #357ac0; 
                    text-decoration: none;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>Hello World!</h1>
                <p>Welcome to my cool web page!</p>
                <p>Design by Elias De Hondt
                <br>Copyright &copy; <a class="eliasdh" target="_blank" href="https://eliasdh.com">EliasDH</a>
                <br>All rights Reserved</p>
            </div>
        </body>
    </html>
    ```
- Add `LoadModule dir_module modules/mod_dir.so` to the `httpd.conf` file.
- Add `DirectoryIndex index.html` to your config file. Restart the web server.

### 👉 Step 5: Directory Auto Index
- Add `LoadModule autoindex_module modules/mod_autoindex.so` to the `httpd.conf` file.
- Create a directory `test` under `DocumentRoot` and define it as follows in your `httpd.conf`.
    ```html
    <Directory "c:/apache24/web/kdg/test">
        Options Indexes
    </Directory>
    ```
- View the directory at `http://127.0.0.1/test/`

### 👉 Step 6: Symbolic link and server info
- Create a new directory `link` in `c:\apache24\web\kdg\test`.
- Create a link from `c:\apache24\web\kdg\test\link` to the logs directory in `ServerRoot`. You can do this in Powershell: 
    ```powershell
    New-Item -ItemType SymbolicLink -Path "c:\apache24\web\kdg\test\link" -Target "c:\apache24\logs"
    ```
    - If for some reason you get an error that the link is already established:
        ```powershell
        Remove-Item "c:\apache24\web\kdg\test\link"
        ```
- In the `httpd.conf` file, add:
    ```html
    <Directory "c:/apache24/web/kdg/test">
        Options Indexes FollowSymLinks
    </Directory>
    ```
- Add `LoadModule info_module modules/mod_info.so` to the `httpd.conf` file.
- And add the following to the `httpd.conf` file:
    ```html
    <Location "/server-info">
        SetHandler server-info
    </Location>
    ```
- Restart the web server.
- If this module is running, you can request all apache settings at `http://127.0.0.1/server-info`.

### 👉 Step 7: Port based Virtual hosts
- We are going to convert our entire configuration file `httpd.conf` as follows.
    ```html
    LoadModule authz_core_module modules/mod_authz_core.so
    LoadModule dir_module modules/mod_dir.so
    LoadModule autoindex_module modules/mod_autoindex.so
    LoadModule info_module modules/mod_info.so

    Listen 80
    Listen 8080

    <VirtualHost *:80>
        ServerName LAPTOP
        ServerRoot c:/apache24
        DocumentRoot c:/apache24/web/kdg
        DirectoryIndex index.html

        <Directory "c:/apache24/web/kdg/test">
            Options Indexes FollowSymLinks
            Require all granted
        </Directory>

        <Location "/server-info">
            SetHandler server-info
            Require local
        </Location>
    </VirtualHost>

    <VirtualHost *:8080>
        ServerName LAPTOP
        DocumentRoot c:/apache24/htdocs
        <Directory "c:/apache24/htdocs">
            Options Indexes FollowSymLinks
            Require all granted
        </Directory>
    </VirtualHost>
    ```
    > NOTE: You can also keep the original configuration and simply add the part of port 8080.
- Restart the web server.

### 👉 Step 8: Authentication
- Create the file `c:/apache24/web/users` and add the following lines:
    ```test
    student1:student1
    student2:student2
    docent1:docent1
    docent2:docent2
    ```
- Create the file `c:/apache24/web/group` and add the following lines:
    ```test
    studenten: student1 student2
    docenten: docent1 docent2
    ```
- Add the following modules to the `httpd.conf` file:
    ```html
    LoadModule authn_core_module modules/mod_authn_core.so
    LoadModule authn_file_module modules/mod_authn_file.so
    LoadModule authz_user_module modules/mod_authz_user.so
    LoadModule authz_groupfile_module modules/mod_authz_groupfile.so
    LoadModule auth_basic_module modules/mod_auth_basic.so
    ```
- Add the following lines within the `<VirtualHost>` section of the second website on port 8080:
    ```html
    <Directory "/">
        AuthType Basic
        AuthName "Restricted Access"
        AuthUserFile "c:/apache24/web/users"
        AuthGroupFile "c:/apache24/web/group"
        Require group docenten
    </Directory>
    ```






## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us eliasdehondt@outlook.com.