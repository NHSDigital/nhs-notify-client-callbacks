# Replay from DLQ CLI

**Status**: Placeholder for Phase 6 (User Story 4) - Tasks T068-T074

## Purpose

This tool will read messages from a client's DLQ and republish them to the Callback Event Queue for reprocessing.

## Implementation Plan

- Batch replay support with progress tracking
- Individual event replay support
- Dry-run mode for safety (shows what would be replayed without sending)
- Replay audit logging
- Client isolation (only replays for specified client)

## Prerequisites

- AWS credentials configured with permissions to:
  - Read from client DLQs
  - Write to Callback Event Queue
  - Delete messages from DLQs
- Node.js 22.11.0 or later

## Installation

```bash
cd scripts/replay-from-dlq
npm install
```

## Usage

### Replay all messages from a client DLQ

```bash
npm start -- \
  --client-id <client-id> \
  --dlq-url <dlq-url> \
  --target-queue-url <queue-url>
```

### Example

```bash
npm start -- \
  --client-id client-a \
  --dlq-url https://sqs.eu-west-2.amazonaws.com/123456789012/client-a-dlq \
  --target-queue-url https://sqs.eu-west-2.amazonaws.com/123456789012/callback-event-queue
```

### Dry run (show what would be replayed)

```bash
npm start -- \
  --client-id client-a \
  --dlq-url https://sqs.eu-west-2.amazonaws.com/123456789012/client-a-dlq \
  --target-queue-url https://sqs.eu-west-2.amazonaws.com/123456789012/callback-event-queue \
  --dry-run
```

### Replay with limits

```bash
# Replay maximum of 50 messages
npm start -- \
  --client-id client-a \
  --dlq-url https://sqs.eu-west-2.amazonaws.com/123456789012/client-a-dlq \
  --target-queue-url https://sqs.eu-west-2.amazonaws.com/123456789012/callback-event-queue \
  --max-messages 50

# Process in batches of 5
npm start -- \
  --client-id client-a \
  --dlq-url https://sqs.eu-west-2.amazonaws.com/123456789012/client-a-dlq \
  --target-queue-url https://sqs.eu-west-2.amazonaws.com/123456789012/callback-event-queue \
  --batch-size 5
```

### Replay a specific message

```bash
npm start -- \
  --client-id client-a \
  --dlq-url https://sqs.eu-west-2.amazonaws.com/123456789012/client-a-dlq \
  --target-queue-url https://sqs.eu-west-2.amazonaws.com/123456789012/callback-event-queue \
  --message-id <message-id>
```

## Options

- `-c, --client-id <id>` - Client ID for DLQ isolation (required)
- `-d, --dlq-url <url>` - DLQ URL to read messages from (required)
- `-t, --target-queue-url <url>` - Target queue URL to replay messages to (required)
- `--dry-run` - Show what would be replayed without sending (optional)
- `--batch-size <number>` - Number of messages to replay in one batch (default: 10)
- `--max-messages <number>` - Maximum messages to replay, 0 = all (default: 0)
- `--message-id <id>` - Replay a specific message by ID (optional)

## Operational Workflow

### Before Replay

1. Check CloudWatch dashboard for DLQ depth
2. Investigate root cause of failures (client endpoint down, configuration issue, etc.)
3. Resolve the underlying issue
4. Verify client webhook is healthy

### During Replay

1. Start with a dry-run to see what would be replayed
2. If dry-run looks correct, run the actual replay
3. Monitor progress via console output
4. Watch CloudWatch metrics for DLQ depth decrease

### After Replay

1. Monitor Transform & Filter Lambda logs for reprocessing
2. Verify callbacks are successfully delivered to client webhook
3. Confirm DLQ depth has decreased to expected level
4. Document the incident and resolution in runbook

## Safety Features

- **Dry-run mode**: Validate replay operation without making changes
- **Client isolation**: Only replays messages for the specified client
- **Progress tracking**: Shows real-time progress during replay
- **Batch control**: Limit number of messages processed
- **Audit logging**: All operations are logged for compliance

## Next Steps After Replay

1. Monitor the Transform & Filter Lambda logs for reprocessing
2. Verify callbacks are delivered to client webhook
3. Check DLQ depth has decreased appropriately
4. Update operational runbook with lessons learned

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

## Related Documentation

- [DLQ Replay Runbook](../../docs/runbooks/dlq-replay.md) - Detailed operational procedures
- [CloudWatch Dashboard Guide](../../docs/monitoring.md) - How to interpret DLQ metrics
- [Architecture Diagram](../../docs/architecture/phase1-diagram.png) - System overview
