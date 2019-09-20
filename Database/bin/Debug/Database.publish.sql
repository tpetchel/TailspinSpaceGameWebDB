﻿/*
Deployment script for Tailspin

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Tailspin"
:setvar DefaultFilePrefix "Tailspin"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
PRINT N'Rename refactoring operation with key 11c6ccd5-87ef-4a82-899d-5860ce7c5a8b is skipped, element [dbo].[Profiles].[Id] (SqlSimpleColumn) will not be renamed to id';


GO
PRINT N'Rename refactoring operation with key 88107e6d-2954-48eb-a255-cb37a60fe6e6 is skipped, element [dbo].[Table1].[Id] (SqlSimpleColumn) will not be renamed to id';


GO
PRINT N'Creating [dbo].[Profiles]...';


GO
CREATE TABLE [dbo].[Profiles] (
    [id]                INT           NOT NULL,
    [userName]          NVARCHAR (50) NOT NULL,
    [avatarUrl]         NVARCHAR (50) NULL,
    [achievements__001] NVARCHAR (50) NULL,
    [achievements__002] NVARCHAR (50) NULL,
    [achievements__003] NVARCHAR (50) NULL,
    [achievements__004] NVARCHAR (50) NULL,
    [achievements__005] NVARCHAR (50) NULL,
    [achievements__006] NVARCHAR (50) NULL,
    [achievements__007] NVARCHAR (50) NULL,
    [achievements__008] NVARCHAR (50) NULL,
    [achievements__009] NVARCHAR (50) NULL,
    [achievements__010] NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Creating [dbo].[Scores]...';


GO
CREATE TABLE [dbo].[Scores] (
    [id]         INT           NOT NULL,
    [profileId]  INT           NOT NULL,
    [score]      INT           NULL,
    [gameMode]   NCHAR (10)    NULL,
    [gameRegion] NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Creating [dbo].[FK_Scores_Profiles]...';


GO
ALTER TABLE [dbo].[Scores] WITH NOCHECK
    ADD CONSTRAINT [FK_Scores_Profiles] FOREIGN KEY ([profileId]) REFERENCES [dbo].[Profiles] ([id]);


GO
