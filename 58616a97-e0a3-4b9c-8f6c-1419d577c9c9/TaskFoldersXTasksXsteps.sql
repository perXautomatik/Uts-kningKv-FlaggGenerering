
with
tf as (select _id, online_id, local_id, name
from task_folders)
,ts as (select _id, local_id, task_folder_local_id, coalesce(tasks.subject,original_body_content,body_content) task
from tasks where completed_datetime is null AND deleted = 0 AND completed_by is null)
,st as (select _id, local_id, task_local_id,subject
from steps)

select name, task, subject steps
from tf left outer join ts on tf.local_id = ts.task_folder_local_id
		left outer join st on ts.local_id = st.task_local_id

