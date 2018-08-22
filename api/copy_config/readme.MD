This is a very simple sample script for migrating a staging configuration
from staging to production. The staging appid is set in the variable "SRC_APP", change to your application's staging id. The production appid is set in the variable "DEST_APP", change to your application's production id.

For security reasons, the api key is not included and must be passed in, like
./migrate.sh APIKEY

For more information on the specifics of the configuration APIs, see
[Configuration APIs](https://docs.tcell.io/v1.0/reference#configs). For
more information on creating and using API Keys, see [API Keys](https://docs.tcell.io/v1.0/reference#usage-tutorial).
