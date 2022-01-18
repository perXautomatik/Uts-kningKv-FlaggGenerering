select * from (select strRubrik,strAvdelningNamn,count(*) c from EDPVisionRegionGotlandTest2.dbo.vwAehHaendelse group by strRubrik, strAvdelningNamn) Q where c > 100 order by strAvdelningNamn,strRubrik,c desc

select * from (select strRubrik, coalesce(strAvdelningNamn,strEnhetNamn,strEnhetKod,strLogKommentar) enhet ,strHaendelseKategori,count(*) c from EDPVisionRegionGotlandTest2.dbo.vwAehHaendelse group by strRubrik, coalesce(strAvdelningNamn,strEnhetNamn,strEnhetKod,strLogKommentar) ,strHaendelseKategori) Q where c > 100 order by enhet,strRubrik,c desc



select * from EDPVisionRegionGotlandTest2.dbo.vwAehHaendelse where strAvdelningNamn is null And strEnhetNamn is null and strEnhetKod is null and strRubrik is not null

select * from (select qt.*,coalesce(strAvdelningNamn,strEnhetNamn,strEnhetKod,strLogKommentar) enhet from (select top 100 * from (select strAerendemening,count(*) c from EDPVisionRegionGotlandTest2.dbo.vwAehAerende group by strAerendemening) Q order by c desc) qt inner join  EDPVisionRegionGotlandTest2.dbo.vwAehAerende qz on qt.strAerendemening = qz.strAerendemening group by coalesce(strAvdelningNamn,strEnhetNamn,strEnhetKod,strLogKommentar),qt.strAerendemening,c) r where strAerendemening <> ''
--where strAerendemening like '%värm%'

order by enhet,strAerendemening,c desc



update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'3-KAMMARBRUNN - ansökan' where strAerendemening = N'AVLOPP Ansökan om 3-kammarbrunn'

update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Anmälan om ändring/upphörande av livsmedelsanläggning' where strAerendemening = N'Anmälan om upphörande av livsmedelanläggning'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Anmälan om ändring/upphörande av livsmedelsanläggning' where strAerendemening = N'Anmälan om upphörande av livsmedelsanläggning'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Anmälan om ändring/upphörande av livsmedelsanläggning' where strAerendemening = N'Anmälan om ändring av livsmedelsanläggning'

update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Ansökan om godkännande/registrering av livsmedelsanläggning' where strAerendemening = N'Ansökan om godkännande/registrering av livsmedelslanläggning'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Ansökan om nedgrävning av hästdjur' where strAerendemening = N'Ansökan om godkännande av plats för nergrävning av hästdjur'

update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Ansökan/anmälan om livsmedelshantering' where strAerendemening = N'Anmälan om livsmedelshantering'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Ansökan/anmälan om livsmedelshantering' where strAerendemening = N'Anmälan/ansökan livsmedelshantering'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Ansökan/anmälan om livsmedelshantering' where strAerendemening = N'Ansökan om godkännande/registrering av livsmedelsanläggning'

update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'AVLOPP Anmälan om ändring' where strAerendemening = N'ÄNDRING av avlopp - anmälan'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'AVLOPP Ansökan om 2-kammarbrunn' where strAerendemening = N'2-KAMMARBRUNN - ansökan'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'AVLOPP Ansökan om 3-kammarbrunn' where strAerendemening = N'3-KAMMARBRUNN - ansökan'


update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'AVLOPPSANLÄGGNING' where strAerendemening = N'AVL ANL'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'AVLOPPSANLÄGGNING' where strAerendemening = N'AVLOPPSANL'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'AVLOPPSANLÄGGNING -ANSÖKAN/ANMÄLAN' where strAerendemening = N'AVLOPPSANLÄGGNING'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'AVLOPPSANLÄGGNING -ANSÖKAN/ANMÄLAN' where strAerendemening = N'NY AVLOPPSANLÄGGNING'


update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'FASTIGHETSUPPLYSNING' where strAerendemening = N'ALLMÄN Fastighetsförfrågan -'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'INSPEKTIONSRAPPORT' where strAerendemening = N'INSPEKTION'

update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Klart vatten - information om avlopp' where strAerendemening = N'Klart vatten - information om avlopp.'

update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'LIVSMEDELSFÖRSÄLJNING ENL 16' where strAerendemening = N'16 § ansökan om tillf livsm.hant'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'LIVSMEDELSFÖRSÄLJNING ENL 16' where strAerendemening = N'16 PAR LL, ANSÖKAN OM TILLFÄLLIG FÖRSÄLJNING'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'LIVSMEDELSFÖRSÄLJNING ENL 16' where strAerendemening = N'LIVSMEDEL,  16'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'LIVSMEDELSFÖRSÄLJNING ENL 16' where strAerendemening = N'LIVSMEDEL Tillfällig livsmedelshantering 16 §'


update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'SLAM/URIN Ansökan om lokalt omhändertagande' where strAerendemening = N'SLAM urin egen tömning- ansökan'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'SLAM/URIN Ansökan om lokalt omhändertagande' where strAerendemening = N'SLAM urin lokalt omhänd.tagande - ansökan'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'SLAM/URIN Ansökan om lokalt omhändertagande' where strAerendemening = N'SLAM/URIN Ansökan om egen tömning'

update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'SOPHÄMTNING Ansökan om hämtning 2 ggr/år' where strAerendemening = N'AVFALL Sopor, hämtning 2 ggr/år'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'SOPHÄMTNING Ansökan om hämtning 2 ggr/år' where strAerendemening = N'SOPHÄMTNING 2 ggr/år - ansökan'

update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'SOPHÄMTNING Ansökan om hämtning 4 ggr/år' where strAerendemening = N'AVFALL Sopor, hämtning 4 ggr/år'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'SOPHÄMTNING Ansökan om hämtning 4 ggr/år' where strAerendemening = N'SOPHÄMTNING 4 ggr/år - ansökan'

update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'SOPHÄMTNING Ansökan om totalbefrielse' where strAerendemening = N'AVFALL Sopor, totalbefrielse -ansökan'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'SOPHÄMTNING Ansökan om totalbefrielse' where strAerendemening = N'SOPHÄMTNING totalbefrielse - ansökan'

update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'SOPHÄMTNING, Ansökan om månadshämtning' where strAerendemening = N'SOPDISPENS -ANSÖKAN VAR 4:E VECKA'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'SOPHÄMTNING, Ansökan om månadshämtning' where strAerendemening = N'SOPHÄMTNING månadshämtning - anmälan'

update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Årlig kontrollrapport 2001, köldmedia' where strAerendemening = N'KÖLDMEDIA -årlig kontrollrapport 2001'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Årlig kontrollrapport 2003, köldmedia' where strAerendemening = N'KÖLDMEDIA -årlig kontrollrapport - 2003'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Årlig kontrollrapport 2004, köldmedia' where strAerendemening = N'KÖLDMEDIA -årlig kontrollrapport - 2004'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Årlig kontrollrapport 2005, köldmedia' where strAerendemening = N'KÖLDMEDIA -årlig kontrollrapport - 2005'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Årlig kontrollrapport 2006, köldmedia' where strAerendemening = N'KÖLDMEDIA -årlig kontrollrapport - 2006'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Årlig kontrollrapport 2007, köldmedia' where strAerendemening = N'KÖLDMEDIA -årlig kontrollrapport - 2007'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Årlig kontrollrapport 2008, köldmedia' where strAerendemening = N'Årlig kontrollrapport, köldmedia - 2008'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Årlig kontrollrapport 2009, köldmedia' where strAerendemening = N'Årlig kontrollrapport, köldmedia 2009'
update EDPVisionRegionGotlandTest2.dbo.tbAehAerende set strAerendemening = N'Årlig kontrollrapport 2013, köldmedia' where strAerendemening = N'Årlig kontrollrapport, köldmedia 2013'