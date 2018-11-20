--18. Afișați numele și prenumele profesorilor,care au predat doar discipline cu o încărcare orară mai mică de 60 de ore.
;with Ore60
AS
(SELECT Id_Disciplina
FROM discipline 
WHERE  Nr_ore_plan_disciplina>60)

SELECT DISTINCT Nume_Profesor,Prenume_Profesor
FROM studenti_reusita r
INNER JOIN profesori p
on r.Id_Profesor=p.Id_Profesor
Where Id_Disciplina NOT IN (SELECT * FROM Ore60)