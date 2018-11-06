/*6. Să se insereze datele in tabelul orarul pentru Grupa= 'CIBJ 71' (Id_ Grupa= 1) pentru ziua de
luni. Toate lectiile vor avea loc în blocul de studii 'B'. Mai jos, sunt prezentate detaliile de
inserare:
(ld_Disciplina = 107, Id_Profesor= 101, Ora ='08:00', Auditoriu = 202);
(Id_Disciplina = 108, Id_Profesor= 101, Ora ='11:30', Auditoriu = 501);
(ld_Disciplina = 119, Id_Profesor= 117, Ora ='13:00', Auditoriu = 501); */

CREATE TABLE orarul( Id_Disciplina int NOT NULL,
                       Id_Profesor int NOT NULL, 
					   Id_Grupa smallint NOT NULL,
					   Zi       char(2) NOT NULL,
					   Ora       Time NOT NULL,
					   Auditoriu  int ,
					   Bloc       char(1) NOT NULL DEFAULT ('B'),
CONSTRAINT [PK_orarul] PRIMARY KEY CLUSTERED 
(
	Id_Disciplina ASC,
	Id_Profesor,
	Id_Grupa ,
	ZI )) ON [PRIMARY]

INSERT orarul VALUES(107, 101, (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='CIB171'), 'Lu', '08:00', 202,DEFAULT)
INSERT orarul VALUES(108, 101, (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='CIB171'), 'Lu', '11:30', 501,DEFAULT)
INSERT orarul VALUES(109, 117, (SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='CIB171'), 'Lu', '13:00', 501,DEFAULT)           

SELECT *  FROM orarul
