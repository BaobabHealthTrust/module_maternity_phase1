#!/bin/bash

usage(){
  echo "Usage: $0 ENVIRONMENT"
  echo
  echo "ENVIRONMENT should be: development|test|production"
} 

ENV=$1

if [ -z "$ENV" ] ; then
  usage
  exit
fi

# set -x # turns on stacktrace mode which gives useful debug information

# if [ ! -x config/database.yml ] ; then
#    cp config/database.yml.example config/database.yml
# fi

#sudo apt-get install htmldoc
#sudo apt-get install wkhtmltopdf
#sudo apt-get install ruby-rmagick
#sudo gem install rqrcode -v="0.4.2"
#sudo gem install bary -v="0.5.0"

USERNAME=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['${ENV}']['username']"`
PASSWORD=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['${ENV}']['password']"`
DATABASE=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['${ENV}']['database']"`

FILES=db/triggers/*
for f in $FILES
do
	echo "Installing $f trigger file..."
	mysql --user=$USERNAME --password=$PASSWORD $DATABASE < $f
done

mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/relationship_type.sql
mysql --user=$USERNAME --password=$PASSWORD $DATABASE < db/birth_report.sql
