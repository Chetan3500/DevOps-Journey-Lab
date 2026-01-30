# Log

## Scripting Action

- **Issue**: Manually check if all 1000s of servers are running or not. If not then restart or log the event.
- **Action**: Create a **Bash** script.
- **Observation**: Notice repeative task when doing manually.
- **Inference**: Script handle the issue.
- **Add**: [`watchdog.sh`](./watchdog.sh) to check on nginx service.
- **Evidence**: Run `./watchdog.sh`
