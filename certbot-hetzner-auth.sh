#!/bin/bash

token=${HETZNER_API_TOKEN:-$(cat /etc/hetzner-dns-token)}
search_name=$( echo $CERTBOT_DOMAIN | rev | cut -d'.' -f 1,2 | rev)
sub_name=$( echo $CERTBOT_DOMAIN | rev | cut -d'.' -f 3- | rev)

if ! test -z ${sub_name}
then
	sub_name=.${sub_name}
fi

curl	-so/dev/null \
	-H "Authorization: Bearer ${token}" \
	-H 'Content-Type: application/json' \
	-X "POST" "https://api.hetzner.cloud/v1/zones/${search_name}/rrsets" \
	-d '{"name":"_acme-challenge'${sub_name}'","type":"TXT","ttl":60,"records":[{"value":"\"'${CERTBOT_VALIDATION}'\""}]}'

# just make sure we sleep for a while (this should be a dig poll loop)
sleep 30
