---
description: Query the O2-IMS inventory and status for a given site.
argument-hint: "Optional: site identifier (defaults to all sites)"
---

# O2 Status

The **O2 Status** command queries your O2 inventory management system to retrieve the current health and capacity information for one or more sites. Provide a site name such as `edge01` to filter results; if omitted the command returns a summary for all known sites. The output includes metrics like CPU and memory utilisation, network throughput, alarms and any resource outages, helping operators monitor their distributed edge infrastructure.