--3.Să se creeze un declanșator, care ar interzice micșorarea notelor in tabelul studenti_reusita și
--modificarea valorilor campului Data_Evaluare, unde valorile acestui camp sunt nenule.
--Declanșatorul trebuie sa se lanseze, numai daca sunt afectate datele studentilor din grupa
--"CIB 171 ". Se va afișa un mesaj de avertizare in cazul tentativei de a încalca constrângerea. 

USE universitatea;
GO
  IF OBJECT_ID(' ex3_1 ', 'TR') IS NOT NULL 
  DROP TRIGGER ex3_1; 
  GO 
  CREATE TRIGGER ex3_1 
  ON studenti_reusita
  AFTER UPDATE 
  AS
  SET NOCOUNT ON
  IF UPDATE(Nota)
  BEGIN 
  If (Select AVG(Nota) from inserted  where Id_Grupa=(Select Id_Grupa from grupe where Cod_Grupa='CIB171') and Nota is not null)<
  (Select AVG(Nota) from deleted where Id_Grupa=(Select Id_Grupa from grupe where Cod_Grupa='CIB171') and Nota is not null )
  
  
  PRINT 'Tentativa de micsorare a Notei'; 
  ROLLBACK; 
END ;

IF UPDATE(Data_Evaluare)
BEGIN
PRINT'Tentativă de modificare a datei de evaluare';
ROLLBACK;
END
GO


update studenti_reusita
SET Nota=Nota-1
where Id_Grupa=(Select Id_Grupa from grupe where Cod_Grupa='CIB171')

update studenti_reusita
SET Data_Evaluare='2018-10-25'
where Id_Disciplina=107

