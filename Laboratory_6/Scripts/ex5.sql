CREATE TABLE profesori_new
(Id_Profesor int NOT NULL
 ,Nume_Profesor char(255)
 ,Prenume_Profesor char(255)
 ,Localitate char (255) DEFAULT('mun. Chisinau')
 ,Adresa_1 char (60)
 ,Adresa_2 char (60),
  CONSTRAINT [PK_profesori_new] PRIMARY KEY CLUSTERED 
(	Id_Profesor )) ON [PRIMARY]
CREATE FUNCTION INSTR(@str VARCHAR(8000), @substr VARCHAR(255), @start INT, @occurrence INT)
  RETURNS INT
  AS
  BEGIN
	DECLARE @found INT = @occurrence,
			@pos INT = @start;
 
	WHILE 1=1 
	BEGIN
		-- Find the next occurrence
		SET @pos = CHARINDEX(@substr, @str, @pos);
 
		-- Nothing found
		IF @pos IS NULL OR @pos = 0
			RETURN @pos;
 
		-- The required occurrence found
		IF @found = 1
			BREAK;
 
		-- Prepare to find another one occurrence
		SET @found = @found - 1;
		SET @pos = @pos + 1;
	END
 
	RETURN @pos;
  END
  GO
INSERT INTO profesori_new(Id_Profesor, Nume_Profesor, Prenume_Profesor, Localitate, Adresa_1, Adresa_2)
 SELECT Id_Profesor
        , Nume_Profesor
		, Prenume_Profesor
		, CASE 
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', ''))=3 
		THEN  Substring(Adresa_Postala_Profesor,1, dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2)-1)
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', '')) =2 
		THEN Substring(Adresa_Postala_Profesor,1, charindex(',',Adresa_Postala_Profesor)-1)
		ELSE Adresa_Postala_Profesor
		END as  localitate
		, CASE 
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', ''))=3 
		THEN  Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2)+1,
		(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 3))-(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2))-1)
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', '')) =2 
		THEN Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 1)+1,
		(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2))-(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 1))-1)
		ELSE NULL
		END as  Adresa_1
		, CASE 
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', ''))=3 
		THEN  Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 3)+1, 5)
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', '')) =2 
		THEN Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2)+1, 5)
		ELSE NULL
		END as  Adresa_2
		 FROM profesori;
		
select * from profesori_new
drop table profesori_new