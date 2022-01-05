create view TestBatchHandelseSkapande as

select distinct fastighet,
                Diarienummer,
                [Utskick har gått till:],
                till,
                [Lagfaren ägare],
                adress

from lista full outer join (select Diarienummer, Fastighetsbeteckning from [påminnelse-12-mån-2020]) q on fastighet = q.Fastighetsbeteckning where Fastighetsbeteckning is not null and fastighet is not null

