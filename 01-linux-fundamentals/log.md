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

---

## The Web Path

To `DROP` or `STOP` the packet/service & check behavior on host machine,

- **Status:** Completed
- **Command Run:** `sudo systemctl stop <SERVICE>`, `sudo iptables -A INPUT -p tcp --dport <PORT> -j DROP`
- **Unexpected Behavior:** `Couldn't connect`, `Connection time out`
- **Hypothesis:** Server port might **STOP** or **DROP**
- **Evidence:** `curl -v --max-time 8 <SERVER-IP>` result with Unexpected Behavior.
- **Add:** [`reset-lab.sh`](../scripts/reset-lab.sh) to restore lab.

---

To check drop packet in server,

- **Status:** Completed
- **Command Run:** `sudo tcpdump -i any port 80 -n`
- **Unexpected Behavior:** showing the TCP SYN packets reaching the interface, but no SYN-ACK was generated
- **Hypothesis:** Server firewall **DROP** the packets
- **Evidence:** Run `curl --max-time 8 <SERVER-IP>` & Check use `tcpdump` to know packets are droping or not

![Visual](../img/tcpdump_port_80.png)

The client retries the SYN packet multiple times before timing out. Later drop stop and the SYN-ACK starting generated means now client get's packets.

---

To see inside the brain of a single process.

- **The Goal:** Find the syscall that is waiting. You will likely see `epoll_wait` just sitting there, doing nothing, because the packets are being dropped before they hit the process.
- **Status:** Completed
- **Command Run:** `sudo strace -p <SERVICE-WORKER-PID>`, `ps aux | grep <SERVICE>`
- **Unexpected Behavior:** You'll see `accept4(...)` (taking the incoming connection) and `epoll_wait` (waiting for data).
- **Hypothesis:** Server firewall **DROP** the packets
- **Evidence:** Run `curl --max-time 8 <SERVER-IP>` & Check use `sudo strace -o trace.log -p <SERVICE-WORKER-PID>`.

## The Memory Depth Spiral

- **Issue**: Web server became unresponsive.
- **Detection**: Checked `dmesg` and found OOM Killer activity.
- **Root Cause**: System memory exhausted by `stress-ng` simulation.
- **Resolution**: Implemented a "Reset Script" and analyzed `oom_score_adj` to protect critical services.

---
