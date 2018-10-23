# Laboratory 4

## I have done the queries number 6,17,26,35,38.

### 6.Afișați numele și prenumele primilor 5 studenți, care au obținut note în ordine descrescătoare la al doilea test de la disciplina Baze de date.
``` sql
SELECT TOP(5) WITH TIES Nume_Student,Prenume_Student, Nota
FROM studenti s
INNER JOIN studenti_reusita r
ON s.Id_Student=r.Id_Student
INNER JOIN discipline d 
ON r.Id_Disciplina=d.Id_Disciplina
WHERE Disciplina='Baze de date' AND Tip_Evaluare='Testul 2' 
ORDER BY Nota DESC
```
### Result:
![Ex6](https://github.com/speianudana/DB/blob/master/Laboratory4/Screenshots_DB/ex6.PNG)

### 17. Afișați numele și prenumele profesorilor, care au predat cel puțin o disciplină studentului cu identificatorul 100.
``` sql
SELECT Nume_Profesor,Prenume_Profesor
FROM profesori p
INNER JOIN studenti_reusita r
ON p.Id_Profesor=r.Id_Profesor
WHERE Id_Student=100
GROUP BY Nume_Profesor,Prenume_Profesor
```
### Result:
![Ex17](https://github.com/speianudana/DB/blob/master/Laboratory4/Screenshots_DB/ex17.PNG)

### 26.Găsiți numele,prenumele și adresele studenților și ale profesorilor care locuiesc pe strada 31 August.
``` sql
SELECT Nume_Student as Nume,
       Prenume_Student as Prenume ,
	   Adresa_Postala_Student as Adresa
       FROM studenti
      WHERE Adresa_Postala_Student LIKE '%31 August%'
UNION

SELECT Nume_Profesor ,
       Prenume_Profesor ,
	   Adresa_Postala_Profesor
	   FROM profesori
	   WHERE Adresa_Postala_Profesor LIKE '%31 August%'
```
### Result:
![Ex26](https://github.com/speianudana/DB/blob/master/Laboratory4/Screenshots_DB/ex26.PNG)

### 35.Găsiți denumirile discipllinelor și media notelor pe disciplină.Afișați numai disciplinele cu medii mai mari decît 7.
``` sql
SELECT  d.Disciplina,
        AVG(Nota) as Nota_Medie
FROM  discipline d
INNER JOIN studenti_reusita s
ON       d.Id_Disciplina=s.Id_Disciplina
GROUP BY Disciplina
HAVING AVG(Nota)>7
```
### Result:
![Ex35](https://github.com/speianudana/DB/blob/master/Laboratory4/Screenshots_DB/ex35.PNG)

### 38.Furnizați denumirile disciplinelor cu o medie mai mică decît media notelor de la disciplina Baze de date.
``` sql
ALTER table studenti_reusita
ALTER Column Nota decimal(5,2);

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
where Disciplina='Baze de date')
```
### Result:
![Ex38](https://github.com/speianudana/DB/blob/master/Laboratory4/Screenshots_DB/ex38.PNG)


