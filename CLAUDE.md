# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DCS World multiplayer server scripting framework ("NP" server). Pure Lua — no build system. Deployment means copying scripts to the DCS `Scripts` folder (`lfs.writedir()`) and restarting the mission or server. Check `dcs.log` and `env.info`/`net.log` output for runtime debugging.

## Two Runtime Environments

All code runs in one of two isolated DCS environments — never confuse them:

| Environment | Entry Point | API Available |
|---|---|---|
| **Server/Hook (GameGUI)** | `Hooks/InitNPGame.lua` | `net`, `lfs`, DCS server callbacks |
| **Mission (SSE)** | `LoadMissionScript/MissionScripting.lua` | `mist`, `ctld`, `trigger`, `timer`, `Group`, `Unit`, etc. |

Cross-environment calls use `net.dostring_in('mission', script_string)`.

## Key Entry Points and Load Order

1. **Server startup:** `Hooks/InitNPGame.lua` → loads `SlotAuth/SlotAuth.lua` and `Source/Version3.0/Callbacks/Init.lua`
2. **Mission load:** `LoadMissionScript/MissionScripting.lua` reads `serverSettings.lua`; only proceeds if server name contains `"TD动态战役"`, then loads: MIST → CTLD → `Mission/Core/NPV2.lua` → all 6 `Mission/Modules/` → `Source/Version3.0/Mission/SourceInit.lua`

## Architecture

- **`SlotAuth/`** — Team balance and slot authorization; dynamic config from `SlotAuth/动态槽位限制.json`
- **`Source/Version3.0/`** — Server-side system: event callbacks (`Callbacks/`), admin/player chat commands (`Callbacks/Commands/`), and mission-side resource/point manager (`Mission/`)
- **`Mission/Core/NPV2.lua`** — Main capture zone loop: proximity capture, 3 defense levels (L1–L3), AWACS/Command Center respawning, MIST/CTLD integration
- **`Mission/Modules/`** — Optional gameplay features: `Bomber.lua`, `Transporter.lua`, `GCI.lua`, `NPCSAR.lua`, `AddEXPL.lua`, `SweepDebris.lua`
- **`Mission/Libs/`** — Third-party libs: `mist.lua`, `CTLD.lua` (do not modify)

## Conventions

**Module structure** — every module exports a single global table:
```lua
MyMod = { Version = 'YYYYMMDD' }
function MyMod.logInfo(msg)  env.info("[MyMod] Info: " .. msg) end
function MyMod.logDebug(msg) if DEBUG then env.info("[MyMod] Dbg: " .. msg) end end
function MyMod.logError(msg) env.info("[MyMod] Err: " .. msg) end
```

**File loading** — always use `dofile(lfs.writedir() .. 'Scripts/...')` at runtime.

**Deferred work** — use `timer.scheduleFunction(fn, args, timer.getTime() + delay)` for spawning or async actions.

**User-facing messages** — `trigger.action.outText(msg, duration)` (mission) or `net.send_chat(msg, all)` (server).

**Defensive checks** — always guard with `Group.getByName(...)` or `Unit.getByName(...)` before acting on dynamic groups.

## Common Pitfalls

- **Do not assign `unitId`** in `mist.dynAdd` unit tables — it breaks DCS slot selection (see comments in `Mission/Core/NPV2.lua`).
- **Paths:** DCS on Windows uses mixed `\`/`/`. Prefer `lfs.writedir() .. 'Scripts/...'` (forward slashes work in Lua's `dofile`).
- **No automated tests** — the suggested approach is Lua static linting plus host-side tests that validate `dofile` load paths.

## Data Persistence

JSON files in `SourceData/` (inside `lfs.writedir()`):
- `玩家资源点.json` — player resource points
- `管理员列表.json` — admin list
- `聊天记录/YYYY-MM-DD.txt` — chat logs

## Resource Point Costs (Bomber module)

| Type | Cost | Count |
|---|---|---|
| Attack | 200 | 5 missiles |
| LowBomber | 200 | 15 bombs |
| StealthBomber | 200 | 2 bombs |
| Bomber | 700 | 20 bombs |
| Nuke | 1000 | 1 (requires ≥4 players) |
