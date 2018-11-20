USE universitatea
GO
DROP VIEW IF EXISTS dbo.exercitiul38;
GO
--Crearea viziune exercitiul38
CREATE VIEW exercitiul38 AS
SELECT  d.Disciplina,
        CAST(AVG(Nota*1.0)as decimal(5,2)) as Nota_Medie
FROM  discipline d
INNER JOIN studenti_reusita s
ON       d.Id_Disciplina=s.Id_Disciplina
GROUP BY Disciplina
HAVING CAST(AVG(Nota*1.0)as decimal(5,2))>(SELECT CAST(AVG(Nota*1.0)as decimal(5,2)) AS Nota_Medie
FROM discipline d
INNER JOIN studenti_reusita s
ON d.Id_Disciplina=s.Id_Disciplina
WHERE Disciplina='Baze de date')
GO
--Test interogare viziune
SELECT * FROM exercitiul38
--
