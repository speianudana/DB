CREATE TABLE graph
 (ID int PRIMARY KEY,
  ParinteID int);

INSERT INTO graph VALUES
(5,0),
(1,0),
(3,2),
(2,1),
(4,2);

;WITH graph1 AS
 (SELECT ID , ParinteID from graph
  where ID = 3 and ParinteID = 2
UNION ALL
  SELECT graph.ID, graph.ParinteID from graph
  INNER JOIN graph1
  ON graph.ID = graph1.ParinteID)
SELECT * from graph1

	