#Faili Importimine
$kasutajad = Import-Csv C:\Users\Administrator\Downloads\kasutajad.csv

#Write-Output $kasutajad

#Loeb failist andmed rida haaval ning iga rida salvestatakse muutujasse $kasutaja massiivi kujul
foreach($kasutaja in $kasutajad){
        
        $Nimi = $kasutaja.Nimi
        $Osakond = $kasutaja.Osakond
        $PATH = "ou=kasutajad,dc=oige,dc=local"
        $OU = "ou=$osakond,ou=kasutajad,dc=oige,dc=local"
        $parool = "Passw0rd"
        
#Kontrollitakse kas loodav kasutaja on juba olemas ning tulemus salvestatakse muutujasse $ktest
        $ktest = $(try {Get-ADUser "$Nimi"} catch{$Null})

#Kontrollitakse, kas OU on olemas, kuhu kasutajat looma hakatakse ning vajadusel luuakse vastav OU
    if (Get-ADOrganizationalUnit -F "Distinguishedname -eq '$ou'")
        {
            Write-Output "OU $ou on juba olemas"
        }
    else
        {
            New-ADOrganizationalUnit  -name $OSAKOND -PATH $PATH
            Write-Output "AD-sse lisati OU nimega $OSAKOND"
        
        }
#Kasutaja loomine koos kontrollig
    if ($ktest -ne $null){
        Write-Output "Kasutaja $Nimi on juba olemas"
      
    }
    else
    {
        New-ADUser `
            -Name "$Nimi" `
            -SamAccountName $Nimi `
            -path $OU `
            -Enabled $true `
            -AccountPassword (ConvertTo-SecureString $parool -AsPlainText -Force) -ChangePasswordAtLogon $true
        
        Write-Output "Lisati kasutaja $Nimi"
      }     
 }
