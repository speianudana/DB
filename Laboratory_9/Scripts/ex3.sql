--3. Sa se creeze o procedura stocata, care ar insera in baza de date informatii despre un student nou. in calitate de parametri de intrare sa serveasca datele personale ale studentului nou si Cod_ Grupa. Sa se genereze toate intrarile-cheie necesare in tabelul studenti_reusita. Notele de evaluare sa fie inserate ca NULL. 
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
