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


alter table orarul
add pisica varchar(10)



drop trigger Ex2
select * from orarul
alter table orarul
drop column pisica 


 