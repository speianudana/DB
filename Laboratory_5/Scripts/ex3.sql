﻿--3. Rezolvati aceeași sarcina, 1, apelînd la structura selectiva CASE. 
DECLARE @N1 INT,@N2 INT,@N3 INT;
DECLARE @MAI_MARE INT;
SET @N1 = 60 * RAND();
SET @N2 = 60 * RAND();
SET @N3 = 60 * RAND();

SET  @MAI_MARE= 
CASE 
WHEN (@N1>@N2) AND (@N1>@N3) THEN @N1 
WHEN (@N2>@N1) AND (@N2>@N3) THEN @N2 
WHEN (@N3>@N1) AND (@N3>@N2) THEN @N3 
END
PRINT @N1;
PRINT @N2;
PRINT @N3;
PRINT 'Mai mare = '+CAST(@MAI_MARE AS VARCHAR(2));

	