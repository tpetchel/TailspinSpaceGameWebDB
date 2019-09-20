CREATE TABLE [dbo].[Profiles] (
    [id]                INT           NOT NULL,
    [userName]          NVARCHAR (50) NOT NULL,
    [avatarUrl]         NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


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
ALTER TABLE [dbo].[Scores] WITH NOCHECK
    ADD CONSTRAINT [FK_Scores_Profiles] FOREIGN KEY ([profileId]) REFERENCES [dbo].[Profiles] ([id]);


GO
CREATE TABLE [dbo].[Achievements] (
    [id]            INT           NOT NULL,
    [description]   NVARCHAR (50)    NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

GO

CREATE TABLE [dbo].[ProfileAchievements] (
    [profileId]         INT           NOT NULL,
    [achievementId]     INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([profileId], [achievementId])
);

GO

ALTER TABLE [dbo].[ProfileAchievements] WITH NOCHECK
    ADD CONSTRAINT [FK_ProfileAchievements_Profiles] FOREIGN KEY ([profileId]) REFERENCES [dbo].[Profiles] ([id]);
GO
ALTER TABLE [dbo].[ProfileAchievements] WITH NOCHECK
    ADD CONSTRAINT [FK_ProfileAchievements_Achievements] FOREIGN KEY ([achievementId]) REFERENCES [dbo].[Achievements] ([id]);
GO

