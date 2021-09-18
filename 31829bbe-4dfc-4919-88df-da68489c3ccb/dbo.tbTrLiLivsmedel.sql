with
TillsynsObject as (
    SELECT
           x.recTillsynsobjektID
            intAntalAnstaellda,
                            case
                                when
                                    decJusteradKontrolltid >= 0.5 AND decJusteradKontrolltid  <=1 then	0.5
                                when
                                    decJusteradKontrolltid >= 1.5 AND decJusteradKontrolltid  <=4.5 then	1
                                when
                                    decJusteradKontrolltid >= 5 AND decJusteradKontrolltid    <= 9.5 then	2
                                when
                                    decJusteradKontrolltid >= 10 AND decJusteradKontrolltid   <= 15.5 then	3
                                when
                                    decJusteradKontrolltid >=16 then 4
                                end "Antal Kontroller Korrekt",
                            decJusteradKontrolltid
                ,intBesoeksintervall,
                case
                    when
                        decJusteradKontrolltid >= 0.5 AND decJusteradKontrolltid <=1 then	 24
                    when
                        decJusteradKontrolltid >= 1.5 AND decJusteradKontrolltid <= 4.5 then 12
                    when
                        decJusteradKontrolltid >= 5 AND decJusteradKontrolltid <=9.5 then	 6
                    when
                        decJusteradKontrolltid >= 10 AND decJusteradKontrolltid <=15.5 then	 4
                    when
                        decJusteradKontrolltid >=16 then                                     3
                    end "Intervall (månader) korrekt"

FROM			dbo.tbTrTillsynsobjekt x
    join
    dbo.tbTrLiLivsmedel q on q.recTillsynsobjektID = x.recTillsynsobjektID where recTillsynsobjektTypID = 7 and decJusteradKontrolltid is not null
    ),


     AntalAnstaellda as (
  select intAntalAnstaellda from (SELECT
			isnull(cast(case when q.intAntalAnstaellda = 102 then 0.5 else q.intAntalAnstaellda end as float),0)  intAntalAnstaellda
FROM		TillsynsObject q) q),

    JusteradKontrollTid as (
        select case AntalAnstaellda.intAntalAnstaellda
        when 0.5 then case when AntalAnstaellda.wJusteradKontrollTid >= 0.5 AND AntalAnstaellda.wJusteradKontrollTid <= 1 then AntalAnstaellda.wJusteradKontrollTid else 1 end
        when 1 then case when AntalAnstaellda.wJusteradKontrollTid >= 1.5  AND AntalAnstaellda.wJusteradKontrollTid <= 4.5  then AntalAnstaellda.wJusteradKontrollTid else 4 end
        when 2 then case when AntalAnstaellda.wJusteradKontrollTid >= 5   AND AntalAnstaellda.wJusteradKontrollTid <= 9.5 then AntalAnstaellda.wJusteradKontrollTid else 9 end
        when 3 then case when AntalAnstaellda.wJusteradKontrollTid >= 10   AND AntalAnstaellda.wJusteradKontrollTid <= 15.5 then AntalAnstaellda.wJusteradKontrollTid else 15 end
        when 4 OR 6 then case when AntalAnstaellda.wJusteradKontrollTid >= 16 then AntalAnstaellda.wJusteradKontrollTid else 16 end end
        korrigerad
        from
        TillsynsObject
    ),

     Tillsynsintervall as (
         select
         case Korrigerad
         when Korrigerad >= 0.5 AND AntalAnstaellda.intAntalAnstaellda <= 1 then 24
          when Korrigerad >= 1.5 AND AntalAnstaellda.intAntalAnstaellda <=  4.5 then	12
          when Korrigerad >= 5 AND AntalAnstaellda.intAntalAnstaellda <= 9.5 then	6
          when Korrigerad >= 10 AND AntalAnstaellda.intAntalAnstaellda <= 15.5 then	4
          when Korrigerad >= 16 then	3 end

         from JusteradKontrollTid


     )


