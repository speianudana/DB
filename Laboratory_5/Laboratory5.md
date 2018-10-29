# Laboratory 5
## TRANSACT-SQL: INSTRUCTIUNI PROCEDURALE
### Sarcini practice
### 1. Completați următorul cod pentru a afișa cel mai mare numar dintre cele trei numere prezentate:
``` sql
DECLARE @N1 INT,@N2 INT,@N3 INT;
DECLARE @MAI_MARE INT;
SET @N1 = 60 * RAND();
SET @N2 = 60 * RAND();
SET @N3 = 60 * RAND();
begin
if (@N1>@N2) AND (@N1>@N3)
SET @MAI_MARE=@N1;
if (@N2>@N1) AND (@N2>@N3)
SET @MAI_MARE=@N2;
if (@N3>@N1) AND (@N3>@N2)
SET @MAI_MARE=@N3;

PRINT @N1;
PRINT @N2;
PRINT @N3;
PRINT 'Mai mare = '+CAST(@MAI_MARE AS VARCHAR(2));
end
```
### Result:
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_5/Screenshots%C8%9A_DBlab5/ex1.PNG)

### 2.Afișati primele zece date (numele, prenumele studentului) in functie de valoarea notei (cu exceptia
### notelor 6 și 8) a studentului la primul test al disciplinei Baze de date , folosind structura de
### altemativa IF. .. ELSE. Să se folosească variabilele. 
``` sql
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
```
### Result:
![Ex2](https://github.com/speianudana/DB/blob/master/Laboratory_5/Screenshots%C8%9A_DBlab5/ex2.PNG)

### 3. Rezolvati aceeași sarcina, 1, apelînd la structura selectiva CASE. 
``` sql
DECLARE @N1 INT,@N2 INT,@N3 INT;
DECLARE @MAI_MARE INT;
SET @N1 = 60 * RAND();
SET @N2 = 60 * RAND();
SET @N3 = 60 * RAND();

SET  @MAI_MARE= 
CASE 
WHEN (@N1>@N2) AND (@N1>@N3) THEN @N1 
WHEN (@N2>@N1) AND (@N2>@N3) THEN @N2 
WHEN (@N3>@N1) AND (@N3>@N2) THEN @N3 
END
PRINT @N1;
PRINT @N2;
PRINT @N3;
PRINT 'Mai mare = '+CAST(@MAI_MARE AS VARCHAR(2));
```
### Result
![Ex3](https://github.com/speianudana/DB/blob/master/Laboratory_5/Screenshots%C8%9A_DBlab5/ex3.PNG)






