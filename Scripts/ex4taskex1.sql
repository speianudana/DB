
BEGIN TRY
DECLARE @N1 INT,@N2 INT,@N3 INT,@N4 int,@result decimal(3,2),@N5 int;
DECLARE @MAI_MARE INT;
SET @N1 = 60 * RAND();
SET @N2 = 60 * RAND();
SET @N3 = 60 * RAND();
SET @N5=-4;
SET @result=sqrt(@N5);
PRINT 'There is not any errors'
end try
begin catch 
print 'There is an error'
print 'Error information:'
PRINT '   The number of error:'+CAST(ERROR_NUMBER() AS VARCHAR(20))
PRINT '   Level ofSeverity:'+CAST(ERROR_SEVERITY() AS VARCHAR(20))
PRINT '   The error status:'+CAST(ERROR_STATE() AS VARCHAR(20))
PRINT '   Error line:'+CAST( ERROR_LINE() AS VARCHAR(20))
PRINT '   Error:'+CAST(ERROR_MESSAGE() AS VARCHAR(200)) 
end catch
begin
if (@N1>@N2) AND (@N1>@N3)
SET @MAI_MARE=@N1;
if (@N2>@N1) AND (@N2>@N3)
SET @MAI_MARE=@N2;
if (@N3>@N1) AND (@N3>@N2)
SET @MAI_MARE=@N3;
PRINT 'Random numbers:' 
PRINT @N1;
PRINT @N2;
PRINT @N3;
PRINT 'Mai mare = '+CAST(@MAI_MARE AS VARCHAR(2));
end