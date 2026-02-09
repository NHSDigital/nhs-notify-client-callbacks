#!/bin/bash

set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

# Run TypeScript type checking across all workspaces
npm ci
npm run typecheck
