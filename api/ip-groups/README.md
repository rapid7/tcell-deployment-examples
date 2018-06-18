# How to Block Banned Country IPs 
Below we provide a brief tutorial on how to use tCell service
to block requests from various banned countries and organizations.


## Determine your banned countries List

Different companies have different restrictions on the 
organizations that they restrict access to. In the Unitied States,
as described at https://www.treasury.gov/resource-center/sanctions/Programs/Pages/faq_10_page.aspx, there is not a single static list of banned countries. Rather, the US Treasury Office of Foreign Assets Control (OFAC) maintains a set of different restrictions depending on a website's purpose and context. Thus, one should determine this list of banned countries per your company profile, regulatory context, geographic scope, and risk management preferences. Depending on your profile, you may want to include IP addresses outside of the country controlled by Specially Designated Nationals, see https://www.treasury.gov/resource-center/sanctions/SDN-List/Pages/default.aspx.


## Get a CIDR block of IP addresses per country

There are a variety of websites that provide, either for free or pay, the ability to download the list of IP CIDR blocks for a country. https://www.ip2location.com/blockvisitorsbycountry.aspx is a popular website that provide a free list. Make sure to download in CIDR IPv4 format.


## Create an IPGroups JSON file for each country 

We will upload the list of CIDR blocks per company using the /ipgroups API. As such, we must convert the text file of CIDR entries to a JSON file that /ipgroups can process, using the  create_json.py utility. This can be performed as follows:

`python cidr_to_json.py --name "IP Group Name" --cidrfile CIDRFILE.TXT --output "IP Group Name".json`
where:

CIDRFILE.TXT is the name of CIDR file downloaded in the previous step

and 

"IP Group Name" is name of country or other group of IPs to block, such as a SDN list.



## Upload the IP Group definition per country

Use the IP Groups API to upload each country ip group definition to the cloud. Sample usage:

`curl -v -X POST -H "Authorization: Bearer APIKEY" -H "Content-Type: application/json" -d @"IP Group Name".json  https://api.tcell.io/customer/api/v1/ipgroups`



The APIKEY should be A User API Key with full-access as explained at https://docs.tcell.io/v1.0/reference.

## Define Blocking Rules

As explained at https://docs.tcell.io/docs/dashboard#section-app-firewall, create an IP blocking rule that blocks if ANY of the IP groups defined in previous section are encountered.



## Keeping IP List Current
This tutorial is based on a static group of CIDR blocks that occur at a fixed time. The IP addresses and CIDR blocks can change over time, and thus periodically one should update IP groups. The subset of steps below explain how to update an existing company group:



### Create new update json File
The same tool above, with slightly different flags, can create an update JSON used to update an existing IP group. Run:



`python cidr_to_json.py --update --cidrfile CIDRFILE.TXT --output IP Group Name.update.json`
where

CIDRFILE.TXT is the updated list of CIDR entries for a country
IP Group Name.update.json is the new json used to update the existing IP group


Then we update as

### Update IP group
`curl -v -X POST -H "Authorization: Bearer APIKEY" -H "Content-Type: application/json" -d @IP Group Name.update.json  https://api.tcell.io/customer/api/v1/ipgroups/IP Group Name/items`

The APIKEY should be a User API Key with full-access as explained at https://docs.tcell.io/v1.0/reference.
