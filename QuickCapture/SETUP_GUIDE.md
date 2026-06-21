# QuickCapture – Setup Guide

A step-by-step guide to go from these files to a working app on your iPhone.

---

## What you need

| Tool | Free? | Link |
|------|-------|------|
| Mac with Xcode 15+ | Free | Mac App Store |
| Apple ID (any) | Free | Already have one |
| Homebrew | Free | https://brew.sh |
| Sideloadly | Free | https://sideloadly.io |
| USB cable | — | plug iPhone in |

---

## Step 1 – Install Xcode

Open the **Mac App Store**, search **Xcode**, and install it (it's large – ~15 GB, give it time).

---

## Step 2 – Generate the Xcode project

1. Open **Terminal** (press ⌘ + Space, type *Terminal*, hit Enter).
2. Drag the `QuickCapture` folder into Terminal to paste its path, then press Enter to go into it:
   ```
   cd /path/to/QuickCapture
   ```
3. Run the setup script:
   ```
   bash setup.sh
   ```
   This installs `xcodegen` (if needed) and generates `QuickCapture.xcodeproj`, then opens it in Xcode automatically.

---

## Step 3 – Sign the app in Xcode

1. In Xcode, click the **blue QuickCapture project icon** at the top of the left sidebar.
2. Under **Targets → QuickCapture**, click the **Signing & Capabilities** tab.
3. Check **Automatically manage signing**.
4. Set **Team** to your Apple ID (click *Add Account…* if it's not there yet).
5. Change the **Bundle Identifier** if Xcode says it's taken – add your initials:  
   `com.dean.quickcapture.dkh` (anything unique works).
6. Repeat steps 2–5 for the **QuickCaptureWidget** target.
   - The widget Bundle ID must start with the app's ID, e.g. `com.dean.quickcapture.dkh.widget`.
7. In both targets, under **App Groups** (still in Signing & Capabilities), update the group ID to match:  
   `group.com.dean.quickcapture.dkh`  
   *(must be identical in both targets and in `DataStore.swift` line 11 and `QuickCaptureWidget.swift` line 17)*

---

## Step 4 – Update the App Group ID in code (if you changed it)

If you changed the bundle ID in Step 3, open these two files and update the group string:

- `QuickCapture/DataStore.swift` → line 11:  
  `static let appGroupID = "group.com.dean.quickcapture"`  
  Change to your new group ID.

- `QuickCaptureWidget/QuickCaptureWidget.swift` → line 17:  
  `guard let defaults = UserDefaults(suiteName: "group.com.dean.quickcapture")`  
  Change to your new group ID.

---

## Step 5 – Build the IPA

1. Plug your iPhone into your Mac via USB.
2. In Xcode, click the **device picker** at the top (where it says "Any iOS Device") and select **your iPhone**.
3. Press **⌘ + B** to build. Fix any errors (usually just the signing step above).
4. Go to **Product → Archive**.
5. When the Archive window opens, click **Distribute App**.
6. Choose **Ad Hoc** → Next → Next → Export.
7. Save the exported folder – it contains your `.ipa` file.

---

## Step 6 – Sideload with Sideloadly

1. Download and open **Sideloadly** from https://sideloadly.io.
2. Plug your iPhone in.
3. Drag your `.ipa` file into Sideloadly.
4. Enter your **Apple ID email** and click **Start**.
5. Enter your Apple ID password when prompted.
6. Wait for "Done". 

> **Free Apple ID note:** Free accounts give a 7-day certificate. You'll need to re-sideload every 7 days (takes ~1 minute). Upgrade to a $99/year Apple Developer account to get 1-year certificates.

---

## Step 7 – Trust the app on your iPhone

1. On iPhone: **Settings → General → VPN & Device Management**.
2. Tap your Apple ID email under "Developer App".
3. Tap **Trust** → **Trust**.

---

## Step 8 – Add the lock screen widget

1. Long-press your lock screen until it enters edit mode.
2. Tap **Customize**.
3. Tap the area below the time (widget zone).
4. Tap **+** → search **QuickCapture** → add the rectangular widget.
5. Tap outside to save. Tap your wallpaper to exit.

Tapping the widget opens the app directly to the Capture screen.

---

## Step 9 – Add to AssistiveTouch

1. **Settings → Accessibility → Touch → AssistiveTouch** → toggle ON.
2. Tap **Customize Top Level Menu**.
3. Tap a **+** slot → **Open App** → search **QuickCapture**.
4. Now the floating AssistiveTouch button → QuickCapture opens instantly from anywhere.

---

## App features

| Feature | How to use |
|---------|-----------|
| Quick note | Open app → type → tap **Save Note** |
| Browse notes | **Notes** tab → swipe left to delete, swipe right to pin |
| Set reminder | Notes tab → tap a note → toggle **Set Reminder** → pick date/time |
| View reminders | **Reminders** tab shows all upcoming alerts |
| Lock screen widget | Shows your last note + count; tap to open app |

---

## Troubleshooting

**"App can't be opened" on iPhone** → Redo Step 7 (Trust the developer).

**Widget not showing notes** → Make sure both targets have the same App Group ID. Rebuild and re-sideload.

**No notification permission dialog** → Settings → QuickCapture → Notifications → Allow.

**7-day cert expired** → Re-run Sideloadly with the same IPA. Your notes are safe (stored on-device).
