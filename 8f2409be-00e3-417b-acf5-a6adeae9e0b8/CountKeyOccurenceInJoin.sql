/*NULLIF - returns NULL if the two passed in values are the same.
Advantage: Expresses your intent to COUNT rows instead of having the SUM() notation. Disadvantage: Not as clear how it is working ("magic" is usually bad).
*/
	WITH
	     bl1 as (SELECT * FROM EDPVisionRegionGotlandAvlopp.dbo.Blad1$),
	     av1 as (select * from EDPVisionRegionGotlandAvlopp.dbo.tbTrEaAvloppsanlaeggning),
	     t1 as (select * from EDPVisionRegionGotlandAvlopp.dbo.tbTrTillsynsobjekt),
	     register
	 AS (SELECT MAX(t1.strObjektsNamn) AS strObjektsNamn, MAX(t1.recTillsynsobjektID) AS recTillsynsobjektID, t1.strOrt, t1.strPostnummer AS TillsynFas_VisionPostnr, t1.strSoekbegrepp, t1.strAdress, t1.strAnteckning, t1.bolTimdebitering, t1.recEnhetID, t1.recAvdelningID, av1.strBoendetyp, av1.strVatten, av1.bolIndraget, av1.strAnlaeggningstyp, av1.strStatus, av1.intByggnadsaar, av1.datBeslutsdatum, av1.datBesiktningsdatum, av1.strNotering, av1.strEfterfoeljandereningReningstyp, av1.intEfterfoeljandereningYta, av1.strEfterfoeljandereningRecipient, av1.strBedoemning, av1.strInventering, av1.datInventeringsdatum, av1.strVattenskyddsomraade, av1.strEfterpoleringTyp, av1.strPrioritet, av1.intLoepnr, av1.intUnderhaallsintervallMaanad, av1.datNaastaService, av1.datFoeregaandeService, av1.strAvrinningsomraade, t1.recVerksamhetID
		 FROM t1
			  INNER JOIN
			  av1
			  ON av1.recTillsynsobjektID = t1.recTillsynsobjektID
		 WHERE( t1.strObjektsNamn IS NOT NULL
			  )
		 GROUP BY t1.recVerksamhetID, t1.strOrt, t1.strPostnummer, t1.strSoekbegrepp, t1.strAdress, t1.strAnteckning, t1.bolTimdebitering, t1.recEnhetID, t1.recAvdelningID, av1.strBoendetyp, av1.strVatten, av1.bolIndraget, av1.strAnlaeggningstyp, av1.strStatus, av1.intByggnadsaar, av1.datBeslutsdatum, av1.datBesiktningsdatum, av1.strNotering, av1.strEfterfoeljandereningReningstyp, av1.intEfterfoeljandereningYta, av1.strEfterfoeljandereningRecipient, av1.strBedoemning, av1.strInventering, av1.datInventeringsdatum, av1.strVattenskyddsomraade, av1.strEfterpoleringTyp, av1.strPrioritet, av1.intLoepnr, av1.intUnderhaallsintervallMaanad, av1.datNaastaService, av1.datFoeregaandeService, av1.strAvrinningsomraade),
	 objektNamnOchObjektid
	 AS (SELECT DISTINCT 
				t1.recTillsynsobjektID, bl1.Objektnamn
		 FROM bl1
			  JOIN
			  t1
			  ON t1.strObjektsNamn = bl1.Objektnamn),
	 BladObjekt
	 AS (SELECT ObjektID, Besöksadress_Adress, Besöksadress_Postnr, Besöksadress_Ort, Besöksadress_Huvudfastighet, FNR, Verksamhetsutövare_Namn, Verksamhetsutöv_Person_orgnr, Fakturamottagare_NAMN, Fakturamottagare_Faktura_ADRESS, Fakturamottagare_Faktura_POSTNR, Fakturamottagare_Faktura_POSTOR, Enhet, Anteckning AS blad_Anteckning, Aktuell_timavgift AS blad_Aktuell_timavgift, Timdebitering, Objektnamn, flik_Avloppsänlaggni_Boendetyp, flik_Avloppsanläggn_Byggnadsår, flik_Avloppsa_Besiktningsdatum, flik_Avloppsanläg_Beslutsdatum, Vatten, Recipient, Inventering, Inventeringsinformation_Datum, Inventeringsinformation_Status, Bedömning AS Blad_Bedömning, PunkttypAB, Fliken_Koordinater
		 FROM bl1
		 WHERE( Objektnamn IS NOT NULL
			  ))

	SELECT			--,COUNT(NULLIF(Fakturamottagare_Faktura_POSTOR, TillsynFas_VisionPostnr)) as  TillsynFas_VisionPostnr
					--,COUNT(NULLIF(bolTimdebitering, TRY_CAST(Timdebitering as bit))) as  Timdebitering
					--,COUNT(NULLIF(BladObjekt.Inventering,register.strInventering)) as strInventering
					--,COUNT(NULLIF(strNotering, strBedoemning)) as strBedoemning
					
					COUNT(NULLIF(strEfterfoeljandereningRecipient, Recipient)) as  Recipient
					,COUNT(NULLIF(BladObjekt.Besöksadress_Adress,register.strAdress)) as strAdress
					,COUNT(NULLIF(BladObjekt.flik_Avloppsänlaggni_Boendetyp,register.strBoendetyp)) as strBoendetyp
					,COUNT(NULLIF(datBeslutsdatum, TRY_CAST( flik_Avloppsanläg_Beslutsdatum as date))) as flik_Avloppsanläg_Beslutsdatum
					,COUNT(NULLIF(BladObjekt.flik_Avloppsanläggn_Byggnadsår,TRY_CAST(TRY_CAST(register.intByggnadsaar as char) as date))) as intByggnadsaar
					,COUNT(NULLIF(datBesiktningsdatum, TRY_CAST(flik_Avloppsa_Besiktningsdatum as date))) as flik_Avloppsa_Besiktningsdatum
					,COUNT(NULLIF(BladObjekt.Inventeringsinformation_Status,register.strStatus)) as strStatus
					,COUNT(NULLIF(BladObjekt.Inventeringsinformation_Datum, TRY_CAST(register.datInventeringsdatum as date))) as datInventeringsdatum
					,COUNT(NULLIF(BladObjekt.Vatten,TRY_CAST(register.strVatten AS float))) as Vatten
					,COUNT(NULLIF(strOrt, Besöksadress_Ort)) as Besöksadress_Ort
	 from register join bladObjekt  
	 on register.strObjektsNamn = BladObjekt.Objektnamn


		


--	ORDER BY ObjektID DESC

	 --FROM anläggningsressultat;
/*(SELECT blad2.*, register2.* FROM BladObjekt as blad2 FULL OUTER JOIN register as register2 ON
  blad2.Inventeringsinformation_Datum = register2.datInventeringsdatum AND
  blad2.flik_Avloppsänlaggni_Boendetyp = register2.strBoendetyp AND
  /*blad2.flik_Avloppsanläggn_Byggnadsår = register2.intByggnadsaar AND
blad2.Besöksadress_Adress = register2.strAdress 
AND blad2.Inventeringsinformation_Status = register2.strStatus 
AND blad2.Inventering = register2.strInventering 
AND blad2.Objektnamn = register2.strObjektsNamn 
where 
  register2.strObjektsNamn is not null 
  and blad2.Objektnamn is not null
) as q 

    LEFT OUTER JOIN register AS Register_1 WHERE ( NOT (Blad1$_1.ObjektID IS NULL) ) Group by Blad1$_1.Objektnamn, Blad1$_1.Besöksadress_Postnr, register_1.TillsynFas_VisionPostnr, Blad1$_1.Besöksadress_Ort, register_1.strOrt, Blad1$_1.Inventering, register_1.strInventering, Blad1$_1.Inventeringsinformation_Datum, register_1.datInventeringsdatum, Blad1$_1.flik_Avloppsänlaggni_Boendetyp, register_1.strBoendetyp, Blad1$_1.Vatten, register_1.strVatten, Blad1$_1.flik_Avloppsanläggn_Byggnadsår, register_1.intByggnadsaar, Blad1$_1.Inventeringsinformation_Status, register_1.strStatus, Blad1$_1.flik_Avloppsa_Besiktningsdatum, register_1.datBesiktningsdatum, register_1.datBeslutsdatum, Blad1$_1.flik_Avloppsanläg_Beslutsdatum ) ON objektNamnOchObjektid.recTillsynsobjektID
   = COALESCE( case When ( Blad1$_1.Inventeringsinformation_Datum = register_1.datInventeringsdatum AND Blad1$_1.flik_Avloppsänlaggni_Boendetyp = register_1.strBoendetyp AND Blad1$_1.flik_Avloppsanläggn_Byggnadsår = register_1.intByggnadsaar AND Blad1$_1.Vatten = TRY_CAST(register_1.strVatten as float) AND Blad1$_1.Besöksadress_Adress = register_1.strAdress AND Blad1$_1.Inventeringsinformation_Status = register_1.strStatus AND Blad1$_1.Inventering = register_1.strInventering AND Blad1$_1.Objektnamn = register_1.strObjektsNamn ) Then register_1.recTillsynsobjektID Else Null End, case When ( Blad1$_1.flik_Avloppsänlaggni_Boendetyp = register_1.strBoendetyp AND Blad1$_1.flik_Avloppsanläggn_Byggnadsår = register_1.intByggnadsaar AND Blad1$_1.Vatten = TRY_CAST(register_1.strVatten as float) AND Blad1$_1.Besöksadress_Adress = register_1.strAdress AND Blad1$_1.Inventeringsinformation_Status = register_1.strStatus AND Blad1$_1.Inventering = register_1.strInventering AND Blad1$_1.Objektnamn = register_1.strObjektsNamn ) Then register_1.recTillsynsobjektID Else Null End, case When ( Blad1$_1.flik_Avloppsanläggn_Byggnadsår = register_1.intByggnadsaar AND Blad1$_1.Vatten = TRY_CAST(register_1.strVatten as float) AND Blad1$_1.Besöksadress_Adress = register_1.strAdress AND Blad1$_1.Inventeringsinformation_Status = register_1.strStatus AND Blad1$_1.Inventering = register_1.strInventering AND Blad1$_1.Objektnamn = register_1.strObjektsNamn ) Then register_1.recTillsynsobjektID Else Null End, case When ( Blad1$_1.Vatten = TRY_CAST(register_1.strVatten as float) AND Blad1$_1.Besöksadress_Adress = register_1.strAdress AND Blad1$_1.Inventeringsinformation_Status = register_1.strStatus AND Blad1$_1.Inventering = register_1.strInventering AND Blad1$_1.Objektnamn = register_1.strObjektsNamn ) Then register_1.recTillsynsobjektID Else Null End, case When ( Blad1$_1.Besöksadress_Adress = register_1.strAdress AND Blad1$_1.Inventeringsinformation_Status = register_1.strStatus AND Blad1$_1.Inventering = register_1.strInventering AND Blad1$_1.Objektnamn = register_1.strObjektsNamn ) Then register_1.recTillsynsobjektID Else Null End, case When ( Blad1$_1.Inventeringsinformation_Status = register_1.strStatus AND Blad1$_1.Inventering = register_1.strInventering AND Blad1$_1.Objektnamn = register_1.strObjektsNamn ) Then register_1.recTillsynsobjektID Else Null End, case When ( Blad1$_1.Inventering = register_1.strInventering AND Blad1$_1.Objektnamn = register_1.strObjektsNamn ) Then register_1.recTillsynsobjektID Else Null End, case When ( Blad1$_1.Objektnamn = register_1.strObjektsNamn ) Then register_1.recTillsynsobjektID Else Null End )
  
    
       
       where (ressult.Blad1_Besöksadress_Ort <> ressult.TillsynFas_VisionPostnr) OR
                                  (NOT (ressult.Objektnamn IS NULL)) AND (ressult.Blad1_Besöksadress_Ort <> ressult.strOrt) OR
                                  (NOT (ressult.Objektnamn IS NULL)) AND (ressult.Blad1_Inventering <> ressult.strInventering) OR
                                  (NOT (ressult.Objektnamn IS NULL)) AND (ressult.Blad1_Inventeringsinformation_Datum <> ressult.datInventeringsdatum) OR
                                  (NOT (ressult.Objektnamn IS NULL)) AND (ressult.Blad1_Inventeringsinformation_Status <> ressult.strStatus)
                              OR (NOT (register_1.strObjektsNamn IS NULL)) AND (Blad1$_1.flik_Avloppsanläggn_Byggnadsår <> register_1.intByggnadsaar)
  OR (
    NOT (ressult.Objektnamn IS NULL)
  ) 
  AND (
    (ressult.Blad1_Vatten) <> TRY_CAST(ressult.strVatten as float) 
    OR (
      TRY_CAST(
        ressult.Blad1_flik_Avloppsa_Besiktningsdatum as date
      ) <> ressult.register_Besiktningsdatum
    ) 
    OR (
      TRY_CAST(
        ressult.register_Beslutsdatum as date
      ) <> ressult.Blad1_flik_Avloppsanläg_Beslutsdatum
    )
  )  */
	
*/