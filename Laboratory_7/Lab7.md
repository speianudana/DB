# Laboratory 7
## DIAGRAME, SCHEME ȘI SINONIME 
### Sarcini practice
### 1. Creați o diagramă a bazei de date, folosind forma de vizualizare standard, structura căreia este descrisă la începutul sarcinilor practice din capitolul 4. 
### Rezultat
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_7/Screenshots_Lab7/ex1.PNG)
### 2.Sa se adauge constrangeri referentiale (legate cu tabelele studenti și profesori) necesare coloanelor Sef_grupa și Prof_Indrumator (sarcina3, capitolul 6) din tabelul grupe. 
![Ex2](https://github.com/speianudana/DB/blob/master/Laboratory_7/Screenshots_Lab7/ex2(1).PNG)
![Ex2](https://github.com/speianudana/DB/blob/master/Laboratory_7/Screenshots_Lab7/ex2(2).PNG)
![Ex2](https://github.com/speianudana/DB/blob/master/Laboratory_7/Screenshots_Lab7/ex2(3).PNG)
![Ex2](https://github.com/speianudana/DB/blob/master/Laboratory_7/Screenshots_Lab7/ex2(4).PNG)

### 3 La diagrama construită, să se adauge și tabelul orarul definit în capitolul 6 al acestei lucrari:tabelul orarul conține identificatorul disciplinei (ld_Disciplina), identificatorul profesorului(Id_Profesor) și blocul de studii (Bloc). Cheia tabelului este constituită din trei cîmpuri:identificatorul grupei (Id_ Grupa), ziua lectiei (Z1), ora de inceput a lectiei (Ora), sala unde are loc lectia (Auditoriu). 
``` sql
CREATE TABLE orarul( Id_Disciplina int NOT NULL,
                       Id_Profesor int NOT NULL, 
					   Id_Grupa smallint NOT NULL,
					   Zi       char(2) NOT NULL,
					   Ora       Time NOT NULL,
					   Auditoriu  int NOT NULL,
					   Bloc       char(1) NOT NULL DEFAULT ('B'),
CONSTRAINT [PK_orarul] PRIMARY KEY CLUSTERED 
(
	Id_Grupa ASC,
	Zi ASC,
	Ora ASC,
	Auditoriu )) ON [PRIMARY]

INSERT orarul VALUES(107, 101, (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='CIB171'), 'Lu', '08:00', 202,DEFAULT)
INSERT orarul VALUES(108, 101, (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='CIB171'), 'Lu', '11:30', 501,DEFAULT)
INSERT orarul VALUES(109, 117, (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='CIB171'), 'Lu', '13:00', 501,DEFAULT)   

INSERT INTO orarul (Id_Disciplina,Id_Profesor,Id_Grupa,Zi,Ora,Auditoriu,Bloc) 
VALUES ((SELECT Id_Disciplina FROM discipline WHERE Disciplina='Structuri de date si algoritmi'),
        (SELECT Id_Profesor FROM profesori WHERE Nume_Profesor='Bivol' and Prenume_Profesor='Ion' ),
        (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='INF171'),'Lu','08:00',115,DEFAULT)
    
INSERT INTO orarul (Id_Disciplina,Id_Profesor,Id_Grupa,Zi,Ora,Auditoriu,Bloc) 
VALUES ((SELECT Id_Disciplina FROM discipline WHERE Disciplina='Programe aplicative'),
        (SELECT Id_Profesor FROM profesori WHERE Nume_Profesor='Mircea' and Prenume_Profesor='Sorin' ),
        (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='INF171'),'Lu','11:30',113,DEFAULT)

INSERT INTO orarul (Id_Disciplina,Id_Profesor,Id_Grupa,Zi,Ora,Auditoriu,Bloc) 
VALUES ((SELECT Id_Disciplina FROM discipline WHERE Disciplina='Baze de date'),
        (SELECT Id_Profesor FROM profesori WHERE Nume_Profesor='Micu' and Prenume_Profesor='Elena' ),
        (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='INF171'),'Lu','13:00',118,DEFAULT)
```
![Ex3](https://github.com/speianudana/DB/blob/master/Laboratory_7/Screenshots_Lab7/ex3(1).PNG)
![Ex3](https://github.com/speianudana/DB/blob/master/Laboratory_7/Screenshots_Lab7/ex3(2).PNG)

### 4.Tabelul orarul trebuie să conțină și 2 chei secundare: (Zi, Ora, Id_ Grupa, Id_ Profesor) și (Zi, Ora, ld_Grupa, ld_Disciplina). 
### Rezultat:

### 5.În diagrama, de asemenea, trebuie sa se defineasca constrangerile referentiale (FK-PK) ale atributelor ld_Disciplina, ld_Profesor, Id_ Grupa din tabelului orarul cu atributele tabelelor respective.
### Rezultat:
![Ex5](https://github.com/speianudana/DB/blob/master/Laboratory_7/Screenshots_Lab7/ex5(1).PNG)
![Ex5](https://github.com/speianudana/DB/blob/master/Laboratory_7/Screenshots_Lab7/ex5(2).PNG)
### 6. Creati, în baza de date universitatea, trei scheme noi: cadre_didactice, plan_studii și studenti. Transferați tabelul profesori din schema dbo in schema cadre didactice, ținînd cont de dependentele definite asupra tabelului menționat. În același mod să se trateze tabelele orarul,discipline care aparțin schemei plan_studii și tabelele studenți, studenti_reusita, care apartin schemei studenti. Se scrie instructiunile SQL respective. 
``` sql
use universitatea
GO
CREATE SCHEMA cadre_didactice;
GO
ALTER SCHEMA cadre_didactice TRANSFER dbo.profesori

GO
CREATE SCHEMA plan_studii;
GO
ALTER SCHEMA plan_studii TRANSFER dbo.orarul
ALTER SCHEMA plan_studii TRANSFER dbo.discipline

GO
CREATE SCHEMA studenti;
GO
ALTER SCHEMA studenti TRANSFER dbo.studenti
ALTER SCHEMA studenti TRANSFER dbo.studenti_reusita
 ```
 ### Rezultat:
 ![Ex6](https://github.com/speianudana/DB/blob/master/Laboratory_7/Screenshots_Lab7/ex6.PNG)
 ### 7.Modificati 2-3 interogari asupra bazei de date universitatea prezentate in capitolul 4 astfel ca numele tabelelor accesate sa fie descrise in mod explicit, ținînd cont de faptul ca tabelele au fost mutate in scheme noi.
 #### 38.Furnizați denumirile disciplinelor cu o medie mai mică decît media notelor de la disciplina Baze de date.
 ``` sql
 --38.Furnizați denumirile disciplinelor cu o medie mai mică decît media notelor de la disciplina Baze de date.

ALTER table studenti.studenti_reusita
ALTER Column Nota decimal(4,2);

SELECT  plan_studii.discipline.Disciplina,
        AVG(Nota) as Nota_Medie
FROM  plan_studii.discipline 
INNER JOIN studenti.studenti_reusita 
ON       plan_studii.discipline.Id_Disciplina=studenti.studenti_reusita.Id_Disciplina
GROUP BY Disciplina
HAVING AVG(studenti.studenti_reusita.Nota)>(SELECT AVG(studenti.studenti_reusita.Nota) AS Nota_Medie
FROM plan_studii.discipline 
INNER JOIN studenti.studenti_reusita 
ON plan_studii.discipline.Id_Disciplina=studenti.studenti_reusita .Id_Disciplina
where Disciplina='Baze de date')
 ```
 #### Rezultat:
  ![Ex7](https://github.com/speianudana/DB/blob/master/Laboratory_7/Screenshots_Lab7/ex7(1).PNG)
  ![Ex7](https://github.com/speianudana/DB/blob/master/Laboratory_7/Screenshots_Lab7/ex7(2).PNG)





