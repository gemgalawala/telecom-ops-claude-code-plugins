# telecom-ops-tests

這是一組針對 **telecom-ops** 插件的最小化測試場景（Scenarios + Prompts + Headless Script）。
請將本資料夾與 `telecom-ops/` 插件資料夾置於同一層，例如：

```
work/
├─ telecom-ops/                # 你的插件骨架（先前提供的 zip 解壓後）
└─ telecom-ops-tests/          # 本測試套件（此 zip 解壓後）
```

## 測試步驟（互動式；建議先試）

1) 啟動 Claude Code，新增本機 Marketplace 並安裝插件：
```
/plugin marketplace add ./telecom-ops-tests/dev-marketplace
/plugin install telecom-ops@dev-marketplace
```
> 若已安裝過，略過這步。

2) 依序貼下列 Prompt 給 Claude：
- `prompts/S1_intent_to_krm.md`
- `prompts/S2_o2_status.md`
- `prompts/S3_hook_check.md`

成功訊號：
- 終端應出現 `[telecom-ops] PostToolUse hook triggered...`（來自插件 `hooks/hooks.json` 綁定的 `scripts/kpt-render.sh`）
- `/intent parse` 與 `/o2 status` 指令可用並有回覆

## 測試步驟（Headless 自動化；選擇性）

在專案根目錄（`work/`）執行：
```
bash telecom-ops-tests/scripts/run_headless.sh
```
輸出會寫到 `telecom-ops-tests/runs/`。

## 結構說明
- `prompts/`：三個情境的提示詞（可直接貼給 Claude Code）
- `scripts/run_headless.sh`：Headless 模式範例，逐一餵 Prompt 並存檔
- `dev-marketplace/.claude-plugin/marketplace.json`：本機 Marketplace，會把 `telecom-ops/` 視為一個可安裝的外掛來源

> 若 Marketplace 安裝卡住，請確認路徑正確、資料夾已「信任」，或改用 `/plugin` 介面重新加載。
