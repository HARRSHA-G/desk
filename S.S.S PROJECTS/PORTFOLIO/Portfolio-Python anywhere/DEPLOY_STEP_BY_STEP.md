# 🚀 Deployment Guide: Uploading Your Portfolio to PythonAnywhere

Follow these steps exactly to deploy your existing project.

## 📦 Phase 1: Prepare Your Files (Local Computer)
1.  **Stop the server**: In your terminal, press `Ctrl+C` to stop `runserver`.
2.  **Zip your project**:
    - Go to your project folder: `C:\Users\Asus\Desktop\S.S.S PROJECTS\PORTFOLIO\Portfolio-Python anywhere`
    - Select **ALL** files (including `manage.py`, `requirements.txt`, `home`, `templates`, etc.).
    - **Right-click** -> **Send to** -> **Compressed (zipped) folder**.
    - Rename it to `mysite.zip`.

---

## ☁️ Phase 2: PythonAnywhere Dashboard
1.  **Dashboard**: Go to your PythonAnywhere Dashboard.
2.  **Web App**: Click the **Web** tab (top right).
3.  **Add a new web app**:
    - Click **"Add a new web app"**.
    - Click **Next**.
    - **Manual Configuration**: Click **"Manual configuration"** (NOT Django!).
    - **Python Version**: Select **Python 3.10**.
    - Click **Next/Create**.

---

## 📂 Phase 3: Upload Files
1.  **Files**: Click the **Files** tab (top right).
2.  **Upload**: Look for the "Upload a file" button.
3.  **Select File**: Choose your `mysite.zip` file.
4.  **Upload**: Click the Upload button.

---

## 💻 Phase 4: Consoles & Setup
1.  **Consoles**: Click the **Consoles** tab.
2.  **Bash**: Click **Bash** under "Start a new console".
3.  **Run these commands** (one by one):

```bash
# 1. Unzip the file
unzip mysite.zip -d mysite

# 2. Go into the folder
cd mysite

# 3. IMPORTANT: Enter the project folder (use quotes because of spaces)
cd "Portfolio-Python anywhere"

# 4. Create Virtual Environment
python3 -m venv venv

# 4. Activate it
source venv/bin/activate

# 5. Install libraries
pip install -r requirements.txt

# 6. Set up database
python manage.py migrate

# 7. Collect static files
python manage.py collectstatic --noinput
```

*(Wait for all dependencies to install!)*

---

## ⚙️ Phase 5: Final Configuration (Web Tab)
1.  Go back to the **Web** tab.
2.  **Virtualenv**:
    - Look for the "Virtualenv" section.
    - Enter the path: `/home/gaddeharshavardhan/mysite/Portfolio-Python anywhere/venv`
    - Checks for a green checkmark ✅.
3.  **Source Code**:
    - Enter path: `/home/gaddeharshavardhan/mysite/Portfolio-Python anywhere`
4.  **WSGI Configuration File**:
    - Click the link (e.g., `/var/www/gaddeharsha_pythonanywhere_com_wsgi.py`).
    - **DELETE EVERYTHING** in that file.
    - **PASTE THIS CODE**:

```python
import os
import sys

# 1. Path to your project
# We point to the folder containing manage.py
path = '/home/gaddeharshavardhan/mysite/Portfolio-Python anywhere'

if path not in sys.path:
    sys.path.append(path)

# 2. Settings module
os.environ['DJANGO_SETTINGS_MODULE'] = 'portfolio_project.settings'

# 3. Start Django
from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
```
    - Click **Save** (Ctrl+S).

---

## � Phase 6: Static Files Setup (Recommended)
Your screenshot showed the "Static Files" section was empty. Let's fix that to ensure your images and styles load correctly.

1.  Go to the **Web** tab.
2.  Scroll down to the **Static files** section.
3.  Click "Enter URL" and type: `/static/`
4.  Click "Enter path" and type: `/home/gaddeharshavardhan/mysite/Portfolio-Python anywhere/staticfiles`
5.  Click **Reload**.

---

## �🚀 Phase 7: Launch & Troubleshooting
1.  Go back to the top of the **Web** tab.
2.  Click the big green **Reload** button.
3.  Click the link to your site.

### ❌ If you see: "ModuleNotFoundError: No module named 'django'"
This is exactly what your logs show! It means the server doesn't know where your libraries (Django) are installed.

**Solution 1: Check the Web Tab (Easiest)**
1.  Go to the **Web** tab.
2.  Look at the **Virtualenv** section.
3.  Ensure it says EXACTLY: `/home/gaddeharshavardhan/mysite/Portfolio-Python anywhere/venv`
4.  If it is empty or red, click it and paste that path.

**Solution 2: Force it in the WSGI file (If Solution 1 fails)**
If the Web tab path is correct but it still fails (sometimes spaces in folder names cause issues), use this "Force Fix" code in your WSGI file:

```python
import os
import sys

# 1. Add your project path
path = '/home/gaddeharshavardhan/mysite/Portfolio-Python anywhere'
if path not in sys.path:
    sys.path.append(path)

# 2. FORCE the Virtualenv (The Emergency Fix)
# We manually tell python where the libraries are
venv_path = '/home/gaddeharshavardhan/mysite/Portfolio-Python anywhere/venv/lib/python3.10/site-packages'
if venv_path not in sys.path:
    sys.path.append(venv_path)

# 3. Settings module
os.environ['DJANGO_SETTINGS_MODULE'] = 'portfolio_project.settings'

# 4. Start Django
from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
```
*(Note: If you used Python 3.9 or 3.11, change `python3.10` in the code above to match!).*


### 404 Page Not Found (The "Yellow Page" Error)
If you see a yellow page saying "Page not found (404)", it means **you typed the wrong URL**.

For example, in your screenshot, you typed:
`.../admmin` (Double 'm') -> **WRONG ❌**

You must type the exact URL defined in your code:
`.../admin` (Single 'm') -> **CORRECT ✅**

**How to handle this professionally?**
Right now, you see the yellow debug page because `DEBUG = True`.
To make it look like a real professional site (and hide these internal details):
1. Go to your `settings.py` file.
2. Change `DEBUG = True` to `DEBUG = False`.
3. Valid URLs will work, and invalid ones will show a standard "Not Found" page instead of this yellow debug screen.



