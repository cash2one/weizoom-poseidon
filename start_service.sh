PORT=${1:-4180}
cd devenv/register_service
python register.py --port $PORT
cd ../..
python manage.py runserver 0.0.0.0:$PORT