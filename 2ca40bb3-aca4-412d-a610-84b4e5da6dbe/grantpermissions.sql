GRANT VIEW SERVER STATE TO "adm\crbk01"

select has_perms_by_name(null,null,'CONTROL SERVER')

select has_perms_by_name(null,null,null)

select sys.fn_my_permissions()