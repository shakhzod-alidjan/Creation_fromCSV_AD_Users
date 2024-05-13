USE [ARTDB]
GO

/****** Object:  Table [dbo].[Positions]    Script Date: 15.09.2021 15:17:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Positions_tmp]') AND type in (N'U'))
DROP TABLE [dbo].[Positions_tmp]
GO

/****** Object:  Table [dbo].[Positions]    Script Date: 15.09.2021 15:17:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Positions_tmp](
	[code] [int] NOT NULL,
	[name] [varchar](255) NOT NULL
) ON [PRIMARY]
GO


USE ARTDB
GO
BULK INSERT Positions_tmp
FROM 'C:\ZUP-AD\Positions.csv'
WITH
(
    CODEPAGE = '65001',
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',   
    TABLOCK

)
GO
