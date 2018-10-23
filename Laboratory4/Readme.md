##Laboratory 4

###I have done the queries number 6,17,26,35,38.

6.Afișați numele și prenumele primilor 5 studenți, care au obținut note în ordine descrescătoare la al doilea test de la disciplina Baze de date.
```
SELECT TOP(5) WITH TIES Nume_Student,Prenume_Student, Nota
FROM studenti s
INNER JOIN studenti_reusita r
ON s.Id_Student=r.Id_Student
INNER JOIN discipline d 
ON r.Id_Disciplina=d.Id_Disciplina
WHERE Disciplina='Baze de date' AND Tip_Evaluare='Testul 2' 
ORDER BY Nota DESC
```
Result:
![Ex6][https://github.com/speianudana/DB/blob/master/Laboratory4/Screenshots_DB/ex6.PNG]



