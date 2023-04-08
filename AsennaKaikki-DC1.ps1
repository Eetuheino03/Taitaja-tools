
Function Main() {
Clear-Host
$valintaS = 0
Write-host "Valitse asetukset mitkä haluat määrittää!"
$valintaS = Read-host "
                      Name:$ComputerName|IP:$ComputerIP
                      <------------------------------>
                      | 1. Palvelin valmistelu       |           Huomaa! .xml conf tiedosto tarvitsee 
                      | 2. AD valmistelu             |
                      | 3. (ominaisuus tulossa!)     |  olla samassa kansiossa että ominaisuus asennukset toimivat!
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
Write-Host "Siirrytään versio valikkoon!"
versioControl
}else {
Write-Host "Et valinnut mitään valitse uudelleen!"
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
$vastausUudelleenS= Read-Host "Haluatko palata päävalikkoon vai sulkea ohjelman? p/s"
if($vastausUudelleenS -eq "p" ){
Clear-Host
Write-Host "Ohjataan päävalikkoon!"
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
    Write-Host "Et voi jättää tätä tyhjäksi!"
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
Write-Host "Tämä kohta ei voi olla tyhjä!"
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
Write-Host "Tätä osiota ei voi jättää tyhjäksi!"
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
    Write-Host "Et voi jättää tätä tyhjäksi!"
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
Write-Host "Et voi jättää tätä tyhjäksi!"
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
Write-Host "Et halunnut aloittaa konfiguraatio skriptiä!"
$reask = Read-Host "Haluatko aloittaa sen uudelleen? k/e"
UudelleenSuoritus
}
}
Function timeask(){
$time = Read-Host "Aseta nopeus toimintojen välillä sekunnissa, paina enter tai syötä lukema. Normaalisti 5 sekuntia!"
if ( $time -in 1..10)
      {
    $timeto = $time
    setup-script
}else {
    $timeto = 5
    setup-script
}
}
Function setup-script() {
Clear-Host
Write-Progress -Activity "tehdään asetuksia" -Status "Aloitetaan!" -Id 1 -PercentComplete 0

Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan nimeä: $ComputerName" -Id 2 -ParentId 1 -PercentComplete 0
Rename-computer -ComputerName $env:COMPUTERNAME -NewName $ComputerName
sleep -Seconds $timeto
Write-Progress -Activity "tehdään asetuksia" -Status "Koneelle on asetettu nimi: $ComputerName" -Id 2 -ParentId 1 -Completed
sleep -Seconds $timeto
Write-Progress -Activity "tehdään asetuksia" -Status "Aloitetaan!" -Id 1 -PercentComplete 20
sleep -Seconds $timeto
#Verkko kohta!
Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 0
# Tarkistaa Interface syöttö muodon
If($InterFaceINDEX -match '[0-9]' ){
 Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 10
 sleep -Seconds $timeto
 Remove-NetIPAddress -InterfaceIndex $InterFaceINDEX
 Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 50
 sleep -Seconds $timeto
 New-NetIPAddress -InterfaceIndex $InterFaceINDEX -IPAddress $ComputerIP -PrefixLength $Subnetprefix -DefaultGateway $GatewayIP
 Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 90
 sleep -Seconds $timeto
}else {
 Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 10
 sleep -Seconds $timeto
 Remove-NetIPAddress -InterfaceAlias $InterFaceINDEX
 Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 50
 sleep -Seconds $timeto
 New-NetIPAddress -InterfaceAlias $Subnetprefix -IPAddress $ComputerIP -PrefixLength $Subnetprefix -DefaultGateway $GatewayIP
 Write-Progress -Activity "tehdään asetuksia" -Status "Asetetaan Verkko asetuksia!" -Id 2 -ParentId 1 -PercentComplete 90
 sleep -Seconds $timeto
 
}

 
sleep -Seconds $timeto
Write-Progress -Activity "tehdään asetuksia" -Status "Verkko asetukset asetettu: Interfaceindex $InterFaceINDEX, IP osoite: $ComputerIP Subnetinprefix: $Subnetprefix Gateaway: $GatewayIP" -Id 2 -ParentId 1 -Completed
sleep -Seconds $timeto
Write-Progress -Activity "tehdään asetuksia" -Status "Aloitetaan!" -Id 1 -PercentComplete 60
sleep -Seconds $timeto
#Verkko kohta loppuu!



Write-Progress -Activity "tehdään asetuksia" -Status "Asennetaan ominaisuuksia!" -Id 2 -ParentId 1 -PercentComplete 0
Install-WindowsFeature –ConfigurationFilePath DeploymentConfigTemplate.xml
sleep -Seconds $timeto
Write-Progress -Activity "tehdään asetuksia" -Status "Ominaisuudet asenettu" -Id 2 -ParentId 1 -Completed
sleep -Seconds $timeto

Write-Progress -Activity "Tehdään asetuksia" -Status "Asetukset tehty! Käynnistetään uudelleen!" -Id 1 -Completed
Write-Output "Kone käynnistyy uudelleen 10 sekunnin päästä!"
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

# Käynnistä uudelleen ja aseta asetukset!
Write-Host "Talleta kaikki keskeneräiset työt! Kone käynnistyy uudelleen 30 sekunnin päästä!"
Sleep 30

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

$DomainName = ""

Function adask1(){
$DomainName = Read-Host "Aseta toimialueen nimi"
if($DomainName -eq ""){
Clear-Host
Write-Host "Toimialueen nimeä ei ole laitettu!"
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
Write-Host " Versio: 0.60
By: Eetu Heino
---------------- 
Tervetuloa Käyttämään automoitua
Microsoft palvelimen konfiguraatio
          työkalua"  
$valintaVersio = Read-Host "Haluatko Takaisin päävalikkoon? k/e |"
#Palautus Functio!
if($valintaVersio -eq "k"){
Write-Host "Palataan!"
sleep -Seconds 2
Clear-Host
Main
}elseif($valintaVersio = "e"){
Write-Host "Haluatko poistua skriptistä kokonaan?"
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
