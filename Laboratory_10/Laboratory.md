# Laboratory 10
## CREAREA ȘI UTILIZAREA DECLANȘATOARELOR
### Sarcini practice:
#### 1. Sa se modifice declanșatorul inregistrare _ noua, in așa fel, încat în cazul actualizării
auditoriului să apară mesajul de informare, care, în afară de disciplina și ora, va afișa codul
grupei afectate, ziua, blocul, auditoriul vechi și auditoriul nou. 
#### TRIGGER:
``` sql
USE universitatea;
GO
IF OBJECT_ID('inregistrare_noua','TR') is not null
DROP TRIGGER inregistrare_noua;
GO
CREATE TRIGGER inregistrare_noua ON orarul
AFTER INSERT
AS PRINT 'A fost creata o noua inregistrare'
GO


ALTER TRIGGER inregistrare_noua ON orarul
 AFTER UPDATE
 AS
 SET NOCOUNT ON
 IF UPDATE (Auditoriu)
 SELECT 'Lectia la disciplina"'+UPPER(d.Disciplina)+'"  de la ora:'+CAST(inserted.Ora as varchar(10))+'" pentru grupa  "'
 +CAST(g.Cod_Grupa as char(6))+'",in ziua de '+inserted.Zi+',Blocul "'+inserted.Bloc+'",s-a transferat din auditoriul "'+CAST(deleted.Auditoriu as varchar(5))+'" în auditoriul "'+CAST(inserted.Auditoriu as varchar(5))+'".'
 FROM grupe g,inserted,deleted
 join discipline d
 on deleted.Id_Disciplina=d.Id_Disciplina
 GO
```
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_10/Screenshots_lab10/ex1(1).PNG)

#### Verificare și rezultate:
``` sql
 UPDATE orarul 
 SET Auditoriu=119 where Id_Profesor=101
``` 
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_10/Screenshots_lab10/ex1(2).PNG)

``` sql
 select *  from orarul

```
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_10/Screenshots_lab10/ex1(3).PNG)

#### 2.Sa se creeze declanșatorul, care ar asigura popularea corectă (consecutivă) a tabelelor studenți
și studenti_reusita, și ar permite evitarea erorilor la nivelul cheilor externe. 
``` sql
CREATE TRIGGER Ex2 on dbo.studenti_reusita
	INSTEAD OF INSERT
	AS SET NOCOUNT ON
    DECLARE @Id_Student int 
    ,@Nume_Student varchar(50) ='Boisteanu'
	,@Prenume_Student varchar(50) ='Dumitru'
	,@Data_Nastere_Student varchar(50)
	,@Adresa_Postala_Student varchar (50)
	SELECT @Id_Student = Id_Student FROM inserted
	INSERT INTO dbo.studenti VALUES(@Id_Student, @Nume_Student, @Prenume_Student,null,null)
	INSERT INTO dbo.studenti_reusita 
	SELECT * FROM inserted;
		
		
	INSERT INTO dbo.studenti_reusita VALUES(202,107,100,1,'Examen', null, null)
```
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_10/Screenshots_lab10/ex2(1).PNG)
#### Rezultate:
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_10/Screenshots_lab10/ex2(2).PNG)
#### 3.Sa se creeze un declanșator, care ar interzice micșorarea notelor în tabelul studenti_reusita și modificarea valorilor campului Data_Evaluare, unde valorile acestui camp sunt nenule.Declanșatorul trebuie sa se lanseze, numai daca sunt afectate datele studentilor din grupa"CIB171". Se va afișa un mesaj de avertizare in cazul tentativei de a încălca constrangerea. 
#### TRIGGER:
``` sql
USE universitatea;
GO
  IF OBJECT_ID(' ex3_1 ', 'TR') IS NOT NULL 
  DROP TRIGGER ex3_1; 
  GO 
  CREATE TRIGGER ex3_1 
  ON studenti_reusita
  AFTER UPDATE 
  AS
  SET NOCOUNT ON
  IF UPDATE(Nota)
  BEGIN 
  If (Select AVG(Nota) from inserted  where Id_Grupa=(Select Id_Grupa from grupe where Cod_Grupa='CIB171') and Nota is not null)<
  (
 Select AVG(Nota) from deleted where Id_Grupa=(Select Id_Grupa from grupe where Cod_Grupa='CIB171') and Nota is not null )
  PRINT 'Tentativa de micsorare a Notei'; 
  ROLLBACK; 
END ;

IF UPDATE(Data_Evaluare)
BEGIN
PRINT'Tentativă de modificare a datei de evaluare';
ROLLBACK;
END
GO
```
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_10/Screenshots_lab10/ex3(1).PNG)

#### Verificare și rezultate:
``` sql
update studenti_reusita
SET Nota=Nota-1
where Id_Grupa=(Select Id_Grupa from grupe where Cod_Grupa='CIB171')
```
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_10/Screenshots_lab10/ex3(2).PNG)

``` sql
update studenti_reusita
SET Data_Evaluare='2018-10-25'
where Id_Disciplina=107
```
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_10/Screenshots_lab10/ex3(3).PNG)


#### 4. Sa se creeze un declanșator DDL care ar interzice modificarea coloanei Id_Disciplina în tabelele bazei de date universitatea cu afișarea mesajului respectiv. 
``` sql
USE universitatea;
GO 
DROP TRIGGER IF EXISTS Ex4 ON DATABASE;
GO
CREATE TRIGGER Ex4  ON DATABASE 
 FOR ALTER_TABLE 
 AS  
SET NOCOUNT ON 
DECLARE @Id_Disciplina int 
SELECT @Id_Disciplina=EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'nvarchar(max)') 
IF @Id_Disciplina='Id_Disciplina'
BEGIN
PRINT('Coloana Id_Disciplina nu poate fi modificata');
ROLLBACK;
END

ALTER TABLE studenti_reusita ALTER COLUMN Id_Disciplina char(1);
GO
```

#### 5.Sa se creeze un declanșator DDL care ar interzice modificarea schemei bazei de date în afara orelor de lucru. 
#### TRIGGER:
``` sql
use universitatea;
GO
DROP TRIGGER if exists ex5 ON DATABASE
GO
CREATE TRIGGER ex5 ON DATABASE 
FOR ALTER_TABLE
AS
SET NOCOUNT ON
DECLARE @Time_Now DATETIME
DECLARE @Start_Time DATETIME
DECLARE @Finish_Time DATETIME
DECLARE @A FLOAT
DECLARE @B FLOAT
SELECT @Time_Now=GETDATE()

SELECT @Start_Time ='2018-12-03 9:00'
SELECT @Finish_Time = '2018-12-03 18:00'
select @A=(cast (@Time_Now as float)-floor(cast(@Time_Now as float)))-
          (cast(@Start_Time as float)-floor(cast(@Start_Time as float))),
       @B=(cast(@Time_Now as float)-floor(cast(@Time_Now as float)))-
	      (cast(@Finish_Time as float)-floor(cast(@Finish_Time as float)))
IF @A<0 
BEGIN
Print('E prea devreme pentru modificări în baza de date!')
ROLLBACK;
END
if @B>0
BEGIN
Print ('E prea tîrziu pentru modificări în baza de date!')
ROLLBACK;
END

```
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_10/Screenshots_lab10/ex5(1).PNG)

#### Verificare și rezultate:
``` sql
alter table orarul
add pisica varchar(10)
```
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_10/Screenshots_lab10/ex5(2).PNG)


#### 6.Să se creeze un declanșator DDL care, la modificarea proprietatilor coloanei Id_Profesor dintr-un tabel, ar face schimbari asemănătoare în mod automat în restul tabelelor. 
``` sql
USE universitatea; 
 GO 
   DROP TRIGGER IF EXISTS ex6 ON DATABASE;  
   GO 
 CREATE TRIGGER ex6 ON DATABASE 
  FOR ALTER_TABLE
    AS 
 SET NOCOUNT ON 
 DECLARE @D varchar(10)  
 DECLARE @event1 varchar(500)  
 DECLARE @event2 varchar(500)  
 DECLARE @event3 varchar(50) 
 SELECT @D=EVENTDATA(). value('(/EVENT_INSTANCE/AlterTableActionList/*/Columns/Name)[1]','nvarchar(max)')
 IF @D = 'Id_Profesor'    
 BEGIN  
 SELECT @event1 = EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)') 
 SELECT @event3 = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','nvarchar(max)') 
 SELECT @event2 = REPLACE(@event1, @event3, 'profesori');
 EXECUTE (@event2) 
 SELECT @event2 = REPLACE(@event1, @event3, 'orarul');
 EXECUTE (@event2) 
 SELECT @event2 = REPLACE(@event1, @event3, 'studenti_reusita');
 EXECUTE (@event2)   
 PRINT 'Datele au fost modificate'   
  END 

alter TABLE profesori alter column Id_Profesor smallint 

```



