
vi har en lista p� vilka �rendenr som har f�tt utskick.BETWEEN
i listan finns 20 ca som f�tt fel utskick.BETWEEN

separare listan i tv� grupper

r�tt utskcik

fel utskick

fin pdfer f�r utskcik

se till att en h�ndelse i samlingsobjekt i vision har en h�ndelse med �nskad text och datum
se till att pdfer finns i n�gon h�ndelse

utf�r stegen innan f�r att sedan s�ka fram dessa i databasen.GO

-- Idee Relationalise a table with low carnality ---
anslut antingen en och samma h�ndelse till x �rendenr... (beh�ver g�ra ett experiment, fr�ga mikael s�der om man kan g�ra til testdbn kanske)
och anslut filerna till h�ndelsen,
    h�r kan det vara s� att anslutningen inte �r unik f�r �rendet utan f�r h�ndelsen
    d� skulle alla filasnlutningar synas. vilket vi inte vill.GO

tr�kigt s�tt att g�ra en db p�, d� det automatiskt blir kopior av stycken ist�llet f�r att refferera till desa
det hade defenitivt varit mer intuitivt att n�r h�ndelse skapas, skapar ett orginal och en copierad referens till detta material
s� att man sedan kan koppla nya refferenskopior fr�n samma orginal.
propblemet �r att dbn skulle beh�va kolla innan den sparar �ndringar, vida referensen �r exakt samma som orginalet
och ifall inte, skapa ett nytt orginal f�r att sedan referera till detta, egentligen inte s� sv�rt eller ressurskr�vande.GO

dbn skulle kunna h�lla en referenslogg, typ, h�rstammar fr�n orginal x
tidpunkt ersatt och via vilket anv�ndarnamn.GO

orginaldatabasen kan i sin tur ha relationer mellan sig sj�lva typ
ineh�ller x
exsisterar i z
skapad av q

d�refter skulle man kunna g�ra ett
likhetsregister d�r alla orginalfinner sina  likheter mellan varandra
n�r deras likheter konstaterats kan man b�rja extrahera likheter till nya orginal
skilja skilnader tills att vi �r nere p� meningsniv�

n�got mer komplicerat �r kod d� variabelnamn kan g�ra saker mycket mer skilnad,  */
-- irrelevant / old ---