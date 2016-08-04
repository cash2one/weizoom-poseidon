#!/bin/bash

#PROJECT_NAME=`basename $PWD`
PROJECT_NAME="wemanage"

MODE=`grep "MODE = " $PROJECT_NAME/settings.py | head -n 1 | sed "s/^MODE *= *'\(.*\)'.*$/\1/"`

if [ "$MODE" == "develop" ]; then
  echo "In DEVELOP mode, i'm trying to rebuild the database. NEVER run this script in DEPLOY mode!"

  # get config from `settings.py`
  DBNAME=`grep "'NAME'" $PROJECT_NAME/settings.py | head -n 1 | awk '{print $2}' | sed "s/^'\(.*\)'.*$/\1/"`
  USER=`grep "'USER'" $PROJECT_NAME/settings.py | head -n 1 | awk '{print $2}' | sed "s/^'\(.*\)'.*$/\1/"`
  PASSWORD=`grep "'PASSWORD'" $PROJECT_NAME/settings.py | head -n 1 | awk '{print $2}' | sed "s/^'\(.*\)'.*$/\1/"`
  HOST=`grep "'HOST'" $PROJECT_NAME/settings.py | head -n 1 | awk '{print $2}' | sed "s/^'\(.*\)'.*$/\1/"`

  echo "USERNAME: [$USER], PASSWORD: [$PASSWORD]"
  echo "
DROP DATABASE IF EXISTS $DBNAME;
CREATE DATABASE $DBNAME DEFAULT CHAR SET 'utf8';" |\
  mysql -u $USER --password=$PASSWORD $DBNAME -h $HOST
  python manage.py syncdb --noinput
fi
