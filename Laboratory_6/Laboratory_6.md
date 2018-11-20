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
  #### a) Șeful grupei trebuie să aibă cea mai bună reușită (medie) din grupă la toate formele de evaluare și la toate disciplinele. Un student nu poate fi șef de grupa la mai multe grupe.
  #### b) Profesorul îndrumător trebuie să predea un număr maximal posibil de discipline la grupa data. Daca nu există o singură candidatură, care corespunde primei cerințe, atunci este ales din grupul de candidați acel cu identificatorul (Id_Profesor) minimal. Un profesor nu poate fi indrumător la mai multe grupe.
  #### c) Să se scrie instructiunile ALTER, SELECT, UPDATE necesare pentru crearea coloanelor în tabelul grupe, pentru selectarea candidaților și înserarea datelor.
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
SET @ID_SEF_1=(SELECT TOP 1 sef_grupa FROM grupe)
SET @ID_SEF_2=(SELECT TOP 1 sef_grupa FROM grupe 
               WHERE sef_grupa IN(SELECT TOP 2 sef_grupa 
                                  FROM grupe
				  ORDER BY sef_grupa ASC)
               ORDER BY sef_grupa DESC)                  
SET @ID_SEF_3=(SELECT TOP 1 sef_grupa FROM grupe 
               WHERE sef_grupa IN (SELECT top 3 sef_grupa 
				   FROM grupe
				   ORDER BY sef_grupa asc)
	       ORDER BY sef_grupa DESC)

UPDATE studenti_reusita SET Nota=Nota+1 WHERE Id_Student IN(@ID_SEF_1, @ID_SEF_2, @ID_SEF_3) AND Nota!=10 

SELECT * FROM studenti_reusita
```
### Rezultat:
![Ex4](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/ex4(1).PNG)
![Ex4](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/ex4.PNG)


### 5. Sa se creeze un tabel profesori_new, care include urmatoarele coloane: Id_Profesor,Nume _ Profesor, Prenume _ Profesor, Localitate, Adresa _ 1, Adresa _ 2.
  #### a) Coloana Id_Profesor trebuie sa fie definita drept cheie primara și, în baza ei, sa fie construit un index CLUSTERED.
  #### b) Cîmpul Localitate trebuie sa posede proprietatea DEFAULT= 'mun. Chisinau'.
  #### c) Să se insereze toate datele din tabelul profesori în tabelul profesori_new. Să se scrie, cu acest scop, un număr potrivit de instrucțiuni T-SQL. Datele trebuie să fie transferate în felul următor: 
  ![Ex5](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/ex5.PNG)
  #### În coloana Localitate să fie inserata doar informatia despre denumirea localității din coloana-sursă Adresa_Postala_Profesor. În coloana Adresa_l, doar denumirea străzii. În coloana Adresa_2, să se păstreze numărul casei și (posibil) a apartamentului. 
``` sql
CREATE TABLE profesori_new
(Id_Profesor int NOT NULL
 ,Nume_Profesor char(255)
 ,Prenume_Profesor char(255)
 ,Localitate char (255) DEFAULT('mun. Chisinau')
 ,Adresa_1 char (60)
 ,Adresa_2 char (60),
  CONSTRAINT [PK_profesori_new] PRIMARY KEY CLUSTERED 
(	Id_Profesor )) ON [PRIMARY]
CREATE FUNCTION INSTR(@str VARCHAR(8000), @substr VARCHAR(255), @start INT, @occurrence INT)
  RETURNS INT
  AS
  BEGIN
	DECLARE @found INT = @occurrence,
			@pos INT = @start;
 
	WHILE 1=1 
	BEGIN
		-- Find the next occurrence
		SET @pos = CHARINDEX(@substr, @str, @pos);
 
		-- Nothing found
		IF @pos IS NULL OR @pos = 0
			RETURN @pos;
 
		-- The required occurrence found
		IF @found = 1
			BREAK;
 
		-- Prepare to find another one occurrence
		SET @found = @found - 1;
		SET @pos = @pos + 1;
	END
 
	RETURN @pos;
  END
  GO
INSERT INTO profesori_new(Id_Profesor, Nume_Profesor, Prenume_Profesor, Localitate, Adresa_1, Adresa_2)
 SELECT Id_Profesor,
        Nume_Profesor,
	Prenume_Profesor,
	CASE 
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', ''))=3 
		THEN  Substring(Adresa_Postala_Profesor,1, dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2)-1)
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', '')) =2 
		THEN Substring(Adresa_Postala_Profesor,1, charindex(',',Adresa_Postala_Profesor)-1)
		ELSE Adresa_Postala_Profesor
		END as  localitate,
	CASE 
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', ''))=3 
		THEN  Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2)+1,
		(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 3))-(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2))-1)
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', '')) =2 
		THEN Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 1)+1,
		(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2))-(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 1))-1)
		ELSE NULL
		END as  Adresa_1,
	CASE 
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', ''))=3 
		THEN  Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 3)+1, 5)
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', '')) =2 
		THEN Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2)+1, 5)
		ELSE NULL
		END as  Adresa_2
	FROM profesori;
		
select * from profesori_new
```
### Rezultat:
![Ex5](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/5(1).PNG)
![Ex5](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/ex5(2).PNG)
![Ex5](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/ex5(3).PNG)
![Ex5](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/5(4).PNG)

### 6. Să se insereze datele in tabelul orarul pentru Grupa= 'CIBJ 71' (Id_ Grupa= 1) pentru ziua de luni. Toate lectiile vor avea loc          în blocul de studii 'B'. Mai jos, sunt prezentate detaliile de inserare:
#### (ld_Disciplina = 107, Id_Profesor= 101, Ora ='08:00', Auditoriu = 202);
####  (Id_Disciplina = 108, Id_Profesor= 101, Ora ='11:30', Auditoriu = 501);
####  (ld_Disciplina = 119, Id_Profesor= 117, Ora ='13:00', Auditoriu = 501); 
``` sql
CREATE TABLE orarul( Id_Disciplina int NOT NULL,
                       Id_Profesor int NOT NULL, 
					   Id_Grupa smallint NOT NULL,
					   Zi       char(2) NOT NULL,
					   Ora       Time NOT NULL,
					   Auditoriu  int ,
					   Bloc       char(1) NOT NULL DEFAULT ('B'),
CONSTRAINT [PK_orarul] PRIMARY KEY CLUSTERED 
(
	Id_Disciplina ASC,
	Id_Profesor,
	Id_Grupa ,
	ZI )) ON [PRIMARY]

INSERT orarul VALUES(107, 101, (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='CIB171'), 'Lu', '08:00', 202,DEFAULT)
INSERT orarul VALUES(108, 101, (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='CIB171'), 'Lu', '11:30', 501,DEFAULT)
INSERT orarul VALUES(109, 117, (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='CIB171'), 'Lu', '13:00', 501,DEFAULT)           

SELECT *  FROM orarul
```
### Rezultat:
![Ex6](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/ex6.PNG)
![Ex6](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/ex6(1).PNG)

### 7. Să se scrie expresiile T-SQL necesare pentru a popula tabelul orarul pentru grupa INF171 ,ziua de luni. 
###   Datele necesare pentru inserare trebuie sa fie colectate cu ajutorul instructiunii/instructiunilor  SELECT și introduse in tabelul-destinație, știind că:
#### lectie #1 (Ora ='08:00', Disciplina = 'Structuri de date si algoritmi', Profesor ='Bivol Ion')
#### lectie #2 (Ora ='11 :30', Disciplina = 'Programe aplicative', Profesor ='Mircea Sorin')
#### lectie #3 (Ora ='13:00', Disciplina ='Baze de date', Profesor = 'Micu Elena') 
``` sql
INSERT INTO orarul (Id_Disciplina,Id_Profesor,Id_Grupa,Zi,Ora,Auditoriu,Bloc) 
VALUES ((SELECT Id_Disciplina FROM discipline WHERE Disciplina='Structuri de date si algoritmi'),
        (SELECT Id_Profesor FROM profesori WHERE Nume_Profesor='Bivol' and Prenume_Profesor='Ion' ),
		(SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='INF171'),'Lu','08:00',DEFAULT,DEFAULT)
    
INSERT INTO orarul (Id_Disciplina,Id_Profesor,Id_Grupa,Zi,Ora,Auditoriu,Bloc) 
VALUES ((SELECT Id_Disciplina FROM discipline WHERE Disciplina='Programe aplicative'),
        (SELECT Id_Profesor FROM profesori WHERE Nume_Profesor='Mircea' and Prenume_Profesor='Sorin' ),
		(SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='INF171'),'Lu','11:30',DEFAULT,DEFAULT)

INSERT INTO orarul (Id_Disciplina,Id_Profesor,Id_Grupa,Zi,Ora,Auditoriu,Bloc) 
VALUES ((SELECT Id_Disciplina FROM discipline WHERE Disciplina='Baze de date'),
        (SELECT Id_Profesor FROM profesori WHERE Nume_Profesor='Micu' and Prenume_Profesor='Elena' ),
		(SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='INF171'),'Lu','13:00',DEFAULT,DEFAULT)
SELECT *  FROM orarul
```
### Rezultat:
![Ex7](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/ex7.PNG)
![Ex7](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/ex7(1).PNG)


### 8.Sa se scrie interogarile de creare a indecșilor asupra tabelelor din baza de date universitatea pentru a asigura o performanta sporita la executarea interogarilor SELECT din Lucrarea practica 4. Rezultatele optimizarii sa fie analizate in baza planurilor de executie, pana la și dupa crearea indecșilor.Indecșii nou-creati sa fie plasati fizic in grupul de fișiere userdatafgroupl (Crearea și întreșinerea bazei de date - sectiunea 2.2.2) 
Crearea filegrupului:
``` sql
ALTER DATABASE universitatea
ADD FILEGROUP userdatafgroupl
GO

ALTER DATABASE universitatea
ADD FILE
( NAME = Indexes,
FILENAME = 'C:\SQL\MyDocuments\Data\db.ndf',
SIZE = 8MB
)
TO FILEGROUP userdatafgroupl
GO
```

#### 6.Afișați numele și prenumele primilor 5 studenți, care au obținut note în ordine descrescătoare la al doilea test de la disciplina Baze de date.

Rezultate înainte de indexare:

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
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/8(1).PNG)
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/8(2).PNG)
Rezultatele după indexare:
``` sql
set statistics io on
set statistics time on

Create Unique nonclustered Index ix_student_reusita on studenti_reusita(Id_Student,Id_Disciplina, Tip_Evaluare, Nota DESC)
where Tip_Evaluare = 'Testul 2' 
on userdatafgroupl
```
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/8(3).PNG)
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/8(4).PNG)
#### 38.Furnizați denumirile disciplinelor cu o medie mai mică decît media notelor de la disciplina Baze de date.
Rezultatele înainte de indexare:
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/8(5).PNG)
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/8(6).PNG)
Rezultatele după indexare pe tabelul discipline:
``` sql
Create Unique nonclustered Index ix_discipline on discipline(Id_Disciplina, Disciplina)
where Disciplina = 'Baze de date' 
on userdatafgroupl
```
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/8(7).PNG)
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/8(8).PNG)
Rezultatele după indexare pe tabelul studenti_reusita(Id_Disciplina):
``` sql
Create nonclustered index ix_studenti_reusita_2 on studenti_reusita (Id_Disciplina) include (Nota)
on userdatafgroupl
```
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/8(9).PNG)
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_6/Screenshots_Lab6/8(10).PNG)


