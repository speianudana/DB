--### 1. Sa se creeze proceduri stocate in baza exercitiilor (2 exercitii) din capitolul 4. Parametrii de intrare trebuie sa corespunda criteriilor din clauzele WHERE ale exercitiilor respective . 
--#### 6.Afișați numele și prenumele primilor 5 studenți, care au obținut note în ordine descrescătoare la al doilea test de la disciplina Baze de date.

USE universitatea
GO
DROP PROCEDURE IF EXISTS Exer1;
GO
CREATE Procedure Exer1
@Disciplina varchar(30)='Baze de date',
@Tip_Evaluare varchar(20)='Testul 2'
AS
SELECT TOP(5) WITH TIES Nume_Student,Prenume_Student, Nota
FROM studenti s
INNER JOIN studenti_reusita r
ON s.Id_Student=r.Id_Student
INNER JOIN discipline d 
ON r.Id_Disciplina=d.Id_Disciplina
WHERE Disciplina=@Disciplina AND Tip_Evaluare=@Tip_Evaluare
ORDER BY Nota DESC

EXEC Exer1;













--#### 38.Furnizați denumirile disciplinelor cu o medie mai mică decît media notelor de la disciplina Baze de date.

DROP PROCEDURE IF EXISTS Exer2;
GO
CREATE Procedure Exer2
@Disciplina varchar(30)='Baze de date'
AS
SELECT  d.Disciplina,
        AVG(Nota) as Nota_Medie
FROM  discipline d
INNER JOIN studenti_reusita s
ON       d.Id_Disciplina=s.Id_Disciplina
GROUP BY Disciplina
HAVING AVG(Nota)>(SELECT AVG(Nota) AS Nota_Medie
FROM discipline d
INNER JOIN studenti_reusita s
ON d.Id_Disciplina=s.Id_Disciplina
where Disciplina=@Disciplina)

EXEC Exer2;