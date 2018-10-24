--35.Găsiți denumirile discipllinelor și media notelor pe disciplină.Afișați numai disciplinele cu medii mai mari decît 7.
SELECT  d.Disciplina,
        AVG(Nota) as Nota_Medie
FROM  discipline d
INNER JOIN studenti_reusita s
ON       d.Id_Disciplina=s.Id_Disciplina
GROUP BY Disciplina
HAVING AVG(Nota)>7