#!/usr/bin/env bash
# Runs the test folders matching the changed features; core changes run everything.
set -euo pipefail
cd mobile
targets=()
for file in "$@"; do
  file=${file#mobile/}
  case "$file" in
    lib/features/*|test/features/*)
      feature=$(echo "$file" | cut -d/ -f3)
      [ -d "test/features/$feature" ] && targets+=("test/features/$feature")
      ;;
    *) exec flutter test ;;
  esac
done
[ ${#targets[@]} -eq 0 ] && exit 0
flutter test $(printf '%s\n' "${targets[@]}" | sort -u) test/architecture
