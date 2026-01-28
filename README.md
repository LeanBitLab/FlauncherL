# FlauncherL

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/banner_dark.svg">
  <source media="(prefers-color-scheme: light)" srcset="assets/banner_light.svg">
  <img alt="FlauncherL Banner" src="assets/banner_light.svg">
</picture>

[![Download](https://img.shields.io/github/v/release/LeanBitLab/FlauncherL?label=Download&style=for-the-badge&color=7C4DFF)](https://github.com/LeanBitLab/FlauncherL/releases/latest) [![Downloads](https://img.shields.io/github/downloads/LeanBitLab/FlauncherL/total?style=for-the-badge&color=7C4DFF&label=Downloads)](https://github.com/LeanBitLab/FlauncherL/releases) [![Stars](https://img.shields.io/github/stars/LeanBitLab/FlauncherL?style=for-the-badge&color=7C4DFF)](https://github.com/LeanBitLab/FlauncherL/stargazers)

**FlauncherL** is a fork of [FLauncher](https://github.com/osrosal/flauncher) (originally by [etienn01](https://gitlab.com/flauncher/flauncher)) - an open-source alternative launcher for Android TV.

This customized version introduces usability enhancements and some UX improvements by [LeanBitLab](https://github.com/LeanBitLab).

## Key Features & Enhancements

- **Data Usage Widget** - Track daily Internet consumption directly from the status bar.
- **Inbuilt OLED Screensaver** - Minimal screensaver with 30s clock position shifting to prevent burn-in.
- **Easy WiFi Access** - Network indicator doubles as a shortcut to system WiFi settings.
- **Quick Presets** - Select Time/Date formats and Category names from a list (No keyboard required).
- **Pitch Black Wallpaper** - Added a true black gradient background option.
- **Enhanced Focus Indicator** - New double-border design ensures perfect visibility on any background.
- **Smart Navigation** - Fixed "bounce back" issues and optimized focus traversal for a smoother experience.
- **Refined Settings** - Reorganized menus with a new "Miscellaneous" section and unified focus styles.
- **New Categories** - Added "All Apps" and "Favorites" with auto-population support.
- **Optimizations** - Improved performance with aggressive icon caching and code cleanups.




## Screenshots

<table>
  <tr>
    <td align="center">Home Screen</td>
    <td align="center">Settings</td>
    <td align="center">Widget</td>
    <td align="center">Screensaver</td>
  </tr>
  <tr>
    <td><img src="docs/images/screenshot_1.png" width="100%" alt="Home Screen"/></td>
    <td><img src="docs/images/screenshot_2.png" width="100%" alt="Settings"/></td>
    <td><img src="docs/images/screenshot_3.png" width="100%" alt="Widget"/></td>
    <td><img src="docs/images/screensaver.gif" width="100%" alt="Screensaver"/></td>
  </tr>
</table>

## Original FLauncher Features

- [x] No ads
- [x] Customizable categories
- [x] Manually reorder apps within categories
- [x] Wallpaper support
- [x] Open "Android Settings"
- [x] Open "App info"
- [x] Uninstall app
- [x] Clock
- [x] Switch between row and grid for categories
- [x] Support for non-TV (sideloaded) apps
- [x] Navigation sound feedback

## Set FlauncherL as default launcher

### Method 1: Remap the Home button
This is the "safer" and easiest way. Use [Button Mapper](https://play.google.com/store/apps/details?id=flar2.homebutton) to remap the Home button of the remote to launch FlauncherL.

### Method 2: Disable the default launcher
**:warning: Disclaimer :warning:**

**You are doing this at your own risk, and you'll be responsible in any case of malfunction on your device.**

The following commands have been tested on Chromecast with Google TV only. This may be different on other devices.

Once the default launcher is disabled, press the Home button on the remote, and you'll be prompted by the system to choose which app to set as default.

#### Disable default launcher
```shell
# Disable com.google.android.apps.tv.launcherx which is the default launcher on CCwGTV
$ adb shell pm disable-user --user 0 com.google.android.apps.tv.launcherx
# com.google.android.tungsten.setupwraith will then be used as a 'fallback' and will automatically
# re-enable the default launcher, so disable it as well
$ adb shell pm disable-user --user 0 com.google.android.tungsten.setupwraith
```

#### Re-enable default launcher
```shell
$ adb shell pm enable com.google.android.apps.tv.launcherx
$ adb shell pm enable com.google.android.tungsten.setupwraith
```

#### Known issues
On Chromecast with Google TV (maybe others), the "YouTube" remote button will stop working if the default launcher is disabled. As a workaround, you can use [Button Mapper](https://play.google.com/store/apps/details?id=flar2.homebutton) to remap it correctly.

## Wallpaper
Because Android's `WallpaperManager` is not available on some Android TV devices, FLauncher implements its own wallpaper management method.

Please note that changing wallpaper requires a file explorer to be installed on the device in order to pick a file.

## Credits

### Original Projects
- **[FLauncher](https://gitlab.com/flauncher/flauncher)** by [etienn01](https://github.com/etienn01) - The original project
- **[FLauncher (Fork)](https://github.com/osrosal/flauncher)** by [osrosal](https://github.com/osrosal) - The base for this fork

---

### FlauncherL
- Customizations by [LeanBitLab](https://github.com/LeanBitLab)
