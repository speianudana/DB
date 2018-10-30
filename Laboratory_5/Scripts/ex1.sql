--1.Completați următorul cod pentru a afișa cel mai mare număr dintre cele trei numere prezentate: 
DECLARE @N1 INT,@N2 INT,@N3 INT;
DECLARE @MAI_MARE INT;
SET @N1 = 60 * RAND();
SET @N2 = 60 * RAND();
SET @N3 = 60 * RAND();
begin
if (@N1>@N2) AND (@N1>@N3)
SET @MAI_MARE=@N1;
if (@N2>@N1) AND (@N2>@N3)
SET @MAI_MARE=@N2;
if (@N3>@N1) AND (@N3>@N2)
SET @MAI_MARE=@N3;

PRINT @N1;
PRINT @N2;
PRINT @N3;
PRINT 'Mai mare = '+CAST(@MAI_MARE AS VARCHAR(2));
end