USE universitatea
GO
DROP VIEW IF EXISTS dbo.exercitiul17;
GO
--Crearea viziune exercitiul17
CREATE VIEW exercitiul17 AS

SELECT Nume_Profesor,Prenume_Profesor
FROM profesori p
INNER JOIN studenti_reusita r
ON p.Id_Profesor=r.Id_Profesor
WHERE Id_Student=100
GROUP BY Nume_Profesor,Prenume_Profesor
GO