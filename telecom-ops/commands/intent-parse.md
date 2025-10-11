---
description: Parse network slice intent into QoS parameters and generate a KRM package skeleton.
argument-hint: "Required: intent description; Optional: bandwidth and latency constraints"
---

# Intent Parse

The **Intent Parse** command translates a high-level service intent into a Nephio-compliant configuration package. When a user provides a natural-language description of a desired network slice (for example, "deploy a URLLC slice with 5 Mbps bandwidth and <10 ms latency"), this command extracts key parameters such as bandwidth, latency and reliability. It then maps those values to standard S-NSSAI and NSST identifiers and produces a set of starter YAML manifests (like `QoSIntent` and `NetworkSlice` objects) that can be committed into your GitOps workflow.

Use this command when you want to rapidly bootstrap a slice deployment from an intent without manually writing Kubernetes resource manifests.