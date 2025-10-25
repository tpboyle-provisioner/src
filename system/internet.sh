#!/bin/bash

TEST_PING_IP="8.8.8.8" # Google's public DNS server
TEST_PING_COUNT=1      # Number of pings to send
TEST_PING_TIMEOUT=2    # Timeout in seconds

is_connected_to_internet () {
  echo "Checking that we're connected to the Internet..."
  # Ping the target IP address and suppress output
  if ping -c "$TEST_PING_COUNT" -W "$TEST_PING_TIMEOUT" "$TEST_PING_IP" > /dev/null 2>&1; then
      return 0 # Connected
  else
      return 1 # Not connected
  fi
}
