/*
	Create schema
*/
    IF SCHEMA_ID('web') IS NULL BEGIN
        EXECUTE('CREATE SCHEMA [web]');
    END
GO

/*
	Create user to be used in the sample API solution
*/
IF USER_ID('DotNetWebApp') IS NULL BEGIN
    CREATE USER [DotNetWebApp] WITH PASSWORD = 'figureouthowtomakespworkwithcert1!';
END

/*
	Grant execute permission to created users
*/
GRANT EXECUTE ON SCHEMA::[web] TO [DotNetWebApp];
GO

/*
	Return all average battery voltage data
*/
CREATE OR ALTER PROCEDURE web.get_epsaveragebatteryvoltage
AS
    SET NOCOUNT ON;
SELECT CAST((
   SELECT
       [downlink_id],
       [avg_bat_voltage]
   FROM
       [eps]
    FOR JSON PATH) AS NVARCHAR(MAX)) AS JsonResult
GO