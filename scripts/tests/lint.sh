#!/bin/bash

set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

# Run linting across all workspaces
npm ci
npm run lint
