---
trigger: always_on
---

# Workflow Policy

> [!IMPORTANT]
> These rules are **MANDATORY**. The agent MUST follow them without exception.

Use the **software-metrics** MCP to track all work.

---

## Startup

1. **ALWAYS** run `mission_status` first to check the project context.

2. **If NO ACTIVE mission exists**:
   - Agent MUST ask user: *"What mission should I start? Please provide a name and description."*
   - Wait for user response, then use `mission_start` to initialize.

3. **If an ACTIVE mission exists**:
   - If a session is `in_progress` (crash recovery): Send `mission_heartbeat` immediately and continue work.
   - If no active session: Agent MUST ask user: *"I'm resuming work on [mission name]. What will we be working on this session?"*
   - Wait for user response, then use `mission_start_session` with their description.

---

## During Work

> [!WARNING]
> Sessions without a heartbeat for **30 minutes** are automatically closed with status `hiatus`.

- Agent MUST send `mission_heartbeat` every **15-20 minutes** during active work.
- If switching contexts or pausing, use `mission_close_session` immediately.

---

## Completion

### Task Complete
- Agent MUST ask user: *"What was accomplished in this session?"*
- Wait for user response, then use `mission_close_session` with their summary as `end_note`.

### Mission Complete
1. Ensure the final session is closed (following the Task Complete flow above).
2. Use `mission_finalize` to permanently mark the mission as completed.
3. A new mission can then be started for the next block of work.
