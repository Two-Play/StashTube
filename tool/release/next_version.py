#!/usr/bin/env python3
"""Prints the version of the next release (without "v").

    tool/release/next_version.py <latest tag or ""> [label ...]

release.yml runs it for every push to main with the highest existing tag
and the labels of the merged pull request:

- no label: the next beta after a beta (1.0.0-beta.5 -> 1.0.0-beta.6),
  else the next patch (1.0.0 -> 1.0.1)
- release:stable: the beta's version without "-beta" (1.0.0-beta.5 ->
  1.0.0), else the next patch
- release:patch / release:minor / release:major: that part goes up
  (1.0.0-beta.5 with release:minor -> 1.1.0)
- release:beta: makes a new version the first beta of it (1.0.0 with
  release:minor and release:beta -> 1.1.0-beta.1)
"""
import re
import sys

VERSION = re.compile(r'^v?(\d+)\.(\d+)\.(\d+)(?:-beta\.(\d+))?$')


def next_version(latest, labels):
    labels = set(labels)
    if not latest:
        major, minor, patch, beta = 0, 0, 0, None
    else:
        match = VERSION.match(latest)
        if not match:
            raise ValueError(f'{latest} is not a version like v1.2.0 or v1.2.0-beta.1')
        major, minor, patch = (int(g) for g in match.group(1, 2, 3))
        beta = int(match.group(4)) if match.group(4) else None

    if 'release:major' in labels:
        major, minor, patch = major + 1, 0, 0
    elif 'release:minor' in labels:
        minor, patch = minor + 1, 0
    elif 'release:patch' in labels:
        patch += 1
    elif beta is not None and 'release:stable' not in labels:
        return f'{major}.{minor}.{patch}-beta.{beta + 1}'
    elif beta is None:
        patch += 1
    # Else release:stable on a beta: its version as it is.

    base = f'{major}.{minor}.{patch}'
    return f'{base}-beta.1' if 'release:beta' in labels else base


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    print(next_version(sys.argv[1], sys.argv[2:]))
