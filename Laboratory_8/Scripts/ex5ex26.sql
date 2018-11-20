--26.Găsiți numele,prenumele și adresele studenților și ale profesorilor care locuiesc pe strada 31 August.
;with persons31aug (Nume,Prenume,Adresa_Postala) as
(SELECT Nume_Student,
       Prenume_Student,
	   Adresa_Postala_Student 
       FROM studenti
      WHERE Adresa_Postala_Student LIKE '%31 August%'
UNION

SELECT Nume_Profesor ,
       Prenume_Profesor ,
	   Adresa_Postala_Profesor
	   FROM profesori
	   WHERE Adresa_Postala_Profesor LIKE '%31 August%')
select * from persons31aug 