--4 Sa se execute restaurarea consecutiva a tuturor copiilor de rezerva create. Recuperarea trebuie
--sa fie realizata intr-o baza de date noua universitatea_lab11. Fișierele bazei de date noi se afla
--in dosarul BD_lab11. Sa se scrie instructiunile SQL respective.

IF EXISTS (SELECT * FROM master.sys.databases WHERE name='universitatea_lab11')
DROP DATABASE universitatea_lab11;
GO
RESTORE DATABASE universitatea_lab11
FROM DISK ='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul1.bak'
WITH MOVE 'universitatea' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\BD_lab11\data.mdf',
MOVE 'Indexes' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\BD_lab11\data1.ndf',
MOVE 'universitatea_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\BD_lab11\log.ldf',
NORECOVERY
GO
RESTORE LOG universitatea_lab11
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul3.bak'
WITH NORECOVERY
GO
RESTORE DATABASE universitatea_lab11
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul2.bak'
WITH 
NORECOVERY
GO