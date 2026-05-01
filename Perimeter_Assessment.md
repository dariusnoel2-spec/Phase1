# TITANCORP: PERIMETER ASSESSMENT REPORT
**Operator:** **Target Subnet:** 172.88.0.0/24

## PHASE 1: ACTIVE ENUMERATION (NMAP)
*(List the live IPs discovered and their running services/versions)*
* **Host 1 ([172.88.0.10]):** [nginx 1.14.2 HTTP port 80 open]
* **Host 2 ([172.88.0.15]):** [No open ports cache database-Redis]
* **Host 3 ([172.88.0.20]):** [Apache http 2.4.66 HTTP port 80 open]

## PHASE 2: VULNERABILITY AUDIT (NIKTO)
*(Run Nikto against the TWO web servers discovered above. List one major finding for each.)*
* **Web Server 1 Finding:** [172.88.0.10 (nginx 1.14.2) — Missing
  X-Frame-Options header leaving the site vulnerable to clickjacking
  attacks where attackers embed the site in a fake page to steal clicks.]
* **Web Server 2 Finding:** [172.88.0.20 (Apache 2.4.66) — HTTP TRACE
  method is active making the server vulnerable to Cross Site Tracing
  (XST) attacks where attackers can steal session cookies and hijack
  authenticated user sessions.]

## PHASE 3: RISK TRIAGE
*(Review your findings. Identify the SINGLE highest-risk vulnerability across the entire DMZ. Justify why it is the top priority using the Likelihood x Impact formula.)*

* **Top Priority Remediation:** [HTTP TRACE method enabled on 172.88.0.20 (Apache 2.4.66) — XST Vulnerability]
* **Justification:** [This is the highest risk finding because the
  likelihood is high — TRACE is enabled by default and trivial to
  exploit. The impact is critical — attackers can steal authenticated
  session cookies bypassing login entirely and taking over user
  accounts. Compared to the missing header on Host 1, this
  vulnerability is actively exploitable with a known attack method
  making it the top priority for immediate remediation.]
