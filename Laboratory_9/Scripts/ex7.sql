--7.Sa se scrie functia care ar calcula varsta studentului. Sa se defineasca urmatorul format al functiei: <nume Juncfie>(<Data _ Nastere _Student>). 

USE universitatea
GO

DROP function IF EXISTS studentAge;
GO
CREATE FUNCTION dbo.studentAge(@Data_Nastere_Student date)
RETURNS INT
    BEGIN
      DECLARE @Age int,@Now datetime
      SET @Now=GETDate()
      SELECT @Age=(CONVERT(int,CONVERT(char(8),@Now,112))-CONVERT(char(8),@Data_Nastere_Student,112))/10000
RETURN @Age
END

print dbo.studentAge('1998-10-05')

