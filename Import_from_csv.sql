USE [ARTDB]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csv_temp]') AND type in (N'U'))
DROP TABLE [dbo].[csv_temp]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[csv_temp] (
	[Surname] [nvarchar](255) collate Cyrillic_General_100_CI_AS NULL ,
	[Name] [nvarchar](255) collate Cyrillic_General_100_CI_AS NULL,
	[Patronymic] [nvarchar](255) collate Cyrillic_General_100_CI_AS NULL,
	[TIN] [nvarchar](255) NULL,
	[PINI] [nvarchar](255) NULL,
	[PhoneNumber] [nvarchar](255) NULL,
	[PositionCode] [nvarchar](255) NULL,
	[StructureCode] [nvarchar](255) NULL,
	[DateOfEmployment] [nvarchar](255) NULL,
	[SecondSupervisorName] [nvarchar](255) collate Cyrillic_General_100_CI_AS NULL,
	[SecondSupervisorPINI] [nvarchar](255) NULL,
	[OrganizationName] [nvarchar](255) collate Cyrillic_General_100_CI_AS NULL,
	[Status] [nvarchar](255) NULL,
	[StaffCategory] [nvarchar](255) NULL
 )ON [PRIMARY]
GO

BULK INSERT csv_temp
FROM 'C:\ZUP-AD\Employees.csv'
WITH
(
    CODEPAGE = '65001',
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',   
    TABLOCK

)
ALTER TABLE [dbo].[csv_temp] ADD [NormalizeDate] AS (CONVERT([datetime],[DateOfemployment],(104)))
ALTER TABLE [dbo].[csv_temp] ADD [Normalizename] AS ([dbo].[str_cyrillic2Latinuz]([Name]))
ALTER TABLE [dbo].[csv_temp] ADD [Normalizesurname] AS ([dbo].[str_cyrillic2Latinuz]([surname]))
ALTER TABLE [dbo].[csv_temp] ADD [Normalizepatronymic] AS ([dbo].[str_cyrillic2Latinuz]([patronymic]))
