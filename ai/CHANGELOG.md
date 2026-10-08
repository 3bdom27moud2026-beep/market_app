# Architecture Changelog

All notable changes to the AI Agent Platform Architecture will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.0.0] - 2026-08-04

### Added
- **18-Layer Enterprise Agent Architecture**: Evolved from legacy 2-tier design into a complete 18-directory platform.
- **Model Context Protocol (MCP)**: Added `ai/mcp/` directory for standardized tool, resource, and transport integration.
- **Observability Layer**: Introduced structured logging, metric collection, OpenTelemetry tracing, and telemetry.
- **AI SDK Contracts**: Added strict component interface specs in `ai/sdk/`.
- **Execution State Engine**: Introduced task/step DAG state graph in `ai/execution/`.
- **Travel Domain Layer**: Added `ai/domain/` to isolate business rules for events, routes, experiences, bookings, users, and notifications.
- **Expanded Schemas**: Added Draft 2020-12 JSON Schemas for tool calls, errors, notifications, and domain payloads.

---

## [1.0.0] - 2026-08-01

### Initial Release
- Basic `brain/`, `skills/`, and `prompts/` documentation structure.
