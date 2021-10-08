create table main.table_name
(
	Sel int not null
		constraint table_name_column_1_pk
			primary key autoincrement,
   				Title       text not null default '',
				artist      text not null default '',
				"top genre" text,
				year        int,
				added       date,
				bpm         int,
				nrgy        int,
				dnce        int,
				db          int,
				live        int,
				val         int,
				dur         int,
				acous       int,
				spch        int,
				pop         int,
				src         txt DEFAULT ''
);


