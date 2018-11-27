# Laboratory 9
## Proceduri stocate și funții definite de utilizator
### Sarcini parctice:
#### 1. Sa se creeze proceduri stocate in baza exercitiilor (2 exercitii) din capitolul 4. Parametrii de intrare trebuie sa corespunda criteriilor din clauzele WHERE ale exercitiilor respective . 
 6.Afișați numele și prenumele primilor 5 studenți, care au obținut note în ordine descrescătoare la al doilea test de la disciplina Baze de date.
``` sql
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
``` 
### Rezultat:
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab9/ex1(1).PNG)


38.Furnizați denumirile disciplinelor cu o medie mai mică decît media notelor de la disciplina Baze de date.
``` sql
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
```
### Rezultat:
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab9/ex1(2).PNG)

#### 2.Sa se creeze o procedura stocată, care nu are niciun parametru de intrare și posedă un parametru de ieșire. Parametrul de ieșire trebuie să returneze numarul de studenți, care nu au sustinut cel putin o forma de evaluare (nota mai mica de 5 sau valoare NULL). 
``` sql
USE universitatea
GO
DROP PROCEDURE IF EXISTS test3;
GO
CREATE PROCEDURE test3
@Nr_studenti int=NULL OUTPUT
AS
SET @Nr_studenti=(
SELECT COUNT(DISTINCT ID_Student) 
FROM studenti_reusita
where Nota<5 or Nota is NULL)
print('Numarul de studenti care nu au sustinut cel putin o formă de evaluare este '+CAST(@Nr_studenti as varchar(10))+'.')

EXEC test3;
```
### Rezultat:
![Ex2](https://github.com/speianudana/DB/blob/master/Laboratory_8/Screenshots_lab9/ex2.PNG)

#### 3. Sa se creeze o procedura stocata, care ar insera in baza de date informatii despre un student nou. in calitate de parametri de intrare sa serveasca datele personale ale studentului nou si Cod_ Grupa. Sa se genereze toate intrarile-cheie necesare in tabelul studenti_reusita. Notele de evaluare sa fie inserate ca NULL. 
``` sql
USE universitatea
GO
DROP PROCEDURE IF EXISTS insertStudent;
GO
CREATE PROCEDURE insertStudent
@Id_Student int,
@Nume_Student varchar(50),
@Prenume_Student varchar(50), 
@Data_Nastere_Student datetime, 
@Adresa_Postala_Student varchar(500),
@Cod_Grupa char(6),
@Id_Grupa int,
@Id_Disciplina int,
@Id_Profesor int,
@Tip_Evaluare varchar(60)

AS
SET NOCOUNT ON
SET @Id_Grupa=(Select Id_Grupa from grupe where Cod_Grupa=@Cod_Grupa )
SET @Id_Disciplina=(SELECT Id_Disciplina from discipline where Disciplina='Baze de date')
SET @Id_Profesor=(SELECT Id_Profesor from profesori where Prenume_Profesor='Ion' and Nume_Profesor='Bivol')
SET @Tip_Evaluare='Testul 1'
     INSERT INTO dbo.studenti
	        (Id_Student,
		       Nume_Student,
           Prenume_Student,
           Data_Nastere_Student,
           Adresa_Postala_Student)
     VALUES
           (@Id_Student
           ,@Nume_Student
           ,@Prenume_Student
           ,@Data_Nastere_Student
           ,@Adresa_Postala_Student)
INSERT INTO studenti_reusita(Id_Student,Id_Grupa,Id_Disciplina,Id_Profesor,Tip_Evaluare) VALUES(@Id_Student,@Id_Grupa,@Id_Disciplina,@Id_Profesor,@Tip_Evaluare)
GO

EXECUTE insertStudent
@Id_Student =191,
@Nume_Student='Speianu' ,
@Prenume_Student='Dana' , 
@Data_Nastere_Student='1998-10-05' , 
@Adresa_Postala_Student='mun.Chisinau,str.Studentilor,7/1' ,
@Cod_Grupa='CIB171',
@Id_Grupa=NULL,
@Id_Disciplina=NULL,
@Id_Profesor=NULL,
@Tip_Evaluare=NULL
GO
```








