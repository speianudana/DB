--2.Sa se creeze o procedura stocată, care nu are niciun parametru de intrare și posedă un parametru de ieșire. Parametrul de ieșire trebuie să returneze numarul de studenți, care nu au sustinut cel putin o forma de evaluare (nota mai mica de 5 sau valoare NULL). 
USE universitatea
GO
DROP PROCEDURE IF EXISTS test3;
GO
CREATE PROCEDURE test3
@Nr_studenti int=NULL OUTPUT
AS
SET @Nr_studenti=(
SELECT COUNT(DISTINCT ID_Student) 
FROM studenti_reusita
where Nota<5 or Nota is NULL)
print('Numarul de studenti care nu au sustinut cel putin o formă de evaluare este '+CAST(@Nr_studenti as varchar(10))+'.')

EXEC test3;




