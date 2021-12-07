        /*
        --automatisera;
        --create a new handelse such as above with an exception.
        * the handelse tabell <- insert + > retrive ( which handelsefiler)
         * arendetabell -> retrive
         * handelseFil tabell -> retrive? ( i think it wasn't nesesary to do any changes as long as we retrive exsiting objects)
         */

create view TestBatchHandelseSkapande as
    /*
     for each ärenden
     create handelse accordingly
        --vi bör inte ansluta flera ärenden med samma händelse? (borde gå då det är en refferencnyckel, men vi har inte sätt sådant ännu, bör testas) om inte,
    vi behöver skapa nya händelser.
        --kanske enklast att göra detta utanför databasen och på så sätt referera dessa via databasen
    vi använder ett referensobjekt och copierar detta så många gånger vi behöver samt ser till att denna har de modifikationer som är relevant
        --make the method accept other händelse to check for files?
    we make the reference number a variable which is provided on execution.
        -- reffobject = Handelse where recHaendelseID = 446413
     copy händelse 446413
        för varje objekt gör modifikationer som beskrivs i metoden
    */
        -- @var1 = 446413 'handelseid can't be null
        -- @rowNr = ? 'the actuall nr of rows in the ärendenr set that you want to process, handelse will be copied to each, #errors if inaccurate
        -- @beskrivning = '' what you'd like to overwrite the messagebox with, if left empty, copy original value.
        --outputs: drops if temptable #handelsenr excists, writes the new handelsenr that has bin created
        --makes selection towards output #handelsenr and comfirms that the nr of rows is exactly @rownr

execute SkapaHandelse

/*
 lägg till filer till händelser med utast händelsenamn vilka är assossierad med x ärenden
    --(ärendennrna står facktiskt i filnamnen, vi behöver egentligen inte hårdkåda eller refera dessa)
    --what about ärenden that does not yeat have the hendelse of choise.
error must be thrown
    --we have a designated place to fetch handelser from and we want to update */

execute SkapaFilHandelseKoppling
        -- expects #handelser is not empty, and not 0 row long, go to end of script and throw error.
        -- expects @var1 = 446413s to have file link eather exactly 1 file or nr files > #handelser
        -- expects join of #händelser and filkopplingar = #händelser or else throw error.

-- test both above
--output should be a preview of of what we order from the it department
select distinct fastighet,
                Diarienummer,
                [Utskick har gått till:],
                till,
                [Lagfaren ägare],
                adress

from lista
         full outer join (select Diarienummer, Fastighetsbeteckning from [påminnelse-12-mån-2020]) q
                         on fastighet = q.Fastighetsbeteckning
where Fastighetsbeteckning is not null
  and fastighet is not null

