USE universitatea
GO
DROP FUNCTION IF EXISTS studentReusita1
GO

CREATE FUNCTION studentReusita1(@Cod_Grupa varchar(6),@is_good varchar(20))
RETURNS @result TABLE 
   (Nume_Student varchar(50),Prenume_Student varchar(50),Nota_Medie  decimal(4,2),is_good varchar(20))
 -- WITH ENCRYPTION
   AS
 BEGIN
   if @is_good='sirguincios'
   
   INSERT INTO @result
 Select Nume_Student,Prenume_Student,cast(avg(Nota)as decimal(4,2)) as Nota_Medie ,@is_good
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
  and Prenume_Student=(select top 1 Prenume_Student--,AVG(Nota) as Nota_Medie
                      from studenti s
                      inner join studenti_reusita r
                      on s.Id_Student=r.Id_Student
                      where Id_Grupa =(Select Id_Grupa from grupe where Cod_Grupa=@Cod_Grupa )
                      Group by Nume_Student,Prenume_Student
                      Order by AVG(Nota) DESC)
Group by Nume_Student,Prenume_Student
else if @is_good='slab'
insert into @result 
Select Nume_Student,Prenume_Student,cast(avg(Nota)as decimal(4,2)) as Nota_Medie ,@is_good
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

select * from dbo.studentReusita1('TI171','sirguincios')


