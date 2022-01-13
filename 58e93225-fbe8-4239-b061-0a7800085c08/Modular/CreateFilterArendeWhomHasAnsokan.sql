
IF OBJECT_ID('tempdb..#filterArendeWhomHasAnsokan') IS NOT NULL DROP TABLE #filterArendeWhomHasAnsokan
create table dbo.#filterArendeWhomHasAnsokan
(
    dianr              nvarchar(max),
    kir                nvarchar(max),
    Handl�ggarsignatur nvarchar(max),
    Huvudkontakt       nvarchar(max),
    S�kbegrepp         nvarchar(max),
    ArendeText         nvarchar(max),
    status             nvarchar(max),
    Beslutsdatum       nvarchar(max),
    Kommentar          nvarchar(max),
    L�pnummer          int,
    dat                datetime2,
    H�ndelsekategori   nvarchar(max),
    rikt               nvarchar(max),
    rub                nvarchar(max),
    HandelseText       nvarchar(max),
    has                nvarchar(max)
);
