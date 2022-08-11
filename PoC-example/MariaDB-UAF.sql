create or replace trigger A before insert on B
for each row select table_rows from information_schema.tables
where table_name = 'C' into @#;
