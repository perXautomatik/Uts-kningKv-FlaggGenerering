
vi har en lista på vilka ärendenr som har fått utskick.BETWEEN
i listan finns 20 ca som fått fel utskick.BETWEEN

separare listan i två grupper

rätt utskcik

fel utskick

fin pdfer för utskcik

se till att en händelse i samlingsobjekt i vision har en händelse med önskad text och datum
se till att pdfer finns i någon händelse

utför stegen innan för att sedan söka fram dessa i databasen.GO

-- Idee Relationalise a table with low carnality ---
anslut antingen en och samma händelse till x ärendenr... (behöver göra ett experiment, fråga mikael söder om man kan göra til testdbn kanske)
och anslut filerna till händelsen,
    här kan det vara så att anslutningen inte är unik för ärendet utan för händelsen
    då skulle alla filasnlutningar synas. vilket vi inte vill.GO

tråkigt sätt att göra en db på, då det automatiskt blir kopior av stycken istället för att refferera till desa
det hade defenitivt varit mer intuitivt att när händelse skapas, skapar ett orginal och en copierad referens till detta material
så att man sedan kan koppla nya refferenskopior från samma orginal.
propblemet är att dbn skulle behöva kolla innan den sparar ändringar, vida referensen är exakt samma som orginalet
och ifall inte, skapa ett nytt orginal för att sedan referera till detta, egentligen inte så svårt eller ressurskrävande.GO

dbn skulle kunna hålla en referenslogg, typ, härstammar från orginal x
tidpunkt ersatt och via vilket användarnamn.GO

orginaldatabasen kan i sin tur ha relationer mellan sig själva typ
inehåller x
exsisterar i z
skapad av q

därefter skulle man kunna göra ett
likhetsregister där alla orginalfinner sina  likheter mellan varandra
när deras likheter konstaterats kan man börja extrahera likheter till nya orginal
skilja skilnader tills att vi är nere på meningsnivå

något mer komplicerat är kod då variabelnamn kan göra saker mycket mer skilnad,  */
-- irrelevant / old ---