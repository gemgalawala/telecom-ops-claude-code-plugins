# Telecom Ops Claude Code Plugin

一個針對電信營運（O-RAN/Nephio）的 Claude Code 插件，提供網路切片意圖解析、O2-IMS 狀態查詢等功能。本插件展示了 Claude Code 插件系統的完整能力，包括 Slash Commands、Agents、Hooks 與 MCP Server 整合。

## 功能特性

### 🎯 Slash Commands（斜槓指令）

#### `/telecom-ops:intent-parse`
將自然語言的服務意圖轉換為 Nephio 相容的 KRM（Kubernetes Resource Model）配置包。

**使用範例：**
```
/telecom-ops:intent-parse intent description: VR network, bandwidth: 5 Mbps downlink, latency: 9 ms, single UE test
```

**功能：**
- 解析帶寬、延遲、可靠性等參數
- 映射到 3GPP S-NSSAI 和 NSST 標準
- 生成 `QoSIntent.yaml` 和 `NetworkSlice.yaml`
- 建立完整的 Kpt package 結構

**輸出：**
```
output/
└── vr-network-package/
    ├── Kptfile
    ├── QoSIntent.yaml
    ├── NetworkSlice.yaml
    └── README.md
```

#### `/telecom-ops:o2-status`
查詢 O2-IMS（O-RAN O2 Interface for Infrastructure Management Service）清單與站點狀態。

**使用範例：**
```
/telecom-ops:o2-status edge01
/telecom-ops:o2-status          # 查詢所有站點
```

**功能：**
- 站點健康狀態監控
- CPU、記憶體、儲存容量查詢
- 網路介面使用率統計
- 告警與部署工作負載狀態

### 🤖 Agent（智能代理）

**`intent-translator`** - 網路切片意圖翻譯器

專門用於將高層級的電信服務意圖轉換為具體的 Kubernetes 資源清單。

**能力：**
- 意圖分析：從自由文本中提取關鍵參數
- 規格映射：將參數映射到 S-NSSAI 值和網路切片模板
- 清單生成指引：規劃 KRM package 結構
- GitOps 整合建議：如何整合到 Porch/ConfigSync 自動化流程

**配置：**
- 模型：Haiku（快速響應）
- 工具：NotebookRead, TodoWrite
- 顏色：藍色

### 🪝 Hooks（鉤子事件）

插件配置了 PostToolUse hook，在每次工具調用後自動觸發。

**當前配置：**
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/kpt-render.sh"
          }
        ]
      }
    ]
  }
}
```

**效果：**
每次工具執行後，終端會顯示：
```
[telecom-ops] PostToolUse hook triggered. This is where you could run kpt rendering or validation.
```

**擴充性：**
可新增 PreToolUse、Notification 等 hooks，實現：
- 檔案寫入前的驗證
- YAML 語法檢查
- 自動執行 kpt render
- 錯誤通知與告警

### 🔌 MCP Server 整合

**⚠️ （進階）MCP Server：若你替換 `.mcp.json` 為實際 O2-IMS / Nephio / kubectl server，插件啟用時會自動啟動對應 server，成為 Claude 的工具。**

**此功能尚未完全開發完成。** 目前提供的是 stub 配置範例。

**當前配置（示例）：**
```json
{
  "mcpServers": {
    "telecom-cli": {
      "command": "${CLAUDE_PLUGIN_ROOT}/scripts/telecom-mcp-server.sh",
      "args": [],
      "env": {
        "EXAMPLE_ENV": "value"
      }
    }
  }
}
```

**未來規劃：**
連接實際的 O2-IMS MCP Server 後，將提供以下工具：
- `mcp__o2ims_list_sites` - 列出所有站點
- `mcp__o2ims_get_site_status` - 獲取站點詳細狀態
- `mcp__o2ims_list_resource_pools` - 查詢資源池
- `mcp__o2ims_get_deployments` - 列出部署的工作負載
- `mcp__o2ims_query_alarms` - 查詢告警事件
- `mcp__o2ims_get_inventory` - 查詢硬體清單

**配置方式：**
參考 `telecom-ops/.mcp.json`，替換為實際的 MCP server 端點與認證資訊。

## 專案結構

```
telecom-ops-claude-code-plugins/
├── .claude-plugin/
│   ├── plugin.json              # 插件元數據
│   └── marketplace.json         # Marketplace 配置
│
├── telecom-ops/                 # 插件主體
│   ├── agents/
│   │   └── intent-translator.md    # 意圖翻譯 Agent
│   ├── commands/
│   │   ├── intent-parse.md         # Intent Parse 指令
│   │   └── o2-status.md            # O2 Status 指令
│   ├── hooks/
│   │   └── hooks.json              # Hook 配置
│   ├── scripts/
│   │   ├── kpt-render.sh           # PostToolUse hook 腳本
│   │   └── telecom-mcp-server.sh   # MCP server stub
│   └── .mcp.json                   # MCP server 配置
│
└── telecom-ops-tests/           # 測試套件
    ├── prompts/
    │   ├── S1_intent_to_krm.md     # 測試案例 1：意圖解析
    │   ├── S2_o2_status.md         # 測試案例 2：O2 狀態查詢
    │   └── S3_hook_check.md        # 測試案例 3：Hook 驗證
    ├── output/                     # 生成的 KRM packages
    ├── scripts/
    │   └── run_headless.sh         # Headless 自動化測試
    └── README.md
```

## 安裝與使用

### 方法 1：從 GitHub 安裝（推薦）

```bash
# 在 Claude Code 中執行
/plugin marketplace add thc1006/telecom-ops-claude-code-plugins
/plugin install telecom-ops@telecom-ops-marketplace
```

### 方法 2：本地安裝（開發用）

```bash
# 克隆專案
git clone https://github.com/thc1006/telecom-ops-claude-code-plugins.git
cd telecom-ops-claude-code-plugins

# 在 Claude Code 中執行
/plugin marketplace add ./telecom-ops-tests/dev-marketplace
/plugin install telecom-ops@dev-marketplace
```

### 啟用插件

```bash
/plugin enable telecom-ops
```

### 驗證安裝

重啟 Claude Code 後，執行：
```bash
/plugin list
```

應該會看到 `telecom-ops` 插件已啟用。

## 測試案例

### 測試 1：Intent Parse（意圖解析）

```
請使用 telecom-ops 插件提供的 /intent parse 指令，
把這段意圖轉為 KRM 草案並列出預計輸出：
VR network，5 Mbps 下行，9 ms 延遲，單 UE 測試。
```

**預期結果：**
- 生成 `QoSIntent.yaml`（包含 5QI=7, 9ms latency, 5Mbps bandwidth）
- 生成 `NetworkSlice.yaml`（eMBB 類型，單 UE 配置）
- 生成 `Kptfile` 和 `README.md`
- 輸出路徑提示

### 測試 2：O2 Status（狀態查詢）

```
請示範 /o2 status --site edge01，
若目前尚未串到實際 O2-IMS，先用 stub 文本回覆 site/health/capacity 欄位。
```

**預期結果：**
- 顯示站點 `edge01` 的健康狀態（OK/DEGRADED）
- 顯示 CPU、記憶體、網路容量與使用率
- 說明如何配置真實的 O2-IMS MCP server

### 測試 3：Hook Verification（Hook 驗證）

```
請執行一個會觸發工具調用的動作，並在回覆中說明：
(1) 我應該在終端看到哪些訊息可判定 PostToolUse hook 已觸發？
(2) 若要再加上 PreToolUse 或 Notification 的 hook，hooks.json 應怎麼擴充？
```

**預期結果：**
- 終端顯示 `[telecom-ops] PostToolUse hook triggered...`
- 提供 PreToolUse 和 Notification hooks 的配置範例
- 說明 `${CLAUDE_PLUGIN_ROOT}` 變數的使用方式

### 自動化測試

使用 headless 模式執行所有測試：
```bash
bash telecom-ops-tests/scripts/run_headless.sh
```

測試結果會儲存在 `telecom-ops-tests/runs/` 目錄。

## 技術細節

### S-NSSAI 映射規則

插件會根據服務類型自動映射到對應的 S-NSSAI：

| 服務類型 | SST | SD | 用途 |
|---------|-----|-----|------|
| VR/視頻串流 | 1 (eMBB) | 000001 | 增強型移動寬帶 |
| IoT 感測器 | 2 (mMTC) | 000002 | 大規模機器通信 |
| 遠程手術/自駕車 | 3 (URLLC) | 000003 | 超可靠低延遲通信 |

### 5QI 映射

| 5QI | 資源類型 | 優先級 | 封包延遲預算 | 適用場景 |
|-----|---------|--------|-------------|---------|
| 5 | GBR | 10 | 100ms | IMS 語音 |
| 7 | GBR | 70 | 100ms | 視頻串流（本插件預設） |
| 9 | Non-GBR | 90 | 300ms | 網頁瀏覽 |
| 82 | GBR | 19 | 10ms | 低延遲 eMBB |

### Hook 執行流程

```
User Request
    ↓
Claude processes
    ↓
Tool Call (Write/Edit/Bash/etc.)
    ↓
[PreToolUse Hook] ← 可配置
    ↓
Tool Execution
    ↓
[PostToolUse Hook] ← 當前已配置
    ↓
Result returned to Claude
    ↓
[Notification Hook] ← 可配置
    ↓
Response to User
```

## 開發與擴展

### 新增 Slash Command

1. 在 `telecom-ops/commands/` 新增 `.md` 文件
2. 使用 frontmatter 定義 description 和 argument-hint
3. 撰寫指令說明與使用範例
4. 重啟 Claude Code 載入新指令

### 新增 Agent

1. 在 `telecom-ops/agents/` 新增 `.md` 文件
2. 定義 agent 名稱、描述、工具、模型
3. 撰寫 agent 的能力說明與指引
4. 重啟 Claude Code 載入新 agent

### 配置 Hooks

編輯 `telecom-ops/hooks/hooks.json`：

```json
{
  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...],
    "Notification": [...]
  }
}
```

支援的 matcher：
- `"*"` - 匹配所有
- `"Write|Edit"` - 匹配特定工具
- `"error"` - 匹配錯誤通知

### 整合 MCP Server

1. 實作符合 MCP 協議的 server
2. 更新 `telecom-ops/.mcp.json` 配置
3. 設定環境變數（API endpoint、token 等）
4. 重啟 Claude Code 啟動 MCP server
5. 使用 `mcp__` 前綴的工具

## 常見問題

### Q: Hook 沒有觸發？

**A:** 檢查以下項目：
1. 腳本是否有執行權限：`chmod +x telecom-ops/scripts/*.sh`
2. Hook 配置是否正確：檢查 `hooks/hooks.json` 語法
3. 插件是否已啟用：`/plugin list`
4. 重啟 Claude Code 並查看終端輸出

### Q: Slash Command 找不到？

**A:**
1. 確認插件已安裝：`/plugin list`
2. 確認插件已啟用：`/plugin enable telecom-ops`
3. 重啟 Claude Code
4. 檢查指令檔案格式是否正確（需要 frontmatter）

### Q: 如何連接真實的 O2-IMS？

**A:** 目前 MCP Server 整合功能尚未完全開發。需要：
1. 實作 O2-IMS MCP server（參考 MCP 協議規範）
2. 更新 `.mcp.json` 配置實際 API endpoint
3. 設定認證資訊（建議使用環境變數）
4. 測試連接與工具可用性

### Q: 生成的 KRM 檔案可以直接部署嗎？

**A:** 生成的檔案是起始模板（skeleton），需要根據實際環境調整：
- 覆蓋區域（coverageArea）
- 網路功能部署目標
- 資源配額
- 命名空間與標籤

建議流程：
1. 使用插件生成初始配置
2. 手動檢視與調整參數
3. 使用 `kpt fn render` 驗證
4. 提交到 GitOps repository
5. 通過 Nephio/Config Sync 部署

## 相關資源

- [Claude Code 文檔](https://docs.claude.com/en/docs/claude-code)
- [Claude Code 插件開發指南](https://docs.claude.com/en/docs/claude-code/plugins)
- [O-RAN Alliance](https://www.o-ran.org/)
- [Nephio Project](https://nephio.org/)
- [3GPP TS 23.501 - 5G System Architecture](https://www.3gpp.org/DynaReport/23501.htm)
- [Kpt Package Management](https://kpt.dev/)

## 授權

本專案採用 MIT 授權。

## 貢獻

歡迎提交 Issue 和 Pull Request！

**開發者：**
- Telecom Plugin Developer

**Repository：**
- https://github.com/thc1006/telecom-ops-claude-code-plugins

## 版本歷史

### v0.0.1 (2025-10-12)
- 初始版本
- 實作 `/telecom-ops:intent-parse` 指令
- 實作 `/telecom-ops:o2-status` 指令
- 新增 `intent-translator` agent
- 配置 PostToolUse hook
- 提供 MCP server stub 配置
- 完整測試套件與文檔
