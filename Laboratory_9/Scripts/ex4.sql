
------------------------------------
USE universitatea
GO
DROP PROCEDURE IF EXISTS replaceProfesor;
GO
CREATE PROCEDURE replaceProfesor
@Nume_Profesor_old varchar(60),
@Prenume_Profesor_old varchar(60),
@Nume_Profesor_new varchar(60),
@Prenume_Profesor_new varchar(60),
@Disciplina varchar(255)
AS

IF ((select Id_Disciplina from discipline where Disciplina=@Disciplina) in (select distinct Id_Disciplina from studenti_reusita where Id_Profesor=(select Id_Profesor from profesori where Nume_Profesor=@Nume_Profesor_old and Prenume_Profesor=@Prenume_Profesor_old)))
BEGIN
  UPDATE profesori
  SET Nume_Profesor=@Nume_Profesor_new,Prenume_Profesor=@Prenume_Profesor_new
  WHERE Nume_Profesor=@Nume_Profesor_old and Prenume_Profesor=@Prenume_Profesor_old
  print('Înlocuirea profesorului '+@Nume_Profesor_old+' '+@Prenume_Profesor_old+' cu '+'profesorul '+@Nume_Profesor_new+' '+@Prenume_Profesor_new+' a avut loc cu succes.')
END
ELSE 
BEGIN
print('Atenție!!!')
print(@Nume_Profesor_old+ ' '+@Prenume_Profesor_old+' nu predă disciplina '+'"'+@Disciplina+'"'+'!!!')
END;
GO

EXECUTE replaceProfesor
@Nume_Profesor_old='Micu',
@Prenume_Profesor_old='Elena',
@Nume_Profesor_new ='Verebceanu',
@Prenume_Profesor_new='Mirela',
@Disciplina='Structuri de date si algoritmi'
select * from profesori
