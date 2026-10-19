# Copyright 2026 Joshua Rich <joshua.rich@gmail.com>.
# SPDX-License-Identifier: 	AGPL-3.0-or-later

#!/usr/bin/env bash -x

# Increment version code.
jq '.appVersionCode += 1' twa-manifest.json > /tmp/twa-manifest.json.updated && \
    cp /tmp/twa-manifest.json.updated twa-manifest.json

# Replace placeholders.
sed \
  -e "s|__ANDROID_KEYSTORE_PATH__|${ANDROID_KEYSTORE_PATH}|" \
  -e "s|__ANDROID_KEYSTORE_ALIAS__|${ANDROID_KEYSTORE_ALIAS}|" \
  -e 's|"fingerprints": {}|"fingerprints": '${ANDROID_KEYSTORE_FINGERPRINT}"|" \
  -e "s|__FORAGD_DOMAIN__|${FORAGD_DOMAIN}|" \
  -e "s|__FORAGD_BASEURL__|${FORAGD_BASEURL}|" \
  twa-manifest.json > twa-manifest-generated.json
