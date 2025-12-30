---
trigger: always_on
---

# Workflow policy

# Rules that must be followed during the course of a workflow

1. Use the software-metrics mcp

- Be sure to check for active sessions, if any, use the resume work session tool, if none, prompt the user for the description and then use the session start tool
- Every 20 minutes use the hearbeat tool to keep the session alive
- Upon completing a task, prompt the user for a session close description, and use the tool to close the current session
- Upon starting a new task, use the tool to start a new session, send the task description with the payload
- Upon mission comletion, prompt the user for a conclusion message and use the tool to finish the current mission
