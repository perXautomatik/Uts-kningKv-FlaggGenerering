WITH summary AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY p.ignorex,p.Anlggningskategori
                                 ORDER BY p.MyDesiredResult DESC) AS rk
      FROM RemoveOrKeep p)

SELECT ObjektID,
       Anlggningskategori,
       ignorex
into ToKep
  FROM summary s

 WHERE s.rk = 1