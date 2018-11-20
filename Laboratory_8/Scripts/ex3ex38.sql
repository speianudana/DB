
USE universitatea
GO
--modificare exercitiul38
ALTER VIEW exercitiul38
WITH SCHEMABINDING --nu este posibilă modificarea sau ștergerea tabelelorpe care acestea sunt definite
AS
SELECT  d.Disciplina,
        CAST(AVG(Nota*1.0)as decimal(5,2)) as Nota_Medie
FROM  dbo.discipline d
INNER JOIN dbo.studenti_reusita s
ON       d.Id_Disciplina=s.Id_Disciplina
GROUP BY Disciplina
HAVING CAST(AVG(Nota*1.0)as decimal(5,2))>(SELECT CAST(AVG(Nota*1.0)as decimal(5,2)) AS Nota_Medie
FROM dbo.discipline d
INNER JOIN dbo.studenti_reusita s
ON d.Id_Disciplina=s.Id_Disciplina
WHERE Disciplina='Baze de date')
WITH CHECK OPTION  --viziunile nu acceptă operațiuni DML,dacă  condițiile clauzei WHERE nu sunt satisfăcute
GO



