USE universitatea
GO
--Modificare viziune exercitiul17
ALTER VIEW exercitiul17
WITH SCHEMABINDING --nu este posibilă modificarea sau ștergerea tabelelorpe care acestea sunt definite
AS
SELECT Nume_Profesor,Prenume_Profesor
FROM dbo.profesori p
INNER JOIN dbo.studenti_reusita r
ON p.Id_Profesor=r.Id_Profesor
WHERE Id_Student=100
GROUP BY Nume_Profesor,Prenume_Profesor
WITH CHECK OPTION --viziunile nu acceptă operațiuni DML,dacă  condițiile clauzei WHERE nu sunt satisfăcute
GO