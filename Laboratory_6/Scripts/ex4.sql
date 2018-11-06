--4. Să se scrie o instrucțiune T-SQL, care ar mări toate notele de evaluare șefilor de grupe cu un
--   punct. Nota maximală (10) nu poate fi mărită.

DECLARE @ID_SEF_1 FLOAT;
DECLARE @ID_SEF_2 FLOAT;
DECLARE @ID_SEF_3 FLOAT;
SET @ID_SEF_1=(SELECT TOP 1 sef_grupa FROM grupe)
SET @ID_SEF_2=(SELECT TOP 1 sef_grupa FROM grupe 
               WHERE sef_grupa IN(SELECT TOP 2 sef_grupa 
                                  FROM grupe
				  ORDER BY sef_grupa ASC)
               ORDER BY sef_grupa DESC)                  
SET @ID_SEF_3=(SELECT TOP 1 sef_grupa FROM grupe 
               WHERE sef_grupa IN (SELECT top 3 sef_grupa 
				   FROM grupe
				   ORDER BY sef_grupa asc)
	       ORDER BY sef_grupa DESC)

UPDATE studenti_reusita SET Nota=Nota+1 WHERE Id_Student IN(@ID_SEF_1, @ID_SEF_2, @ID_SEF_3) AND Nota!=10 

SELECT * FROM studenti_reusita


