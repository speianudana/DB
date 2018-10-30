--4. Modificati exercitiile din sarcinile 1 și 2 pentru a include procesarea erorilor cu TRY și CATCH, și RAISERRROR. 
BEGIN TRY
DECLARE @Nota1 int, @Nota2 int,@TipEvaluare varchar(10),@Disciplina varchar(20),@Top int,@result decimal(3,2);
SET @Nota1=0;
SET @Nota2=8;
SET @result=@Nota2=0;
SET @TipEvaluare='Testul 1';
SET @Disciplina='Baze de date';
SET @Top=10;
PRINT 'There are not any errors'
end try
begin catch
print 'There is an error'
print 'Error information:'
PRINT '   The number of error:'+CAST(ERROR_NUMBER() AS VARCHAR(20))
PRINT '   Level ofSeverity:'+CAST(ERROR_SEVERITY() AS VARCHAR(20))
PRINT '   The error status:'+CAST(ERROR_STATE() AS VARCHAR(20))
PRINT '   Error line:'+CAST( ERROR_LINE() AS VARCHAR(20))
PRINT '   Error:'+CAST(ERROR_MESSAGE() AS VARCHAR(200)) 
end catch
begin
if (@Nota1 not  in (Select top (@Top) Nota  from studenti s
	inner join studenti_reusita r
	on s.Id_Student=r.Id_Student
	inner join discipline d
	on d.Id_Disciplina=r.Id_Disciplina
	where  Disciplina=@Disciplina and Tip_Evaluare=@TipEvaluare)
    
	and 

	@Nota2 not in (Select top (@Top) Nota from studenti s
	inner join studenti_reusita r
	on s.Id_Student=r.Id_Student
	inner join discipline d
	on d.Id_Disciplina=r.Id_Disciplina
	where  Disciplina=@Disciplina and Tip_Evaluare=@TipEvaluare))

(select top(@Top) Nume_Student,Prenume_Student,Nota j
from studenti s
inner join studenti_reusita r
on s.Id_Student=r.Id_Student
inner join discipline d
on d.Id_Disciplina=r.Id_Disciplina
where  Disciplina=@Disciplina and Tip_Evaluare=@TipEvaluare)
 

else 
(select top(@Top) Nume_Student,Prenume_Student,Nota from  studenti s
inner join studenti_reusita r
on s.Id_Student=r.Id_Student
inner join discipline d
on d.Id_Disciplina=r.Id_Disciplina
where  Disciplina=@Disciplina and Tip_Evaluare=@TipEvaluare and @Nota1!=Nota and @Nota2!=Nota)
if (@Nota1=0)or(@Nota2=0)
begin
RAISERROR ('Grades cannot be 0,it can be between 1-10 inclusively ',15,5,19)
end
end



