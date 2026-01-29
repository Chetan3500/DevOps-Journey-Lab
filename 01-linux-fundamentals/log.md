# Lab Logs

## Nginx Permission

- **Status:** Completed
- **Command Run:** `sudo chmod 000 /var/log/nginx`
- **Unexpected Behavior:** Site still loads. Why?
- **Hypothesis:** Master process (root) has the file open already.
- **Evidence:** `ls -la` shows 000, but `lsof -p <pid>` shows the file is open.

### Reasons

- **Process Inheritance**: The Nginx Master Process starts as root. It opens the log files before you changed the permissions. Once a file is opened, the kernel gives the process a File Descriptor (FD).
- **The "Key" is already in the lock**: Changing the directory permissions later (chmod 000) prevents new attempts to open the file, but it doesn't revoke the "key" (the FD) the process already holds in memory.
- **Kernel Logic**: The Linux kernel checks permissions at the time of opening, not at every single write operation.
