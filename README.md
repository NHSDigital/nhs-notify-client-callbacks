# NHS Notify Client Callbacks

Event-driven infrastructure for delivering NHS Notify callback notifications to client webhook endpoints. This repository implements the Callbacks domain as part of the NHS Notify distributed architecture, receiving events from the Shared Event Bus and orchestrating webhook delivery via EventBridge API Destinations.

## Overview

The Client Callbacks infrastructure processes message and channel status events, applies client-specific subscription filters, and delivers callbacks to configured webhook endpoints. Events flow from the Shared Event Bus through an SQS queue, are transformed and filtered by a Lambda function, then routed to clients via per-client API Destination Target Rules.

### Key Features

- **Event-Driven Architecture**: Consumes CloudEvents from the Shared Event Bus (`uk.nhs.notify.client-callbacks.*` namespace)
- **Client Subscription Filtering**: Applies per-client rules for message status and channel status event types
- **Webhook Delivery**: EventBridge API Destinations with per-client configuration and retry policies
- **Failure Handling**: Per-client Dead Letter Queues
- **Backward Compatibility**: Maintains callback payload format compatibility with legacy Core domain implementation

## Table of Contents

- [NHS Notify Client Callbacks](#nhs-notify-client-callbacks)
  - [Overview](#overview)
    - [Key Features](#key-features)
  - [Table of Contents](#table-of-contents)
  - [Architecture](#architecture)
    - [Components](#components)
    - [Event Flow](#event-flow)
  - [Setup](#setup)
    - [Prerequisites](#prerequisites)
    - [Configuration](#configuration)
  - [Usage](#usage)
    - [Testing](#testing)
  - [Infrastructure](#infrastructure)
  - [Contributing](#contributing)
  - [Contacts](#contacts)
  - [Licence](#licence)

## Architecture

### Components

- **Shared Event Bus**: Cross-domain EventBridge bus receiving events from Core, Routing, and other NHS Notify domains
- **Callback Event Queue**: SQS queue subscribed to `uk.nhs.notify.client-callbacks.*` events via EventBridge Target Rule
- **Transform & Filter Lambda**: Processes events, loads client configurations, applies subscription filters, and routes to Callbacks Event Bus
- **Callbacks Event Bus**: Domain-specific EventBridge bus for webhook orchestration
- **API Destination Target Rules**: Per-client rules invoking HTTPS endpoints with client-specific authentication
- **Client Config Storage**: S3 bucket storing client subscription configurations (status filters, webhook endpoints)
- **Per-Client DLQs**: SQS Dead Letter Queues for failed webhook deliveries (one per client)

### Event Flow

1. Status change events published to Shared Event Bus in `uk.nhs.notify.client-callbacks.*` namespace
2. SQS Target Rule routes events to Callback Event Queue
3. EventBridge Pipe invokes Transform & Filter Lambda with event batches
4. Lambda loads client subscription configs from S3
5. Lambda applies client-specific filters (message status, channel status)
6. Matching events published to Callbacks Event Bus
7. API Destination Target Rules deliver callbacks to client webhook endpoints
8. Failed deliveries moved to per-client DLQs after retry exhaustion

## Setup

Clone the repository:

```shell
git clone https://github.com/NHSDigital/nhs-notify-client-callbacks.git
cd nhs-notify-client-callbacks
```

### Prerequisites

The following software packages, or their equivalents, are expected to be installed and configured:

- [Node.js](https://nodejs.org/) 20.x or later (for Lambda development)
- [Terraform](https://www.terraform.io/) 1.5.x or later
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- [asdf](https://asdf-vm.com/) version manager
- [GNU make](https://www.gnu.org/software/make/) 3.82 or later

> [!NOTE]<br>
> The version of GNU make available by default on macOS is earlier than 3.82. You will need to upgrade it or certain `make` tasks will fail. On macOS, you will need [Homebrew](https://brew.sh/) installed, then to install `make`, like so:
>
> ```shell
> brew install make
> ```
>
> You will then see instructions to fix your [`$PATH`](https://github.com/nhs-england-tools/dotfiles/blob/main/dot_path.tmpl) variable to make the newly installed version available.

- [GNU sed](https://www.gnu.org/software/sed/) and [GNU grep](https://www.gnu.org/software/grep/) are required for scripted command-line output processing
- [Python](https://www.python.org/) required to run Git hooks
- [`jq`](https://jqlang.github.io/jq/) a lightweight and flexible command-line JSON processor

### Configuration

Install and configure toolchain dependencies:

```shell
make config
```

## Usage

### Testing

Run unit tests for Lambda functions:

```shell
npm test
```

## Infrastructure

Infrastructure is managed with Terraform under `infrastructure/terraform/`:

- `components/`: Terraform components for different environments/accounts
- `modules/`: Reusable Terraform modules for callback infrastructure

**Deploy infrastructure**:

```shell
cd infrastructure/terraform/components/<component>
terraform init
terraform plan
terraform apply
```

Key infrastructure modules:

- **callback-event-queue**: SQS queue and EventBridge Target Rule for Shared Event Bus subscription
- **transform-filter-lambda**: Lambda function with EventBridge Pipe trigger
- **callbacks-event-bus**: Domain-specific EventBridge bus
- **api-destinations**: Per-client API Destination Target Rules
- **client-config-storage**: S3 bucket for subscription configurations

## Contributing

Contributions should follow the NHS Notify development standards:

- See [AGENTS.md](./AGENTS.md) for AI-assisted development guidelines
- Follow existing patterns for Lambda functions and Terraform modules
- Include tests for new functionality
- Update documentation for infrastructure or configuration changes

Key development practices:

- **Branching**: Feature branches from `main` with descriptive names (e.g., `feature/CCM-XXXXX-description`)
- **Testing**: Unit tests required for Lambda functions; integration tests for event flow
- **Logging**: Use structured JSON logging with correlation IDs
- **Infrastructure**: All infrastructure changes via Terraform with peer review
- **Event Schema**: Follow NHS Notify CloudEvents specification from `nhs-notify-standards` repository

## Contacts

- [Tim Marston](https://github.com/cgitim) - Lead Developer
- [Mike Wild](https://github.com/mjewildnhs) - Developer

## Licence

Unless stated otherwise, the codebase is released under the MIT License. This covers both the codebase and any sample code in the documentation.

Any HTML or Markdown documentation is [© Crown Copyright](https://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/) and available under the terms of the [Open Government Licence v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
