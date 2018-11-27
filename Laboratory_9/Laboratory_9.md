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
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex1(1).PNG)


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
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex1(2).PNG)

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
![Ex2](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex2.PNG)

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

select * from studenti
select * from studenti_reusita
```
#### Rezultat
![Ex3](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex3(1).PNG)
![Ex3](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex3(2).PNG)

#### 4.Fie ca un profesor se elibereaza din functie la mijlocul semestrului. Sa se creeze o procedura stocata care ar reatribui inregistrarile din tabelul studenti_reusita unui alt profesor. Parametri de intrare: numele si prenumele profesorului vechi, numele si prenumele profesorului nou,disciplina. in cazul in care datele inserate sunt incorecte sau incomplete, sa se afiseze un mesaj de avertizare. 
``` sql
USE universitatea
GO
DROP PROCEDURE IF EXISTS replaceProfesor;
GO
CREATE PROCEDURE replaceProfesor
@Nume_Profesor_old varchar(60),
@Prenume_Profesor_old varchar(60),
@Nume_Profesor_new varchar(60),
@Prenume_Profesor_new varchar(60),
@Disciplina varchar(255)
AS

IF ((select Id_Disciplina from discipline where Disciplina=@Disciplina) in (select distinct Id_Disciplina from studenti_reusita where Id_Profesor=(select Id_Profesor from profesori where Nume_Profesor=@Nume_Profesor_old and Prenume_Profesor=@Prenume_Profesor_old)))
BEGIN
  UPDATE profesori
  SET Nume_Profesor=@Nume_Profesor_new,Prenume_Profesor=@Prenume_Profesor_new
  WHERE Nume_Profesor=@Nume_Profesor_old and Prenume_Profesor=@Prenume_Profesor_old
  print('Înlocuirea profesorului '+@Nume_Profesor_old+' '+@Prenume_Profesor_old+' cu '+'profesorul '+@Nume_Profesor_new+' '+@Prenume_Profesor_new+' a avut loc cu succes.')
END
ELSE 
BEGIN
print('Atenție!!!')
print(@Nume_Profesor_old+ ' '+@Prenume_Profesor_old+' nu predă disciplina '+'"'+@Disciplina+'"'+'!!!')
END;
GO
```
Pentru un profesor care nu exista sau pentru cazul cind profesorul cu numele si prenumele dat nu preda disciplina data:
``` sql
EXECUTE replaceProfesor
@Nume_Profesor_old='Verebceanu',
@Prenume_Profesor_old='Mirela',
@Nume_Profesor_new ='Micu',
@Prenume_Profesor_new='Elena',
@Disciplina='Structuri de date si algoritmi'
```
![Ex4](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex4(1).PNG)

Pentru atunci cind profesorul preda disciplina pe care am dat-o:
``` sql
EXECUTE replaceProfesor
@Nume_Profesor_old='Micu',
@Prenume_Profesor_old='Elena',
@Nume_Profesor_new ='Verebceanu',
@Prenume_Profesor_new='Mirela',
@Disciplina='Structuri de date si algoritmi'
```
![Ex4](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex4(2).PNG)
``` sql
select * from profesori
```
![Ex4](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex4(3).PNG)
#### 5.Sa se creeze o procedura stocata care ar forma o lista cu primii 3 cei mai buni studenti la o disciplina, si acestor studenti sa le fie marita nota la examenul final cu un punct (nota maximala posibila este 10). in calitate de parametru de intrare, va servi denumirea disciplinei.Procedura sa returneze urmatoarele campuri: Cod_ Grupa, Nume_Prenume_Student,Disciplina, Nota _ Veche, Nota _ Noua. 



#### 6.Sa se creeze functii definite de utilizator in baza exercitiilor (2 exercitii) din capitolul 4.Parametrii de intrare trebuie sa corespunda criteriilor din clauzele WHERE ale exercitiilor respective. 
38.Furnizați denumirile disciplinelor cu o medie mai mică decît media notelor de la disciplina Baze de date.
``` sql
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
```
#### Rezultat:
![Ex6](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex6(1).PNG)
![Ex6](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex6(2).PNG)



17. Afișați numele și prenumele profesorilor, care au predat cel puțin o disciplină studentului cu identificatorul 100.
``` sql
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
```
![Ex6](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex6(3).PNG)
![Ex6](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex6(4).PNG)

#### 7. Sa se scrie functia care ar calcula varsta studentului. Sa se defineasca urmatorul format al functiei: 
(<nume Functie>(<Data _Nastere _Student>)).
	
	
``` sql
USE universitatea
GO
DROP function IF EXISTS studentAge;
GO
CREATE FUNCTION dbo.studentAge(@Data_Nastere_Student date)
RETURNS INT
    BEGIN
      DECLARE @Age int,@Now datetime
      SET @Now=GETDate()
      SELECT @Age=(CONVERT(int,CONVERT(char(8),@Now,112))-CONVERT(char(8),@Data_Nastere_Student,112))/10000
RETURN @Age
END
```
#### Rezultat:
![Ex7](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex7.PNG)

#### 8.Sa se creeze o functie definita de utilizator, care ar returna datele referitoare la reusita unui student. Se defineste urmatorul format al functiei: nume Functie(<Nume_Prenume_Student>).Sa fie afisat tabelul cu urmatoarele campuri:Nume_Prenume_Student, Distiplina, Nota, Data_Evaluare. 

``` sql
USE universitatea
GO
DROP FUNCTION IF EXISTS studentReusita
GO
CREATE FUNCTION studentReusita(@Nume_Prenume_Student varchar(50))
RETURNS TABLE
WITH ENCRYPTION
AS
RETURN
(SELECT concat(Nume_Student,' ',Prenume_Student) as Nume_Prenume_Student,Disciplina,Nota,Data_Evaluare
 from studenti_reusita r
 inner join discipline d
 on r.Id_Disciplina=d.Id_Disciplina
 inner join studenti s
 on r.Id_Student=s.Id_Student
 WHERE concat(Nume_Student,' ',Prenume_Student)=@Nume_Prenume_Student); 

SELECT * From dbo.studentReusita('Cosovanu Geanina')

```
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex8(1).PNG)
#### Rezultat:
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex8(2).PNG)

#### 9.Se cere realizarea unei functii definite de utilizator, care ar gasi cel mai sarguincios sau cel mai slab student dintr-o grupa. Se defineste urmatorul format al functiei: numeFunctie(Cod_ Grupa, is_good). Parametrul <is_good> poate accepta valorile "sarguincios" sau "slab", respectiv. Functia sa returneze un tabel cu urmatoarele campuri Grupa,Nume_Prenume_Student, Nota Medie , is_good. Nota Medie sa fie cu precizie de 2 zecimale.
``` sql
DROP FUNCTION IF EXISTS studentReusita1
GO
CREATE FUNCTION studentReusita1(@Cod_Grupa varchar(6),@is_good varchar(20))
RETURNS @result TABLE 
   (Cod_Grupa varchar(6),Nume_Prenume_Student varchar(50),Nota_Medie  decimal(4,2),is_good varchar(20))
   AS
 BEGIN
   if @is_good='sirguincios'
   
   INSERT INTO @result
 Select @Cod_Grupa,concat(Nume_Student,' ',Prenume_Student) as Nume_Prenume_Student,cast(avg(Nota)as decimal(4,2)) as Nota_Medie ,@is_good
  from studenti s
  inner join studenti_reusita r
  on s.Id_Student=r.Id_Student
  where Nume_Student=(select top 1 Nume_Student
                      from studenti s
                      inner join studenti_reusita r
                      on s.Id_Student=r.Id_Student
                      where Id_Grupa =(Select Id_Grupa from grupe where Cod_Grupa=@Cod_Grupa )
                      Group by Nume_Student,Prenume_Student
                      Order by AVG(Nota) DESC) 
  and Prenume_Student=(select top 1 Prenume_Student
                      from studenti s
                      inner join studenti_reusita r
                      on s.Id_Student=r.Id_Student
                      where Id_Grupa =(Select Id_Grupa from grupe where Cod_Grupa=@Cod_Grupa )
                      Group by Nume_Student,Prenume_Student
                      Order by AVG(Nota) DESC)
Group by Nume_Student,Prenume_Student

else if @is_good='slab'
insert into @result 
Select @Cod_Grupa,concat(Nume_Student,' ',Prenume_Student)as Nume_Prenume_Student,cast(avg(Nota)as decimal(4,2)) as Nota_Medie ,@is_good
  from studenti s
  inner join studenti_reusita r
  on s.Id_Student=r.Id_Student
  where Nume_Student=(select top 1 Nume_Student
                      from studenti s
                      inner join studenti_reusita r
                      on s.Id_Student=r.Id_Student
                      where Id_Grupa =(Select Id_Grupa from grupe where Cod_Grupa=@Cod_Grupa )
                      Group by Nume_Student,Prenume_Student
                      Order by AVG(Nota) ASC) 
  and Prenume_Student=(select top 1 Prenume_Student
                      from studenti s
                      inner join studenti_reusita r
                      on s.Id_Student=r.Id_Student
                      where Id_Grupa =(Select Id_Grupa from grupe where Cod_Grupa=@Cod_Grupa )
                      Group by Nume_Student,Prenume_Student
                      Order by AVG(Nota) ASC)
Group by Nume_Student,Prenume_Student
return;
end
```
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex9(1).PNG)
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex9(2).PNG)

#### Rezultate:
``` sql
select * from dbo.studentReusita1('INF171','sirguincios')

```
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex9(4).PNG)
``` sql
select * from dbo.studentReusita1('INF171','slab')
```
![Ex8](https://github.com/speianudana/DB/blob/master/Laboratory_9/Screenshots_lab9/ex9(3).PNG)












