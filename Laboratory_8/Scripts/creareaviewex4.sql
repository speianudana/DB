
USE universitatea
GO
DROP VIEW IF EXISTS dbo.exercitiul4;
GO
--Crearea viziune exercitiul38
CREATE VIEW exercitiul4 AS
SELECT * FROM discipline WHERE LEN(Disciplina) > 20
GO
--Test interogare viziune
SELECT * FROM exercitiul4
