#Обновление пользователей
#SHAXA
#Clear Manager
#Clear Member_of_Group
#Update_OrganizationName
#Update_Supervisor_Department_Director_ATTRIBUTE---->st

Import-Module sqlserver
$Logfile = "C:\Vault\Log\Update.log"

Function Write-FileLog
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}
$employeestexnopark = Invoke-Sqlcmd -ServerInstance '192.168.12.17' -Database 'ARTDB' -Username 'sa' -Password 'Aa123456' -Query 'SELECT * FROM Imported1CusersArtel Where StructureCode = 11766'
Write-Host $employeestexnopark


#Генерация выгрузки из ADImport-Module ActiveDirectory
Get-ADUser -Server "TSM-DC01.domain.artelgroup.org" -Filter * -Properties GivenName, Surname, SamAccountName, DisplayName, ObjectGUID, CN, Title, UserPrincipalName, Enabled, PostalCode, EmployeeID, Department, Office, Description, Company, streetAddress, st |select *, @{n='ParentContainer';e={$_.distinguishedname -replace '^.+?,(CN|OU.+)','$1'}} |
? { ($_.ParentContainer -notlike '*Builtin*')}| Export-Csv c:\Vault\currentADUsersartelupdate.csv -Delimiter ";" -Encoding "UTF8" -NoTypeInformation
$CurrentADMatrixtexnopark = Import-Csv C:\Vault\currentADUsersartelupdate.csv -Delimiter ";" -Encoding "UTF8"



foreach ($User in $employeestexnopark){
#Сброс всех переменных
Clear-Variable 1CState, Password, 1CFirstname, 1CMiddlename, 1CLastname, 1CFullName, 1CTitle, 1CStateBoolean, 1CEmpDate, 1CDepartment,  1CDescription, 1CUserPrincipalName, 1CMail,  1CSAMAccount, 1CPINI, 1COU, TEMPGUID, 1CSAMAccount1,1CCollar
$Password = "Aa123456"
$Company = $User.OrganizationName
$1CSupervisorName = $User.SupervisorName
Write-Host $Company
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
$1CDepartment =$User.Department
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
Write-Host "-----"
Write-Host $Password
Write-Host $1CFullName
Write-Host $1CTitle
Write-Host $1CStateBoolean
Write-Host $1CDescription 
Write-Host $1CDepartment
Write-Host $1CUserPrincipalName
Write-Host $1CSAMAccount
Write-Host $1CPINI

$CurrentAD = $CurrentADMatrixtexnopark | Where-Object PostalCode -EQ $1CPINI
#Write-Host $1CStateBoolean
Write-Host $1CPINI
Write-Host "-------"
Write-Host  $CurrentAD
$TEMPGUID = $CurrentAD.ObjectGUID
  if ( $TEMPGUID -ne $null )
  {Write-Host "tempguid" $TEMPGUID
  Set-ADUser -Server "TSM-DC01.domain.artelgroup.org" -identity $TEMPGUID -EmployeeID $1CPINI
  Write-Host "#checkandupdateADuser"
        
        if ( $1CSAMAccount -ne $CurrentAD.SamAccountName)
            {$TEMPSAMAccountName = $CurrentAD.SamAccountName
            $Message = "     Previous SAMACCOUNTname "+ $TEMPSAMAccountName + " is not equal to new " + $1CSAMAccount
            Write-Host $Message - ForegroundColor RED
            Set-ADUser -Server "TSM-DC01.domain.artelgroup.org" -identity $TEMPGUID -Replace @{samaccountname=$1CSamAccount}
            $Message1 = "     Updated previous SAMAccountName " + $TEMPSAMAccountName + " to " + $1CSamAccount
           Write-Host $Message1 -ForegroundColor RED
            }
        else
            {$TEMPSAMAccountName = $CurrentAD.SamAccountName
            $Message = "     Previous SAMACCOUNTname "+ $TEMPSAMAccountName + " is equal to new " + $1CSAMAccount
           Write-Host $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
           Write-Host $Message1 -ForegroundColor GREEN 
            }
        
        
        if ( $1CUserPrincipalName -ne $CurrentAD.UserPrincipalName)
            {#$TEMPUserPrincipalName = $CurrentAD.UserPrincipalName
            #$Message = "     Previous UserPrincipalName "+ $TEMPUserPrincipalName + " is not equal to new " + $1CUserPrincipalName
            #Write-Host   $Message -ForegroundColor RED
            #Set-ADUser -Server "TSM-DC01.domain.artelgroup.org" -identity $TEMPGUID -UserPrincipalName $1CUserPrincipalName
            #$Message1 = "     Updated previous UserPrincipalName " + $TEMPUserPrincipalName + " to " + $1CUserPrincipalName
            #Write-Host $Message1 -ForegroundColor RED
            }
        else
            {#$TEMPUserPrincipalName = $CurrentAD.UserPrincipalName
            #$Message = "     Previous UserPrincipalName "+ $TEMPUserPrincipalName + " is equal to new " + $1CUserPrincipalName
            #Write-Host $Message -ForegroundColor GREEN
            #$Message1 = "     Nothing to do"
            #Write-Host $Message1 -ForegroundColor GREEN 
            }
        
        
        if ($1CFirstname -ne $CurrentAD.GivenName)
            {$TEMPFirstname = $CurrentAD.GivenName
            $Message = "     Previous Firstname "+ $TEMPFirstname + " is not equal to new " + $1CFirstname
            Write-Host   $Message -ForegroundColor RED
            Set-ADUser -Server "TSM-DC01.domain.artelgroup.org" -identity $TEMPGUID -GivenName $1CFirstname
            $Message1 = "     Updated previous Firstname " + $TEMPFirstname + " to " + $1CFirstname
            Write-Host $Message1 -ForegroundColor RED
            }
            else
            {$TEMPFirstname = $CurrentAD.GivenName
            $Message = "     Previous Firstname "+ $TEMPfirstname + " is equal to new " + $1Cfirstname
            Write-Host $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            Write-Host $Message1 -ForegroundColor GREEN
            }

        if ($1CLastname -ne $CurrentAD.Surname)
            {$TEMPLastname = $CurrentAD.Surname
            $Message = "     Previous lastname "+ $TEMPLastname + " is not equal to new " + $1Clastname
            Write-Host   $Message -ForegroundColor RED
            Set-ADUser -Server "TSM-DC01.domain.artelgroup.org" -identity $TEMPGUID -Surname $1Clastname
            $Message1 = "     Updated previous lastname " + $TEMPlastname + " to " + $1Clastname
            Write-Host $Message1 -ForegroundColor RED
            }

            else
            {$TEMPLastname = $CurrentAD.Surname
            $Message = "     Previous Lastname "+ $TEMPLastname + " is equal to new " + $1CLastname
            Write-Host $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            Write-Host $Message1 -ForegroundColor GREEN
            }

        if ($1CFullName -ne $CurrentAD.DisplayName)
            {$TEMPFullName = $CurrentAD.DisplayName
            $Message = "     Previous DisplayName "+ $TEMPFullName + " is not equal to new " + $1CFullName
            Write-Host   $Message -ForegroundColor RED
            Set-ADUser -Server "TSM-DC01.domain.artelgroup.org" -identity $TEMPGUID -DisplayName $1CFullName
            $Message1 = "     Updated previous DisplayName " + $TEMPFullName + " to " + $1CFullName
            Write-Host $Message1 -ForegroundColor RED
            }
            else
            {$TEMPFullName = $CurrentAD.DisplayName
            $Message = "     Previous DisplayName "+ $TEMPFullName + " is equal to new " + $1CFullName
            Write-Host $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            Write-Host $Message1 -ForegroundColor GREEN
            }
       if ($Company -ne $CurrentAD.OrganizationName)
            {$TEMPOrgName = $CurrentAD.OrganizationName
            $Message = "     Previous Company "+ $TEMPOrgName + " is not equal to new " + $Company
            Write-Host   $Message -ForegroundColor RED
            Set-ADUser -Server "TSM-DC01.domain.artelgroup.org" -identity $TEMPGUID -Replace @{company=$Company}
            $Message1 = "     Updated previous company " + $TEMPOrgName + " to " + $Company
            Write-Host $Message1 -ForegroundColor RED
            }
            else
            {$TEMPOrgName = $CurrentAD.OrganizationName
            $Message = "     Previous Company "+ $TEMPOrgName + " is equal to new " + $Company
            Write-Host $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            Write-Host $Message1 -ForegroundColor GREEN
            }
#12
       if ($1CSupervisorName -ne $CurrentAD.SupervisorName)
            {$TEMPSupervisorName = $CurrentAD.SupervisorName
            $Message = "     SupervisorName "+ $TEMPSupervisorName + " is not equal to new " + $1CSupervisorName
            Write-Host   $Message -ForegroundColor RED
            Set-ADUser -Server "TSM-DC01.domain.artelgroup.org" -identity $TEMPGUID -Replace @{st=$1CSupervisorName}
            $Message1 = "     Updated previous SupervisorName " + $TEMPSupervisorName + " to " + $SupervisorName
            Write-Host $Message1 -ForegroundColor RED
            }
            else
            {$TEMPSupervisorName = $CurrentAD.SupervisorName
            $Message = "     Previous Supervisor "+ $TEMPSupervisorName + " is equal to new " + $SupervisorName
            Write-Host $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            Write-Host $Message1 -ForegroundColor GREEN
            }


       if ($1CFullName -ne $CurrentAD.CN)
            {$TEMPCN = $CurrentAD.CN
            $Message = "     Previous CN "+ $TEMPCN + " is not equal to new " + $1CFullName
            Write-Host   $Message -ForegroundColor RED
            Get-ADUser -Server "TSM-DC01.domain.artelgroup.org" -identity $TEMPGUID  | Rename-ADObject -NewName $1CFullName
            $Message1 = "     Updated previous CN " + $TEMPCN + " to " + $1CFullName
            Write-Host $Message1 -ForegroundColor RED
            }
            else
            {$TEMPCN = $CurrentAD.CN
            $Message = "     Previous CN "+ $TEMPCN + " is equal to new " + $1CFullName
            Write-Host $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            Write-Host $Message1 -ForegroundColor GREEN
            }

       if ($1CTitle -ne $CurrentAD.Title)
            {$TEMPTitle = $CurrentAD.Title
            $Message = "     Previous Title "+ $TEMPTitle + " is not equal to new " + $1CTitle
            Write-Host   $Message -ForegroundColor RED
            Set-ADUser -Server "TSM-DC01.domain.artelgroup.org" -identity $TEMPGUID -Title $1CTitle
            $Message1 = "     Updated previous Title " + $TEMPTitle + " to " + $1CTitle
            Write-Host $Message1 -ForegroundColor RED
            }
            else
            {$TEMPTitle = $CurrentAD.Title
            $Message = "     Previous Title "+ $TEMPTitle + " is equal to new " + $1CTitle
            Write-Host $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            Write-Host $Message1 -ForegroundColor GREEN
            }
              
            #---------  
              
        if (($1StateBoolean -eq "True") -and ($CurrentAD.Enabled -eq "False"))
            {
           Enable-ADAccount -Server "TSM-DC01.domain.artelgroup.org" -identity $TEMPGUID
            $Message1 = "    Account was disabled and enabled now"
            Write-Host ($1StateBoolean -ne $CurrentAD.Enabled)
            Write-Host ($CurrentAD.Enabled -eq "False")
            Write-Host "------------" 
            Write-Host $1StateBoolean
            Write-Host $CurrentAD.Enabled
            Write-Host "------------" 
            Write-Host $Message1 -ForegroundColor GREEN
            Start-Sleep -s 10
            }

         if (($1CStateBoolean -eq "False") -and ($CurrentAD.Enabled -eq "True"))
            {
           Disable-ADAccount -identity $TEMPGUID
            $Message1 = "    Account was enabled and disabled now"
            Write-Host ($1CStateBoolean -ne $CurrentAD.Title)
            Write-Host ($CurrentAD.Enabled -eq "True")
            Write-Host "------------"
            Write-Host $1CStateBoolean 
            Write-Host $CurrentAD.Enabled
            Write-Host "------------" 
            Write-Host $Message1 -ForegroundColor RED
            }
            #-----------
         if (($1CStateBoolean -eq "False") -and ($CurrentAD.Enabled -eq "False")){
         $removegroupsuser = Get-ADUser -Identity $TempGUID

         if ($removegroupsuser) {
                                 $groups = Get-ADUser -Identity $TempGUID -Properties MemberOf | Select-Object -ExpandProperty MemberOf
                                 foreach ($group in $groups) {
                                                              Remove-ADGroupMember -Identity $group -Members $removegroupsuser -Confirm:$false
                                                             }
    }
         
         Set-ADUser -identity $TEMPGUID -clear manager}

         if ($1CDepartment -ne $CurrentAD.Department)
            {$TEMDepartment = $CurrentAD.Department
            $Message = "     Previous Department "+ $TEMPDepartment + " is not equal to new " + $1CDepartment
            Write-Host   $Message -ForegroundColor RED
            Set-ADUser -Server "TSM-DC01.domain.artelgroup.org" -identity $TEMPGUID -Department $1CDepartment
            $Message1 = "     Updated previous Department " + $TEMPDepartment + " to " + $1CDepartment
            Write-Host $Message1 -ForegroundColor RED
            }
        else
            {$TEMDepartment = $CurrentAD.Department
            $Message = "     Previous Department "+ $TEMDepartment + " is equal to new " + $1CDepartment
            Write-Host $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            Write-Host $Message1 -ForegroundColor GREEN
            }

         if ($1CDepartment -ne $CurrentAD.Office)
            {$TEMPOffice = $CurrentAD.Office
            $Message = "     Previous Office "+ $TEMPOffice + " is not equal to new " + $1CDepartment
            Write-Host   $Message -ForegroundColor RED
            Set-ADUser -Server "TSM-DC01.domain.artelgroup.org" -identity $TEMPGUID -Office $1CDepartment
            $Message1 = "     Updated previous Office " + $TEMPOffice + " to " + $1CDepartment
            Write-Host $Message1 -ForegroundColor RED
            }
        else
            {$TEMPOffice = $CurrentAD.Office
            $Message = "     Previous Office "+ $TEMPOffice + " is equal to new " + $1CDepartment
            Write-Host $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            Write-Host $Message1 -ForegroundColor GREEN
            }
            
           
            
         if ($1COU -ne $CurrentAD.ParentContainer)
            {$TEMPParentContainer = $CurrentAD.ParentContainer
             $Message = "     Previous ParentContainer "+ $TEMPParentContainer + " is not equal to new " + $1COU
             Write-Host $Message -ForegroundColor RED
             Move-ADObject  -Server "TSM-DC01.domain.artelgroup.org" -Identity $TEMPGUID -TargetPath $1COU
             $Message1 = $1CDescription + " moved to " + $1COU
             Write-Host $Message1 -ForegroundColor RED}
         else
            {$TEMPParentContainer = $CurrentAD.ParentContainer
             $Message = "     Previous ParentContainer "+ $TEMPParentContainer + " is equal to new " + $1COU
             Write-Host $Message -ForegroundColor GREEN
             $Message1 = "     Nothing to do"
             Write-Host $Message1 -ForegroundColor GREEN
            }

         if ($1CDescription -ne $CurrentAD.Description)
            {$TEMPDescription = $CurrentAD.Description
            $Message = "     Previous Description "+ $TEMPDescription + " is not equal to new " + $1CDescription
            Write-Host   $Message -ForegroundColor RED
            Set-ADUser -Server "TSM-DC01.domain.artelgroup.org" -identity $TEMPGUID -Description $1CDescription
            $Message1 = "     Updated previous Description " + $TEMPDescription + " to " + $1CDescription
            Write-Host $Message1 -ForegroundColor RED
            }
        else
            {$TEMPDescription = $CurrentAD.Description
            $Message = "     Previous Description "+ $TEMPDescription + " is equal to new " + $1CDescription
            Write-Host $Message -ForegroundColor GREEN
            $Message1 = "     Nothing to do"
            Write-Host $Message1 -ForegroundColor GREEN
            }
  Write-Host "ENDcheckandupdateADuser"
  }

  else
  {<#
  Write-Host "#CreateADuser"
  Write-Host $1CFullName
  Write-Host $1CFirstname
  Write-Host $1CLastname
  Write-Host $1CMail
  Write-Host $1CSamAccount
  Write-Host $1CUserPrincipalName
  Write-Host $1CPINI
  Write-Host $1CTitle
  Write-Host $1CDescription
  Write-Host $1COU
  if ($1CСollar -eq 'White Collar'){New-ADUser -Server "TSM-DC01.domain.artelgroup.org" -Name $1CFullName -displayName $1CFullName -GivenName $1CFirstname -Surname $1CLastname -EmailAddress $1CMail -SamAccountName $1CSamAccount -UserPrincipalName $1CUserPrincipalName -EmployeeID $1CPINI -Title $1CTitle -Description $1CDescription -Path $1COU -OfficePhone $1cphone -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -force) -Enabled $true}
  else
  {New-ADUser -Server "TSM-DC01.domain.artelgroup.org" -Name $1CFullName -displayName $1CFullName -GivenName $1CFirstname -Surname $1CLastname -EmailAddress $1CMail -SamAccountName $1CSamAccount -UserPrincipalName $1CUserPrincipalName -EmployeeID $1CPINI -Title $1CTitle -OfficePhone $1cphone -Description $1CDescription -Path $1COU -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -force) -Enabled $false}
  Write-Host "END#CreateADuser"
  #>}



}
