# This file is for you! Edit it to implement your own hooks (make targets) into
# the project as automated steps to be executed on locally and in the CD pipeline.

include scripts/init.mk

# ==============================================================================

# Example CI/CD targets are: dependencies, build, publish, deploy, clean, etc.

dependencies: # Install dependencies needed to build and test the project @Pipeline
	pnpm install --frozen-lockfile
	pnpm run generate-dependencies

build: # Build the project artefact @Pipeline
	(cd docs && make build)
	pnpm run --recursive --if-present lambda-build

publish: # Publish the project artefact @Pipeline
	# Lambda artefacts are built and packaged by Terraform during deployment
	# No separate publish step required - Lambda deployment packages are created inline

deploy: # Deploy the project artefact to the target environment @Pipeline
	# Deployment is handled via Terraform in infrastructure/terraform/
	# See infrastructure/terraform/components/callbacks/ for Lambda deployments
	# Run: cd infrastructure/terraform && terraform apply

clean:: # Clean-up project resources (main) @Operations
	rm -f .version
	rm -rf lambdas/*/dist
	rm -rf scripts/*/dist
	rm -rf node_modules
	rm -rf lambdas/*/node_modules
	rm -rf scripts/*/node_modules
	rm -rf .reports
	rm -rf **/.reports
	rm -f .reports/lcov.info
	(cd docs && make clean)

config:: _install-dependencies version # Configure development environment (main) @Configuration
	(cd docs && make install)

version:
	rm -f .version
	make version-create-effective-file dir=.
	echo "{ \"schemaVersion\": 1, \"label\": \"version\", \"message\": \"$$(head -n 1 .version 2> /dev/null || echo unknown)\", \"color\": \"orange\" }" > version.json
# ==============================================================================

${VERBOSE}.SILENT: \
	build \
	clean \
	config \
	dependencies \
	deploy \
