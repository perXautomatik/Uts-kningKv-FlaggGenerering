select Objektnamn as verksamhetsnamn,
       ObjektID ,
       Besöksadress_Huvudfastighet as Besöksadress_Huvudfastighet,
       FNR,
        PunkttypAB,
       Anteckning,


       Inventering,
       Inventeringsinformation_Datum,
       Inventeringsinformation_Status,
       Bedömning as Bedmning,

       flik_Avloppsänlaggni_Boendetyp flik_Avloppsnlaggni_Boendetyp,
       flik_Avloppsanläggn_Byggnadsĺr as flik_Avloppsanlggn_Byggnadsr,
       flik_Avloppsa_Besiktningsdatum,
       flik_Avloppsanläg_Beslutsdatum as flik_Avloppsanlg_Beslutsdatum,
       Vatten,
           Recipient,


       Anläggningskategori as Anlggningskategori,
       PunkttypER,
       Anläggningstyp as Anlggningstyp,
              text,
       Anläggning_för_S_Anläggningstyp as Anlggning_fr_S_Anlggningstyp,
       Anläggning_för_EfterföljRText as Anlggning_fr_EfterfljRText,
        Externt_Tjänsteid as Externt_Tjnsteid,



       Volym_m3,
       Anläggning_för_Slamav_Volym_m3 as Anlggning_fr_Slamav_Volym_m3,
       Anl_för_EftR_TöInterv_mĺn as Anl_fr_EftR_TInterv_mn,

       AnlförEfterR_Anläggningstyp as AnlfrEfterR_Anlggningstyp,
              besiktningdatum,
       beslutsdatum,
       AnlF_efR_Koordinater_X_o_Y,




              Fliken_Koordinater,
       fliken_Ärenden as fliken_renden,
              fliken_Fastigheter,
       fliken_FastigheterFNR,
        PĺFastighet as påFastighet,


       Externt_Tjänsteid2 as ignorex
 into #Organizer
FROM tempdb.dbo.[4HelaSolen] t where Externt_Tjänsteid2 <> 0