# VR Network Slice Package

此 package 包含用於部署 VR 網路切片的 Nephio KRM 清單。

## 服務意圖

- **服務**：VR network（單 UE 測試）
- **下行帶寬**：5 Mbps（保證）/ 10 Mbps（最大）
- **上行帶寬**：1 Mbps（保證）/ 2 Mbps（最大）
- **延遲**：9 ms 封包延遲預算
- **用途**：低延遲互動式 VR 串流測試

## 生成的檔案

```
vr-network-package/
├── Kptfile                  # Package 元數據與 pipeline 配置
├── QoSIntent.yaml          # QoS 參數與 5QI 映射
├── NetworkSlice.yaml       # 網路切片定義與 SLO
└── README.md               # 本文件
```

## 關鍵配置

### S-NSSAI 映射
- **SST**: 1 (eMBB - enhanced Mobile Broadband)
- **SD**: 000001 (VR 服務區分碼)

### QoS 配置
- **5QI**: 7（視頻串流，GBR）
- **優先級**: 20（中高）
- **流量類型**: GBR（Guaranteed Bit Rate）
- **封包錯誤率**: 1.0e-3

### 資源需求
- AMF, SMF, UPF（高吞吐量配置）, PCF
- CPU: 2 核心
- Memory: 4Gi
- Storage: 10Gi

## 部署方式

使用 kpt 或 kubectl 直接部署：

```bash
# 使用 kpt
kpt fn render vr-network-package/
kpt live init vr-network-package/
kpt live apply vr-network-package/

# 使用 kubectl
kubectl apply -f vr-network-package/
```

## 下一步

1. 檢查並調整 `NetworkSlice.yaml` 中的覆蓋區域定義
2. 配置實際的網路功能部署目標
3. 整合到您的 GitOps 工作流程
4. 透過 Nephio 控制器監控切片部署狀態
