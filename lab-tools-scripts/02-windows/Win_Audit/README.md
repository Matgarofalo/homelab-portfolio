# Project: Windows System Health Audit Tool (PowerShell)

**Date:** October 2025
**Development Method:** AI-Assisted Scripting / Logic Validation

## 1. Executive Summary
Designed and implemented an automated PowerShell telemetry tool (`Get-SystemHealthReport.ps1`) to perform rapid security and health auditing of Windows endpoints.

**The Objective:** To move from multiple manual checks to an automated, code-based assessment standard.
**The Methodology:** I defined the admin requirements and logic flow, then utilized AI tools to assist with the logic and accelerate syntax generation. 

## 2. Architectural Logic (The "Why")
The script was designed to answer five critical questions that I deemed essential for a baseline health check:
1.  **Identity:** What hardware/OS am I running? (`Get-ComputerInfo`)
2.  **Defense:** Are the shields up? (Service Audit: Defender, Firewall, Updates)
3.  **System Currency:** Is the system patched? (HotFix check > 30 days)
4.  **Connectivity:** Network Status (`Get-NetAdapter`)
5.  **Performance:** Is anything hogging resources? (Top 10 CPU Processes)

## 3. Implementation Log

###  Logic Definition & Script Generation
* **Requirement:** I needed a script that could run without external dependencies and output a clean text file for logging.
* **Prompt Engineering:** Directed AI to construct a modular script using cmdlets (`Get-NetIPConfiguration`).
* **Code Audit:** Reviewed the generated loops (`foreach`) and conditional logic (`if/else`) to ensure the script handled "Stopped" services correctly without throwing fatal errors.

###  Troubleshooting & Logic 
During the initial testing, I encountered environmental blockers that required manual code adjustment:

* **Logic Failure (ICMP Blocking):**
    * *Issue:* The initial script used `Test-NetConnection` to verify internet access. The firewall blocked this, causing false negatives.
    * *Resolution:* I modified the logic to check Layer 2 status via **`Get-NetAdapter`** instead. If the physical link is "Up," the test passes. This eliminated false alarms caused by firewall rules.
* **Service Instability:**
    * *Issue:* Critical services like `wuauserv` (Windows Update) were flagged as "Stopped."
    * *Resolution:* Integrated `Set-Service` commands to enforce "Automatic" startup types, turning the script from a passive "Audit Tool" into an active "Remediation Tool."

## 4. Usage & Execution

**Prerequisites:**
The script requires administrative privileges to query system services.
```powershell
# 1. Set Execution Policy (Temporary)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

# 2. Run the Tool
.\Get-SystemHealthReport.ps1
