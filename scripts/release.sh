#!/usr/bin/env bash
#
# Written by: Robin Gierse - robin.gieres@checkmk.com - on 20230502
# Adapted for personal use by: Robin Gierse - info@thorian93.de - on 20240323
#
# Purpose:
# Prepare this repository for a release.
#
# Usage: ./release.sh -s 0.0.1 -t 0.0.2
#

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
collection_dir="${script_dir%/*}"

while getopts 's:t:' OPTION; do
  case "$OPTION" in
    s)
      source_version="$OPTARG" ;;
    t)
      target_version="$OPTARG" ;;
    ?)
      echo "Unknown option!"
      exit 1
      ;;
  esac
done

echo "# General things to keep in mind:"
echo "- Did you provide changelogs for all relevant changes?"
echo "- Did you update SUPPORT.md with the latest compability information?"
echo

echo "# Changes:"
sed -i "s/version: ${source_version}/version: ${target_version}/g" "${collection_dir}/galaxy.yml" && echo "Updated Collection version in 'galaxy.yml' from ${source_version} to ${target_version}."
sed -i "s/version: ${source_version}/version: ${target_version}/g" "${collection_dir}/requirements.yml" && echo "Updated Collection version in 'requirements.yml' from ${source_version} to ${target_version}."
echo "# End changes section."
echo

echo "# Test findings:"
if [[ $(find "${collection_dir}/changelogs/fragments" | wc -l) -lt 1 ]] ; then echo "Make sure to provide all relevant changelogs!" ; fi
grep -R release_summary "${collection_dir}/changelogs/fragments/" > /dev/null || echo "Please provide a 'release_summary' in the changelogs!"
grep "${target_version}" "${collection_dir}/SUPPORT.md" > /dev/null || echo "Please provide a line about the version support in 'SUPPORT.md'!"
echo "# End tests section."
