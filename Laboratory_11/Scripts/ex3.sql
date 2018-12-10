--3 Sa se scrie instructiunea unui backup al jurnalului de tranzactii al bazei de date universitatea. 
--Fisierul copiei de rezerva sa se numeasca exercitiul3.bak
GO
EXEC sp_addumpdevice 'DISK', 'backup_Log', 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul3.bak'

GO
BACKUP LOG universitatea TO backup_Log
GO