  select z.strFileName
	       , case
	      when CHARINDEX('-', right(z.strFileName, 8)) = 4
	          then right(z.strFileName, 4)
		  else left(right(z.strFileName, 8), 4)
		 end loepnummer
	       , x.recHaendelseFileObjectID
	       , x.recFileObjectID
	  from EDPVisionRegionGotlandTest2.dbo.vwAehAerende Aerende
	       inner join EDPVisionRegionGotlandTest2.dbo.vwAehHaendelse handelse
	      on Aerende.recAerendeID = handelse.recAerendeID
	      left outer join EDPVisionRegionGotlandTest2.dbo.tbAehHaendelseFileObject x
	      on x.recHaendelseID = handelse.recHaendelseID
	      left outer join EDPVisionRegionGotlandTest2.dbo.vwEDPFileObject z
	      on x.recFileObjectID = z.recFileObjectID
	  where Aerende.strDiarienummer = 'MBNV-2020-3533'