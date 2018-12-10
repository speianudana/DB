--2 Sa se scrie instructiunea unui backup diferentiat al bazei de date universitatea. Fișierul copiei de rezerva sa se numeasca exercitiul2.bak.
BACKUP DATABASE universitatea  
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul2.bak'  
WITH DIFFERENTIAL 
GO  
BACKUP LOG universitatea TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul2.bak'

