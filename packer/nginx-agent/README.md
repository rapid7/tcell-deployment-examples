# Description
This example is how to create an AMI with nginx/tCell via packer.

# Contents
It consists of 3 files:
* tcell-nginx-ubuntu.json - This is the packer file to be used with `packer build`
* tcell_agent.config - This is an example tCell agent config file to illustrate what it should look like, and where it should be copied to.
* nginx.conf - This is an example nginx.conf that illustrates what should be added to the nginx.conf for tCell

# Building AMIs
For creating an AMI with everything "baked-in," then replace the configuration files above with what you want in the final
deployment. This is not recommended for production, since for instance, in the tcell_agent.config file there is an API key.
But it is acceptable for initial testing.

It is recommended that the config files get copied in via cloudformation (CF) when creating the instance. The files
can be hosted on s3, and copied in via CF. Further, many fields in the tcell_agent.config file are settable via
environment variables, if that is the preferred means of passing in secrets. For nginx, the conf file is the only
way to pass things in, however, it contains no secrets so this should be okay. 

# Other Notes
Note that the packer script will need to be updated to the latest tCell agent version URL. To get this, go to 
the Admin section, to Agent Downloads, select the Web Server Agent tab, and select nginx. The link to the
latest release is shown, and replace the url used for download with the newest release.

These files are provided as examples, and should be updated with the appropriate security/operational standards 
required for any given deployment. Feedback, bugfixes, etc. are welcome.
