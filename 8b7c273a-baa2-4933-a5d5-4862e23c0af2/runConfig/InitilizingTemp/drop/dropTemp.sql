
;IF object_id('TEMPDB..toInsert') IS not null BEGIN
    drop table toInsert
    end
IF object_id('TEMPDB..addressesToBeCorrected') IS not null BEGIN
drop table addressesToBeCorrected
end
IF object_id('TEMPDB..fordig') IS not null BEGIN
drop table fordig
end
;
