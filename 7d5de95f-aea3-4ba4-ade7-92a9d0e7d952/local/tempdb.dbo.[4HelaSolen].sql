select Besöksadress_Adress, Besöksadress_Postnr, Besöksadress_Ort, Besöksadress_Huvudfastighet, FNR,
       Verksamhetsutövare_Namn, Verksamhetsutöv_Person_orgnr, Fakturamottagare_NAMN, Fakturamottagare_Faktura_ADRESS,
       Fakturamottagare_Faktura_POSTNR, Fakturamottagare_Faktura_POSTOR, Enhet, Anteckning, Aktuell_timavgift, Timdebitering
     , Objektnamn, flik_Avloppsänlaggni_Boendetyp, flik_Avloppsanläggn_Byggnadsĺr, flik_Avloppsa_Besiktningsdatum,
       flik_Avloppsanläg_Beslutsdatum, Vatten, Recipient, Inventering, Inventeringsinformation_Datum, Bedömning,
       Inventeringsinformation_Status, fliken_Fastigheter, fliken_FastigheterFNR, PunkttypAB, Fliken_Koordinater,
       fliken_Ärenden, Anläggningskategori, besiktningdatum, beslutsdatum, Anläggningstyp, Volym_m3, Anl_för_EftR_TöInterv_mĺn,
       AnlF_efR_Koordinater_X_o_Y, PunkttypER, Anläggning_för_EfterföljRText, Anläggningskategori_2, Anläggning_för_S_Anläggningstyp,
       Externt_Tjänsteid, text, Anläggning_för_Slamav_Volym_m3, Anläggningskategori_3, AnlförEfterR_Anläggningstyp, besiktningdatum_2,
       beslutsdatum_2, Externt_Tjänsteid2, Volym_m32, xa.ObjektID, Path, Diarienummer, Löpnummer

     , (case when tk.ObjektID = xa.ObjektID THEN '1'
					    ELSE case when xa.Externt_Tjänsteid2 = TK.ignorex AND
							   Anlggningskategori = tk.Anlggningskategori then '2' end
	END) as aasfa
into WithRemovalX
from tempdb.dbo.[4HelaSolen] xa
    left outer join ToKep TK on xa.Externt_Tjänsteid2 = TK.ignorex AND Anlggningskategori = tk.Anlggningskategori