select group_concat(distinct _id) _id
     , group_concat(distinct online_id) online_id
     , group_concat(distinct local_id) local_id
     , group_concat(distinct change_key) change_key
     , group_concat(distinct delete_after_sync) delete_after_sync
     , group_concat(distinct due_date) due_date
     , group_concat(distinct due_date_changed) due_date_changed
     , group_concat(distinct task_folder_local_id) task_folder_local_id
     , group_concat(distinct task_folder_local_id_changed) task_folder_local_id_changed
     , group_concat(distinct status) status
     , group_concat(distinct status_changed) status_changed
     , group_concat(distinct importance) importance
     , group_concat(distinct importance_changed) importance_changed
     , subject
     , group_concat(distinct subject_changed) subject_changed
     , group_concat(distinct body_content) body_content
     , group_concat(distinct body_content_changed) body_content_changed
     , group_concat(distinct original_body_content) original_body_content
     , group_concat(distinct body_content_type) body_content_type
     , group_concat(distinct body_content_type_changed) body_content_type_changed
     , group_concat(distinct body_last_modified) body_last_modified
     , group_concat(distinct body_last_modified_changed) body_last_modified_changed
     , group_concat(distinct is_reminder_on) is_reminder_on
     , group_concat(distinct is_reminder_on_changed) is_reminder_on_changed
     , group_concat(distinct reminder_datetime) reminder_datetime
     , group_concat(distinct reminder_datetime_changed) reminder_datetime_changed
     , group_concat(distinct reminder_type) reminder_type
     , group_concat(distinct position) position
     , group_concat(distinct position_changed) position_changed
     , group_concat(distinct created_datetime) created_datetime
     , group_concat(distinct completed_datetime) completed_datetime
     , group_concat(distinct completed_datetime_changed) completed_datetime_changed
     , group_concat(distinct imported) imported
     , group_concat(distinct postponed_date) postponed_date
     , group_concat(distinct postponed_date_changed) postponed_date_changed
     , group_concat(distinct committed_date) committed_date
     , group_concat(distinct committed_date_changed) committed_date_changed
     , group_concat(distinct committed_order) committed_order
     , group_concat(distinct committed_order_changed) committed_order_changed
     , group_concat(distinct is_ignored) is_ignored
     , group_concat(distinct is_ignored_changed) is_ignored_changed
     , group_concat(distinct deleted) deleted
     , group_concat(distinct recurrence_type) recurrence_type
     , group_concat(distinct recurrence_interval) recurrence_interval
     , group_concat(distinct recurrence_interval_type) recurrence_interval_type
     , group_concat(distinct recurrence_days_of_week) recurrence_days_of_week
     , group_concat(distinct recurrence_changed) recurrence_changed
     , group_concat(distinct source) source
     , group_concat(distinct created_by) created_by
     , group_concat(distinct completed_by) completed_by
     , group_concat(distinct allowed_scopes) allowed_scopes
     , group_concat(distinct last_modified_date_time) last_modified_date_time
from tasks
group by subject