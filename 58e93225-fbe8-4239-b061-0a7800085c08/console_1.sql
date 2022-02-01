begin try
drop table tempflagga
end try begin catch
    end catch

begin try
create table tempFlagga (
fastighet nvarchar(max)
)
end try begin catch end catch

declare @a as nvarchar(max) =
    N'select fastighet from sde_miljo_halsoskydd.GNG.FLAGGSKIKTET_P
    '



insert into TempFlagga
EXEC [GISDATA].master.dbo.sp_executesql

@a

select * from tempflagga



    on gr.fastighet = flags.fastighet
    from tempExcel.dbo.[gröna-flaggor-kv] gr left outer join