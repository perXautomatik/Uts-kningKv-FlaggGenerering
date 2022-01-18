create table tbTrTillsynsobjekt
(
	recTillsynsobjektID int identity
		constraint PK_tbTrTillsynsobjektHistorik
			primary key,
	recTillsynsobjektTypID int not null
		constraint FK_tbTrTillsynsobjekt_tbTrTillsynsobjektsTyp
			references tbTrTillsynsobjektsTyp,
	recVerksamhetID int
		constraint FK_tbTrTillsynsobjekt_tbTrVerksamhet
			references tbTrVerksamhet,
	strObjektsNamn nvarchar(60),
	strAdress nvarchar(60),
	strOrt nvarchar(50),
	strSoekbegrepp nvarchar(60),
	strAnteckning nvarchar(max),
	recLastLogPostID int,
	intBeraeknadAarsavgift int,
	intJusteradAarsavgift int,
	decRabatt decimal(7,3),
	decKontrolltid decimal(6,2),
	decJusteradKontrolltid decimal(6,2),
	bolSpecialpris bit constraint DF_tbTrTillsynsobjekt_bolSpecialpris default 0 not null,
	bolTimdebitering bit constraint DF_tbTrTillsynsobjekt_bolTimdebitering default 0 not null,
	strProevningsplikt nvarchar(3),
	intAarsavgiftAttDebitera int,
	bolDebiterasEj bit constraint DF_tbTrTillsynsobjekt_bolDebiterasEj default 0 not null,
	recTyperID int,
	recDeladFakturamottagareID int
		constraint FK_tbTrTillsynsobjekt_tbVisDeladFakturamottagare_recDeladFakturamottagareID
			references tbVisDeladFakturamottagare
				on delete set null,
	recAvdelningID int
		constraint FK_tbTrTillsynsobjekt_tbVisAvdelning
			references tbVisAvdelning,
	recEnhetID int
		constraint FK_tbTrTillsynsobjekt_tbVisEnhet
			references tbVisEnhet,
	strPostnummer nvarchar(50),
	datFoeregaaendeBesoek datetime,
	datNaastaBesoeks datetime,
	intBesoeksintervall int,
	intTidsskuld int,
	intDebiteradFoer int
)
go

create index IX_tbTrTillsynsobjekt_recTillsynsobjektID_recVerksamhetID
	on tbTrTillsynsobjekt (recTillsynsobjektID, recVerksamhetID) include (strObjektsNamn, decJusteradKontrolltid)
go

create index IX_tbTrTillsynsobjekt_strObjektsNamn
	on tbTrTillsynsobjekt (strObjektsNamn)
go

create index IX_tbTrTillsynsobjekt_recTillsynsobjektTypID
	on tbTrTillsynsobjekt (recTillsynsobjektTypID)
go

create index IX_tbTrTillsynsobjekt_recVerksamhetID
	on tbTrTillsynsobjekt (recVerksamhetID)
go

create index IX_tbTrTillsynsobjekt_recDeladFakturamottagareID
	on tbTrTillsynsobjekt (recDeladFakturamottagareID)
go

create index IX_tbTrTillsynsobjekt_recAvdelningID
	on tbTrTillsynsobjekt (recAvdelningID)
go

create index IX_tbTrTillsynsobjekt_recEnhetID
	on tbTrTillsynsobjekt (recEnhetID)
go

