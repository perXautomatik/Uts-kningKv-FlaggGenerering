declare @a as TABLE (
  col1 int, col2 int,col3 int
);

INSERT INTO @a(col3) VALUES (1);
INSERT INTO @a(col3) VALUES (2);



select * from @a where exists(select col1 from @a except select col2 from @a)
