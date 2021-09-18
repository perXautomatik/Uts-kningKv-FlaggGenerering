update
    dbo.tbTrLiLivsmedel
set intAntalAnstaellda = case
                             when
                                 decJusteradKontrolltid >= 0.5 AND decJusteradKontrolltid <= 1 then 102
                             when
                                 decJusteradKontrolltid >= 1.5 AND decJusteradKontrolltid <= 4.5 then 1
                             when
                                 decJusteradKontrolltid >= 5 AND decJusteradKontrolltid <= 9.5 then 2
                             when
                                 decJusteradKontrolltid >= 10 AND decJusteradKontrolltid <= 15.5 then 3
                             when
                                 decJusteradKontrolltid >= 16 then 4 end

FROM dbo.tbTrTillsynsobjekt x
         join
     dbo.tbTrLiLivsmedel q on q.recTillsynsobjektID = x.recTillsynsobjektID
where recTillsynsobjektTypID = 7
  and decJusteradKontrolltid is not null;
go

update
    dbo.tbTrTillsynsobjekt
set intBesoeksintervall =
        case
            when
                decJusteradKontrolltid >= 0.5 AND decJusteradKontrolltid <= 1 then 24
            when
                decJusteradKontrolltid >= 1.5 AND decJusteradKontrolltid <= 4.5 then 12
            when
                decJusteradKontrolltid >= 5 AND decJusteradKontrolltid <= 9.5 then 6
            when
                decJusteradKontrolltid >= 10 AND decJusteradKontrolltid <= 15.5 then 4
            when
                decJusteradKontrolltid >= 16 then 3
            end
FROM dbo.tbTrTillsynsobjekt x
         join
     dbo.tbTrLiLivsmedel q on q.recTillsynsobjektID = x.recTillsynsobjektID
where recTillsynsobjektTypID = 7
  and decJusteradKontrolltid is not null