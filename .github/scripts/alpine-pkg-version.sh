#!/usr/bin/env sh
# Print the version of a package in an Alpine repository, as recorded in APKINDEX.
# Usage: alpine-pkg-version.sh <branch> <repo> <arch> <package>
# Example: alpine-pkg-version.sh edge main x86_64 iperf3  ->  3.21-r0
set -eu

branch=$1
repo=$2
arch=$3
pkg=$4

url="https://dl-cdn.alpinelinux.org/alpine/${branch}/${repo}/${arch}/APKINDEX.tar.gz"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

curl -sSfL --retry 3 --retry-delay 2 --max-time 60 -o "$tmp/APKINDEX.tar.gz" "$url"
tar -xzf "$tmp/APKINDEX.tar.gz" -C "$tmp" APKINDEX

# APKINDEX is a set of blank-line-separated records of "K:value" lines.
# Match the record whose P: (package name) is exactly $pkg, then print its V:.
awk -v RS='' -v pkg="$pkg" '
  {
    name = ""; ver = ""
    n = split($0, lines, "\n")
    for (i = 1; i <= n; i++) {
      if (substr(lines[i], 1, 2) == "P:") name = substr(lines[i], 3)
      if (substr(lines[i], 1, 2) == "V:") ver  = substr(lines[i], 3)
    }
    if (name == pkg && ver != "") { print ver; found = 1; exit }
  }
  END { if (!found) exit 1 }
' "$tmp/APKINDEX"
