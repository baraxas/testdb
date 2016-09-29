SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SetObject]
    @DomainId uniqueidentifier,
    @Guid nchar(32),
    @Rid int,
    @ADsPath nvarchar(2048),
    @SamName nvarchar(256),
    @Type nvarchar(64),
    @Flags int = NULL,
    @Expires int = NULL,
    @InvocationId uniqueidentifier = NULL,
    @USN bigint = NULL,
    @ObjectId uniqueidentifier OUTPUT
AS

DECLARE @Error int
SET @Error = 0

SELECT
    @ObjectId = ObjectId
FROM
    Objects
WHERE
    -- If GUIDs are the same, we need to make sure that DomainId's are the same
    -- as well.  Because, in the intra-forest move, source and target objects
    -- have the same GUID however they are represented as two different objects
    -- in ADMT database.
    (@Guid IS NOT NULL AND Guid = @Guid AND DomainId = @DomainId) OR (DomainId = @DomainId AND Rid = @Rid)

IF @ObjectId IS NOT NULL
BEGIN
    UPDATE
        Objects
    SET
        DomainId     = @DomainId,
        ADsPath      = @ADsPath,
        SamName      = @SamName,
        Rid          = @Rid,
        Type         = @Type,
        Flags        = CASE WHEN @Flags IS NOT NULL THEN @Flags ELSE Flags END,
        Expires      = CASE WHEN @Expires IS NOT NULL THEN @Expires ELSE Expires END,
        InvocationId = CASE WHEN @InvocationId IS NOT NULL THEN @InvocationId ELSE InvocationId END,
        USN          = CASE WHEN (@USN IS NOT NULL AND @USN > 0) THEN @USN ELSE USN END
    WHERE
        ObjectId = @ObjectId

    SET @Error = @@ERROR
END
ELSE
BEGIN
    SET @ObjectId = NEWID()

    INSERT Objects
    (
         ObjectId,  DomainId,  Guid,  ADsPath,  SamName,  Rid,  Type,  Flags,  Expires,  InvocationId,  USN
    )
    VALUES
    (
        @ObjectId, @DomainId, @Guid, @ADsPath, @SamName, @Rid, @Type, @Flags, @Expires, @InvocationId, @USN
    )

    SET @Error = @@ERROR
END

RETURN @Error


GO
