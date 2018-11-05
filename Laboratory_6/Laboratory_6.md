# Laboratory 6
## CREAREA TABELELOR ȘI INDECȘILOR
### Sarcini practice
### 1.Sa se scrie o instructiune T-SQL, care ar popula coloana Adresa _ Postala _ Profesor din tabelul profesori cu valoarea 'mun. Chisinau', unde adresa este necunoscută.
``` sql
UPDATE profesori SET Adresa_Postala_Profesor='mun. Chisinău' WHERE Adresa_Postala_Profesor IS NULL;
SELECT Nume_Profesor,Prenume_Profesor,Adresa_Postala_Profesor 
FROM profesori
```
### Rezultat
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/ex1.PNG)

### 2. Sa se modifice schema tabelului grupe, ca sa corespunda urmatoarelor cerinte:
``` sql
--   a) Campul Cod_ Grupa sa accepte numai valorile unice și să nu accepte valori necunoscute.
        ALTER TABLE grupe 
        ADD UNIQUE (Cod_Grupa);

--   b) Să se țină cont că cheie primară, deja, este definită asupra coloanei Id_ Grupa.       
      ALTER TABLE grupe
      ALTER COLUMN Cod_Grupa char(6) NOT NULL;
```
### Rezultat
![Ex2](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/ex2.PNG)

### 3.La tabelul grupe, să se adauge 2 coloane noi Sef_grupa și Prof_Indrumator, ambele de tip INT. Să se populeze câmpurile nou-create cu cele mai potrivite candidaturi în baza criteriilor de mai jos: 
  ### a) Șeful grupei trebuie să aibă cea mai bună reușită (medie) din grupă la toate formele de evaluare și la toate disciplinele. Un student nu poate fi șef de grupa la mai multe grupe.
  ### b) Profesorul îndrumător trebuie să predea un număr maximal posibil de discipline la grupa data. Daca nu există o singură candidatură, care corespunde primei cerințe, atunci este ales din grupul de candidați acel cu identificatorul (Id_Profesor) minimal. Un profesor nu poate fi indrumător la mai multe grupe.
  ### c) Să se scrie instructiunile ALTER, SELECT, UPDATE necesare pentru crearea coloanelor în tabelul grupe, pentru selectarea candidaților și înserarea datelor.
  ``` sql
ALTER TABLE grupe
ADD Sef_Grupa int,Prof_Indrumator int;

DECLARE c1 CURSOR FOR 
SELECT id_grupa FROM grupe 

DECLARE @gid int
    ,@sid int
    ,@pid int

OPEN c1
FETCH NEXT FROM c1 into @gid 
WHILE @@FETCH_STATUS = 0
BEGIN
 SELECT TOP 1 @sid=id_student
   FROM studenti_reusita
   WHERE id_grupa = @gid and Id_Student NOT IN (SELECT isnull(sef_grupa,'') FROM grupe)
   GROUP BY id_student
   ORDER BY cast(avg (NOTA*1.0)as decimal(5,2)) DESC

 SELECT TOP 1 @pid=id_profesor
      FROM studenti_reusita
      WHERE id_grupa = @gid AND Id_profesor NOT IN (SELECT isnull (prof_indrumator, '') FROM grupe)
      GROUP BY id_profesor
      ORDER BY count (DISTINCT id_disciplina) DESC, id_profesor
 
 UPDATE grupe
    SET   sef_grupa = @sid
      ,prof_indrumator = @pid
  WHERE Id_Grupa=@gid
 FETCH NEXT FROM c1 into @gid 
END
CLOSE c1
DEALLOCATE c1

Select *
from grupe
```
### Rezultat:
![Ex3](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/ex3(1).PNG)
![Ex3](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/ex3(2).PNG)
![Ex3](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/ex3(3).PNG)

### 4.Să se scrie o instrucțiune T-SQL, care ar mări toate notele de evaluare șefilor de grupe cu un punct. Nota maximală (10) nu poate fi mărită.
``` sql
DECLARE @ID_SEF_1 FLOAT;
DECLARE @ID_SEF_2 FLOAT;
DECLARE @ID_SEF_3 FLOAT;
SET @ID_SEF_1=(SELECT TOP 1 sef_grupa from grupe)
SET @ID_SEF_2=(SELECT TOP 1 sef_grupa from grupe 
               WHERE sef_grupa IN(select top 2 sef_grupa 
                                  from grupe
				  order by sef_grupa asc)
               ORDER BY sef_grupa DESC)                  
SET @ID_SEF_3=(SELECT TOP 1 sef_grupa from grupe 
               WHERE sef_grupa IN 
			                 (select top 3 sef_grupa from grupe
							    order by sef_grupa asc)
			   ORDER BY sef_grupa DESC
                   )

UPDATE studenti_reusita SET Nota=Nota+1 WHERE Id_Student IN(@ID_SEF_1, @ID_SEF_2, @ID_SEF_3) AND Nota!=10 
```






