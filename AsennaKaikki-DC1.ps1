# Määritellään globaali debug-tilan muuttuja skriptin alkuun
$Global:DebugMode = $false

Function Main() {
    $ComputerName = $env:COMPUTERNAME
    $ComputerIP = (Test-Connection -ComputerName $ComputerName -Count 1).Ipv4Address.IPAddressToString
    $debugStatus
    # Määritetään kiinteä leveys valikon riveille
    $lineWidth = 41
    $nameDisplay = " Name:$ComputerName".PadRight($lineWidth)
    $ipDisplay = " IP:$ComputerIP".PadRight($lineWidth)

    Clear-Host
    Write-Host " ___________________________________________ "
    Write-host " |Valitse asetukset mitkä haluat määrittää!| "
    Write-Host " |_________________________________________| "
    Write-Host " |$nameDisplay|"
    Write-Host " |$ipDisplay|"
    Write-Host "<------------------------------------------->"
    Write-Host " | 1. Palvelimen valmistelu                | "
    Write-Host " | 2. Active-Driectory pystytys            | "
    Write-Host " | 3. Lisäominaisuudet                     | "
    Write-Host " | 4. Poistu                               | "
    Write-Host " | 5. Versio                               | "
    # Käytetään if-lausetta debug-tilan näyttämiseen
    $debugStatus = if ($Global:DebugMode) {'PÄÄLLÄ     '} else {'POIS PÄÄLTÄ'}
    Write-Host " | 6. Debug-tila: " -NoNewline
        if ($Global:DebugMode) {
    Write-Host "PÄÄLLÄ     " -NoNewline -ForegroundColor Red
        } else {
    Write-Host "POIS PÄÄLTÄ" -NoNewline -ForegroundColor Green
                }
Write-Host "              | "
    Write-Host " |-----------------------------------------| "
    $valintaS = Read-Host " |"

    Switch ($valintaS) {
        1 {
            Clear-Host
            Write-Host "Aloitetaan palvelimen valmistelu!" -ForegroundColor Green
            Start-Sleep -Seconds 1.5
            if (-not $Global:DebugMode) { hostAsk }
        }
        2 {
            Clear-Host
            Write-Host "Aloitetaan Active-Directory pystytystä!" -ForegroundColor Green
            Start-Sleep -Seconds 1.5
            if (-not $Global:DebugMode) { adASK }
        }
        3 {
            if (-not $Global:DebugMode) { Lisävalikko }
        }
        4 {
            Clear-Host
            Write-Host "Poistutaan!" -ForegroundColor Red
            Start-Sleep -Seconds 1.5
            Exit
            Clear-Host
        }
        5 {
            if (-not $Global:DebugMode) { versioControl }
        }
        6 {
            $Global:DebugMode = -not $Global:DebugMode
            $debugStatus = if ($Global:DebugMode) {'PÄÄLLÄ'} else {'POIS PÄÄLTÄ'}
            Main
        }
        default { Main }
    }
}


Function hostAsk(){
Clear-Host
$ComputerName = Read-host "Ennen asennusta aseta koneen nimi"
    if($ComputerName -eq ""){
        Clear-Host
        Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
        Start-sleep -Seconds 1.5
        hostAsk
    }else {
    Networkask
    }
}
Function UudelleenSuoritus(){
    switch ($reask) {
        'k' {
            Clear-Host
            hostAsk
        }
        default {
            Clear-Host
            $vastausUudelleenS = Read-Host "Haluatko palata päävalikkoon vai sulkea ohjelman? p/s"
            switch ($vastausUudelleenS) {
                'p' {
                    Clear-Host
                    Write-Host "Ohjataan päävalikkoon!" -ForegroundColor Green
                    Main
                }
                's' {
                    Clear-Host
                    Write-Host "Suljetaan ohjelma!" -ForegroundColor Red
                    Start-Sleep -Seconds 1.5
                    Exit
                }
                default {
                    Clear-Host
                    Write-Host "Ohjataan päävalikkoon!" -ForegroundColor Green
                    Main
                }
            }
        }
    }
    
}
Function Networkask() {
Function adapterSelect(){
Get-NetAdapter -name *
$InterFaceINDEX = Read-Host "Laita Verkko kortin indexi tai nimi"
Clear-Host
if($InterFaceINDEX -eq "") {
    Clear-Host
    Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
    Start-sleep -Seconds 1.5
    Clear-Host
    adapterSelect
}else {
Clear-Host
ComputeripS
}
}
Function ComputeripS(){
$ComputerIP = Read-Host "Aseta staattinen osoite "
if($ComputerIP -eq "") {
Clear-Host
Write-Host "Tämä kohta ei voi olla tyhjä!" -ForegroundColor Red
Start-sleep -Seconds 1.5
Clear-Host
ComputeripS
}else {
subnetS
}
}
Function subnetS(){
$Subnetprefix = Read-Host "Aseta subnet prefix "
if($Subnetprefix -eq ""){
Clear-Host
Write-Host "Tätä osiota ei voi jättää tyhjäksi!" -ForegroundColor Red
Start-sleep -Seconds 1.5
Clear-Host
subnetS
}elseif($Subnetprefix -in 8..30) {
gateawayS
}else{
Clear-Host
Write-Host "Valitse kunnon Subnetprefix" -ForegroundColor Red
Start-sleep -Seconds 1.5
Clear-Host
subnetS
}
}
Function gateawayS(){
$GatewayIP = Read-Host "Aseta Gateaway osoite "
Clear-Host
Function checkgatawayC() {
    $gateawayAnwser = Read-host "Haluatko muuttaa staattisen osoitteen vai gateaway osoitteen? s/g |"
    
    switch ($gateawayAnwser) {
        "s" {
            Clear-Host
            Write-Host "Sinut ohjataan staatisen osoitteen asettamiseen!" -ForegroundColor Green
            Start-sleep -Seconds 1.5
            Clear-Host
            ComputeripS
        }
        "g" {
            Clear-Host
            Write-Host "Sinut ohjataan gateaway asettamiseen!" -ForegroundColor Green
            Start-sleep -Seconds 1.5
            Clear-Host
            gateawayS
        }
        default {
            Clear-Host
            Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
            Start-sleep -Seconds 1.5
            Clear-Host
            checkgatawayC
        }
    }
}

If($ComputerIP -eq $GatewayIP){
Write-Host "Virheellinen osoite! $ComputerIP ja $GatewayIP ovat samat!!" -ForegroundColor Red
Write-Host "Aseta asetukset uudelleen!" -ForegroundColor Red
Start-sleep -Seconds 1.5
Clear-Host
checkgatawayC
}else {
if($GatewayIP -eq ""){
Clear-Host
Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
Start-sleep -Seconds 1.5
Clear-Host
gateawayS
}else {
    dnsAsk
}
}
}
Function dnsAsk(){
    Clear-Host
$dnsIP = Read-Host "Syötä DNS palvelin osoitteet oletuksena 127.0.0.1 | "
    If($dnsIP -eq ""){
        $dnsIP = '127.0.0.1'
        dnsASK2
                    }else{
                            dnsASK2
                        }
}
Function dnsASK2(){
    Clear-Host
    $dnsIP2 = Read-Host "Syötä toinen dns osoite tai jatka painamalla enter | "
        if($dnsIP2 -eq ""){
            asetuksetDATA
        }else {
        asetuksetDATA
        }

}
Clear-Host
adapterSelect
}
Function asetuksetDATA(){
$asetuksetDATA
$asetuksetDATA=@([PSCustomObject]@{
    Koneen_Nimi = $ComputerName
    Verkkokortti = $InterFaceINDEX
    IP = $ComputerIP
    Subnet = $Subnetprefix
    Gateway = $GatewayIP
    DNS_1 = $dnsIP
    DNS_2 = $dnsIP2
})
asetuksetSTAT
}
Function asetuksetSTAT() {
    $reask
Clear-Host
Write-Output "Yhteen veto Asetuksista: "
$asetuksetDATA | Format-Table -AutoSize | Out-String -Width ([int]::MaxValue)
$Startconf = Read-Host "Haluatko jatkaa k/e?"

switch ($Startconf) {
    'k' {
        Clear-Host
        Write-Host "Aloitetaan konfiguraatiota!" -ForegroundColor Green
        timeask
    }
    default {
        Clear-Host
        Write-Host "Et halunnut aloittaa konfiguraatio skriptiä!" -ForegroundColor Red
        $reask = Read-Host "Haluatko aloittaa sen uudelleen? k/e"
        UudelleenSuoritus
    }
}

}
Function timeask(){
    $timeto
param(
    $tim
)
$timeto = 5
$time = Read-Host "Aseta nopeus toimintojen välillä sekunnissa, paina enter tai syötä lukema. Normaalisti 5 sekuntia!"
if ( $time -in 1..10)
    {
    $timeto = $time
    Start-script
}else {
    $timeto = 5
    Start-script
}
}
Function Start-script() {
Clear-Host
Write-Progress -Activity "tehdään asetuksia" -Status "Aloitetaan!" -Id 1 -PercentComplete 0

Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan nimeä: $ComputerName" -Id 2 -ParentId 1 -PercentComplete 0
    Rename-computer -ComputerName $env:COMPUTERNAME -NewName $ComputerName
Write-Progress -Activity "tehdään asetuksia" -Status "Koneelle on asetettu nimi: $ComputerName" -Id 2 -ParentId 1 -Completed
Start-sleep -Seconds $timeto
Write-Progress -Activity "tehdään asetuksia" -Status "Aloitetaan!" -Id 1 -PercentComplete 20
#Verkko kohta!
Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 0
# Tarkistaa Interface syöttö muodon
If($InterFaceINDEX -match "^\d{1,2}$"){
Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 10
    Remove-NetIPAddress -InterfaceIndex $InterFaceINDEX
Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 50
Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -id 2 -ParentId 1 -PercentComplete 60
    Set-DnsClientServerAddress -InterfaceIndex $InterFaceINDEX -ServerAddresses ("$dnsIP,dnsIP2")
Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -id 2 -ParentId 1 -PercentComplete 70
    New-NetIPAddress -InterfaceIndex $InterFaceINDEX -IPAddress $ComputerIP -PrefixLength $Subnetprefix -DefaultGateway $GatewayIP
Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 90
}else {
Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 10
    Remove-NetIPAddress -InterfaceAlias $InterFaceINDEX
Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 50
Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 60
    Set-DnsClientServerAddress -InterfaceAlias $InterFaceINDEX -ServerAddresses ("$dnsIP,dnsIP2")
Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 70
    New-NetIPAddress -InterfaceAlias $InterFaceINDEX -IPAddress $ComputerIP -PrefixLength $Subnetprefix -DefaultGateway $GatewayIP
Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 90
}
Write-Progress -Activity "tehdään asetuksia" -Status "Verkko asetukset asetettu: Interfaceindex $InterFaceINDEX, IP osoite: $ComputerIP Subnetinprefix: $Subnetprefix Gateaway: $GatewayIP" -Id 2 -ParentId 1 -Completed
Start-sleep -Seconds $timeto
Write-Progress -Activity "tehdään asetuksia" -Status "Aloitetaan!" -Id 1 -PercentComplete 60
#Verkko kohta loppuu!



Write-Progress -Activity "tehdään asetuksia" -Status "Asennetaan ominaisuuksia!" -Id 2 -ParentId 1 -PercentComplete 0
    Install-WindowsFeature -ConfigurationFilePath DeploymentConfigTemplate.xml
Write-Progress -Activity "tehdään asetuksia" -Status "Ominaisuudet asenettu" -Id 2 -ParentId 1 -Completed
Start-sleep -Seconds $timeto
Write-Progress -Activity "Tehdään asetuksia" -Status "Asetukset tehty! Käynnistetään uudelleen!" -Id 1 -Completed
for ($i = 10; $i -ge 0; $i--) {
    Write-Host "Uudelleenkäynnistys tapahtuu $i sekunnin kuluttua..." -ForegroundColor Red -NoNewline
    Start-Sleep -Seconds 1
    # Poistetaan edellinen rivi, jotta konsoli pysyy siistinä.
    if ($i -gt 0) {
        Write-Host "`r" -NoNewline
    }
}
Restart-Computer -Force
}
Function adsetup(){
# AD Asetukset
Try{
    Install-ADDSForest -DomainName $DomainName -InstallDNS -ErrorAction Stop -NoRebootOnCompletion
    Write-Host "Active Directory Domain Services asetukset on asetettu ilman ongelmia!" -ForegroundColor Green
    }
Catch{
    Write-Warning -Message $("Virhe tuli asetuksien asetuksessa!: "+ $_.Exception.Message)
    Break;
    }

# Silmukka, joka laskee 30:stä 0:aan
for ($i = 30; $i -ge 0; $i--) {
    Write-Host "Uudelleenkäynnistys tapahtuu $i sekunnin kuluttua..." -ForegroundColor Red -NoNewline
    Start-Sleep -Seconds 1
    # Poistetaan edellinen rivi, jotta konsoli pysyy siistinä.
    if ($i -gt 0) {
        Write-Host "`r" -NoNewline
    }
}

Try{
    Restart-Computer -ComputerName $env:computername -ErrorAction Stop
    Write-Host "Kone käynnistyy uudelleen!!" -ForegroundColor Green
    }
Catch{
    Write-Warning -Message $("Virhe tuli käynnistäessä konetta uudelleen! $($env:computername). Error: "+ $_.Exception.Message)
    Break;
    }
}
Function adASK(){
Function adask1(){
$DomainName = Read-Host "Aseta toimialueen nimi"
if($DomainName -eq ""){
Clear-Host
Write-Host "Toimialueen nimeä ei ole laitettu!" -ForegroundColor Red
Clear-Host
adask1
}else {
adsetup
}
}
Clear-Host
adask1
}
Function versioControl() {
    Clear-Host
    Write-Host " ____________________________________________"
    Write-Host " |               Asetus valikko!            | "
    Write-Host " |            Versio: x.xx(v0.82)Beta       | "
    Write-Host " |                By: Eetu Heino            | "
    Write-Host " |    Active-Directory automointi työkalu   | "
    Write-Host " |------------------------------------------| "
    $valintaVersio = Read-Host " |Haluatko Takaisin päävalikkoon? k/e       |"

    switch ($valintaVersio) {
        "k" {
            Write-Host "Palataan!"
            Start-Sleep -Seconds 1
            Clear-Host
            Main
        }
        "e" {
            Write-Host "Haluatko poistua skriptistä kokonaan?" -ForegroundColor Red
            $valintaVersio = Read-Host "k/e|"
            switch ($valintaVersio) {
                "k" {
                    Clear-Host
                    Write-Host "Poistutaan!"
                    Start-Sleep -Seconds 1.5
                    Clear-Host
                    exit
                }
                default {
                    Clear-Host
                    versioControl
                }
            }
        }
        default {
            Clear-Host
            versioControl
        }
    }
}


Function Lisävalikko(){
Function MainMenu(){
Clear-Host
Write-Host "  Valitse ominaisuus mitä haluat käyttää: "
Write-Host " ________________________________________ "
write-host " |1. Automaattinen OU rakentaja         | "
Write-Host " |                                      | "
write-host " |2. Group Policy importer              | "
Write-Host " |                                      | "
write-host " |3. Työaseman valmistelu ja liittäminen| "
Write-Host " |______________________________________| "
Write-Host " |            |"
write-host " |4. Takaisin |"
Write-Host " |____________|"
$OmiVa = Read-Host " |"

switch($OmiVa){
    1 {Clear-Host; Write-Host "Ominaisuus on Beta testauksessa!" -ForegroundColor Yellow; Start-sleep -Seconds 1.5; OUbuilder}
    2 {Clear-Host; Write-Host "ominaisuutta ei ole vielä!" -ForegroundColor Red; Start-sleep -Seconds 1.5; MainMenu}
    3 {workstationAsk}
    4 {Main}
    default {MainMenu}

}
}
Function OUbuilder(){
    Function OUbuilderMain(){
        Clear-Host
        Write-Host " _________________"
        Write-Host " |               |"
        Write-Host " |Valitse asetus!|"
        Write-Host " |_______________|"
        Write-Host " ___________________________ "
        Write-Host " |1. Pika OU rakennus      | "
        Write-Host " |2. Pika käyttäjien lisäys| "
        Write-Host " |3. Pika ryhmien luonti   | "
        Write-Host " |4. Takaisin              | "
        Write-Host " |-------------------------- "
        $OUanwser = Read-Host " |"
        switch($OUanwser){
            1 {OUask}
            2 {UserAsk}
            3 {GroupMain}
            4 {Lisävalikko}
        }
    }
    Function OUask(){
        Function OUdomainAsk(){
            $OUdomain0
            $OUdomain1
        Clear-Host
        $OUdomain = Read-Host "Aseta domain"
        $OUdomainParts = $OUdomain.Split(".")
        $OUdomain0 = $OUdomainParts[0]
        $OUdomain1 = $OUdomainParts[1]
            if($OUdomain -eq ""){
                Clear-Host
                Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
                Start-sleep -Seconds 1.5
                OUdomainAsk
            }else{
                OUmainAsk
            }
        }
        Function OUmainAsk(){
        Clear-Host
        $OUmainS = Read-Host "Kirjoita pää/root ou:n nimi"
            if($OUmainS -eq ""){
                Clear-Host
                Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
                Start-sleep -Seconds 1.5
                OUmainAsk
            }else{
                OUsetup
            }
        }
        Function OUmainAsk2(){
        Clear-Host
        $OUmainS2 = Read-Host "Kirjoita ou:n nimi minkä alle haluat rakentaa? "
            if($OUmainS2 -eq ""){
                Clear-Host
                Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
                Start-sleep -Seconds 1.5
                OUmainAsk2
            }else{
                ouRepetask2
            }
        }
        Function ouRepetask2($nimetDATA, $OUnim){
        Clear-History
        $repet = Read-Host "Kuinka monta ala ou haluat?"
            if($repet -eq ""){
                Clear-Host
                Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
                Start-sleep -Seconds 1.5
                ouRepetask2
            } elseif($repet -match '^\d{1,2}$'){
                for ($i=1; $i -le $repet;$i++) {
                    $OUnim = Read-Host "Syötä ala ou:n nimi"
                    New-ADOrganizationalUnit -Name $OUnim -Path "OU=$OUmainS2,OU=$OUmainS,DC=$OUdomain0,DC=$OUdomain1"
                }
                OUbuilderMain
            }else {
            ouRepetask2
            }
        }
        Function ouRepetask($nimetDATA, $OUnim){
        Clear-History
        $repet = Read-Host "Kuinka monta ala ou haluat?"
            if($repet -eq ""){
                Clear-Host
                Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
                Start-sleep -Seconds 1.5
                ouRepetask
            } elseif($repet -match '^\d{1,2}$'){
                for ($i=1; $i -le $repet;$i++) {
                    Clear-Host
                    $OUnim = Read-Host "Syötä ala ou:n nimi"
                    New-ADOrganizationalUnit -Name $OUnim -Path "OU=$OUmainS,DC=$OUdomain0,DC=$OUdomain1"
                }
                OUbuilderMain
            }else {
            ouRepetask
            }
        }
    OUdomainAsk
    }
    Function OUsetup(){
        $OUExists = Get-ADOrganizationalUnit -Filter {Name -eq $OUmainS}
        Clear-Host
        Write-Progress -Activity "OU rakennus" -Status "Tehdään OU rakennusta!" -Id 1 -PercentComplete 0
        Write-Progress -Activity "OU rakennus" -Status "Tarkistetaan onko ou olemassa!" -Id 2 -ParentId 1 -PercentComplete 50
        Start-sleep -Seconds 1
            if ($OUExists){
            Clear-Host
            Start-sleep -Seconds 1
            Write-Progress -Activity "OU rakennus" -Status "Tarkistetaan onko ou olemassa!" -Id 2 -ParentId 1 -Completed
            Write-Progress -Activity "OU rakennus" -Status "Tehdään OU rakennusta!" -Id 1 -Completed
            OUmainAsk2
            }else{
            Write-Progress -Activity "OU rakennus" -Status "Tarkistetaan onko ou olemassa!" -Id 2 -ParentId 1 -Completed
            Write-Progress -Activity "OU rakennus" -Status "Tehdään pää OU!" -Id 2 -ParentId 1 -PercentComplete 0
            New-ADOrganizationalUnit -Name "$OUmainS" -Path "DC=$OUdomain0,DC=$OUdomain1"
            Write-Progress -Activity "OU rakennus" -Status "Tehdään pää OU!" -Id 2 -ParentId 1 -Completed
            Write-Progress -Activity "OU rakennus" -Status "Tehdään OU rakennusta!" -Id 1 -PercentComplete 10
            Write-Progress -Activity "OU rakennus" -Status "Tehdään OU rakennusta!" -Id 1 -Completed
            ouRepetask
                    }
    }
    Function UserAsk(){
    Clear-Host
        Function DomainAsk (){
            $OUdomain0
            $OUdomain1
        Clear-Host
        $OUdomain = Read-Host "Aseta domain"
        $OUdomainParts = $OUdomain.Split(".")
        $OUdomain0 = $OUdomainParts[0]
        $OUdomain1 = $OUdomainParts[1]
            if($OUdomain -eq ""){
                Clear-Host
                Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
                Start-sleep -Seconds 1.5
                DomainAsk
            }else{
                pathAsk
            }
        }
        Function pathAsk() {
            $pathAsk
            Clear-Host
            $pathAsk = Read-Host "Minkä ou:n alle haluat kyseiset käyttäjät "
            pathAsk2
        }
        Function pathAsk2() {
            Clear-Host
            $pathAsk2 = Read-Host "Valitse ala ou tai paina enter jatkaaksesi "
                if ($pathAsk2 -eq "") {
                repetAsk
                }else {
                    pathAsk3
                }
        }
        Function pathAsk3() {
            Clear-Host
            $pathAskU = Read-Host "Haluatko määritellä vielä ala ou:n vai jatkaa? m/j ? "
            Switch ($pathAskU) {
                j {repetAsk2}
                m {pathAsk4}
                default {pathAsk3}
            }
        }
        Function pathAsk4() {
            $pathAsk4
            Clear-Host
            $pathAsk4 = Read-Host "Valitse ala ou "
                if ($pathAsk2 -eq "") {
                pathAsk4
                }else {
                    repetAsk3
                }
        }
        Function repetAsk (){
            Clear-Host
            $repet = Read-Host "Kuinka monta Käyttäjää haluat?"
            if($repet -eq ""){
                Clear-Host
                Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
                Start-sleep -Seconds 1.5
                repetAsk
            } elseif($repet -match '^\d{1,2}$'){
                for ($i=1; $i -le $repet;$i++) {
                    Clear-Host
                    $UserName = Read-Host "Syötä käytäjän nimi "
                    New-ADUser -Name "$UserName" -Path "OU=$pathAsk,DC=$OUdomain0,DC=$OUdomain1" -Accountpassword (Read-Host -AsSecureString "Käyttäjän salasana ") -Enable $true
                }
                OUbuilderMain
            }else {
            repetAsk
            }

        }
        Function repetAsk2 (){
            Clear-Host
            $repet = Read-Host "Kuinka monta Käyttäjää haluat?"
            if($repet -eq ""){
                Clear-Host
                Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
                Start-sleep -Seconds 1.5
                repetAsk2
            } elseif($repet -match '^\d{1,2}$'){
                for ($i=1; $i -le $repet;$i++) {
                    Clear-Host
                    $UserName = Read-Host "Syötä käytäjän nimi "
                    New-ADUser -Name "$UserName" -Path "OU=$pathAsk2,OU=$pathAsk,DC=$OUdomain0,DC=$OUdomain1" -Accountpassword (Read-Host -AsSecureString "Käyttäjän salasana ") -Enable $true
                }
                OUbuilderMain
            }else {
            repetAsk
            }

        }
        Function repetAsk3 (){
            Clear-Host
            $repet = Read-Host "Kuinka monta Käyttäjää haluat?"
            if($repet -eq ""){
                Clear-Host
                Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
                Start-sleep -Seconds 1.5
                ouRepetask3
            } elseif($repet -match '^\d{1,2}$'){
                for ($i=1; $i -le $repet;$i++) {
                    Clear-Host
                    $UserName = Read-Host "Syötä käytäjän nimi "
                    New-ADUser -Name "$UserName" -Path "OU=pathAsk4,OU=$pathAsk2, OU=$pathAsk,DC=$OUdomain0,DC=$OUdomain1" -Accountpassword (Read-Host -AsSecureString "Käyttäjän salasana ") -Enable $true
                }
                OUbuilderMain
            }else {
            repetAsk
            }

        }
        DomainAsk
    }
    function GroupMain {
       ##Täytyy toteuttaa uudelleen!!!!
        
    }
OUbuilderMain
}
Function workstationAsk(){
Function workstationInterfaceAsk(){
    Clear-Host
    Get-NetAdapter *
    $workstationINT = Read-Host "Valitse verkkokortti mitä haluat käyttää joko prefix tai nimi"
    if($workstationINT -eq ""){
    Clear-Host
    Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
    Start-sleep -Seconds 1.5
    Clear-Host
    workstationInterfaceAsk
    }else{
    Clear-Host
    workstationIPAsk
    }
}
Function workstationIPAsk(){
    Clear-Host
$workstationIP = Read-Host "Laita työaseman staattinen osoite: "
    If($workstationIP -eq ""){
        Clear-Host
        Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
        Start-sleep -Seconds 1.5
        workstationIPAsk
    }else {
    Clear-Host
    workstationSubnetAsk
    }
}
Function workstationSubnetAsk(){
    $workstationSubnetPrefix
    Clear-Host
    $workstationSubnetPrefix = Read-Host "laita subnetin prefix"
        if($workstationSubnet -eq ""){
        Clear-Host
        Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
        Start-sleep -Seconds 1.5
        workstationSubnetAsk
        }else{
        workstationGateawayAsk
        }
}
Function workstationGateawayAsk(){
    Clear-Host
$workstationgateIP=Read-Host "Laita Gateaway osoite"
        if($workstationgateIP -eq ""){
            Clear-Host
            Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
            Start-sleep -Seconds 1.5
            Clear-Host
            workstationGateawayAsk
        }elseif($workstationgateIP -eq $workstationIP){
            Clear-Host
            $workstationTGAsk = Read-Host "Sinun työaseman ja gateaway osoite on sama! kumman haluat vaihtaa? t/g|" -ForegroundColor Red

switch ($workstationTGAsk) {
    "t" {
        Clear-Host
        workstationIPAsk
    }
    "g" {
        Clear-Host
        workstationGateawayAsk
    }
    default {
        Clear-Host
        $workstationAnwser = Read-Host "Haluatko poistua koko ohjelmasta? k/e "
        switch ($workstationAnwser) {
            "k" {
                Clear-Host
                Write-Host "Poistutaan ohjelmasta!" -ForegroundColor Red
                Start-sleep -Seconds 1.5
                Exit
            }
            "e" {
                Clear-Host
                MainMenu
            }
            default {
                Clear-Host
                Write-Host "Epäkelpo valinta. Palataan päävalikkoon." -ForegroundColor Yellow
                Start-Sleep -Seconds 1.5
                MainMenu
            }
        }
    }
}

        }else {
        workstationDNSask
        }
}
Function workstationDNSask(){
    Clear-Host
    $workstationDNS=Read-Host "Aseta työaseman dns osoite"
    if($workstationDNS -eq ""){
        Clear-Host
        Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
        Start-sleep -Seconds 1.5
        workstationDNSask
    }else {
    workstationDNSask2
    }
}
Function workstationDNSask2(){
    Clear-Host
$workstationDNS2=Read-Host "Aseta toinen dns osoite tai paina enter jatkaaksesi "
        if($workstationDNS2 -eq ""){
            workstationADask
        }elseif($workstationDNS2 -match "[^0-9\.]+$"){
            workstationADask
        }else{
            Clear-Host
            Write-Host "Tarkista syöttämäsi osoite!" -ForegroundColor Red
            Start-sleep -Seconds 1.5
            workstationDNSask2
        }
}
Function workstationADask(){
    Clear-Host
    $workstationADname = Read-Host "laita domain nimi mihin haluat työaseman liittää"
        if($workstationADname -eq ""){
            Clear-Host
            Write-Host "Et voi jättää tätä tyhjäksi!" -ForegroundColor Red
            Start-sleep -Seconds 1.5
            Clear-Host
            workstationADask
        }else{
        ##Asetukset näytetään lopuksi
        workstationDATA
        }
}
Function workstationDATA(){
    $workstationDATA
##Tämä Functio muokkaa datan taulukoksi!
## Taulukko talletetaan DATA osioon!
$workstationDATA =@(
    ## Taulukosta tehdään kustom objekti
        [PSCustomObject]@{
            Verkkokortti = $workstationINT
            IP = $workstationIP
            Subnet = $workstationSubnetPrefix
            Gateaway = $workstationgateIP
            DNS_1 = $workstationDNS
            DNS_2 = $workstationDNS2
            Domain = $workstationADname
        }

)
workstationSettingsStat
}
Function workstationSettingsStat(){
    $workstationSettingsAsk
    ##Uusi tapa tehdä taulukoita otetaan käyttöön joka puolella!
    Clear-Host
    Write-Host "Tässä ovat sinun asettamat asetukset"
    $workstationDATA | Format-Table -AutoSize | Out-String -Width ([int]::MaxValue)
    $workstationSettingsAsk=Read-Host "Haluatko jatkaa? k/e "
        ##Vastauksen käsittely työasemissa
}
Clear-Host
workstationInterfaceAsk
}
Function workstationSetup(){
    Function workstationIPsetup(){
        if($workstationINT -match "^\d{1,2}$"){
            Write-Progress -Activity "Aloitetaan asetuksien määrittämistä!" -Status "Tehdään verkko asetuksia!" -Id 1 -PercentComplete 0
            Remove-NetIPAddress -InterfaceIndex $workstationINT
            Write-Progress -Activity "Aloitetaan asetuksien määrittäminen!" -Status "Tehdään verkko asetuksia!" -Id 1 -PercentComplete 10
            New-NetIPAddress -InterfaceIndex $workstationINT -IPAddress $workstationIP -PrefixLength $workstationSubnetPrefix -DefaultGateway $workstationgateIP
            Write-Progress -Activity "Aloitetaan asetuksien määrittäminen!" -Status "tehdään verkko asetuksia!" -Id 1 -PercentComplete 20
            Set-DnsClientServerAddress -InterfaceIndex $workstationSubnetPrefix -ServerAddresses ("$workstationDNS,$workstationDNS2")
            Write-Progress -Activity "Aloitetaan asetuksien määrittäminen!" -Status "tehdään verkko asetuksia!" -Id 1 -Completed
            Start-sleep -Seconds 1.5
            workstationADjoin
        }else{
            Write-Progress -Activity "Aloitetaan asetuksien määrittämistä!" -Status "Tehdään verkko asetuksia!" -Id 1 -PercentComplete 0
            Remove-NetIPAddress -InterfaceAlias $workstationINT
            Write-Progress -Activity "Aloitetaan asetuksien määrittäminen!" -Status "Tehdään verkko asetuksia!" -Id 1 -PercentComplete 10
            New-NetIPAddress -InterfaceAlias $workstationINT -IPAddress $workstationIP -PrefixLength $workstationSubnetPrefix -DefaultGateway $workstationgateIP
            Write-Progress -Activity "Aloitetaan asetuksien määrittäminen!" -Status "tehdään verkko asetuksia!" -Id 1 -PercentComplete 20
            Set-DnsClientServerAddress -InterfaceAlias $workstationSubnetPrefix -ServerAddresses ("$workstationDNS,$workstationDNS2")
            Write-Progress -Activity "Aloitetaan asetuksien määrittäminen!" -Status "tehdään verkko asetuksia!" -Id 1 -Completed
            Start-sleep -Seconds 1.5
            workstationADjoin
        }
    }
    Function workstationADjoin(){
        Clear-Host
        Add-Computer -DomainName $workstationADname
        Write-Host "Kone käynnistyy uudelleen 10 sekunnin päästä! :)" -ForegroundColor Red
        Start-sleep -Seconds 2
            for ($i = 9; $i -ge 0; $i--) {
                Clear-Host;Write-Host $i -ForegroundColor Red;Start-Sleep -Seconds 1
            }
        Restart-Computer -Force
    }
}
Clear-Host
MainMenu
}
main