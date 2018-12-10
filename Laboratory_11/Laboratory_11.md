
# Laboratory 11

## Recuperarea bazei de date
### Sarcini practice:
#### 1. Să se creeze un dosar Backup_lab11. Să se execute un backup complet al bazei de date universitatea în acest dosar. Fișierul copiei de rezerva sa se numeasca exercitiul1.bak. Să se scrie instrucțiunea SQL respectivă.
``` sql
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='device03')
EXEC sp_dropdevice 'device03' , 'delfile';
EXEC sp_addumpdevice 'DISK', 'device03','C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\device03_exercitiul11.bak'
GO 
BACKUP DATABASE universitatea
TO device03 WITH FORMAT,
NAME = N'universitatea-Full Database Backup'
GO
```
#### Rezultate:
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_11/Screenshots_lab11/ex1.PNG)

#### 2 Sa se scrie instructiunea unui backup diferentiat al bazei de date universitatea. Fișierul copiei de rezerva sa se numeasca exercitiul2.bak.
``` sql
BACKUP DATABASE universitatea  
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul2.bak'  
WITH DIFFERENTIAL 
GO  
BACKUP LOG universitatea TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul2.bak'
```
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_11/Screenshots_lab11/ex2(1).PNG)
#### Rezultate:
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_11/Screenshots_lab11/ex2(2).PNG)


#### 3.Să se scrie instructiunea unui backup al jurnalului de tranzactii al bazei de date universitatea. Fisierul copiei de rezerva sa se numeasca exercitiul3.bak.
``` sql
GO
EXEC sp_addumpdevice 'DISK', 'backup_Log', 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul3.bak'
GO
BACKUP LOG universitatea TO backup_Log
GO
```
#### Rezultate:
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_11/Screenshots_lab11/ex3.PNG)

#### 4.Să se execute restaurarea consecutivă a tuturor copiilor de rezerva create. Recuperarea trebuie să fie realizată într-o bază de date noua universitatea_lab11. Fișierele bazei de date noi se afla în dosarul BD_lab11. Să se scrie instrucțiunile SQL respective.
``` sql
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
```
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_11/Screenshots_lab11/ex4(1).PNG)
#### Rezultate:
![Ex1](https://github.com/speianudana/DB/blob/master/Laboratory_11/Screenshots_lab11/ex4.PNG)




