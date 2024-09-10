#!/bin/sh
# Version: 1.0
# Install GroupIB Custom Objects
printf -- "\n----- Installing GroupIB Custom Objects -----\n\n"
# Entering Maintenance mode
printf "Installing Custom Objects - Step 1 of 5 (Entering Maintenance Mode)\n\n"
/var/www/api/artisan down
printf "Installing Custom Objects - Step 2 of 5 (Installing the GroupIB Custom Objects)\n\n"
# Copy the files
DIR=$( cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P )
/bin/cp -v "${DIR}/images/"*'.svg' /var/www/api/database/seeds/data/icons/images/custom_objects/
/bin/cp -v "${DIR}/groupib.json" /var/www/api/database/seeds/data/custom_objects/
# Install the Custom Object
/var/www/api/artisan threatq:make-object-set --file=/var/www/api/database/seeds/data/custom_objects/groupib.json >> ./GroupIB_install.log
# Configure the Image for the Custom Object
printf "Installing Custom Objects - Step 3 of 5 (Configuring icons for the GroupIB Custom Objects)\n\n"
/var/www/api/artisan threatq:object-settings --code=money_mule --icon=/var/www/api/database/seeds/data/icons/images/custom_objects/MoneyMule.svg --background-color='#03ac14' >> ./GroupIB_install.log
/var/www/api/artisan threatq:object-settings --code=imei --icon=/var/www/api/database/seeds/data/icons/images/custom_objects/IMEI.svg --background-color='#03ac14' >> ./GroupIB_install.log
/var/www/api/artisan threatq:object-settings --code=organization --icon=/var/www/api/database/seeds/data/icons/images/custom_objects/Organization.svg --background-color='#03ac14' >> ./GroupIB_install.log
/var/www/api/artisan threatq:object-settings --code=account --icon=/var/www/api/database/seeds/data/icons/images/custom_objects/Account.svg --background-color='#ED414D' >> ./GroupIB_install.log
/var/www/api/artisan threatq:object-settings --code=card --icon=/var/www/api/database/seeds/data/icons/images/custom_objects/CompromisedCard.svg --background-color='#ED414D' >> ./GroupIB_install.log
# Update Permissions
printf "Installing Custom Objects - Step 4 of 5 (Updating Permissions in ThreatQ)\n\n"
/var/www/api/artisan cache:clear >> ./GroupIB_install.log
/var/www/api/artisan threatq:update-permissions >> ./GroupIB_install.log
# Exit Maintenance mode
printf "Installing Custom Objects - Step 5 of 5 (Exiting Maintenance Mode and Restarting Dynamo)\n\n"
/var/www/api/artisan up
systemctl restart threatq-dynamo
