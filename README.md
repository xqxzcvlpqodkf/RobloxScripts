# RobloxScripts

A collection of utility scripts designed for Roblox exploits.

All scripts hosted in this repository are **public to use**. However, they are built with modern execution standards in mind and rely on standard environment functions. If you run into issues, ensure your environment isn't heavily stripped down or missing core HTTP/hooking functions.

---

## ⚡ Main Loader

Instead of hunting down specific scripts for specific games, use the main loader. It automatically checks your current `game.PlaceId` and executes the matching script if one is available.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/xqxzcvlpqodkf/RobloxScripts/refs/heads/main/Loader.lua"))()
```

> **How it works:** The loader pulls your Place ID on execution, queries the script manifest, and initializes the environment setup for that specific game. If the current game isn't supported yet, it will throw a notification on your screen.

---

## ⚠️ Compatibility & Executor Requirements

These scripts rely on standard environment features (like file system functions, library hooks, etc). 

* **High UNC / sUNC Required:** These scripts are **not supported OR tested** on low UNC & sUNC executors. If your executor fails basic Unified Naming Convention checks, features will break or fail to load entirely.
* **Recommended Environments:** Use a modern, well-maintained executor (like Volt, Potassium, Real, etc) to ensure you can execute the scripts.
* **No Support for Stripped Environments:** If a script throws `nil` global errors or fails on missing environment calls, your executor lacks the required API support.

---

## 📜 Usage & License

While these scripts are completely public for anyone to execute and run in-game, the codebase itself is maintained under a custom **Source-Available License**.

* **Allowed:** Running, executing, and using the scripts freely across your own sessions.
* **Prohibited:** Re-uploading, hosting mirrors on third-party script hubs, modifying and republishing as your own, or creating public forks/repositories of this codebase.

For complete legal terms, check the [`LICENSE`](./LICENSE) file included in the repository.
