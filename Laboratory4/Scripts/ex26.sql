--26.Găsiți numele,prenumele și adresele studenților și ale profesorilor care locuiesc pe strada 31 August.
SELECT Nume_Student as Nume,
       Prenume_Student as Prenume ,
	   Adresa_Postala_Student as Adresa
       FROM studenti
      WHERE Adresa_Postala_Student LIKE '%31 August%'
UNION

SELECT Nume_Profesor ,
       Prenume_Profesor ,
	   Adresa_Postala_Profesor
	   FROM profesori
	   WHERE Adresa_Postala_Profesor LIKE '%31 August%'