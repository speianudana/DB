 DROP TRIGGER IF EXISTS ex4 ON DATABASE;  
   GO
CREATE TRIGGER ex4
on database
for ALTER_TABLE
AS
SET NOCOUNT ON
DECLARE @Disciplina varchar(50)
SET @Disciplina =EVENTDATA(). value('(/EVENT_INSTANCE/AlterTableActionList/*/Columns/Name)[1]','nvarchar(max)')
IF @Disciplina='Disciplina'
BEGIN
PRINT ('Coloana Disciplina nu poate fi modificată');
ROLLBACK;
END
go

ALTER TABLE discipline
ALTER COLUMN Disciplina varchar(50)

