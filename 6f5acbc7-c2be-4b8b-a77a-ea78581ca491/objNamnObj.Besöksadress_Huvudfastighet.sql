with
    objectNamnX as (select distinct
        [Besöksadress_Adress]
      ,[Besöksadress_Postnr]
      ,[Besöksadress_Ort]
      ,[Besöksadress_Huvudfastighet]
      ,[FNR]
      ,[Verksamhetsutövare_Namn]
      ,[Verksamhetsutöv_Person_orgnr]
      ,[Fakturamottagare_NAMN]
      ,[Fakturamottagare_Faktura_ADRESS]
      ,[Fakturamottagare_Faktura_POSTNR]
      ,[Fakturamottagare_Faktura_POSTOR]
      ,[Enhet]
      ,[Aktuell_timavgift]
      ,[Timdebitering]

 FROM [ostergarn] where Besöksadress_Huvudfastighet is not null),

     objNamnObj as (select distinct [Besöksadress_Huvudfastighet],[Objektnamn] FROM [ostergarn] where Besöksadress_Huvudfastighet is not null),


     anläggningar as (select distinct
       [Anteckning]
      ,[flik_Avloppsänlaggni_Boendetyp]
      ,[flik_Avloppsanläggn_Byggnadsår]
      ,[flik_Avloppsa_Besiktningsdatum]
      ,[flik_Avloppsanläg_Beslutsdatum]
      ,[Vatten]
      ,[Recipient]
      ,[Inventering]
      ,[Inventeringsinformation_Datum]
      ,[Inventeringsinformation_Status]
      ,[Bedömning]
      ,[fliken_Fastigheter]
      ,[fliken_FastigheterFNR]
      ,[PunkttypAB]
      ,[Fliken_Koordinater]
      ,[fliken_Ärenden]
      ,[Anläggningskategori]
      ,[besiktningdatum]
      ,[beslutsdatum]
      ,[Anläggningstyp]
      ,[Volym_m3]
      ,[Anl_för_EftR_TöInterv_mån]
      ,[AnlF_efR_Koordinater_X_o_Y]
      ,[PunkttypER]
      ,[Anläggning_för_EfterföljRText]
      ,[Anläggningskategori_2]
      ,[Anläggning_för_S_Anläggningstyp]
      ,[Externt_Tjänsteid]
      ,[text]
      ,[Anläggning_för_Slamav_Volym_m3]
      ,[Anläggningskategori_3]
      ,[AnlförEfterR_Anläggningstyp]
      ,[besiktningdatum_2]
      ,[beslutsdatum_2]
      ,[Externt_Tjänsteid2]
      ,[Volym_m32]
      ,[ObjektID]
      ,[Path]
      ,[Diarienummer]
      ,[Löpnummer]
FROM [ostergarn] where ObjektID is not null
     ),

    objectnamnTobjectID as (select  [ObjektID],min([Objektnamn]) "objektnamn" FROM [ostergarn] where [Objektnamn] is not null group by [ObjektID])


--select objectNamnX.* , objectnamnTobjectID.ObjektID  from objectNamnX left outer join objectnamnTobjectID on objectNamnX.[Objektnamn] = objectnamnTobjectID.[objektnamn]

select objectNamnX.Besöksadress_Huvudfastighet,
       anläggningar.ObjektID,
       Objektnamn,
       Besöksadress_Adress,
       Besöksadress_Postnr,
       Besöksadress_Ort,
       FNR,
       Verksamhetsutövare_Namn,
       Verksamhetsutöv_Person_orgnr,
       Fakturamottagare_NAMN,
       Fakturamottagare_Faktura_ADRESS,
       Fakturamottagare_Faktura_POSTNR,
       Fakturamottagare_Faktura_POSTOR,
       Enhet,
       Aktuell_timavgift,
       Timdebitering,
       Anteckning,
       flik_Avloppsänlaggni_Boendetyp,
       flik_Avloppsanläggn_Byggnadsår,
       flik_Avloppsa_Besiktningsdatum,
       flik_Avloppsanläg_Beslutsdatum,
       Vatten,
       Recipient,
       Inventering,
       Inventeringsinformation_Datum,
       Inventeringsinformation_Status,
       Bedömning,
       fliken_Fastigheter,
       fliken_FastigheterFNR,
       PunkttypAB,
       Fliken_Koordinater,
       fliken_Ärenden,
       Anläggningskategori,
       besiktningdatum,
       beslutsdatum,
       Anläggningstyp,
       Volym_m3,
       Anl_för_EftR_TöInterv_mån,
       AnlF_efR_Koordinater_X_o_Y,
       PunkttypER,
       Anläggning_för_EfterföljRText,
       Anläggningskategori_2,
       Anläggning_för_S_Anläggningstyp,
       Externt_Tjänsteid,
       text,
       Anläggning_för_Slamav_Volym_m3,
       Anläggningskategori_3,
       AnlförEfterR_Anläggningstyp,
       besiktningdatum_2,
       beslutsdatum_2,
       Externt_Tjänsteid2,
       Volym_m32,
       Path,
       Diarienummer,
       Löpnummer
from objectNamnX left outer join (select objNamnObj.Besöksadress_Huvudfastighet,
                                         objNamnObj.Objektnamn,
                                         ObjektID
                                  from objNamnObj left join objectnamnTobjectID on objectnamnTobjectID.objektnamn= objNamnObj.Objektnamn) as namnId on namnId.Besöksadress_Huvudfastighet = objectNamnX.Besöksadress_Huvudfastighet
left outer join anläggningar on namnId.ObjektID = anläggningar.ObjektID where namnId.ObjektID is not null

