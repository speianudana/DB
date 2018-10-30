--2. Afișati primele zece date (numele, prenumele studentului) in functie de valoarea notei (cu exceptia
--notelor 6 și 8) a studentului la primul test al disciplinei Baze de date , folosind structura de
--altemativa IF. .. ELSE. Să se folosească variabilele. 
DECLARE @Nota1 int, @Nota2 int,@TipEvaluare varchar(10),@Disciplina varchar(20);
SET @Nota1=6;
SET @Nota2=8;
SET @TipEvaluare='Testul 1';
SET @Disciplina='Baze de date';

select top(10) Nume_Student,Prenume_Student,Nota
from studenti s
inner join studenti_reusita r
on s.Id_Student=r.Id_Student
inner join discipline d
on d.Id_Disciplina=r.Id_Disciplina
where  Disciplina=@Disciplina and Tip_Evaluare=@TipEvaluare
                              and Nota!=@Nota1 
							  and Nota!=@Nota2




