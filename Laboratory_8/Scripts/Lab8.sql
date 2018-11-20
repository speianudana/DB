/* # Laboratory 8
## Administrarea viziunilor și a expresiilor-tabel
### Sarcini practice:
#### 1.Să se creeze două viziuni in baza interogărilor formulate în două exerciții indicate din capitolul4. 
Prima viziune sa fie construită în Editorul de interogări, iar a doua, utilizand View
Designer. 
### Rezultat:
Am construit viziunea utilizând View Designer,pentru interogarea de la Laboratorul 4,exercițiul 17:
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab8/ex1(2).PNG)
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab8/ex1(1).PNG)
``` sql
USE universitatea
GO
DROP VIEW IF EXISTS dbo.exercitiul17;
GO
--Crearea viziune exercitiul17
CREATE VIEW exercitiul17 AS

SELECT Nume_Profesor,Prenume_Profesor
FROM profesori p
INNER JOIN studenti_reusita r
ON p.Id_Profesor=r.Id_Profesor
WHERE Id_Student=100
GROUP BY Nume_Profesor,Prenume_Profesor
GO
```

Am construit viziunea utilizând Editorul de interogări,pentru interogarea de la Laboratorul 4,exercițiul 38:
``` sql
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
```
### Rezultat:
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab8/ex1(3).PNG)
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab8/ex1(4).PNG)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
#### 2. Să se scrie cate un exemplu de instrucțiuni INSERT, UPDATE, DELETE asupra viziunilor
create. Să se adauge comentariile respective referitoare la rezultatele executarii acestor
instructiuni. 
Using UPDATE:
``` sql
UPDATE exercitiul38
SET Nota_Medie=8
WHERE Disciplina='Programarea WEB'
```
### Result:
![Ex2](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab8/ex2(1).PNG)
Nu s-au putut şterge datele din tabel deoarece există o legătură între tabele .

Using INSERT:

Firsty I will create a new view .A view that contain a table that has not relations with other tables:
``` sql
USE universitatea
GO
DROP VIEW IF EXISTS dbo.exercitiul2;
GO
--Crearea viziune exercitiul3
CREATE VIEW exercitiul2 AS
SELECT * FROM profesori_new WHERE Id_Profesor between 95 and 118
GO
--Test interogare viziune
SELECT * FROM exercitiul3
```
Now we will insert :
``` sql
USE universitatea
GO 
INSERT INTO exercitiul3
VALUES ('99','Speianu','Dana','s.Dubăsarii Vechi','str.Stefan cel Mare','14');

select * from exercitiul3
``` 
![Ex2](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab8/ex2(2).PNG)


Using DELETE:
``` sql
DELETE exercitiul3
WHERE Id_Profesor=99

SELECT * FROM exercitiul3
```
![Ex2](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab8/ex2(3).PNG)

Inserarea valorilor a fost cu succes deoarece aceată viziune foloseşte doar un tabel fără legături externe dar dacă ar fi mai multe tabele ar apărea o eroare că moficarea afectează mai multe tabele din baza de date. 
Now,lets do deletion for another view,for which table has relationships:
``` sql
DELETE exercitiul38
WHERE Disciplina ='Baze de date'
```
![Ex2](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab8/ex2(4).PNG)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

3.Să se scrie instructiunile SQL care ar modifica viziunile create (in exercitiul 1) in așa fel, incat
sa nu fie posibila modificarea sau ștergerea tabelelor pe care acestea sunt definite și viziunile
sa nu accepte operatiuni DML, daca conditiile clauzei WHERE nu sunt satisfăcute. 
Pentru viziunea exercitiul38:
``` sql

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
![Ex3](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab8/ex3(1).PNG)
```
Pentru viziunea exercitiul17:
``` sql
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
```
![Ex3](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab8/ex3(2).PNG)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
### 4.Să se scrie instrucţiunile de testare a proprietăților noi definite.
``` sql
USE universitatea 
GO
DROP Table dbo.profesori,dbo.studenti_reusita
UPDATE exemplul17 SET Prenume_Profesor='Dana' WHERE Prenume_Profesor='Diana'
```
![Ex4](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab8/ex4.PNG)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
### 5.Sa se rescrie 2 interogări formulate în exercițiile din capitolul 4, in așa fel, încat interogarile
imbricate sa fie redate sub forma expresiilor CTE. 

#### 38.Furnizați denumirile disciplinelor cu o medie mai mică decît media notelor de la disciplina Baze de date.
``` sql
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
```
### Result:
![Ex5](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab8/ex5(1).PNG)

#### 26.Găsiți numele,prenumele și adresele studenților și ale profesorilor care locuiesc pe strada 31 August.
``` sql
;with persons31aug (Nume,Prenume,Adresa_Postala) as
(SELECT Nume_Student,
       Prenume_Student,
	   Adresa_Postala_Student 
       FROM studenti
      WHERE Adresa_Postala_Student LIKE '%31 August%'
UNION

SELECT Nume_Profesor ,
       Prenume_Profesor ,
	   Adresa_Postala_Profesor
	   FROM profesori
	   WHERE Adresa_Postala_Profesor LIKE '%31 August%')
select * from persons31aug 
```
### Result:
![Ex5](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab8/ex5(2).PNG)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
6.Se considera un graf orientat, precum cel din figura de mai jos și fie se dorește parcursă calea
de la nodul id = 3 la nodul unde id = 0. Să se facă reprezentarea grafului orientat in forma de
expresie-tabel recursiv.
Să se observe instrucțiunea de dupa UNION ALL a membrului recursiv, precum și partea de
pana la UNION ALL reprezentata de membrul-ancora. 
![Ex6](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab8/ex6(1).PNG)



*/