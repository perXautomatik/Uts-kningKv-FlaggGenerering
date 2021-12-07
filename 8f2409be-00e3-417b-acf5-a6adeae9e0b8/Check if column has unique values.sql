with
     z as ( select * from EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAvloppsanlaeggning),
     t as ( select * from EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjekt),
     ressult as (SELECT DISTINCT 
                         MAX(t.strObjektsNamn) AS strObjektsNamn, MAX(t.recTillsynsobjektID) AS recTillsynsobjektID, 
                         t.strOrt, t.strPostnummer AS TillsynFas_VisionPostnr, 
                         t.strSoekbegrepp, t.strAdress, t.strAnteckning, 
                         t.bolTimdebitering, t.recEnhetID, t.recAvdelningID, 
                         z.strBoendetyp, z.strVatten, 
                         z.bolIndraget, z.strAnlaeggningstyp, 
                         z.strStatus, z.intByggnadsaar, 
                         z.datBeslutsdatum, z.datBesiktningsdatum, 
                         z.strNotering, z.strEfterfoeljandereningReningstyp, 
                         z.intEfterfoeljandereningYta, z.strEfterfoeljandereningRecipient, 
                         z.strBedoemning, z.strInventering, 
                         z.datInventeringsdatum, z.strVattenskyddsomraade, 
                         z.strEfterpoleringTyp, z.strPrioritet, 
                         z.intLoepnr, z.intUnderhaallsintervallMaanad, 
                         z.datNaastaService, z.datFoeregaandeService, 
                         z.strAvrinningsomraade, t.recVerksamhetID
FROM            t INNER JOIN
                         z ON 
                         z.recTillsynsobjektID = t.recTillsynsobjektID
WHERE        (t.strObjektsNamn IS NOT NULL)
GROUP BY t.recVerksamhetID, t.strOrt, t.strPostnummer, 
                         t.strSoekbegrepp, t.strAdress, t.strAnteckning, 
                         t.bolTimdebitering, t.recEnhetID, t.recAvdelningID, 
                         z.strBoendetyp, z.strVatten, 
                         z.bolIndraget, z.strAnlaeggningstyp, 
                         z.strStatus, z.intByggnadsaar, 
                         z.datBeslutsdatum, z.datBesiktningsdatum, 
                         z.strNotering, z.strEfterfoeljandereningReningstyp, 
                         z.intEfterfoeljandereningYta, z.strEfterfoeljandereningRecipient, 
                         z.strBedoemning, z.strInventering, 
                         z.datInventeringsdatum, z.strVattenskyddsomraade, 
                         z.strEfterpoleringTyp, z.strPrioritet, 
                         z.intLoepnr, z.intUnderhaallsintervallMaanad, 
                         z.datNaastaService, z.datFoeregaandeService, 
                         z.strAvrinningsomraade)
						 SELECT CASE WHEN count(distinct recTillsynsobjektID)= count(recTillsynsobjektID) 
THEN 'column values are unique' ELSE 'column values are NOT unique' END
FROM ressult; 