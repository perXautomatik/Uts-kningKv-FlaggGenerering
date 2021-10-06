select * from EDPVisionRegionGotland.dbo.vwAehAerende q
where q.STRSOEKBEGREPP = 'NÄR SMISS 1:28';

SELECT * from vwAehAerende
WHERE
      strFastighetsbeteckning = 'Follingbo Klinte 1:36'
      or
      strFastighetsbeteckning = 'Follingbo Klinte 1:54'
;

select top 1 * from tbAehAerende order by recAerendeId desc;