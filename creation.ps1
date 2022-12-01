#Создание новых пользователей
Import-Module sqlserver
$Logfile = "C:\Vault\Log\Creation.log"

Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}
 
$employeestexnopark = Invoke-Sqlcmd -ServerInstance 'X.X.X.X' -Database 'ARTDB' -Username 'sa' -Password 'PASSWORD' -Query 'SELECT * FROM Imported1CusersArtel where user_id > 10000'
#LogWrite $employeestexnopark


#Generate from ADImport-Module ActiveDirectory
Get-ADUser -Server "FQDN DOMAIN CONTROLLER" -Filter * -Properties * |select *, @{n='ParentContainer';e={$_.distinguishedname -replace '^.+?,(CN|OU.+)','$1'}} |
? { ($_.ParentContainer -notlike '*Builtin*')}| Export-Csv c:\Vault\currentADUsercreation.csv -Delimiter ";" -Encoding "UTF8" -NoTypeInformation

$CurrentADMatrixtexnopark = Import-Csv C:\Vault\currentADUsercreation.csv -Delimiter ";" -Encoding "UTF8"


foreach ($User in $employeestexnopark)
{#Reset all variables
Clear-Variable 1CState, Password, 1CFirstname, 1CMiddlename, 1CLastname, 1CFullName, 1CTitle, 1CStateBoolean, 1CEmpDate, 1CDepartment,  1CDescription, 1CUserPrincipalName, 1CMail,  1CSAMAccount, 1CPINI, 1COU, TEMPGUID, 1CSAMAccount1,1CCollar, 1CPhone
$Password = "PASSWORD"
$1CFirstname = $User.Name
$1CMiddlename = $User.Patronymic
$1CLastname = $User.Surname
$1CFullName = $User.Surname + " " + $User.Name  + " " +  $User.Patronymic
$1CTitle = $User.Position
$1CState = $User.Status
$1CStateBoolean ="Unknown"
if ($1CState -eq 1){
$1CStateBoolean = "True"}
if ($1CState -eq 2){
$1CStateBoolean = "False"}
$1CEmpDate = $User.DateOfEmployment.ToString("dd.MM.yyyy")
$1CDepartment = $User.Department.SubString(0,[math]::min(63,$User.Department.length) )
$1CUserPrincipalName = $User.ADLogin + "@artelelectronics.com"
$1CMail = $User.ADLogin +"@artelelectronics.com"
$1CSAMAccount = $User.user_id
$1CSAMAccount1 = "1"+$1CSAMAccount
$1CPINI = $User.PINI
$1CTIN = $User.TIN
$1COU = $User.OU
$1CCollar = $User.staffcategory
$1cphone = $User.Phonenumber
if ($1CState -eq 2){$1CDescription = $1CTitle+". Дата приёма "+$1CEmpDate+". Уволен."}else{$1CDescription = $1CTitle+". Дата приёма "+$1CEmpDate}
$CurrentAD = $CurrentADMatrixtexnopark | Where-Object PostalCode -EQ $1CPINI
#LogWrite $1CStateBoolean
#LogWrite $CurrentAD
#LogWrite "-------"
#LogWrite $CurrentAD.ObjectGUID
$TEMPGUID = $null
$TEMPGUID = $CurrentAD.ObjectGUID
  if ( $TEMPGUID -ne $null )
  {
  <#LogWrite "#checkandupdateADuser"
        
        if ( $1CSAMAccount -ne $CurrentAD.SamAccountName)
            {$TEMPSAMAccountName = $CurrentAD.SamAccountName
            $Message = "     Previous SAMACCOUNTname "+ $TEMPSAMAccountName + " is not equal to new " + $1CSAMAccount
           LogWrite   $Message -ForegroundColor RED
            Set-ADUser -Server "FQDN DOMAIN CONTROLLER" -identity $TEMPGUID -Replace @{samaccountname=$1CSamAccount}
            $Message1 = "     Updated previous SAMAccountName " + $TEMPSAMAccountName + " to " + $1CSamAccount
           LogWrite $Message1 -ForegroundColor RED
            }
        else
            {$TEMPSAMAccountName = $CurrentAD.SamAccountName
            $Message = "     Previous SAMACCOUNTname "+ $TEMPSAMAccountName + " is equal to new " + $1CSAMAccount
           LogWrite $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
           LogWrite $Message1 -ForegroundColor GREEN 
            }
        
        
        if ( $1CUserPrincipalName -ne $CurrentAD.UserPrincipalName)
            {$TEMPUserPrincipalName = $CurrentAD.UserPrincipalName
            $Message = "     Previous UserPrincipalName "+ $TEMPUserPrincipalName + " is not equal to new " + $1CUserPrincipalName
            LogWrite   $Message -ForegroundColor RED
            Set-ADUser -Server "TSM-DC01.domain.artelgroup.org" -identity $TEMPGUID -UserPrincipalName $1CUserPrincipalName
            $Message1 = "     Updated previous UserPrincipalName " + $TEMPUserPrincipalName + " to " + $1CUserPrincipalName
            LogWrite $Message1 -ForegroundColor RED
            }
        else
            {$TEMPUserPrincipalName = $CurrentAD.UserPrincipalName
            $Message = "     Previous UserPrincipalName "+ $TEMPUserPrincipalName + " is equal to new " + $1CUserPrincipalName
            LogWrite $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            LogWrite $Message1 -ForegroundColor GREEN 
            }
        
        
        if ($1CFirstname -ne $CurrentAD.GivenName)
            {$TEMPFirstname = $CurrentAD.GivenName
            $Message = "     Previous Firstname "+ $TEMPFirstname + " is not equal to new " + $1CFirstname
            LogWrite   $Message -ForegroundColor RED
            Set-ADUser -Server "FQDN DOMAIN CONTROLLER" -identity $TEMPGUID -GivenName $1CFirstname
            $Message1 = "     Updated previous Firstname " + $TEMPFirstname + " to " + $1CFirstname
            LogWrite $Message1 -ForegroundColor RED
            }
        else
            {$TEMPFirstname = $CurrentAD.GivenName
            $Message = "     Previous Firstname "+ $TEMPfirstname + " is equal to new " + $1Cfirstname
            LogWrite $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            LogWrite $Message1 -ForegroundColor GREEN
            }

            if ($1CLastname -ne $CurrentAD.Surname)
            {$TEMPLastname = $CurrentAD.Surname
            $Message = "     Previous lastname "+ $TEMPLastname + " is not equal to new " + $1Clastname
            LogWrite   $Message -ForegroundColor RED
            Set-ADUser -Server "FQDN DOMAIN CONTROLLER" -identity $TEMPGUID -Surname $1Clastname
            $Message1 = "     Updated previous lastname " + $TEMPlastname + " to " + $1Clastname
            LogWrite $Message1 -ForegroundColor RED
            }

        else
            {$TEMPLastname = $CurrentAD.Surname
            $Message = "     Previous Lastname "+ $TEMPLastname + " is equal to new " + $1CLastname
            LogWrite $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            LogWrite $Message1 -ForegroundColor GREEN
            }

        if ($1CFullName -ne $CurrentAD.DisplayName)
            {$TEMPFullName = $CurrentAD.DisplayName
            $Message = "     Previous DisplayName "+ $TEMPFullName + " is not equal to new " + $1CFullName
            LogWrite   $Message -ForegroundColor RED
            Set-ADUser -Server "FQDN DOMAIN CONTROLLER" -identity $TEMPGUID -DisplayName $1CFullName
            $Message1 = "     Updated previous DisplayName " + $TEMPFullName + " to " + $1CFullName
            LogWrite $Message1 -ForegroundColor RED
            }
        else
            {$TEMPFullName = $CurrentAD.DisplayName
            $Message = "     Previous DisplayName "+ $TEMPFullName + " is equal to new " + $1CFullName
            LogWrite $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            LogWrite $Message1 -ForegroundColor GREEN
            }
            
        if ($1CFullName -ne $CurrentAD.CN)
            {$TEMPCN = $CurrentAD.CN
            $Message = "     Previous CN "+ $TEMPCN + " is not equal to new " + $1CFullName
            LogWrite   $Message -ForegroundColor RED
            Get-ADUser -Server "FQDN DOMAIN CONTROLLER" -identity $TEMPGUID  | Rename-ADObject -NewName $1CFullName
            $Message1 = "     Updated previous CN " + $TEMPCN + " to " + $1CFullName
            LogWrite $Message1 -ForegroundColor RED
            }
        else
            {$TEMPCN = $CurrentAD.CN
            $Message = "     Previous CN "+ $TEMPCN + " is equal to new " + $1CFullName
            LogWrite $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            LogWrite $Message1 -ForegroundColor GREEN
            }

        if ($1CTitle -ne $CurrentAD.Title)
            {$TEMPTitle = $CurrentAD.Title
            $Message = "     Previous Title "+ $TEMPTitle + " is not equal to new " + $1CTitle
            LogWrite   $Message -ForegroundColor RED
            Set-ADUser -Server "FQDN DOMAIN CONTROLLER" -identity $TEMPGUID -Title $1CTitle
            $Message1 = "     Updated previous Title " + $TEMPTitle + " to " + $1CTitle
            LogWrite $Message1 -ForegroundColor RED
            }
        else
            {$TEMPTitle = $CurrentAD.Title
            $Message = "     Previous Title "+ $TEMPTitle + " is equal to new " + $1CTitle
            LogWrite $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            LogWrite $Message1 -ForegroundColor GREEN
            }
              
            #---------  
              
        if (($1StateBoolean -eq "True") -and ($CurrentAD.Enabled -eq "False"))
            {
           Enable-ADAccount -Server "FQDN DOMAIN CONTROLLER" -identity $TEMPGUID
            $Message1 = "    Account was disabled and enabled now"
            LogWrite ($1StateBoolean -ne $CurrentAD.Enabled)
            LogWrite ($CurrentAD.Enabled -eq "False")
            LogWrite "------------" 
            LogWrite $1StateBoolean
            LogWrite $CurrentAD.Enabled
            LogWrite "------------" 
            LogWrite $Message1 -ForegroundColor GREEN
            Start-Sleep -s 10
            }

         if (($1CStateBoolean -eq "False") -and ($CurrentAD.Enabled -eq "True"))
            {
           Disable-ADAccount -Server "FQDN DOMAIN CONTROLLER" -identity $TEMPGUID
            $Message1 = "    Account was enabled and disabled now"
            LogWrite ($1CStateBoolean -ne $CurrentAD.Title)
            LogWrite ($CurrentAD.Enabled -eq "True")
            LogWrite "------------"
            LogWrite $1CStateBoolean 
            LogWrite $CurrentAD.Enabled
            LogWrite "------------" 
            LogWrite $Message1 -ForegroundColor RED
            }
            #-----------

         if ($1CDepartment -ne $CurrentAD.Department)
            {$TEMDepartment = $CurrentAD.Department
            $Message = "     Previous Department "+ $TEMPDepartment + " is not equal to new " + $1CDepartment
            LogWrite   $Message -ForegroundColor RED
            Set-ADUser -Server "FQDN DOMAIN CONTROLLER" -identity $TEMPGUID -Department $1CDepartment
            $Message1 = "     Updated previous Department " + $TEMPDepartment + " to " + $1CDepartment
            LogWrite $Message1 -ForegroundColor RED
            }
        else
            {$TEMDepartment = $CurrentAD.Department
            $Message = "     Previous Department "+ $TEMDepartment + " is equal to new " + $1CDepartment
            LogWrite $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            LogWrite $Message1 -ForegroundColor GREEN
            }

         if ($1CDepartment -ne $CurrentAD.Office)
            {$TEMPOffice = $CurrentAD.Office
            $Message = "     Previous Office "+ $TEMPOffice + " is not equal to new " + $1CDepartment
            LogWrite   $Message -ForegroundColor RED
            Set-ADUser -Server "FQDN DOMAIN CONTROLLER" -identity $TEMPGUID -Office $1CDepartment
            $Message1 = "     Updated previous Office " + $TEMPOffice + " to " + $1CDepartment
            LogWrite $Message1 -ForegroundColor RED
            }
        else
            {$TEMPOffice = $CurrentAD.Office
            $Message = "     Previous Office "+ $TEMPOffice + " is equal to new " + $1CDepartment
            LogWrite $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            LogWrite $Message1 -ForegroundColor GREEN
            }
            
           
            
         if ($1COU -ne $CurrentAD.ParentContainer)
            {$TEMPParentContainer = $CurrentAD.ParentContainer
             $Message = "     Previous ParentContainer "+ $TEMPParentContainer + " is not equal to new " + $1COU
             LogWrite $Message -ForegroundColor RED
             Move-ADObject  -Server "FQDN DOMAIN CONTROLLER" -Identity $TEMPGUID -TargetPath $1COU
             $Message1 = $1CDescription + " moved to " + $1COU
             LogWrite $Message1 -ForegroundColor RED}
         else
            {$TEMPParentContainer = $CurrentAD.ParentContainer
             $Message = "     Previous ParentContainer "+ $TEMPParentContainer + " is equal to new " + $1COU
             LogWrite $Message -ForegroundColor GREEN
             $Message1 = "     Nothing to do"
             LogWrite $Message1 -ForegroundColor GREEN
            }

         if ($1CDescription -ne $CurrentAD.Description)
            {$TEMPDescription = $CurrentAD.Description
            $Message = "     Previous Description "+ $TEMPDescription + " is not equal to new " + $1CDescription
            LogWrite   $Message -ForegroundColor RED
            Set-ADUser -Server "FQDN DOMAIN CONTROLLER" -identity $TEMPGUID -Description $1CDescription
            $Message1 = "     Updated previous Description " + $TEMPDescription + " to " + $1CDescription
            LogWrite $Message1 -ForegroundColor RED
            }
        else
            {$TEMPDescription = $CurrentAD.Description
            $Message = "     Previous Description "+ $TEMPDescription + " is equal to new " + $1CDescription
            LogWrite $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            LogWrite $Message1 -ForegroundColor GREEN
            }
  LogWrite "ENDcheckandupdateADuser"
  #>}

  else
  {
  if ($1CCollar -eq 'White Collar')
   
  {
  LogWrite "User $1CUserPrincipalName | $1CSAMAccount|$1CDepartment created as activated"
  Write-Host "TEST! User $1CUserPrincipalName | $1CSAMAccount|$1CDepartment created as activated"
  New-ADUser -Server "FQDN DOMAIN CONTROLLER" -Name $1CFullName -displayName $1CFullName -GivenName $1CFirstname -Surname $1CLastname -EmailAddress $1CMail -SamAccountName $1CSamAccount -UserPrincipalName $1CUserPrincipalName -EmployeeID $1CPINI -Title $1CTitle -Description $1CDescription -Path $1COU -OfficePhone $1cphone -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -force) -Enabled $true -Department $1CDepartment -PostalCode $1CPINI
  #New-Mailbox -Name $1CFullName -UserPrincipalName $1CUserPrincipalName -Password (ConvertTo-SecureString -String 'Artel2022' -AsPlainText -Force)  -FirstName $1CFirstname -LastName $1CLastname
 
  }
  else
  {LogWrite "User $1CUserPrincipalName | $1CSAMAccount|$1CDepartment  created as deactivated"
  Write-Host "TEST! User $1CUserPrincipalName | $1CSAMAccount|$1CDepartment  created as deactivated"
  New-ADUser -Server "FQDN DOMAIN CONTROLLER" -Name $1CFullName -displayName $1CFullName -GivenName $1CFirstname -Surname $1CLastname -EmailAddress $1CMail -SamAccountName $1CSamAccount -UserPrincipalName $1CUserPrincipalName -EmployeeID $1CPINI -Title $1CTitle -OfficePhone $1cphone -Description $1CDescription -Path $1COU -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -force)  -Enabled $false -Department $1CDepartment -PostalCode $1CPINI
  LogWrite "END#CreateADuser" 
  Write-Host "END#CreateADuser"
  
  }
  
  Start-Sleep -s 3}



}

#-Department $1CDepartment