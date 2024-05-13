USE ARTDB
UPDATE dbo.Imported1CusersArtel
SET Changed = 0;
GO
USE ARTDB
MERGE Imported1CusersArtel AS TARGET
USING (SELECT * from csv_temp WHERE (csv_temp.[PINI] NOT LIKE '%[A-Z, a-z]%' AND csv_temp.[PINI] IS NOT NULL) ORDER BY csv_temp.NormalizeDate ASC, csv_temp.PINI ASC OFFSET 0 ROWS )   AS SOURCE
ON (TARGET.PINI = SOURCE.PINI)
WHEN MATCHED AND TARGET.[Name] <> Source.[Normalizename] OR TARGET.[Patronymic] <> Source.[NormalizePatronymic] OR TARGET.[Surname] <> Source.[NormalizeSurname] OR TARGET.[PositionCode] <> Source.[PositionCode] OR TARGET.[DateOfEmployment] <> Source.[NormalizeDate] OR TARGET.[StructureCode] <> Source.[StructureCode] OR TARGET.[Status] <> Source.[Status] OR TARGET.[StaffCategory] <> Source.[StaffCategory] OR TARGET.[PhoneNumber] <> Source.[PhoneNumber] OR TARGET.[SecondSupervisorName] <> Source.[SecondSupervisorName] OR TARGET.[SecondSupervisorPINI] <> Source.[SecondSupervisorPINI] OR TARGET.[OrganizationName] <> Source.[OrganizationName]
THEN UPDATE SET TARGET.[Name] = Source.[NormalizeName], TARGET.[Patronymic] = Source.[NormalizePatronymic], TARGET.[Surname] = Source.[NormalizeSurname],TARGET.[PositionCode] = Source.[PositionCode], TARGET.[DateOfEmployment] = Source.[NormalizeDate], TARGET.[StructureCode] = Source.[StructureCode], TARGET.[Status] = Source.[Status], TARGET.[StaffCategory] = Source.[StaffCategory], TARGET.[PhoneNumber] = Source.[PhoneNumber], TARGET.[Changed] = 1,  TARGET.[SecondSupervisorName] = Source.[SecondSupervisorName], TARGET.[SecondSupervisorPINI] = SOURCE.[SecondSupervisorPINI], TARGET.[OrganizationName] = SOURCE.[OrganizationName]
WHEN NOT MATCHED BY TARGET
THEN INSERT ([Name],[Patronymic],[Surname],[PositionCode],[DateOfEmployment],[StructureCode],[Status],[PINI],[Changed],[StaffCategory],[PhoneNumber],[SecondSupervisorName],[SecondSupervisorPINI],[OrganizationName])  VALUES (SOURCE.[NormalizeName], SOURCE.[NormalizePatronymic], SOURCE.[NormalizeSurname], SOURCE.[PositionCode], Source.[NormalizeDate], SOURCE.[StructureCode], SOURCE.[Status], SOURCE.[PINI],1,SOURCE.[StaffCategory],SOURCE.[PhoneNumber],SOURCE.[SecondSupervisorName],SOURCE.[SecondSupervisorPINI],SOURCE.[OrganizationName]);
