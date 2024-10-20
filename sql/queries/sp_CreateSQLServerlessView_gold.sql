USE gold_db
GO

CREATE OR ALTER PROC CreateSQLServerlessview_gold 
    @ViewName NVARCHAR(100)
AS
BEGIN
    DECLARE @statement NVARCHAR(MAX); -- Use NVARCHAR since ViewName is NVARCHAR

    -- Construct the dynamic SQL statement
    SET @statement = N'CREATE OR ALTER VIEW ' + QUOTENAME(@ViewName) + N' AS
    SELECT
        *
    FROM
        OPENROWSET(
            BULK ''' + N'https://masterssg.dfs.core.windows.net/gold/ratail_inventory/' + @ViewName + N''',
            FORMAT = ''DELTA''
        ) AS [result];';

    -- Print the statement for debugging
    PRINT @statement;

    -- Execute the dynamically constructed SQL statement
    EXEC sp_executesql @statement;
END
GO
