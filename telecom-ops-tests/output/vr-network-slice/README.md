# VR Network Slice Package

This package contains the Nephio KRM manifests for deploying a VR network slice with the following characteristics:

## Service Intent
- **Service**: VR network (single UE demonstration)
- **Bandwidth (Downlink)**: 5 Mbps guaranteed, 10 Mbps maximum
- **Bandwidth (Uplink)**: 1 Mbps guaranteed, 2 Mbps maximum
- **Latency**: 9 ms packet delay budget
- **Use Case**: Interactive VR streaming with low latency requirements

## Generated Files

```
vr-network-slice/
├── Kptfile                  # Package metadata and pipeline configuration
├── QoSIntent.yaml          # QoS parameters and 5QI mapping
├── NetworkSlice.yaml       # Network slice definition and SLOs
└── README.md               # This file
```

## Key Configuration Details

### S-NSSAI Mapping
- **SST**: 1 (eMBB - enhanced Mobile Broadband)
- **SD**: 000001 (VR service differentiator)

### QoS Profile
- **5QI**: 7 (Video streaming, GBR)
- **Priority Level**: 20 (medium-high)
- **Traffic Type**: GBR (Guaranteed Bit Rate)
- **Packet Error Rate**: 1.0e-3

### Resource Requirements
- AMF, SMF, UPF (high-throughput profile), PCF
- CPU: 2 cores
- Memory: 4Gi
- Storage: 10Gi

## Usage

Deploy this package using kpt or apply directly with kubectl:

```bash
# Using kpt
kpt fn render vr-network-slice/
kpt live init vr-network-slice/
kpt live apply vr-network-slice/

# Using kubectl
kubectl apply -f vr-network-slice/
```

## Next Steps

1. Review and adjust coverage area definitions in `NetworkSlice.yaml`
2. Configure actual network function deployment targets
3. Integrate with your GitOps workflow (e.g., push to a Config Sync repository)
4. Monitor slice deployment status via Nephio controllers
