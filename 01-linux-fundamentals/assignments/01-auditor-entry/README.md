# Auditor Entry

This is a great shift in strategy. By doing **5+ scenarios per assignment**, we ensure that a concept isn't just a
"one-off" memory, but a deeply ingrained skill. We will treat each assignment like a **"Work Week"** where your manager
gives you progressively harder tickets.

Here is the **Official Kickoff** for **Assignment #1: The Identity & Access Week**.

---

## 📂 Folder Structure Reminder

```txt
01-auditor-entry/
├── img             # Result images
├── logs.md         # TODO, Issue, Fix, Notes
└── README.md       # here
```

---

## 💼 Assignment #1: Identity & Access Management (IAM)

**The Context:** You are the only SRE at a growing startup. Your Technical Manager is very strict about security ("Least
Privilege").

### **Scenario 1: The New Auditor (The Setup)**

- **The Manager says:** "We have a security audit starting. Create a user `auditor-bob`. He needs to read Nginx logs,
  but I don't want him having `sudo` or being able to see other users' home directories. Prove to me he can read the
  logs but can't touch `/root`."
- **Key Skills:** `useradd`, `groups`, `permissions`.

### **Scenario 2: The "Over-Privileged" Developer (The Cleanup)**

- **The Manager says:** "I found out a developer named `dev-alice` was added to the `sudo` group by mistake! This is a
  huge security risk. Remove her from the `sudo` group immediately, but make sure she stays in the `developers` group so
  she can still work."
- **Key Skills:** `usermod`, `gpasswd`, `/etc/group` auditing.

### **Scenario 3: The "Ghost" Service Account (The System Audit)**

- **The Manager says:** "I see a user in `/etc/passwd` called `www-data`. I'm worried it's a real person. Check the
  'Shell' column in `/etc/passwd`. If it's a system account, it shouldn't have a login shell. If it does, change it to
  `/usr/sbin/nologin` to lock it down."
- **Key Skills:** `/etc/passwd` columns, `usermod -s`.

### **Scenario 4: The Locked Door (The Permissions Trap)**

- **The Manager says:** "Nginx is throwing 'Permission Denied' errors even though the file is there. I think someone
  changed the **Group Ownership** of `/var/log/nginx/`. Fix the ownership so the group `adm` owns it, and ensure the
  group has 'Read' (r) permissions."
- **Key Skills:** `chown`, `chmod`.

### **Scenario 5: The Emergency Lockout (The Firing)**

- **The Manager says:** "We just let `auditor-bob` go. I need his account disabled **immediately** so he can't log in
  via SSH, but I don't want to delete his files yet because we need them for evidence. Lock his password and change his
  shell."
- **Key Skills:** `passwd -l`, `usermod -s /usr/sbin/nologin`.

---
