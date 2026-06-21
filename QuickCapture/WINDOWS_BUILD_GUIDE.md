# Getting the IPA on Windows (No Mac Required)

GitHub gives you a free cloud Mac to build the app. Here's the full flow.

---

## Step 1 – Create a free GitHub account

Go to https://github.com and sign up. It's free, takes 2 minutes.

---

## Step 2 – Install GitHub Desktop

Download from https://desktop.github.com and install it (standard Windows installer).

Sign in with your GitHub account when it opens.

---

## Step 3 – Create a new repository

1. In GitHub Desktop: **File → New Repository**
2. Name: `QuickCapture`
3. Local path: pick somewhere easy like your Desktop
4. Click **Create Repository**

---

## Step 4 – Copy the QuickCapture project files in

1. Open the repo folder (GitHub Desktop → **Repository → Show in Explorer**)
2. Copy everything inside your `QuickCapture` folder (the one Claude built) into this folder.
   Make sure you see `project.yml`, `setup.sh`, the `QuickCapture/` subfolder, `.github/` folder, etc.

---

## Step 5 – Push to GitHub

Back in GitHub Desktop:
1. You'll see all the files listed on the left as "changes"
2. At the bottom left, type a summary like `initial` and click **Commit to main**
3. Click **Publish repository** (top right) → make sure **Keep this code private** is checked → **Publish Repository**

---

## Step 6 – Watch the build

1. Go to https://github.com/YOUR_USERNAME/QuickCapture (replace YOUR_USERNAME)
2. Click the **Actions** tab
3. You'll see a workflow called **Build QuickCapture IPA** running — click it to watch
4. It takes about 4–6 minutes on GitHub's free Mac

If it goes green ✅ — you're done. If it goes red ❌ — send me the error log and I'll fix it.

---

## Step 7 – Download the IPA

1. Click the completed workflow run
2. Scroll to the bottom — you'll see **Artifacts**
3. Click **QuickCapture-IPA** to download a zip file
4. Unzip it — inside is `QuickCapture.ipa`

---

## Step 8 – Sideload with Sideloadly

1. Download Sideloadly from https://sideloadly.io (Windows version)
2. Plug your iPhone in via USB
3. Open Sideloadly, drag `QuickCapture.ipa` in
4. Enter your Apple ID email and click **Start**
5. Enter your Apple ID password when prompted
6. Wait for "Done ✓"

---

## Step 9 – Trust the app on your iPhone

**Settings → General → VPN & Device Management → [your Apple ID] → Trust**

---

## Step 10 – Add the lock screen widget & AssistiveTouch

**Lock screen widget:**
1. Long-press your lock screen → Customize
2. Tap the widget area below the clock → + → search QuickCapture → add the rectangular widget

**AssistiveTouch:**
1. Settings → Accessibility → Touch → AssistiveTouch → ON
2. Customize Top Level Menu → + → Open App → QuickCapture

---

## Re-sideloading (every 7 days with free Apple ID)

Free Apple accounts expire every 7 days. When the app stops opening:
1. Open Sideloadly
2. Drag the same IPA in again
3. Done — your notes are saved

> Upgrade to a $99/year Apple Developer account to avoid this.

---

## Need to rebuild after code changes?

Any time you change the code and push to GitHub, the workflow runs automatically and produces a new IPA in the Actions tab.
