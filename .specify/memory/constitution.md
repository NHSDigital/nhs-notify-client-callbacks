<!--
Sync Impact Report
- Version: none → 1.0.0
- Modified principles:
  - Added I. Patient & Data Protection (NON-NEGOTIABLE)
  - Added II. Callback Contract Fidelity
  - Added III. Test-First & CI Enforcement (NON-NEGOTIABLE)
  - Added IV. Observability & Operational Resilience
  - Added V. Simplicity & Template Alignment
- Added sections:
  - Additional Constraints & Standards
  - Development Workflow & Quality Gates
- Removed sections:
  - None
- Templates requiring updates (✅ updated / ⚠ pending):
  - ✅ .specify/templates/plan-template.md
  - ✅ .specify/templates/spec-template.md
  - ✅ .specify/templates/tasks-template.md
  - ✅ .specify/templates/agent-file-template.md
  - ✅ .specify/templates/checklist-template.md
- Deferred TODOs:
  - None
-->

# NHS Notify Client Callbacks Constitution

## Core Principles

### I. Patient & Data Protection (NON-NEGOTIABLE)

This repository operates within the NHS Notify ecosystem and MAY process
person-identifiable or sensitive operational data. Protecting that data and the
people it represents is the primary constraint on all design and
implementation choices.

- All data that can directly or indirectly identify a patient, citizen, or
  staff member MUST be handled according to NHS, ICO, and local information
  governance requirements (including least privilege, data minimisation, and
  purpose limitation).
- Secrets, credentials, and keys MUST NOT be committed to the repository.
  They MUST be provided via approved secret-management mechanisms (for example,
  GitHub or AWS secrets, parameter stores) and referenced via configuration.
- Data in transit MUST use TLS, and data at rest MUST rely on managed
  encryption provided by the underlying platform or explicitly configured
  cryptography in Terraform or application code.
- Logs, metrics, and traces MUST avoid including raw patient-identifiable
  data. Where correlation is required, stable surrogate identifiers (for
  example, hashed or pseudonymised IDs) SHOULD be used with a documented
  rationale.
- Any new data flow or integration that exposes patient or operational data to
  another system MUST be documented in architecture or sequence diagrams in
  docs/ and, where appropriate, reviewed with information governance and
  security.

### II. Callback Contract Fidelity

This repository is responsible for client callbacks and integration touch
points. The external contract is a product surface and MUST be treated as such.

- Callback payloads, event schemas, and error formats MUST be defined as
  explicit contracts (for example, TypeScript types, JSON schemas, or OpenAPI)
  and kept under version control in this repository.
- Changes to callback contracts MUST be backwards compatible by default. Any
  intentional breaking change MUST:
  - be versioned (for example, via explicit version fields, separate
    endpoints, or schema versions), and
  - include a migration and deprecation plan documented in docs/ and the
    CHANGELOG.
- Every callback contract MUST have automated tests that validate both
  successful and failure scenarios (for example, malformed payloads,
  connectivity failures, downstream timeouts).
- Retry, idempotency, and deduplication behaviour for callbacks MUST be
  documented and tested so that client systems can reason about at-least-once
  or exactly-once processing guarantees.
- Any integration with third-party or partner systems MUST clearly document
  ownership, SLAs, and operational expectations (for example, response
  timeouts, retry windows, and expected error handling).

### III. Test-First & CI Enforcement (NON-NEGOTIABLE)

Quality gates are enforced through automated tests and CI. Features are not
considered complete until they are covered by meaningful automated tests and
all repository tooling succeeds.

- New behaviour in lambdas, utilities, or shared modules MUST be accompanied by
  unit tests and, where appropriate, integration or contract tests in the
  corresponding tests/ directories.
- Tests SHOULD be written before or alongside implementation. At minimum, tests
  MUST be added in the same pull request as the behaviour they exercise.
- The root npm scripts ("lint", "typecheck", "test:unit") and any
  repo-specific Make targets (for example, make test, make githooks-run)
  MUST remain green on the main branch. Pull requests MUST NOT be merged while
  these checks are failing.
- CI pipelines MUST treat test failures and linter or typecheck failures as
  hard blockers for deployment.
- Where tests are temporarily skipped (for example, using .skip or explicit
  conditionals), the pull request MUST include a clear justification and a
  follow-up ticket reference.

### IV. Observability & Operational Resilience

Callbacks and internal processing MUST be observable enough that production
issues can be detected, diagnosed, and remediated quickly without ad-hoc
debugging.

- Lambda functions and background processes MUST emit structured logs with
  enough context to trace a single callback or request end-to-end without
  exposing sensitive data.
- Metrics and, where supported, traces SHOULD capture key operational
  indicators such as callback volume, success and failure rates, latency
  percentiles, and retry counts.
- Failure modes (for example, downstream unavailability, timeouts, malformed
  input) MUST have explicit handling paths that prevent unbounded retries or
  silent data loss (for example, DLQs, parking queues, or compensating logic).
- Infrastructure definitions (for example, Terraform under
  infrastructure/terraform/) MUST capture resilience characteristics such as
  timeouts, retry policies, and alarms rather than relying solely on
  application defaults.
- Runbooks or operational guidance SHOULD be added to docs/ for any
  non-trivial operational flows (for example, replaying failed callbacks,
  draining queues, or rotating keys).

### V. Simplicity & Template Alignment

This repository is derived from the NHS Notify repository template. Changes
MUST respect the existing conventions and avoid unnecessary complexity.

- New tooling, frameworks, or architectural patterns MUST have a clear
  rationale linked to an identified need (for example, performance, security,
  or maintainability) and SHOULD be captured in an ADR or similar decision
  record in docs/.
- Where the repository template already provides a workable approach (for
  example, Make targets, Jest configuration, TypeScript setup), new code and
  tooling SHOULD align with those patterns rather than introducing bespoke
  alternatives.
- Public APIs, event contracts, and shared modules SHOULD favour the simplest
  design that satisfies current requirements, avoiding speculative generality
  and over-abstraction.
- Dead code, unused example files, and obsolete template artefacts SHOULD be
  removed promptly once they are no longer needed to reduce cognitive load and
  security surface area.
- Documentation MUST be updated as part of any significant behavioural or
  architectural change, keeping README, docs/, and Spec Kit artefacts in sync.

## Additional Constraints & Standards

This section captures repository-wide constraints that cut across individual
features.

- Technology stack:
  - Infrastructure MUST be defined as code, primarily using Terraform under
    infrastructure/terraform/ and following existing module and component
    patterns.
  - Application logic for AWS Lambdas and shared utilities SHOULD be
    implemented in TypeScript or JavaScript using the existing workspace
    structure (for example, lambdas/, utils/).
  - Testing MUST rely on the shared tooling provided at the repository root
    (for example, Jest, ESLint, TypeScript) unless a deviation is explicitly
    justified.
- Dependencies:
  - New runtime dependencies MUST be reviewed for security, support, and
    licence compatibility. Where possible, prefer well-supported, widely
    adopted libraries.
  - Transitive dependency overrides in the root package.json MUST NOT be
    removed or changed without verifying that npm run lint, npm run typecheck,
    and npm run test:unit succeed across all workspaces.
- Security and compliance:
  - All changes MUST respect NHS, ICO, and local security standards. Static
    analysis and secret-scanning tools configured for this repository MUST not
    be disabled without an alternative control.
  - Any new external integration, data store, or cloud service MUST be added
    to relevant documentation (for example, architecture diagrams, data flow
    descriptions) and, where applicable, reviewed through the appropriate
    governance channels.
- Documentation:
  - Significant features and integrations MUST be documented in docs/
    (architecture, data flows, operational notes) and wired into the Spec Kit
    workflow via specs/, plans, and tasks where appropriate.

## Development Workflow & Quality Gates

Development work in this repository MUST follow a predictable, testable
workflow that aligns with Spec Kit and existing NHS Notify practices.

- Branching and feature work:
  - Features SHOULD be developed on topic branches named consistently (for
    example, [ticket]-[short-description]).
  - For work managed via Spec Kit, each feature SHOULD have a corresponding
    directory under specs/ containing spec.md, plan.md, and tasks.md.
- Local workflows:
  - Contributors MUST run make config when first setting up the repository to
    install toolchain dependencies and Git hooks.
  - Before raising a pull request, contributors MUST run the relevant
    Make targets and npm scripts (for example, make githooks-run, npm run
    lint, npm run typecheck, npm run test:unit) or their repository-specific
    equivalents.
- Pull requests and reviews:
  - Every pull request MUST be reviewed by at least one other engineer
    familiar with this codebase.
  - Reviewers MUST verify that changes comply with this constitution,
    including security, testing, and documentation requirements.
  - Changes that introduce or modify public contracts, infrastructure, or
    security boundaries SHOULD reference a ticket or ADR explaining the
    rationale and impact.
- Release and deployment:
  - Only code that passes all configured CI checks (lint, typecheck, unit
    tests, and any integration or end-to-end tests) MAY be promoted to higher
    environments.
  - Emergency changes MUST still be retrospectively aligned with this
    constitution, including adding missing tests and documentation in a
    follow-up change.

## Governance

This constitution governs how work is specified, implemented, and operated in
the nhs-notify-client-callbacks repository.

- Authority and precedence:
  - This constitution supersedes ad-hoc practices and informal conventions for
    this repository. Where conflicts arise, the constitution MUST be treated as
    the source of truth.
  - Spec Kit artefacts (for example, spec.md, plan.md, tasks.md) and
    repository documentation (for example, README, docs/) MUST remain
    consistent with this constitution.
- Amendments and versioning:
  - Any change to principles, constraints, or governance rules MUST be made in
    a pull request that updates this file and explains the change in the pull
    request description.
  - Version numbers MUST follow semantic versioning:
    - MAJOR: Backwards-incompatible governance or principle changes.
    - MINOR: New principles or materially expanded guidance.
    - PATCH: Clarifications, wording, or non-semantic refinements.
  - The Last Amended date MUST be updated whenever the constitution changes.
- Compliance and review:
  - Reviewers of feature work MUST explicitly consider this constitution when
    approving changes, especially around data protection, contracts, testing,
    and observability.
  - At least once every 6 months, maintainers SHOULD review this constitution
    against actual practice and update it if the repository’s reality has
    diverged.
  - Where an intentional exception is required (for example, time-limited
    deviation from a principle), the pull request MUST document the exception
    and include a follow-up item to remove or regularise it.

**Version**: 1.0.0 | **Ratified**: 2026-01-15 | **Last Amended**: 2026-01-15
