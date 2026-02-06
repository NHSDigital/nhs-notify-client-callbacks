# # This script is run before the Terraform apply command.
# # It ensures all Node.js dependencies are installed, generates any required dependencies,
# # and builds all Lambda functions in the workspace before Terraform provisions infrastructure.

pnpm install --frozen-lockfile

pnpm run generate-dependencies --if-present

pnpm run lambda-build
