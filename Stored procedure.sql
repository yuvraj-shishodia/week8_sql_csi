CREATE PROCEDURE PopulateDateDimension
    @InputDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartDate DATE = DATEFROMPARTS(YEAR(@InputDate), 1, 1);
    DECLARE @EndDate DATE = DATEFROMPARTS(YEAR(@InputDate), 12, 31);

    ;WITH DateSeries AS (
        SELECT @StartDate AS [date]
        UNION ALL
        SELECT DATEADD(DAY, 1, [date])
        FROM DateSeries
        WHERE [date] < @EndDate
    )
    INSERT INTO DateDimension (
        [date],
        day_name,
        day_of_week,
        day_of_month,
        day_of_year,
        week_of_year,
        month_name,
        month,
        quarter,
        year
    )
    SELECT
        [date],
        DATENAME(WEEKDAY, [date]) AS day_name,
        DATEPART(WEEKDAY, [date]) AS day_of_week,
        DATEPART(DAY, [date]) AS day_of_month,
        DATEPART(DAYOFYEAR, [date]) AS day_of_year,
        DATEPART(WEEK, [date]) AS week_of_year,
        DATENAME(MONTH, [date]) AS month_name,
        DATEPART(MONTH, [date]) AS month,
        DATEPART(QUARTER, [date]) AS quarter,
        DATEPART(YEAR, [date]) AS year
    FROM DateSeries
    OPTION (MAXRECURSION 366);  -- Handle leap years
END
