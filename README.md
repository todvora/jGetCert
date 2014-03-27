jGetCert
========

Import SSL certificates into Java trusted certificate store.

There are several reasons, why you may need to import SSL certificate into java certificate store. 
- Maybe you need to read HTTPS url, secured with certificate by unknown authority.
- Other example is communication with WebService using self signed certificate. 
- Your maven repository mirror may be using unknown CA.

This tool does few simple things. First, it downloads SSL certificate of given host. 
Then it locates your Java home and cacerts storage. Finally it imports downloaded certificate into storage.

Most important commands used by tool are:

echo -n | openssl s_client -connect <hostname>:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > <temfile_for_new_cert>

and 

sudo keytool -import -trustcacerts -keystore <certstore_path> -storepass <password> -noprompt -alias <alias of cert> -file <file_containing_new_cert>


Usage
=====
1) download jgetcert.sh file. 
2) run ./jgetcert.sh without any parameters. 
3) You will be asked for Host, Java home and cacerts password. There is autodetection of Java home and predefined default java cacert password "changeit"
4) Certificate will be permanently stored into cacerts.

Required environment
====================
Script is tested on Ubuntu 12.04, it should work on standard linux distributions. There is used 'sudo' command.
You need Java Runtime Environment installed.

After update of JRE, you may need to reimport certificate again. It may be overriden with new distributed version of cacerts.
