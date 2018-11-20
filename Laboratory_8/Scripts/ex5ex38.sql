;with avgnotaDisciplina (Medie_Disciplina) as
(SELECT AVG(Nota) AS Nota_Medie
FROM discipline d
INNER JOIN studenti_reusita s
ON d.Id_Disciplina=s.Id_Disciplina
where Disciplina='Baze de date')
SELECT  d.Disciplina,
        AVG(Nota) as Nota_Media
FROM  discipline d
INNER JOIN studenti_reusita s
ON       d.Id_Disciplina=s.Id_Disciplina
GROUP BY Disciplina
HAVING AVG(Nota)>(Select Medie_Disciplina from avgnotaDisciplina);