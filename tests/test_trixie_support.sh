#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

CREATE_SH="$ROOT/build/create.sh"
RECONFIG_SH="$ROOT/files/usr/sbin/reconfig-clusterctrl"
POSTINST_SH="$ROOT/files/etc/kernel/postinst.d/clusterctrl"

assert_contains() {
 file="$1"
 text="$2"
 desc="$3"
 if ! grep -Fq "$text" "$file"; then
  echo "FAIL: $desc"
  echo "Missing text: $text"
  exit 1
 fi
}

echo "Checking Raspberry Pi OS Trixie image detection entries..."
assert_contains "$CREATE_SH" 'raspios-trixie-armhf.img' "Missing armhf standard Trixie image detection"
assert_contains "$CREATE_SH" 'raspios-trixie-armhf-lite.img' "Missing armhf lite Trixie image detection"
assert_contains "$CREATE_SH" 'raspios-trixie-armhf-full.img' "Missing armhf full Trixie image detection"
assert_contains "$CREATE_SH" 'raspios-trixie-arm64.img' "Missing arm64 standard Trixie image detection"
assert_contains "$CREATE_SH" 'raspios-trixie-arm64-lite.img' "Missing arm64 lite Trixie image detection"
assert_contains "$CREATE_SH" 'raspios-trixie-arm64-full.img' "Missing arm64 full Trixie image detection"

echo "Checking Trixie release handling..."
assert_contains "$CREATE_SH" 'RASPIOS32TRIXIE' "Missing RASPIOS32TRIXIE handling in build/create.sh"
assert_contains "$CREATE_SH" 'RASPIOS64TRIXIE' "Missing RASPIOS64TRIXIE handling in build/create.sh"
assert_contains "$RECONFIG_SH" '"$VERSION_CODENAME" = "trixie"' "Missing trixie codename support in reconfig-clusterctrl"
assert_contains "$POSTINST_SH" '"$VERSION_CODENAME" = "trixie"' "Missing trixie codename support in kernel postinst script"

echo "PASS: Trixie support checks completed successfully."
