#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

# Required!
DEVICE=nicki
VENDOR=sony

# Load extractutils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

ROOT_DIR="$MY_DIR"/../../..

# Initialize the helper
setup_vendor "$DEVICE" "$VENDOR" "$ROOT_DIR"

# Copyright headers and guards
write_headers

# Sony/Device specific blobs
write_makefiles "$MY_DIR"/proprietary-files-sony.txt

# Qualcomm BSP blobs - we put a conditional around here
# in case the BSP is actually being built
printf '\n%s\n' "ifeq (\$(QCPATH),)" >> "$PRODUCTMK"
printf '\n%s\n' "ifeq (\$(QCPATH),)" >> "$ANDROIDMK"

write_makefiles "$MY_DIR"/proprietary-files-qc.txt

cat << EOF >> "$PRODUCTMK"
endif
EOF

cat << EOF >> "$ANDROIDMK"
endif
EOF

# We are done!
write_footers
