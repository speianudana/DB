--#### 38.Furnizați denumirile disciplinelor cu o medie mai mică decît media notelor de la disciplina Baze de date.
USE universitatea 
GO
DROP FUNCTION IF EXISTS test4;
GO
CREATE FUNCTION  test4(@Disciplina varchar(255))
RETURNS TABLE
WITH ENCRYPTION
AS 
RETURN
(SELECT  d.Disciplina,
        AVG(Nota) as Nota_Medie
FROM  discipline d
INNER JOIN studenti_reusita s
ON       d.Id_Disciplina=s.Id_Disciplina
GROUP BY Disciplina
HAVING AVG(Nota)>(SELECT AVG(Nota) AS Nota_Medie
FROM discipline d
INNER JOIN studenti_reusita s
ON d.Id_Disciplina=s.Id_Disciplina
where Disciplina=@Disciplina));

select * from dbo.test4('Baze de date')

---#### 17. Afișați numele și prenumele profesorilor, care au predat cel puțin o disciplină studentului cu identificatorul 100.
USE universitatea 
GO
DROP FUNCTION IF EXISTS test5;
GO
CREATE FUNCTION  test5(@Id_Student int)
RETURNS TABLE
WITH ENCRYPTION
AS 
RETURN
(SELECT DISTINCT Nume_Profesor,Prenume_Profesor
FROM profesori p
INNER JOIN studenti_reusita r
ON p.Id_Profesor=r.Id_Profesor
WHERE Id_Student=@Id_Student);

select * from dbo.test5(100);