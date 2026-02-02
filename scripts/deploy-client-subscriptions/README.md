# Deploy Client Subscriptions CLI

**Status**: Placeholder for Phase 2 (User Story 2) - Tasks T050-T053

## Purpose

This tool will validate client subscription configurations against the JSON schema and upload them to the S3 Client Config bucket.

## Implementation Plan

- JSON schema validation using ajv
- S3 upload with validation
- Deployment logging and error handling
- Dry-run mode for testing

## Prerequisites

- AWS credentials configured with permissions to write to the Client Config S3 bucket
- Node.js 22.11.0 or later

## Installation

```bash
cd scripts/deploy-client-subscriptions
npm install
```

## Usage

### Deploy a client configuration

```bash
npm start -- \
  --config <path-to-config.json> \
  --bucket <s3-bucket-name> \
  --environment <env>
```

### Example

```bash
npm start -- \
  --config ./client-configs/client-a.json \
  --bucket client-config-dev \
  --environment dev
```

### Dry run (validation only)

```bash
npm start -- \
  --config ./client-configs/client-a.json \
  --bucket client-config-dev \
  --environment dev \
  --dry-run
```

### With custom schema

```bash
npm start -- \
  --config ./client-configs/client-a.json \
  --bucket client-config-dev \
  --environment dev \
  --schema ../../specs/CCM-13912-externalise-callbacks-phase1/contracts/client-config.schema.json
```

## Options

- `-c, --config <path>` - Path to client configuration JSON file (required)
- `-b, --bucket <name>` - S3 bucket name for client configs (required)
- `-e, --environment <env>` - Target environment: dev, staging, prod (required)
- `--dry-run` - Validate configuration without uploading (optional)
- `--schema <path>` - Path to JSON schema file for validation (optional)

## Configuration Format

Client configuration files should follow the schema defined in:
`specs/CCM-13912-externalise-callbacks-phase1/contracts/client-config.schema.json`

Example:

```json
{
  "clientId": "client-a",
  "webhookUrl": "https://client-a.example.com/webhooks/notify",
  "subscriptions": {
    "messageStatus": ["delivered", "failed"],
    "channelStatus": ["sms_delivered", "email_failed"]
  }
}
```

## Next Steps After Deployment

1. Run Terraform to sync infrastructure with the new configuration
2. Verify the Transform & Filter Lambda picks up the updated configuration
3. Test callback delivery to the client webhook

## Development

```bash
# Type checking
npm run typecheck

# Linting
npm run lint
npm run lint:fix

# Build
npm run build
```
