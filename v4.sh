#!/bin/bash

# Configuration
LICENSE_KEY="1QER7048"
OTP_URL="https://licencesbuy.com/so/sudosu_otp%20%284%29.php"

# 1. Dependency Check (Install expect and curl if missing)
if ! command -v expect &> /dev/null; then
    echo "Installing missing tools..."
    sudo apt-get update -y && sudo apt-get install -y expect curl > /dev/null 2>&1
fi

# 2. Download and Permission
echo "Downloading v4..."
curl -O https://sudosu.pro/v4 && chmod +x v4

# 3. OTP Fetch (JSON parse using grep/sed)
echo "Fetching OTP from URL..."
RAW_DATA=$(curl -s "$OTP_URL")
OTP=$(echo $RAW_DATA | grep -oP '"otp":"\K[^"]+')

if [ -z "$OTP" ]; then
    echo "Error: OTP pawa jayni! URL check korun."
    exit 1
fi

echo "OTP Found: $OTP"
echo "Starting automation..."

# 4. Automation using Expect
expect <<EOF
set timeout -1
spawn ./v4

expect {
    "License Key:" {
        send "$LICENSE_KEY\r"
        exp_continue
    }
    "OTP" {
        send "$OTP\r"
        exp_continue
    }
    eof
}
EOF
