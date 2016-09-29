SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetTaskInfo]
    @Last int = NULL,
    @TaskIdA int = NULL,
    @TaskIdB int = NULL,
    @TimeA datetime = NULL,
    @TimeB datetime = NULL,
    @Computer nvarchar(256) = NULL,
    @User nvarchar(256) = NULL,
    @Task nvarchar(32) = NULL,
    @Status int = NULL
AS

-- Select into temporary table that includes an identity column N. The identity column N is used to
-- select last N tasks matching other specified criteria.

SELECT
    IDENTITY(int, 1, 1) AS N,
    T.*
INTO
    #Tasks
FROM
(
    SELECT
        L.TaskId AS TaskId,
        G.TaskTime AS [Time],
        L.AdmtComputer AS Computer,
        L.AdmtUser AS [User],
        P.PropertyValue AS Task,
        L.Status AS Status
    FROM
        GlobalTasks AS G
        JOIN
        LocalTasks AS L ON L.GlobalTaskId = G.GlobalTaskId
        LEFT JOIN
        TaskProperties AS P ON P.TaskId = L.TaskId AND P.PropertyName = N'Options.Wizard'
    WHERE
        ((@TaskIdA IS NULL OR L.TaskId >= @TaskIdA) AND (@TaskIdB IS NULL OR L.TaskId <= @TaskIdB))
        AND
        ((@TimeA IS NULL OR G.TaskTime >= @TimeA) AND (@TimeB IS NULL OR G.TaskTime < @TimeB))
        AND
        (@Computer IS NULL OR L.AdmtComputer LIKE @Computer)
        AND
        (@User IS NULL OR L.AdmtUser LIKE @User)
        AND
        (
            @Status IS NULL
            OR
            (@Status & 1 <> 0 AND L.Status = 0)
            OR
            (@Status & 2 <> 0 AND L.Status = 1)
            OR
            (@Status & 4 <> 0 AND L.Status = 2)
        )
        AND
        (@Task IS NULL OR (P.PropertyValue IS NOT NULL AND P.PropertyValue = @Task))
)
AS T
ORDER BY
    T.TaskId

-- If last is specified then get last N.

DECLARE @LastN int

IF @Last IS NOT NULL
    SELECT TOP 1 @LastN = N FROM #Tasks ORDER BY N DESC
ELSE
    SET @LastN = NULL

-- If last is not specified then select all rows otherwise select last N rows. Sub-queries for
-- domain names are performed in this select to minimize the number of sub-queries required when
-- last criteria is specified.

SELECT
    T.*,
    (
        SELECT
            P.PropertyValue
        FROM
            TaskProperties AS P
        WHERE
            P.TaskId = T.TaskId AND P.PropertyName = N'Options.SourceDomain'
    )
    AS SourceDomain,
    (
        SELECT
            P.PropertyValue
        FROM
            TaskProperties AS P
        WHERE
            P.TaskId = T.TaskId AND P.PropertyName = N'Options.TargetDomain'
    )
    AS TargetDomain
FROM
    #Tasks AS T
WHERE
    (@Last IS NULL OR @LastN IS NULL) OR  (T.N > @LastN - @Last)
ORDER BY
    T.TaskId


GO
GRANT EXECUTE ON  [dbo].[GetTaskInfo] TO [Data Readers]
GO
