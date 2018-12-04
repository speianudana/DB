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
alter table studenti_reusita alter column Id_Profesor smallint 
select * from discipline
select * from sys.triggers