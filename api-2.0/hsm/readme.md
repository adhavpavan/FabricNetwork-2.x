

sudo apt install softhsm2

echo directories.tokendir = /tmp > $HOME/softhsm2.conf
export SOFTHSM2_CONF=$HOME/softhsm2.conf
softhsm2-util --init-token --slot 0 --label "ForFabric" --pin 98765432 --so-pin 1234


The Security Officer PIN, specified with the --so-pin flag, can be used to re-initialize the token, and the user PIN (see below), specified with the --pin flag, is used by applications to access the token for generating and retrieving keys.