/*7. Să se scrie expresiile T-SQL necesare pentru a popula tabelul orarul pentru grupa INF171 ,ziua de luni. 
Datele necesare pentru inserare trebuie sa fie colectate cu ajutorul instructiunii/instructiunilor
SELECT și introduse in tabelul-destinație, știind că:
lectie #1 (Ora ='08:00', Disciplina = 'Structuri de date si algoritmi', Profesor ='Bivol Ion')
lectie #2 (Ora ='11 :30', Disciplina = 'Programe aplicative', Profesor ='Mircea Sorin')
lectie #3 (Ora ='13:00', Disciplina ='Baze de date', Profesor = 'Micu Elena') */


INSERT INTO orarul (Id_Disciplina,Id_Profesor,Id_Grupa,Zi,Ora,Auditoriu,Bloc) 
VALUES ((SELECT Id_Disciplina FROM discipline WHERE Disciplina='Structuri de date si algoritmi'),
        (SELECT Id_Profesor FROM profesori WHERE Nume_Profesor='Bivol' and Prenume_Profesor='Ion' ),
		(SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='INF171'),'Lu','08:00',DEFAULT,DEFAULT)
    
INSERT INTO orarul (Id_Disciplina,Id_Profesor,Id_Grupa,Zi,Ora,Auditoriu,Bloc) 
VALUES ((SELECT Id_Disciplina FROM discipline WHERE Disciplina='Programe aplicative'),
        (SELECT Id_Profesor FROM profesori WHERE Nume_Profesor='Mircea' and Prenume_Profesor='Sorin' ),
		(SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='INF171'),'Lu','11:30',DEFAULT,DEFAULT)

INSERT INTO orarul (Id_Disciplina,Id_Profesor,Id_Grupa,Zi,Ora,Auditoriu,Bloc) 
VALUES ((SELECT Id_Disciplina FROM discipline WHERE Disciplina='Baze de date'),
        (SELECT Id_Profesor FROM profesori WHERE Nume_Profesor='Micu' and Prenume_Profesor='Elena' ),
		(SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='INF171'),'Lu','13:00',DEFAULT,DEFAULT)

SELECT * FROM orarul