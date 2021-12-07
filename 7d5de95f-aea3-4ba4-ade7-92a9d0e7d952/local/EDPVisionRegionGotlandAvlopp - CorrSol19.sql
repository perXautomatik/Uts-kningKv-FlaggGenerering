use EDPVisionRegionGotlandAvlopp;
with VisionÄrenden as (SELECT
    dbo.tbAehAerende.intDiarienummerLoepNummer
	,dbo.tbAehAerendeData.strDiarienummer
	,dbo.tbAehAerende.strSoekbegrepp
FROM dbo.tbAehAerende
LEFT OUTER JOIN dbo.tbAehAerendeData ON dbo.tbAehAerendeData.recAerendeID = dbo.tbAehAerende.recAerendeID
LEFT OUTER JOIN dbo.tbAehProjekt ON dbo.tbAehAerende.recProjektID = dbo.tbAehProjekt.recProjektID
LEFT OUTER JOIN dbo.tbAehHaendelseBeslut ON dbo.tbAehAerende.recLastHaendelseBeslutID = dbo.tbAehHaendelseBeslut.recHaendelseBeslutID
LEFT OUTER JOIN dbo.tbAehAerendetyp ON dbo.tbAehAerende.recAerendetypID = dbo.tbAehAerendetyp.recAerendetypID
LEFT OUTER JOIN dbo.tbVisEnhet ON dbo.tbAehAerende.recEnhetID = dbo.tbVisEnhet.recEnhetID
LEFT OUTER JOIN dbo.tbVisFoervaltning ON dbo.tbAehAerende.recFoervaltningID = dbo.tbVisFoervaltning.recFoervaltningID
LEFT OUTER JOIN dbo.tbVisAvdelning ON dbo.tbAehAerende.recAvdelningID = dbo.tbVisAvdelning.recAvdelningID
LEFT OUTER JOIN tbVisEnstakaKontakt AS fakturamottagarekontakt
    ON fakturamottagarekontakt.recEnstakaKontaktID = (
		SELECT recEnstakaKontaktID
		FROM tbVisEnstakafakturamottagare
		WHERE recEnstakaFakturamottagareID = tbAehAerende.recEnstakaFakturamottagareID
		)
LEFT OUTER JOIN dbo.tbVisKommun ON dbo.tbVisKommun.recKommunID = dbo.tbAehAerende.recKommunID
LEFT OUTER JOIN dbo.tbEDPUser ON dbo.tbEDPUser.intUserID = dbo.tbAehAerendeData.intUserID
LEFT OUTER JOIN dbo.vwAehAerendeTotaltid ON dbo.vwAehAerendeTotaltid.recAerendeID = tbAehAerende.recAerendeID
LEFT OUTER JOIN dbo.tbVisExternTjaenst ON dbo.tbVisExternTjaenst.recExternTjaenstID = tbAehAerende.recExternTjaenstID
LEFT OUTER JOIN dbo.tbAehHaendelse ON dbo.tbAehHaendelse.recHaendelseID = tbAehHaendelseBeslut.recHaendelseID)

   ,toCorrect as ( select tempExcel.[dbo].usp_SplitStringByDelimeeter(x.fliken_Ärenden,2,'-') year,
                          tempExcel.[dbo].usp_SplitStringByDelimeeter(x.fliken_Ärenden,3,'-') nr
                   from (select fliken_Ärenden from tempExcel.dbo.sol19_4Kol group by fliken_Ärenden) x
                            left outer join tempExcel.dbo.sol19_ÄrendenrAttJoina
                                            on fliken_Ärenden = sol19_ÄrendenrAttJoina.Diarienummer
                   where Diarienummer is null
                     and fliken_Ärenden <> '0'
                     AND fliken_Ärenden <> 'anteckning')
, corrected as (
select max(strDiarienummer) strDiarienummer,strSoekbegrepp from (select * from toCorrect
) z
cross apply VisionÄrenden q where q.intDiarienummerLoepNummer = z.nr AND q.strDiarienummer like  '%' + cast(z.year as varchar(4)) + '%' AND strSoekbegrepp <> ''
    group by z.year,Z.nr,strSoekbegrepp
    )
,firstInsert as (select Diarienummer fliken_ärenden, ObjektID from tempExcel.dbo.sol19_ÄrendenrAttJoina join tempExcel.dbo.sol19_4Kol s194K on sol19_ÄrendenrAttJoina.fnr = s194K.FNR)

,forgotten as (select ty.*,qw.fnr from (select * from corrected) ty
left outer join [GISDATA].sde_geofir_gotland.gng.FA_TIDIGAREBETECKNING qw on ty.strSoekbegrepp = qw.beteckning where qw.fnr is not null )

,toInsert as (
select * from firstInsert
union
select strDiarienummer fliken_ärenden, ObjektID from forgotten join tempExcel.dbo.sol19_4Kol s194K on forgotten.fnr = s194K.FNR
where forgotten.fnr is not null)

select distinct 'Anteckning' anläggningskategori, 'Anteckning' Anläggningstyp, fliken_ärenden Anläggning_för_EfterföljRText ,toInsert.ObjektID from toInsert left outer join VisionÄrenden on toInsert.fliken_ärenden = VisionÄrenden.strDiarienummer where strSoekbegrepp is null



