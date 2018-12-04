CREATE TRIGGER Ex2 on dbo.studenti_reusita
	INSTEAD OF INSERT
	AS SET NOCOUNT ON
    DECLARE @Id_Student int 
    ,@Nume_Student varchar(50) ='Boisteanu'
	,@Prenume_Student varchar(50) ='Dumitru'
	,@Data_Nastere_Student varchar(50)
	,@Adresa_Postala_Student varchar (50)
	SELECT @Id_Student = Id_Student FROM inserted
	INSERT INTO dbo.studenti VALUES(@Id_Student, @Nume_Student, @Prenume_Student,null,null)
	INSERT INTO dbo.studenti_reusita 
	SELECT * FROM inserted;
		
		
	INSERT INTO dbo.studenti_reusita VALUES(202,107,100,1,'Examen', null, null)

	SELECT * FROM studenti
	SELECT DISTINCT * FROM studenti_reusita
    GO


drop trigger populate_table
select * from studenti_reusita
select * from sys.triggers