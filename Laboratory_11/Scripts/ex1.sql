IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='device03')
EXEC sp_dropdevice 'device03' , 'delfile';
EXEC sp_addumpdevice 'DISK', 'device03','C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\device03_exercitiul11.bak'
GO 
BACKUP DATABASE universitatea
TO device03 WITH FORMAT,
NAME = N'universitatea-Full Database Backup'
GO