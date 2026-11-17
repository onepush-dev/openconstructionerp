#!/bin/bash
# OpenConstructionERP Railway start wrapper.
# Upstream gives admin to the first person who registers on a fresh install (seeded demo accounts don't count).
# On a public Railway URL that would be whoever finds it first, so this wrapper claims that bootstrap slot at
# first boot with an owner account whose password is generated per deploy (OE_OWNER_PASSWORD), then keeps
# running the upstream entrypoint unchanged. Later registrations get the upstream default (dormant viewer,
# admin-approve). If the owner email is already registered, nothing happens.
set -u
/app/entrypoint.sh &
APP=$!
trap 'kill -TERM $APP 2>/dev/null' TERM INT
if [ -n "${OE_OWNER_PASSWORD:-}" ]; then
  for i in $(seq 1 300); do
    curl -fs -o /dev/null http://127.0.0.1:8080/api/health && break
    kill -0 $APP 2>/dev/null || break
    sleep 1
  done
  body=$(printf '{"email":"%s","password":"%s","full_name":"%s"}' "$OE_OWNER_EMAIL" "$OE_OWNER_PASSWORD" "${OE_OWNER_NAME:-Owner}")
  code=$(curl -s -o /tmp/owner.json -w '%{http_code}' -H 'content-type: application/json' -d "$body" http://127.0.0.1:8080/api/v1/users/auth/register)
  case "$code" in
    201) role=$(python -c 'import json;print(json.load(open("/tmp/owner.json")).get("role","?"))' 2>/dev/null)
         echo "railway: created the owner account $OE_OWNER_EMAIL (role: $role); sign in with OE_OWNER_PASSWORD from Variables" ;;
    409) echo "railway: owner account $OE_OWNER_EMAIL already exists" ;;
    *)   echo "railway: owner registration returned $code: $(head -c 300 /tmp/owner.json)" ;;
  esac
fi
wait $APP
