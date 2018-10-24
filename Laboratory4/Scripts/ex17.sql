
--17. Afișați numele și prenumele profesorilor, care au predat cel puțin o disciplină studentului cu identificatorul 100.
SELECT Nume_Profesor,Prenume_Profesor
FROM profesori p
INNER JOIN studenti_reusita r
ON p.Id_Profesor=r.Id_Profesor
WHERE Id_Student=100
GROUP BY Nume_Profesor,Prenume_Profesor