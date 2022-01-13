
IF OBJECT_ID('tempdb..#filterArendeWhomHasAnsokan') IS NOT NULL DROP TABLE #filterArendeWhomHasAnsokan
create table dbo.#filterArendeWhomHasAnsokan
(
    dianr              nvarchar(max),
    kir                nvarchar(max),
    Handläggarsignatur nvarchar(max),
    Huvudkontakt       nvarchar(max),
    Sökbegrepp         nvarchar(max),
    ArendeText         nvarchar(max),
    status             nvarchar(max),
    Beslutsdatum       nvarchar(max),
    Kommentar          nvarchar(max),
    Löpnummer          int,
    dat                datetime2,
    Händelsekategori   nvarchar(max),
    rikt               nvarchar(max),
    rub                nvarchar(max),
    HandelseText       nvarchar(max),
    has                nvarchar(max)
);
