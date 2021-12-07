use [tempExcel]
 insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'tillMinaMedelanden4'))
begin try
drop table FromJoinWithCorrection;
end try
begin catch
end catch

   ;
with
   KORRIGERANDE AS (SELECT fa.ÄGARE 			faÄGARE
			 , fa.POSTADRESS 		faPOSTADRESS
			 , fa.POSTNR 			faPOSTNR
			 , fa.POSTORT 			faPOSTORT
			 , fa.[personnr/Organisationnr] faPERSONNRORGAN
			 , fa.SOURCE			faSOURCE
			 ,  cc.ÄGARE                     CÄGARE
			   ,  cc.POSTADRESS                CPOSTADRESS
			   ,  cc.POSTNR                    CPOSTNR
			   ,  cc.POSTORT                   CPOSTORT
			   ,  cc.[personnr/Organisationnr] CPERSONNRORGAN
			   ,  cc.SOURCE                    CSOURCE

		      FROM  fromCorrigerande cc
			  INNER JOIN  fromFulaatkorrigera fa ON  cc.ID =  fa.ID)

,joinWithCorrection as (SELECT distinct fnr,
    	COALESCE(CÄGARE,joinFirAndInitial.namn) namn,
        COALESCE(CPOSTADRESS, joinFirAndInitial.adress) adress,
        COALESCE(CPOSTNR, joinFirAndInitial.POSTNR) POSTNR,
        COALESCE(CPOSTORT,joinFirAndInitial.POSTORT) POSTORT,
        COALESCE(CPERSONNRORGAN, joinFirAndInitial.org)org,
        COALESCE(CSOURCE,joinFirAndInitial.SOURCE)SOURCE
    from tempExcel.dbo.FromcorrecAndelCo joinFirAndInitial
	    LEFT OUTER JOIN  korrigerande on
		try_cast(replace(joinFirAndInitial.org,'-','') as bigint)
		    = try_cast(replace(KORRIGERANDE.faPERSONNRORGAN,'-','') as bigint))
			/* 	joinFirAndInitial.NAMN = faÄGARE and
			IIF(KORRIGERANDE.faPERSONNRORGAN is not null,
			concat(KORRIGERANDE.faPERSONNRORGAN, korrigerande.faÄGARE), KORRIGERANDE.faÄGARE)
			=
			IIF(KORRIGERANDE.faPERSONNRORGAN is not null,
			concat(joinFirAndInitial.org, joinFirAndInitial.NAMN), joinFirAndInitial.NAMN))
			coalesce(korrigerande.ÄGARE,			joinFirAndInitial.namn) = 				joinFirAndInitial.namn AND
			coalesce(korrigerande.POSTADRESS,			joinFirAndInitial.ADRESS) = 			joinFirAndInitial.adress AND
			coalesce(korrigerande.POSTNR,			joinFirAndInitial.POSTNR) = 			joinFirAndInitial.POSTNR AND
			coalesce(korrigerande.POSTORT,			joinFirAndInitial.POSTORT) = 			joinFirAndInitial.POSTORT AND
			coalesce(korrigerande.[personnr/Organisationnr],	joinFirAndInitial.org) = 	joinFirAndInitial.org AND
			coalesce(korrigerande.SOURCE,			joinFirAndInitial.SOURCE) = 			joinFirAndInitial.SOURCE)
			*/

select * into FromJoinWithCorrection from joinWithCorrection
;
insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'end4'));
    --order by STATUSKOMMENTAR,POSTNR,dnr,ÄGARE,POSTORT,POSTADRESS

