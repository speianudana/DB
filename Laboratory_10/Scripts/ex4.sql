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

select * from studenti_reusita 
