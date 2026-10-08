# Tool Execution Permissions & Security Scopes

## Security Policy
- **Read Operations** (`search_events`, `weather`, `location`): Allowed for all authenticated users.
- **Write Operations** (`create_booking`, `payment`): Requires double confirmation and biometric/session token header.
