--1. Sa se modifice declanșatorul înregistrare_noua, in așa fel, încât în cazul actualizării  auditoriului să apară mesajul de informare, care, în afară de disciplina și ora, va afișa codul grupei afectate, ziua, blocul, auditoriul vechi și auditoriul nou. 

USE universitatea;
GO
IF OBJECT_ID('inregistrare_noua','TR') is not null
DROP TRIGGER inregistrare_noua;
GO
CREATE TRIGGER inregistrare_noua ON orarul
AFTER INSERT
AS PRINT 'A fost creata o noua inregistrare'
GO


ALTER TRIGGER inregistrare_noua ON orarul
 AFTER UPDATE
 AS
 SET NOCOUNT ON
 IF UPDATE (Auditoriu)
 SELECT 'Lectia la disciplina"'+UPPER(d.Disciplina)+'"  de la ora:'+CAST(inserted.Ora as varchar(10))+'" pentru grupa  "'
 +CAST(g.Cod_Grupa as char(6))+'",in ziua de '+inserted.Zi+',Blocul "'+inserted.Bloc+'",s-a transferat din auditoriul "'
 +CAST(deleted.Auditoriu as varchar(5))+'" în auditoriul "'+CAST(inserted.Auditoriu as varchar(5))+'".'
 FROM grupe g,inserted,deleted
 join discipline d
 on deleted.Id_Disciplina=d.Id_Disciplina
 GO


 UPDATE orarul 
 SET Auditoriu=110 where Id_Profesor=101

 select *  from orarul

 alter table orarul
 drop table orarul