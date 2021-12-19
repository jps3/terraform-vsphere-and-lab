#!/bin/sh -eu
#
# Usage: add_proxy_user [user1 [user2 [...]]]
#

len="24"
i="0"

catch() {
    echo "Error $1 occurred on line $2"
}

trap 'catch $? $LINENO' ERR

test -e /etc/adduser.conf || echo "No /etc/adduser.conf (needed for adduser command to work)"

for user in "$@"
do

    printf 'Adding lab proxy user "%s" ... ' "$user"

    # Simple check for valid username to prevent command injection
    echo -n "$user" | grep -E -q '^[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)$'

    # Generate an encrypted, random password
    rand_pass="$(jot -r -c "$len" 23 127 | rs -g0 | encrypt -b a -c default)"

    # Add new user
    adduser -batch "$user" "labproxy" "" "$rand_pass" || printf '\n'

    # Maybe there's a GitHub public key?
    (
        curl -s "https://api.github.com/users/$user/keys" \
        | jq -r '.[].key|"restrict,port-forwarding,command=\"/usr/bin/false\" " + .'
    ) > /home/$user/.ssh/authorized_keys

    i=$((i + 1))

done

printf '>>> Added %i users\n' "$i"
