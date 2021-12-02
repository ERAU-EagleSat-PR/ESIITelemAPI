/*
	Create schema
*/
IF SCHEMA_ID('web') IS NULL
    BEGIN
        EXECUTE ('CREATE SCHEMA [web]');
    END
GO

/*
	Create user to be used in the sample API solution
*/
IF USER_ID('DotNetWebApp') IS NULL
    BEGIN
        CREATE USER [DotNetWebApp] WITH PASSWORD = 'figureouthowtomakespworkwithcert1!';
    END

/*
	Grant execute permission to created users
*/
GRANT EXECUTE ON SCHEMA::[web] TO [DotNetWebApp];
GO

/*
    Return all eps data
 */
CREATE OR ALTER PROCEDURE web.get_alleps
AS
    SET NOCOUNT ON;
SELECT downlink_id       AS DownlinkId,
       avg_bat_voltage   AS AvgBatVoltage,
       brownouts         AS Brownouts,
       charge_time_min   AS ChargeTimeMins,
       peak_charge_power AS PeakChargePower
FROM [eps]
FOR JSON PATH;
GO

/*
	Return EPS data for a specific downlink
*/
CREATE OR ALTER PROCEDURE web.get_eps @Id INT
AS
    SET NOCOUNT ON;
SELECT downlink_id       AS DownlinkId,
       avg_bat_voltage   AS AvgBatVoltage,
       brownouts         AS Brownouts,
       charge_time_min   AS ChargeTimeMins,
       peak_charge_power AS PeakChargePower
FROM [eps]
WHERE [downlink_id] = @Id
FOR JSON PATH;
GO

/*
    Return all average battery voltage with associated downlink and timestamp
 */
CREATE OR ALTER PROCEDURE web.get_allepsavgbatvol
AS
    SET NOCOUNT ON;
SELECT eps.downlink_id              AS DownlinkId,
       telemetry.downlink_timestamp AS PassTimestamp,
       avg_bat_voltage              AS AvgBatVoltage
FROM [eps]
         INNER JOIN [telemetry] ON eps.downlink_id = telemetry.downlink_id
FOR JSON PATH;
GO

/*
    Return all brownouts with associated downlink and timestamp
 */
CREATE OR ALTER PROCEDURE web.get_allbrownouts
AS
    SET NOCOUNT ON;
SELECT eps.downlink_id              AS DownlinkId,
       telemetry.downlink_timestamp AS PassTimestamp,
       brownouts                    AS Brownouts
FROM [eps]
         INNER JOIN [telemetry] ON eps.downlink_id = telemetry.downlink_id
FOR JSON PATH;
GO

/*
    Return all charge time data with associated downlink and timestamp
 */
CREATE OR ALTER PROCEDURE web.get_allchargetime
AS
    SET NOCOUNT ON;
SELECT eps.downlink_id              AS DownlinkId,
       telemetry.downlink_timestamp AS PassTimestamp,
       charge_time_min              AS ChargeTimeMin
FROM [eps]
         INNER JOIN [telemetry] ON eps.downlink_id = telemetry.downlink_id
FOR JSON PATH;
GO

/*
    Return all charge time data with associated downlink and timestamp
 */
CREATE OR ALTER PROCEDURE web.get_allpeakchargepower
AS
    SET NOCOUNT ON;
SELECT eps.downlink_id              AS DownlinkId,
       telemetry.downlink_timestamp AS PassTimestamp,
       peak_charge_power            AS PeakChargePower
FROM [eps]
         INNER JOIN [telemetry] ON eps.downlink_id = telemetry.downlink_id
FOR JSON PATH;
GO

/*
	Create new EPS entry and associated telemetry object
*/
CREATE OR ALTER PROCEDURE web.put_eps @Json NVARCHAR(MAX)
AS
    SET NOCOUNT ON;
    ALTER SEQUENCE dbo.DownlinkIdSeq RESTART WITH 1;
WITH [source] AS (
    SELECT *
    FROM OPENJSON(@Json) WITH (
        [DownlinkId] INT,
        [AvgBatVoltage] DECIMAL(5, 3),
        [Brownouts] INT,
        [ChargeTimeMin] DECIMAL(5, 2),
        [PeakChargePower] DECIMAL(5, 2)
        )
)
INSERT
INTO [eps]
(downlink_id, avg_bat_voltage, brownouts, charge_time_min, peak_charge_power)
SELECT DownlinkId,
       AvgBatVoltage,
       Brownouts,
       ChargeTimeMin,
       PeakChargePower
FROM [source];
DECLARE @DownlinkId INT
SELECT @DownlinkId = [DownlinkId]
FROM OPENJSON(@Json) WITH ([DownlinkId] INT);
    EXEC web.get_eps @DownlinkId;
GO

/*
	Create new telemetry object
*/
CREATE OR ALTER PROCEDURE web.put_telemetry @Json NVARCHAR(MAX)
AS
    SET NOCOUNT ON;
/*DECLARE @DownlinkId INT = NEXT VALUE FOR dbo.DownlinkIdSeq;*/
WITH [source] AS (
    SELECT *
    FROM OPENJSON(@Json) WITH (
        [DownlinkTimestamp] DATETIME,
        [PassNumber] INT
        )
)
INSERT
INTO [telemetry] (downlink_timestamp, pass_number)
SELECT DownlinkTimestamp,
       PassNumber
FROM [source];
DECLARE @DownlinkId INT
SELECT @DownlinkId = (downlink_id)
FROM telemetry;
    EXEC web.get_telemetry @DownlinkId;
GO

/*
	Return telemetry data for a specific downlink ID
*/
CREATE OR ALTER PROCEDURE web.get_telemetry @Id INT
AS
    SET NOCOUNT ON;
SELECT downlink_id AS DownlinkId, downlink_timestamp AS DownlinkTimestamp, pass_number AS PassNumber
FROM [telemetry]
WHERE [downlink_id] = @Id
FOR JSON PATH;
GO

/*
    Return all telemetry data
 */
CREATE OR ALTER PROCEDURE web.get_alltelemetry
AS
    SET NOCOUNT ON;
SELECT downlink_id AS DownlinkId, downlink_timestamp AS DownlinkTimestamp, pass_number AS PassNumber
FROM [telemetry]
FOR JSON PATH;
GO