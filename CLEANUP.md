# Linux Package Maintenance Guide
A workflow for keeping a lean system by managing manual/automatic packages and cleaning up "Ghost" configurations.
---

## 1. The "Trim the Fat" Workflow
This process converts unnecessary manual installs into dependencies and lets the system sweep them away.

### Step A: Mark Libraries as Automatic

By default, some libraries get marked "manual" if you install them specifically. This command tells the system: *"Only keep these if something else needs them."*

```bash
sudo apt-mark auto 'lib.*' 'python3-.*' 'xcb-.*'
```

## Step B: The Auto-Removal
Now that the libraries are marked as auto, run the removal tool to delete any that aren't being used by your primary apps.

```bash
sudo nala autoremove
```

## Deep Cleaning
Once the software is gone, there is often "residue" left behind (cache files and old configurations).

Clear Package Cache
Clears out the downloaded .deb installers sitting in your storage.

```bash
sudo nala clean

```

## Remove "Residual Config" (The Ghost Purge)
When you upgrade a package (like moving from i3 v4.20 to v4.23), the old version leaves behind configuration "ghosts" labeled as rc (Removed, but Config remains).

### 1. Check for ghosts:

```bash
dpkg -l | grep '^rc'

```

### 2. Purge all ghosts:
If you are sure you don't need the settings from those old versions, wipe them:

```bash
sudo nala purge $(dpkg -l | grep '^rc' | awk '{print $2}')
```


## Summary of Commands

| Command | Action |
| --- | --- |
| `apt-mark showmanual` | See everything you "officially" installed. |
| `apt-mark auto [pattern]` | Change a package from "Required" to "Dependency". |
| `nala autoremove` | Uninstall any dependency that no longer has a "parent" app. |
| `nala clean` | Delete old installer files to save disk space. |
| `nala purge` | Delete a program **plus** its configuration files. |


> Note: If you ever see rc in your package list, it means the program is already uninstalled, but its settings files are still taking up space in /etc and the dpkg database. Purging is safe unless you specifically want to keep those settings for a future reinstall.


## Building Software

To keep your system clean while building software from source, the "best" way is to treat build dependencies as temporary scaffolding. If you mark them as **automatic** immediately after installation, the system knows they are only there to serve a purpose, not to stay forever.

### The "Install & Flag" Method

The goal is to install the headers (usually `-dev` packages) but tell the system: *"I'm only using these right now; feel free to sweep them away later."*

1. **Install the packages normally:**
```zsh
sudo nala install libx11-dev libxft-dev libxinerama-dev

```


2. **Immediately mark them as auto:**
```zsh
sudo apt-mark auto libx11-dev libxft-dev libxinerama-dev

```


3. **Build your software:**
Run your `make` and `sudo make install` commands.
4. **The Cleanup:**
Once your software is compiled and installed (usually to `/usr/local/bin`), the system no longer needs the `-dev` source headers. Run:
```zsh
sudo nala autoremove

```

---

### The "Pro" Move: The One-Liner

If you know exactly what you need for a specific build, you can combine the installation and the "auto" flag into one line so you don't forget:

```zsh
sudo nala install libx11-dev && sudo apt-mark auto libx11-dev

```

### Why this works

When you compile a program, the compiler needs the headers (`-dev` files) to create the binary. Once that binary is created and saved to your disk, it usually only needs the standard libraries (`libx11-6`), not the development headers. By marking the headers as `auto`, `nala autoremove` will see that nothing in the official package database "depends" on those headers and will offer to delete them for you.
