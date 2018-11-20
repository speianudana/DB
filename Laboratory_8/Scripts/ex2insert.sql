
USE universitatea
GO
DROP VIEW IF EXISTS dbo.exercitiul3;
GO
--Crearea viziune exercitiul2
CREATE VIEW exercitiul3 AS
SELECT * FROM profesori_new WHERE Id_Profesor between 95 and 118
GO
--inserare
USE universitatea
GO 
INSERT INTO exercitiul3
VALUES ('99','Speianu','Dana','s.Dubăsarii Vechi','str.Stefan cel Mare','14');
--Test interogare viziune
SELECT * FROM exercitiul3
