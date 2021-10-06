--hämta ärendenr från vision
DF as dia-fnr from vision


--hämta fastigheter från excel
kir as kir where status röd from excel

;hämta adresser från
fir as
    fnr - adress-namn-org-source-andel where beteckning in kir

 firFOA as   fnr-org-andel from fir

 firOA as   org-adress from fir

 firON as    org-namn from fir

gis as
    fnr - adress-namn-org-'gis'-1/count

gisFOA as  fnr-org-andel from gis

gisOA as  org-adress

gisON  as  org-namn

FOa as gisFoa union firfoa
    f,o,min(a)
    group by f,o


oa as gisoa union firoa
    count org
    	sort desc
    	filter

xOn as gison union firon
	count org
    	sort desc
    	filter


OAN as oa join xon on org

FOANA as Oan join Foa on org

FOANAD as foana join fd on fnr