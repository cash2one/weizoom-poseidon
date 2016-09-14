mysql -u poseidon --password=weizoom poseidon < rebuild_database.sql
python manage.py syncdb --noinput