with 
     b1 as (select Inventering,Inventeringsinformation_Status,Besöksadress_Adress,Vatten,Inventeringsinformation_Datum,flik_Avloppsänlaggni_Boendetyp,flik_Avloppsanläggn_Byggnadsår,* from Blad1$_1)
    ,r1 as (select * from register_1)
select * from b1  inner join r1
ON objektNamnOchObjektid.recTillsynsobjektID =
						COALESCE(
							case When (b1.Inventeringsinformation_Datum = r1.datInventeringsdatum AND b1.flik_Avloppsänlaggni_Boendetyp = r1.strBoendetyp AND b1.flik_Avloppsanläggn_Byggnadsår = r1.intByggnadsaar AND b1.Vatten = TRY_CAST(r1.strVatten as float) AND b1.Besöksadress_Adress = r1.strAdress AND b1.Inventeringsinformation_Status = r1.strStatus AND b1.Inventering = r1.strInventering AND b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End,
							case When (b1.flik_Avloppsänlaggni_Boendetyp = r1.strBoendetyp AND b1.flik_Avloppsanläggn_Byggnadsår = r1.intByggnadsaar AND b1.Vatten = TRY_CAST(r1.strVatten as float) AND b1.Besöksadress_Adress = r1.strAdress AND b1.Inventeringsinformation_Status = r1.strStatus AND b1.Inventering = r1.strInventering AND b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End,
							case When (b1.flik_Avloppsanläggn_Byggnadsår = r1.intByggnadsaar AND b1.Vatten = TRY_CAST(r1.strVatten as float) AND b1.Besöksadress_Adress = r1.strAdress AND b1.Inventeringsinformation_Status = r1.strStatus AND b1.Inventering = r1.strInventering AND b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End,
							case When (b1.Vatten = TRY_CAST(r1.strVatten as float) AND b1.Besöksadress_Adress = r1.strAdress AND b1.Inventeringsinformation_Status = r1.strStatus AND b1.Inventering = r1.strInventering AND b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End,
							case When (b1.Besöksadress_Adress = r1.strAdress AND b1.Inventeringsinformation_Status = r1.strStatus AND b1.Inventering = r1.strInventering AND b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End,
							case When (b1.Inventeringsinformation_Status = r1.strStatus AND b1.Inventering = r1.strInventering AND b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End,
							case When (b1.Inventering = r1.strInventering AND b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End,
							case When (b1.Objektnamn = r1.strObjektsNamn) Then r1.recTillsynsobjektID Else Null End)