---
trigger: always_on
---

# Workflow policy

# Rules that must be followed during the course of a workflow

1. Use the **software-metrics** MCP to track your work.

### Startup

- Always run `mission_status` first to check the project context.
- **If NO ACTIVE mission exists**:
  - Prompt the user for a **new mission** name and description.
  - Use `mission_start` to initialize the new mission.
- **If an ACTIVE mission exists**:
  - If a session is **in_progress** (crash recovery): Continue work and send a `mission_heartbeat`.
  - If **no active session**: Prompt the user for a plan/description, then use `mission_start_session` to resume work on the current mission.

### During Work

- Every **15-20 minutes**, use `mission_heartbeat` to keep the session alive.
- If you step away or switch contexts, use `mission_close_session`.

### Completion

- **Task Complete**: Prompt for a summary of what was accomplished, then use `mission_close_session` with that summary as the `end_note`.
- **Mission Complete**:
    1. Ensure the final session is closed.
    2. Use `mission_finalize` to permanently mark the mission as completed.
    3. *Note*: Finalizing a mission verifies it is done; you can then start a fresh mission for the next block of work.
