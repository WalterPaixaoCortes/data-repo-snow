select concat('- name: ', table_name) as source
from information_schema.tables
where table_schema = 'SRC'
