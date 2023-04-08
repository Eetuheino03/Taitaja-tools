
Function Main() {
$ComputerIP = (Test-Connection -ComputerName $env:computername -count 1).ipv4address.IPAddressToString
Clear-Host
$valintaS = 0
Write-host "Valitse asetukset mitk‰ haluat m‰‰ritt‰‰!"
$valintaS = Read-host "
                      Name:$env:COMPUTERNAME | IP:$ComputerIP
                      <------------------------------>
                      | 1. Palvelin valmistelu       |           Huomaa! .xml conf tiedosto tarvitsee 
                      | 2. AD valmistelu             |  olla samassa kansiossa ett‰ ominaisuus asennukset toimivat!
                      | 3. (ominaisuus tulossa!)     |  
                      | 4. Poistu                    |
                      | 5. Versio                    |         
                      | "
                                                    
if($valintaS -eq 1) {
Clear-Host
Write-Host "Aloitetaan normaali konfiguraatio!"
sleep -Seconds 2
Clear-Host
hostAsk
}elseif($valintaS -eq 2){
Clear-Host
Write-Host "Aloitetaan AD pystytys!"
sleep -Seconds 2
Clear-Host
adASK
}elseif($valintaS -eq 3){
    Clear-Host
    sleep -Seconds 2
    Clear-Host
    Main
}elseif($valintaS -eq 4){
Clear-Host
Write-Host "poistutaan!"
sleep -Seconds 2
exit
}elseif($valintaS -eq 5){
Clear-Host
Write-Host "Siirryt‰‰n versio valikkoon!"
versioControl
}else {
Write-Host "Et valinnut mit‰‰n valitse uudelleen!"
sleep -Seconds 2
Main
}
}
Function hostAsk(){
$ComputerName = Read-host "Ennen asennusta aseta koneen nimi"
Clear-Host
Networkask
}
Function UudelleenSuoritus(){
If($reask -eq 'k'){
Clear-Host
hostAsk
}else {
Clear-Host
$vastausUudelleenS= Read-Host "Haluatko palata p‰‰valikkoon vai sulkea ohjelman? p/s"
if($vastausUudelleenS -eq "p" ){
Clear-Host
Write-Host "Ohjataan p‰‰valikkoon!"
Main
}
if($vastausUudelleenS -eq "s"){
Clear-Host
Write-Host "Suljetaan ohjelma!"
sleep -Seconds 2
Exit
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
    Write-Host "Et voi j‰tt‰‰ t‰t‰ tyhj‰ksi!"
    sleep -Seconds 2
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
Write-Host "T‰m‰ kohta ei voi olla tyhj‰!"
sleep -Seconds 2
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
Write-Host "T‰t‰ osiota ei voi j‰tt‰‰ tyhj‰ksi!"
sleep -Seconds 2
Clear-Host
subnetS
}elseif($Subnetprefix -in 8..30) {
gateawayS
}else{
Clear-Host
Write-Host "Valitse kunnon Subnetprefix"
sleep -Seconds 2
Clear-Host
subnetS
}
}
Function gateawayS(){
$GatewayIP = Read-Host "Aseta Gateaway osoite "
Clear-Host
Function checkgatawayC(){
$gateawayAnwser = Read-host "Haluatko muuttaa staattisen osoitteen vai gateaway osoitteen? s/g |"
    if($gateawayAnwser -eq "s") {
    Clear-Host
    Write-Host "Sinut ohjataan staatisen osoitteen asettamiseen!"
    sleep -Seconds 2
    Clear-Host
    ComputeripS
    }elseif($gateawayAnwser -eq "g"){
    Clear-Host
    Write-Host "Sinut ohjataan gateaway asettamiseen!"
    sleep -Seconds 2
    Clear-Host
    gateawayS
    }elseif($gateawayAnwser -eq ""){
    Clear-Host
    Write-Host "Et voi j‰tt‰‰ t‰t‰ tyhj‰ksi!"
    sleep -Seconds 2
    Clear-Host
    checkgatawayC
    }}
If($ComputerIP -eq $GatewayIP){
Write-Host "Virheellinen osoite! $ComputerIP ja $GatewayIP ovat samat!!"
Write-Host "Aseta asetukset uudelleen!"
sleep -Seconds 2
Clear-Host
checkgatawayC
}else {
if($GatewayIP -eq ""){
Clear-Host
Write-Host "Et voi j‰tt‰‰ t‰t‰ tyhj‰ksi!"
sleep -Seconds 2
Clear-Host
gateawayS
}else {
asetuksetSTAT
}
}
}
adapterSelect
}
Function asetuksetSTAT() {
Write-Output "Yhteen veto Asetuksista: "
Write-Output "Koneen nimeksi asetettu: $ComputerName"
Write-Output "Valitsemasi verkkokortin Indexi tai nimi: $InterFaceINDEX"
Write-Output "Koneen osoitteeksi asetettu: $ComputerIP"
Write-Output "Koneen Subnetin prefix on: $Subnetprefix"
Write-Output "Default-Gateaway on asetettu: $GatewayIP"
$Startconf = Read-Host "Haluatko jatkaa k/e?"
if($Startconf -eq 'k'){
Clear-host
Write-Host "Aloitetaan konfiguraatiota!"
timeask
}else {
Clear-Host
Write-Host "Et halunnut aloittaa konfiguraatio skripti‰!"
$reask = Read-Host "Haluatko aloittaa sen uudelleen? k/e"
UudelleenSuoritus
}
}
Function timeask(){
$time = Read-Host "Aseta nopeus toimintojen v‰lill‰ sekunnissa, paina enter tai syˆt‰ lukema. Normaalisti 5 sekuntia!"
if ( $time -in 1..10)      {
    $timeto = $time
    setup-script
}else {
    $timeto = 5
    setup-script
}
}
Function setup-script() {
Clear-Host
Write-Progress -Activity "tehd‰‰n asetuksia" -Status "Aloitetaan!" -Id 1 -PercentComplete 0

Write-Progress -Activity "tehd‰‰n asetuksia" -Status "Asetetaan nime‰: $ComputerName" -Id 2 -ParentId 1 -PercentComplete 0
Rename-computer -ComputerName $env:COMPUTERNAME -NewName $ComputerName
sleep -Seconds $timeto
Write-Progress -Activity "tehd‰‰n asetuksia" -Status "Koneelle on asetettu nimi: $ComputerName" -Id 2 -ParentId 1 -Completed
sleep -Seconds $timeto
Write-Progress -Activity "tehd‰‰n asetuksia" -Status "Aloitetaan!" -Id 1 -PercentComplete 20
sleep -Seconds $timeto
#Verkko kohta!
Write-Progress -Activity "tehd‰‰n asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 0
# Tarkistaa Interface syˆttˆ muodon
If($InterFaceINDEX -match "^\d{1,2}$"){
 Write-Progress -Activity "tehd‰‰n asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 10
 sleep -Seconds $timeto
 Remove-NetIPAddress -InterfaceIndex $InterFaceINDEX
 Write-Progress -Activity "tehd‰‰n asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 50
 sleep -Seconds $timeto
 New-NetIPAddress -InterfaceIndex $InterFaceINDEX -IPAddress $ComputerIP -PrefixLength $Subnetprefix -DefaultGateway $GatewayIP
 Write-Progress -Activity "tehd‰‰n asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 90
 sleep -Seconds $timeto
}else {
 Write-Progress -Activity "tehd‰‰n asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 10
 sleep -Seconds $timeto
 Remove-NetIPAddress -InterfaceAlias $InterFaceINDEX
 Write-Progress -Activity "tehd‰‰n asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 50
 sleep -Seconds $timeto
 New-NetIPAddress -InterfaceAlias $InterFaceINDEX -IPAddress $ComputerIP -PrefixLength $Subnetprefix -DefaultGateway $GatewayIP
 Write-Progress -Activity "tehd‰‰n asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 90
 sleep -Seconds $timeto
 
}

 
sleep -Seconds $timeto
Write-Progress -Activity "tehd‰‰n asetuksia" -Status "Verkko asetukset asetettu: Interfaceindex $InterFaceINDEX, IP osoite: $ComputerIP Subnetinprefix: $Subnetprefix Gateaway: $GatewayIP" -Id 2 -ParentId 1 -Completed
sleep -Seconds $timeto
Write-Progress -Activity "tehd‰‰n asetuksia" -Status "Aloitetaan!" -Id 1 -PercentComplete 60
sleep -Seconds $timeto
#Verkko kohta loppuu!



Write-Progress -Activity "tehd‰‰n asetuksia" -Status "Asennetaan ominaisuuksia!" -Id 2 -ParentId 1 -PercentComplete 0
Install-WindowsFeature ñConfigurationFilePath DeploymentConfigTemplate.xml
sleep -Seconds $timeto
Write-Progress -Activity "tehd‰‰n asetuksia" -Status "Ominaisuudet asenettu" -Id 2 -ParentId 1 -Completed
sleep -Seconds $timeto

Write-Progress -Activity "Tehd‰‰n asetuksia" -Status "Asetukset tehty! K‰ynnistet‰‰n uudelleen!" -Id 1 -Completed
Write-Output "Kone k‰ynnistyy uudelleen 10 sekunnin p‰‰st‰!"
Write-Output "$timeto"
sleep -Seconds 10
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

# K‰ynnist‰ uudelleen ja aseta asetukset!
Write-Host "Talleta kaikki keskener‰iset tyˆt! Kone k‰ynnistyy uudelleen 30 sekunnin p‰‰st‰!"
Sleep 30

Try{
    Restart-Computer -ComputerName $env:computername -ErrorAction Stop
    Write-Host "Kone k‰ynnistyy uudelleen!!" -ForegroundColor Green
    }
Catch{
     Write-Warning -Message $("Virhe tuli k‰ynnist‰ess‰ konetta uudelleen! $($env:computername). Error: "+ $_.Exception.Message)
     Break;
     }
}
Function adASK(){

$DomainName = ""

Function adask1(){
$DomainName = Read-Host "Aseta toimialueen nimi"
if($DomainName -eq ""){
Clear-Host
Write-Host "Toimialueen nime‰ ei ole laitettu!"
Clear-Host
adask1
}else {
adsetup
}
}
  adask1
}
Function versioControl(){
Clear-Host
Write-Host " Versio: 0.65 (stable)
By: Eetu Heino
---------------- 
Tervetuloa K‰ytt‰m‰‰n automoitua
Microsoft palvelimen konfiguraatio
          tyˆkalua"  
$valintaVersio = Read-Host "Haluatko Takaisin p‰‰valikkoon? k/e |"
#Palautus Functio!
if($valintaVersio -eq "k"){
Write-Host "Palataan!"
sleep -Seconds 2
Clear-Host
Main
}elseif($valintaVersio = "e"){
Write-Host "Haluatko poistua skriptist‰ kokonaan?"
$valintaVersio = Read-Host "k/e|"
if($valintaVersio -eq "k"){
Clear-Host
Write-Host "Poistutaan!"
sleep -Seconds 2
Clear-Host
exit
}else {
Clear-Host
versioControl
}

}


}


main
