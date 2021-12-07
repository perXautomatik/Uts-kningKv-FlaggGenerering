with 
     b1 as (select Inventering,Inventeringsinformation_Status,Bes�ksadress_Adress,Vatten,Inventeringsinformation_Datum,flik_Avlopps�nlaggni_Boendetyp,flik_Avloppsanl�ggn_Byggnads�r,* from Blad1$_1)
    ,r1 as (select * from register_1)
select * from b1  inner join r1
ON objektNamnOchObjektid.recTillsynsobjektID =
						COALESCE(
							case When (b1.Inventeringsinformation_Datum = r1.datInventeringsdatum AND b1.flik_Avlopps�nlaggni_Boendetyp = r1.strBoendetyp AND b1.flik_Avloppsanl�ggn_Byggnads�r = r1.intByggnadsaar AND b1.Vatten = TRY_CAST(r1.strVatten as float) AND b1.Bes�ksadress_Adress = r1.strAdress AND b1.Inventeringsinformation_Status = r1.strStatus AND b1.Inventering = r1.strInventering AND b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End,
							case When (b1.flik_Avlopps�nlaggni_Boendetyp = r1.strBoendetyp AND b1.flik_Avloppsanl�ggn_Byggnads�r = r1.intByggnadsaar AND b1.Vatten = TRY_CAST(r1.strVatten as float) AND b1.Bes�ksadress_Adress = r1.strAdress AND b1.Inventeringsinformation_Status = r1.strStatus AND b1.Inventering = r1.strInventering AND b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End,
							case When (b1.flik_Avloppsanl�ggn_Byggnads�r = r1.intByggnadsaar AND b1.Vatten = TRY_CAST(r1.strVatten as float) AND b1.Bes�ksadress_Adress = r1.strAdress AND b1.Inventeringsinformation_Status = r1.strStatus AND b1.Inventering = r1.strInventering AND b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End,
							case When (b1.Vatten = TRY_CAST(r1.strVatten as float) AND b1.Bes�ksadress_Adress = r1.strAdress AND b1.Inventeringsinformation_Status = r1.strStatus AND b1.Inventering = r1.strInventering AND b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End,
							case When (b1.Bes�ksadress_Adress = r1.strAdress AND b1.Inventeringsinformation_Status = r1.strStatus AND b1.Inventering = r1.strInventering AND b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End,
							case When (b1.Inventeringsinformation_Status = r1.strStatus AND b1.Inventering = r1.strInventering AND b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End,
							case When (b1.Inventering = r1.strInventering AND b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End,
							case When (b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End)