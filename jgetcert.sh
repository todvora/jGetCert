#!/bin/bash

# reads from user input, if empty input, return default value (param one)
function read_or_default {
    read USERINPUT
    if [[ -z "$USERINPUT" ]]; then
            echo $1
        else
            echo $USERINPUT
         fi
}

function user_input { #user_input OUTPUT_VARNAME DISPLAY_TEXT DEFAULT_VALUE
    echo
    echo -n "Enter $2 [default: $3] > "
    VAL=$(read_or_default $3)
    # eval needed to define variable with name provided in first param
    eval $1=$VAL
}

user_input "HOST" "hostname of SSL cert" "www.google.com"

# temp file for downloaded certificate
TMPFILE=$(tempfile)

echo
echo "----certificate info----"
# download certificate, store in TMPFILE and print same basic info
echo -n | openssl s_client -connect $HOST:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $TMPFILE

# default location from environment variable JAVA_HOME
DEFJAVADIR=$JAVA_HOME;
if [[ -z "$DEFJAVADIR" ]]; then
    # if JAVA_HOME not found, then try to detect, where is java executable located
    # remove /bin/java to get path to base java directory
    DEFJAVADIR=$(update-alternatives --list java | tail -n 1 | sed 's/\(.*\)bin\/java/\1/')
fi

# construct cacerts path from base java directory
DEFCERTSTORE="$DEFJAVADIR/jre/lib/security/cacerts"

#read user preference of certstore location and use default, if no input
user_input "CERTSTORE" "Java certstore location" $DEFCERTSTORE

# test, if there really exists file with certsore
if [ ! -f $CERTSTORE ]; then
    echo "Certificate store $CERTSTORE not found, exiting!"
    exit 2
fi

# cacerts store password, default variant in distributions is "changeit"
user_input "USRKEYSTOREPASS" "keystore password" "changeit"

# import to cacerts keystore
sudo keytool -import -trustcacerts -keystore $CERTSTORE -storepass $USRKEYSTOREPASS -noprompt -alias $HOST -file $TMPFILE
echo
