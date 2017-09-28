#!/bin/bash
# Copyright 2017 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

source util.sh

main() {
  # Get our working project, or exit if it's not set.
  local project_id=$(get_project_id)
  if [[ -z "$project_id" ]]; then
    exit 1
  fi
  local url="https://${project_id}.appspot.com/airportName?iataCode=${IATA_CODE}"
  echo "This command will exit automatically in $TIMEOUT_SECONDS seconds."
  echo "Generating traffic to ${url}..."
  echo "Press Ctrl-C to stop."
  local endtime=$(($(date +%s) + $TIMEOUT_SECONDS))
  # Send queries repeatedly until TIMEOUT_SECONDS seconds have elapsed.
  while [[ $(date +%s) -lt $endtime ]]; do
    curl "$url" &> /dev/null
  done
}

# Defaults.
IATA_CODE="SFO"
TIMEOUT_SECONDS=$((5 * 60)) # Timeout after 5 minutes.

if [[ "$#" == 1 ]]; then
  API_KEY="$1"
elif [[ "$#" == 2 ]]; then
  API_KEY="$1"
  IATA_CODE="$2"
else
  echo "Wrong number of arguments specified."
  echo "Usage: generate_traffic.sh api-key [iata-code]"
  exit 1
fi

main "$@"