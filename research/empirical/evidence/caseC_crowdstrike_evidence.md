# Case C: CrowdStrike Falcon Channel File 291 outage (July 19, 2024): primary-source evidence

Evidence collection only. No hypothesis grading. Collected 2026-11-22. All quotes are copied verbatim from text I extracted myself from the downloaded HTML or PDF (pdftotext, or an HTML-to-text pass). Where a page has changed since 2024, I used the dated web.archive.org capture and note it.

## Tagging conventions
- **RETROSPECTIVE / CONTEMPORANEOUS**: whether the fact was *available* before 04:09 UTC on 19 July 2024 (the brief's definition). None of the sources below was published before 04:09 UTC on 19 July, so every row is RETROSPECTIVE by publication. Rows that *describe the state of affairs before 04:09 UTC* (process design, earlier releases) are marked "RETROSPECTIVE (describes pre-incident state)". Rows published during the active response (19–23 July) are also marked "intra-incident" to separate them from post-incident reports (24 July onward).
- **Confidence**: High = verbatim from the issuing institution's own primary document, and consistent across documents. Medium = verbatim but contradicted elsewhere, vendor self-report with no independent check, or the phrasing is hedged. Low = indirect.
- **Vendor guidance** is labelled as such.

## Sources (source_id)
| id | Institution | Document | Publication date | URL | Archive copy |
|---|---|---|---|---|---|
| S1 | CrowdStrike | Preliminary Post Incident Review (PIR) | 2024-07-24; header "Updated 2024-07-25 1900 UTC" | https://www.crowdstrike.com/en-us/blog/falcon-content-update-preliminary-post-incident-report/ | CDX-listed: web.archive.org/web/20240724044532/https://www.crowdstrike.com/blog/falcon-content-update-preliminary-post-incident-report/ (not opened) |
| S2 | CrowdStrike | Executive Summary: Root Cause Analysis -- Channel File 291 (2 pp.) | page footers 2024-08-06 (PDF metadata creation date 2024-08-19) | https://www.crowdstrike.com/wp-content/uploads/2024/08/Executive-Summary_Root-Cause-Analysis_Channel-File-291.pdf | CDX-listed: web.archive.org/web/20240902193944/... (not opened) |
| S3 | CrowdStrike | External Technical Root Cause Analysis -- Channel File 291 (12 pp.) | 2024-08-06 (page footers) | https://www.crowdstrike.com/wp-content/uploads/2024/08/Channel-File-291-Incident-Root-Cause-Analysis-08.06.2024.pdf | CDX-listed: web.archive.org/web/20240806170341/... (not opened) |
| S4 | CrowdStrike | Technical Details: Falcon Content Update for Windows Hosts (blog) | 2024-07-20 (hub says "Published 2024-07-20 0100 UTC") | https://www.crowdstrike.com/en-us/blog/falcon-update-for-windows-hosts-technical-details/ | CDX-listed: web.archive.org/web/20240720170853/... (not opened) |
| S5 | CrowdStrike | Statement on Falcon Content Update for Windows Hosts, with Tech Alert ("Update 9:22am ET, July 19, 2024") (vendor guidance) | 2024-07-19 | https://www.crowdstrike.com/blog/statement-on-falcon-content-update-for-windows-hosts/ | VERIFIED, opened: https://web.archive.org/web/20240719145915/https://www.crowdstrike.com/blog/statement-on-falcon-content-update-for-windows-hosts/ |
| S6a | CrowdStrike | Remediation and Guidance Hub ("Updated 4:40pm ET, July 20, 2024") (vendor guidance) | 2024-07-20 | https://www.crowdstrike.com/falcon-content-update-remediation-and-guidance-hub/ | VERIFIED, opened: https://web.archive.org/web/20240720210050/https://www.crowdstrike.com/falcon-content-update-remediation-and-guidance-hub/ |
| S6b | CrowdStrike | Remediation and Guidance Hub ("Page last updated 2024-07-22 2205 UTC") | 2024-07-22 | same | VERIFIED, opened: https://web.archive.org/web/20240722221101/https://www.crowdstrike.com/falcon-content-update-remediation-and-guidance-hub/ |
| S6c | CrowdStrike | Remediation and Guidance Hub ("Page last updated 2024-07-23 1757 UTC") | 2024-07-23 | same | VERIFIED, opened: https://web.archive.org/web/20240723180833/https://www.crowdstrike.com/falcon-content-update-remediation-and-guidance-hub/ |
| S6d | CrowdStrike | Remediation and Guidance Hub, live version ("Page last updated 2024-08-06 2119 UTC"; FAQ "Updated 2024-10-28 1255 UTC") | 2024-08-06 / 2024-10-28 | live (the S5 URL now redirects here) | live copy, fetched 2026-11-22 |
| S7 | Microsoft | "Helping our customers through the CrowdStrike outage" (D. Weston blog) | 2024-07-20 | https://blogs.microsoft.com/blog/2024/07/20/helping-our-customers-through-the-crowdstrike-outage/ | CDX-listed: web.archive.org/web/20240720155434/... (not opened; I read the live page) |
| S8 | Microsoft | "New Recovery Tool to help with CrowdStrike issue impacting Windows endpoints" (Intune Customer Success, Tech Community) (vendor guidance) | 2024-07-20; updated 7/21, 7/22 (v3.1), 7/23, 7/31 | https://techcommunity.microsoft.com/blog/intunecustomersuccess/new-recovery-tool-to-help-with-crowdstrike-issue-impacting-windows-endpoints/4196959 | CDX-listed earliest: web.archive.org/web/20240721061833/ (old t5 URL; not opened). I read the live page (Version 14.0, updated Jul 31, 2024) |
| S9 | Microsoft Azure | Azure Status page, "Awareness - Virtual Machines" ("last updated at 09:26 UTC on 19 July 2024") (vendor guidance) | 2024-07-19 | https://azure.status.microsoft/en-us/status | VERIFIED, opened: https://web.archive.org/web/20240719093510/https://azure.status.microsoft/en-us/status |
| S10 | Microsoft Azure | Azure Status page, same item ("last updated at 14:20 UTC on 19 July 2024") | 2024-07-19 | same | VERIFIED, opened: https://web.archive.org/web/20240719152930/https://azure.status.microsoft/en-us/status |
| S11 | Microsoft Azure | Azure Status History (separate Central US storage incident) | 2024-07-19 | https://azure.status.microsoft/en-us/status/history/ | VERIFIED, opened: https://web.archive.org/web/20240719153050/https://azure.status.microsoft/en-us/status/history/ |
| S12 | Microsoft | "Windows Security best practices for integrating and managing security tools" (Security blog) | 2024-07-27 | https://www.microsoft.com/en-us/security/blog/2024/07/27/windows-security-best-practices-for-integrating-and-managing-security-tools/ | not archived (not checked) |

Not reachable or not used: Microsoft KB5042421 (the live URL returns 404 and there is no Wayback snapshot for that exact URL); the CrowdStrike support-portal PDFs linked from the hub (bootable recovery ISO manual, BitLocker manuals, GCP manual) need a login; the Windows Message Center capture at 10:58 UTC on 19 July had no CrowdStrike entry yet. I did not consult Congressional testimony or any third-party reporting.

---

## Q1. Release and halt

**1.1 Release time.** "On Friday, July 19, 2024 at 04:09 UTC, as part of regular operations, CrowdStrike released a content configuration update for the Windows sensor to gather telemetry on possible novel threat techniques." (S1, PIR, "What Happened?"; published 2024-07-24.) RETROSPECTIVE. High.
- Same time in S4 ("What Happened?", 2024-07-20): "On July 19, 2024 at 04:09 UTC, as part of ongoing operations, CrowdStrike released a sensor configuration update to Windows systems." RETROSPECTIVE (intra-incident). High.

**1.2 Revert time.** "The defect in the content update was reverted on Friday, July 19, 2024 at 05:27 UTC." (S1, "What Happened?") RETROSPECTIVE. High.
- S4: "The sensor configuration update that caused the system crash was remediated on Friday, July 19, 2024 05:27 UTC."
- S6d, FAQ "Has this issue been fixed?" (updated 2024-10-28): "Channel File 291 was identified and fixed 78 minutes after it was released, at 1:27 a.m. EDT on July 19." (05:27 UTC − 04:09 UTC = 78 min, so this is consistent.) RETROSPECTIVE. High.
- Earliest archived public statement (S5, capture 2024-07-19 14:59:15 UTC; text "Update 9:22am ET, July 19, 2024"): "CrowdStrike Engineering has identified a content deployment related to this issue and reverted those changes." and "Channel file "C-00000291*.sys" with timestamp of 0527 UTC or later is the reverted (good) version. Channel file "C-00000291*.sys" with timestamp of 0409 UTC is the problematic version." RETROSPECTIVE (intra-incident). High.

**1.3 What the revert did and did not do.**
- It did: "Systems coming online after this time, or that did not connect during the window, were not impacted." (S1). S5: "Windows hosts which have not been impacted do not require any action as the problematic channel file has been reverted." High.
- It did not repair hosts that had already crashed: "If hosts are still crashing and unable to stay online to receive the Channel File Changes, the following steps can be used to workaround this issue" (S5, Tech Alert "Current Action"). So recovery through the revert depended on a crashed host staying up long enough to download the reverted file. High.
- The deprecated file can stay on disk: "When deprecation occurs, a new file is deployed, but the old file can remain in the sensor's directory." (S6c, "File Classification Status Update", 2024-07-23 1757 UTC). Also: "It is normal for multiple "C-00000291*.sys files to be present in the CrowdStrike directory – as long as one of the files in the folder has a timestamp of 0527 UTC or later, that will be the active content." (S6a). High.
- S4: "CrowdStrike has corrected the logic error by updating the content in Channel File 291. No additional changes to Channel File 291 beyond the updated logic will be deployed."

**1.4 Conflicting timestamps in Microsoft/Azure sources (recorded, not resolved).**
- S9 (Azure Status, last updated 09:26 UTC 19 July): "We approximate impact started around 19:00 UTC on the 18th of July."
- S10 (Azure Status, last updated 14:20 UTC 19 July): "Updated: We approximate impact started as early as 04:09 UTC on the 18th of July, when this update started rolling out." The date "18th" conflicts with CrowdStrike's 19 July.
- S7 (Microsoft blog, 2024-07-20): "On July 18, CrowdStrike, an independent cybersecurity company, released a software update that began impacting IT systems globally." No time zone is given.
- Confidence that these Microsoft dates are correct: Low. CrowdStrike's 04:09 UTC on 19 July is consistent across S1, S3-related pages, S4, S5 and S6.
- S11 records a separate Azure Central US storage incident: "Between 21:56 UTC on 18 July 2024 and 12:15 UTC on 19 July 2024 ..." with "02:51 UTC on 19 July 2024 – 99% of all impacted compute resources recovered". This is a concurrent but unrelated incident and a possible confound for Azure-side timing.

## Q2. Affected endpoints

**2.1 What happened to hosts.** "When received by the sensor and loaded into the Content Interpreter, problematic content in Channel File 291 resulted in an out-of-bounds memory read triggering an exception. This unexpected exception could not be gracefully handled, resulting in a Windows operating system crash (BSOD)." (S1, "What Happened on July 19, 2024?"). High.
- Boot loop / restart state: S9/S10: VMs "may encounter a bug check (BSOD) and get stuck in a restarting state." S6c uses the phrase "automatic recovery of systems in a boot loop". S3 explains why the crash recurs at boot: "CrowdStrike's kernel driver is loaded from an early phase of system boot" (S3, Technical Details, "Kernel Driver Usage", p.8), and the crash happens "At the next IPC notification from the operating system" (S3, "What Happened", p.2). The RCA does not itself use the words "boot loop".
- Stop codes: the KB title cited in S8 reads "KB5042421: CrowdStrike issue impacting Windows endpoints causing an 0x50 or 0x7E error message on a blue screen". The S3 crash dump shows "PAGE_FAULT_IN_NONPAGED_AREA (50)" and "IMAGE_NAME: csagent.sys" (p.9).

**2.2 Scope.** "Systems in scope include Windows hosts running sensor version 7.11 and above that were online between Friday, July 19, 2024 04:09 UTC and Friday, July 19, 2024 05:27 UTC and received the update. Mac and Linux hosts were not impacted." (S1). S5 adds: "Hosts running Windows 7/2008 R2 are not impacted". High.

**2.3 Hosts online after the revert.** "Systems coming online after this time, or that did not connect during the window, were not impacted." (S1). S6a/S6d: "Windows hosts which are brought online after 2024-07-19 0527 UTC will not be impacted". S6d: "Windows hosts installed and provisioned after 2024-07-19 0527 UTC are not impacted" (tagged "Updated 2024-07-21 1435 UTC"). High (vendor statement).

**2.4 Counts.**
- "We currently estimate that CrowdStrike's update affected 8.5 million Windows devices, or less than one percent of all Windows machines." (S7, Microsoft, 2024-07-20). Source: Microsoft, not CrowdStrike. S7 does not describe how the estimate was made. Medium.
- S12 (Microsoft, 2024-07-27) on the crash-report data: "the number of devices which generated crash reports is a subset of the number of impacted devices previously shared by Microsoft in our blog post, because crash reports are sampled and collected only from customers who choose to upload their crashes to Microsoft." S12 also includes a figure ("Figure 1 CrowdStrike driver associated crash dump reports over time"). It is an image and I did not extract numbers from it.
- None of the CrowdStrike documents (PIR, RCA, executive summary, hub, FAQ) gives a count of affected hosts. **NOT FOUND.**

## Q3. Recovery procedures

**3.1 Original manual workaround (S5, Tech Alert in capture 2024-07-19 14:59 UTC; vendor guidance):**
> "Workaround Steps for individual hosts:
> Reboot the host to give it an opportunity to download the reverted channel file. If the host crashes again, then:
> Boot Windows into Safe Mode or the Windows Recovery Environment
> NOTE: Putting the host on a wired network (as opposed to WiFi) and using Safe Mode with Networking can help remediation.
> Navigate to the %WINDIR%\System32\drivers\CrowdStrike directory
> Locate the file matching "C-00000291*.sys", and delete it.
> Boot the host normally.
> Note: Bitlocker-encrypted hosts may require a recovery key."

RETROSPECTIVE (intra-incident; available by 13:22 UTC / 9:22am ET on 19 July at the latest, according to the page's own timestamp). High.

**3.2 Cloud / virtual workaround (S5, same capture):**
> "Option 1: Detach the operating system disk volume from the impacted virtual server / Create a snapshot or backup of the disk volume ... / Attach/mount the volume to to a new virtual server / Navigate to the %WINDIR%\System32\drivers\CrowdStrike directory / Locate the file matching "C-00000291*.sys", and delete it. / Detach the volume from the new virtual server / Reattach the fixed volume to the impacted virtual server
> Option 2: Roll back to a snapshot before 0409 UTC."
- Azure, same day (S9, 09:26 UTC): "We recommend customers that are able to, to restore from a backup from before this time. Alternatively, customers can attempt to repair the OS disk offline ... Once the disk is attached, customers can attempt to delete the following file. Windows/System/System32/Drivers/CrowdStrike/C00000291*.sys". Encrypted disks: "Disks that are encrypted may need these additional instructions: Unlocking an encrypted disk for offline repair". High.

**3.3 Documented requirements.**
- Console or physical access: implied by "Boot Windows into Safe Mode or the Windows Recovery Environment" (S5). For the USB tool it is explicit: "Insert the USB key into an impacted device. Reboot the device. ... From the BIOS boot menu, choose Boot from USB" (S8). S8 on PXE: "The affected Windows devices should be on the same subnet as the PXE Server and should be hard-wired instead of using a Wi-Fi network." High.
- BitLocker: "Bitlocker-encrypted hosts may require a recovery key." (S5, S6a, S6d). The hub links "Bitlocker recovery without recovery keys" (S6d, "Updated 2024-07-21 0023 UTC"; the content is behind a portal login and was not read). High.
- Administrator rights (S8, Microsoft, vendor guidance): WinPE option "does not require local admin privileges. However, you may need to manually enter the BitLocker recovery key"; Safe mode option: "you must have access to an account with local administrator rights on the device. ... This option may enable recovery on BitLocker-enabled devices without requiring the entry of BitLocker recovery keys ... for devices using TPM-only protectors". Media creation requires "Administrative privileges on the Windows client" and "A USB drive with min 1GB and max of 32GB." High.
- Network: wired network recommended for the reboot path: "We strongly recommend putting the host on a wired network (as opposed to WiFi) prior to rebooting as the host will acquire internet connectivity considerably faster via ethernet." (S6a, 2024-07-20). For WinPE media, "Network or other drivers are not required." (S8). High.
- Reimaging as a last resort: "If the device cannot connect to a PXE network and USB is not an option, reimaging the device might be a solution." (S8).

**3.4 Later automated or remote options, with dates.**
| Date (UTC) | Option | Quote / source |
|---|---|---|
| 2024-07-19 ~10:30 | Repeated VM restarts (Azure) | "Update as of 10:30 UTC on 19 July 2024: We have received reports of successful recovery from some customers attempting multiple Virtual Machine restart operations ... several reboots (as many as 15 have been reported) may be required, but overall feedback is that reboots are an effective troubleshooting step at this stage." (S10) |
| 2024-07-20 | Microsoft Recovery Tool (USB / WinPE) | S8 is dated Jul 20, 2024. Change log: "[7/21/2024] - Complete update ... new option for recovery using safe boot, the option to generate ISO or USB"; "[7/21/2024] - PXE recovery option added."; "[7/22/2024] - Signed Microsoft Recovery Tool updated" ("version 3.1") |
| 2024-07-20 | Microsoft/CrowdStrike Azure "scalable solution" | "CrowdStrike has helped us develop a scalable solution that will help Microsoft's Azure infrastructure accelerate a fix for CrowdStrike's faulty update." (S7). No further detail. |
| 2024-07-21 21:06 | CrowdStrike "new technique", opt-in | "As stated in our social media post at 2024-07-21 2106 UTC, together with customers, CrowdStrike tested a new technique to accelerate impacted system remediation. We're in the process of operationalizing an opt-in to this technique." (S6b, item "Updated 2024-07-22 1528 UTC") |
| 2024-07-22 | CrowdStrike automated techniques | "On July 22, 2024, CrowdStrike introduced automated techniques to accelerate remediation." (S6d FAQ). Also "CrowdStrike tested an update to the remediation that was deployed on Friday, July 19, 2024 05:27 UTC. The update has accelerated our ability to remediate hosts." (S6c, "Updated 2024-07-22 2237 UTC") |
| 2024-07-22 17:58 | CrowdStrike bootable recovery ISO / USB | "Option 1 – Build automated recovery ISOs with drivers" (S6b, "Updated 2024-07-22 1758 UTC"; S6d manual "Updated 2024-07-26 2105 UTC") with "Note: Bitlocker-encrypted hosts may require a recovery key." |
| 2024-07-22 15:10 | Self-remediation video for remote users | "Review the following video on CrowdStrike Host Self-Remediation for Remote Users." (S6b/S6d) |
| 2024-07-22 17:58 | GCP script | "GCP CrowdStrike File Remediation Script – provides a Python script customers can use to remediate impacted hosts residing in the GCP." (S6d) |
| 2024-07-23 | Cloud known-bad classification | "the impacted version of the channel file was added to Falcon's known-bad list in the CrowdStrike Cloud. No sensor updates, new channel files, or code was deployed from the CrowdStrike Cloud. For operational machines, this is a hygiene action. For impacted systems with strong network connectivity, this action could also result in the automatic recovery of systems in a boot loop. This was configured in US-1, US-2, and EU on July 23, 2024 UTC. Gov-1 and Gov-2 customers can request a channel file 291 known-bad classification by contacting CrowdStrike Support." (S6c, 2024-07-23 1757 UTC) |

The documents do not describe how the 22 July "automated techniques" work or what the opt-in involves.

**3.5 Documented reboot-loop recovery successes.**
- Vendor instruction: "Reboot the host to give it an opportunity to download the reverted channel file." (S5).
- Customer reports relayed by Azure: "reports of successful recovery from some customers attempting multiple Virtual Machine restart operations ... (as many as 15 have been reported)" (S10). These are anecdotal reports relayed by Microsoft. There are no counts and no rate. Medium.
- S6c, "could also result in the automatic recovery of systems in a boot loop" for hosts "with strong network connectivity". This is hedged ("could") and gives no count. Medium.
- **NOT FOUND:** any quantified share of hosts that recovered by rebooting alone.

## Q4. Independent recovery (not dependent on the affected OS booting)

**Vendor-level control (stopping distribution):** the 05:27 UTC revert (S1) and the 23 July cloud known-bad classification (S6c). Both act only through the sensor on a running host. The revert protects hosts that had not yet received the file. Crashed hosts benefit only if they "stay online to receive the Channel File Changes" (S5) or have "strong network connectivity" (S6c).

**Customer-level mechanisms documented:**
1. Windows Recovery Environment / Safe Mode (S5). Safe Mode boots the affected Windows installation in a reduced configuration. WinRE is named but not described. **None of the sources says whether WinRE was present or enabled by default on affected machines.** Every source requires local console access and may require the BitLocker key.
2. External WinPE boot media (S8, Microsoft, from 20 July). This does not depend on the affected OS booting: "Recover from WinPE – this option produces boot media that will help facilitate the device repair"; "does not require local admin privileges". It requires a separate Windows machine, admin rights there, a USB drive or PXE on the same subnet, BIOS boot-menu access, and possibly the BitLocker key. It was not available by default: it had to be built after the incident.
3. CrowdStrike bootable recovery ISO/USB (S6b, from 22 July). The same kind of external media. The details are in a manual behind the portal login (not read).
4. Offline disk repair or snapshot rollback for cloud and virtual machines (S5, S9). This is independent of the affected OS: the disk is attached to another VM, or restored from a pre-04:09 snapshot. It depends on hypervisor or cloud console access and on backups or snapshots existing beforehand. S9: "We recommend customers that are able to, to restore from a backup".
5. Windows 365 Cloud PC: "customers may attempt to restore their Cloud PC to a known good state prior to the release of the update (July 19, 2024)" (S8).

Microsoft context (S12, 2024-07-27): "Since kernel drivers run at the most trusted level of Windows, where containment and recovery capabilities are by nature constrained, security vendors must carefully balance needs like visibility and tamper resistance with the risk of operating within kernel mode." RETROSPECTIVE. High (as a Microsoft statement).

**NOT FOUND:** any statement that an automatic, pre-provisioned recovery path (independent of the faulty driver loading) was in place by default and recovered hosts without human action. None of the documents describes the Falcon sensor or Windows automatically skipping the faulty channel file after repeated crashes.

## Q5. Process causes and changes

**5.1 Stated root causes (S3, RCA, 2024-08-06).**
- Summary (p.2): "it was the confluence of these issues that resulted in a system crash: the mismatch between the 21 inputs validated by the Content Validator versus the 20 provided to the Content Interpreter, the latent out-of-bounds read issue in the Content Interpreter, and the lack of a specific test for non-wildcard matching criteria in the 21st field."
- Finding 1 (p.3): "The number of fields in the IPC Template Type was not validated at sensor compile time".
- Finding 2 (p.3): "A runtime array bounds check was missing for Content Interpreter input fields on Channel File 291".
- Finding 3 (p.4): "Template Type testing should cover a wider variety of matching criteria". Detail: "a static set of 12 test cases was selected ... included a regex wildcard matching criterion in the 21st field for all Template Instances, meaning that execution of these tests during development and release builds did not expose the latent out-of-bounds read".
- Finding 4 (p.5): "The Content Validator contained a logic error" ("it based its assessment on the expectation that the IPC Template Type would be provided with 21 inputs").
- Finding 5 (p.5): "Template Instance validation should expand to include testing within the Content Interpreter".
- Finding 6 (p.6): "Template Instances should have staged deployment". Findings text: "Each Template Instance should be deployed in a staged rollout."
- Why it was missed (p.2): "This parameter count mismatch evaded multiple layers of build validation and testing ... In part, this was due to the use of wildcard matching criteria for the 21st input during testing and in the initial IPC Template Instances."
- PIR (S1) framing: "Due to a bug in the Content Validator, one of the two Template Instances passed validation despite containing problematic content data." and "Based on the testing performed before the initial deployment of the Template Type (on March 05, 2024), trust in the checks performed in the Content Validator, and previous successful IPC Template Instance deployments, these instances were deployed into production."
- **Internal inconsistency (recorded):** S2 (executive summary) says "The sensor expected 20 input fields, while the update provided 21 input fields." S3 (full RCA) says "The new IPC Template Type defined 21 input parameter fields, but the integration code that invoked the Content Interpreter with Channel File 291's Template Instances supplied only 20 input values". Both describe a 20-versus-21 mismatch, but they word the direction differently.

**5.2 Stated mitigations (verbatim, with stated status).**
- Compile-time validation: "A patch for the Sensor Content Compiler that validates the number of inputs provided by a Template Type was developed on July 19, 2024, and went into production on July 27, 2024" (S3 p.3).
- Bounds check: "Bounds checking was added to the Content Interpreter function that retrieves input strings on July 25, 2024. ... This release will be generally available by August 9, 2024." (S3 pp.3–4).
- Content Validator: "This fix will be released to production by August 19, 2024." and "The Content Validator was modified to only allow wildcard matching criteria in the 21st field" (S3 p.5).
- Staged deployment: "New Template Instances that have passed canary testing are to be successively promoted to wider deployment rings or rolled back if problems are detected." (S3 p.6). PIR (S1): "Implement a staggered deployment strategy for Rapid Response Content in which updates are gradually deployed to larger portions of the sensor base, starting with a canary deployment." Executive summary (S2): "This work has been completed with an updated deployment ring process".
- Customer control: "The Falcon platform has been updated to provide customers with increased control over the delivery of Rapid Response Content. Customers can choose where and when Rapid Response Content updates are deployed." (S3 p.6). PIR (S1): "Provide customers with greater control over the delivery of Rapid Response Content updates by allowing granular selection of when and where these updates are deployed."
- Testing (S1): "Local developer testing / Content update and rollback testing / Stress testing, fuzzing and fault injection / Stability testing / Content interface testing"; "Enhance existing error handling in the Content Interpreter."
- Third-party review (S3): "CrowdStrike has engaged two independent third-party software security vendors".
- **Pre-incident contrast (RETROSPECTIVE, describes pre-incident state):** Sensor Content had staged rollout and N/N-1/N-2 customer policies: "This culminates in a staged sensor rollout process that starts with dogfooding internally at CrowdStrike, followed by early adopters. ... Customers then have the option of selecting which parts of their fleet should install the latest sensor release ('N'), or one version older ('N-1') or two versions older ('N-2') through Sensor Update Policies." (S1). The PIR states that "Customers have complete control over the deployment of the sensor — which includes Sensor Content and Template Types." The PIR does not explicitly state that customers lacked control over Rapid Response Content before the incident. That is implied only by the mitigation wording ("greater control"). Channel-file update frequency: "Updates to Channel Files are a normal part of the sensor's operation and occur several times a day" (S4).

## Q6. Recovery latency (quoted only)
| Statement date | Figure | Quote / source |
|---|---|---|
| Hub item "Updated 2024-07-25 1954 UTC" | >97% | "Using a week-over-week comparison, greater than 97% of Windows sensors are online as of July 24 at 5pm PT, compared to before the content update." (S6d) |
| Hub "Updated 2024-07-31 1638 UTC (Final Post-Incident Measurement Report)" | ~99% | "Using a week-over-week comparison, ~99% of Windows sensors are online as of July 29 at 5pm PT, compared to before the content update. We typically see a variance of ~1% week-over-week in sensor connections." (S6d); the same figure appears in S3 p.1 ("As of July 29 at 5 p.m. PT") |
| 2024-08-06 | ~99% | S2: "As of July 29, 2024, at 8:00 p.m. EDT, ~99% of Windows sensors were online, compared to before the content update." (5 p.m. PT = 8 p.m. EDT, so this is the same instant) |
| Qualitative | "within hours" | "mobilized immediately to restore systems and bring many back online within hours" (S2); "These efforts enabled the systems to come back online within hours following the initial incident." (S6d FAQ) |
| Qualitative | | "Each customer environment is unique, with varying degrees of complexity and architectural constraints that can significantly impact remediation timelines. We can confirm that almost all systems have restored operations and are back online." (S6d FAQ, updated 2024-10-28) |

Limitations: the percentages measure sensor connections compared week over week. They are not counts of restored hosts, and the denominator is not stated. **NOT FOUND:** any count or percentage for 19–23 July, any distribution of time-to-recovery per host, the number of hosts that rebooted successfully versus needed manual repair, or any device-level timing.

## Q7. Contemporaneous versus retrospective
- **Available before 04:09 UTC on 19 July 2024:** none of the sources consulted was published before that time. The facts about pre-incident design (Sensor Content staged rollout and N/N-1/N-2 policies; Rapid Response Content delivered as channel files "several times a day"; sensor 7.11 GA on 28 Feb 2024; IPC Template Type stress test on 5 Mar 2024; instances released 5 Mar and 8–24 Apr 2024; the latent 20/21 mismatch) describe the state before 04:09 UTC, but were documented only afterwards (S1 24 July, S3 6 Aug, S4 20 July). I found no pre-incident public document in this collection showing that customers or CrowdStrike knew of the mismatch or of the deployment gap.
- **Published during the incident (19–23 July), RETROSPECTIVE:** the 04:09/05:27 file timestamps and revert (S5, around 13:22–14:59 UTC on 19 July); the manual Safe Mode/WinRE workaround and BitLocker caveat (S5); the Azure restart reports and "as many as 15" reboots (S10, 10:30 UTC on 19 July); Microsoft's 8.5M estimate (S7, 20 July); the Microsoft USB tool (S8, 20–22 July); CrowdStrike automated techniques (21–22 July) and cloud known-bad (23 July) (S6b, S6c).
- **Post-incident reports:** PIR (24/25 July), sensor-online percentages (25 and 31 July), RCA and executive summary (6 Aug), FAQ (updated 28 Oct 2024).
