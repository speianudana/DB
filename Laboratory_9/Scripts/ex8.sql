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
