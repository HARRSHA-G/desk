# Deploying to PythonAnywhere (Professional Approach)

This guide walks you through setting up your project on PythonAnywhere with a professional environment configuration.

## 1. Professional Project Setup (Done Automatically)
We have already:
- Configured `settings.py` to handle production settings securely.
- Added `whitenoise` for efficient static file serving.
- Created a `requirements.txt` with all dependencies frozen.

## 2. Setting Up on PythonAnywhere

### Step A: Upload Code
1.  Go to the **Files** tab in PythonAnywhere.
2.  Upload your project (you can zip the `p22222` folder and unzip it there).

### Step B: Create Virtual Environment (The Professional Way)
Open a **Bash Console** on PythonAnywhere and run these commands:

```bash
# 1. Navigate to your project folder
cd p22222  # or whatever your folder name is

# 2. Create a fresh virtual environment
python3 -m venv venv

# 3. Activate the environment
source venv/bin/activate

# 4. Install dependencies
pip install -r requirements.txt
```

### Step C: Database Setup
Still in the Bash console, initialize your production database:

```bash
python manage.py migrate
python manage.py collectstatic --noinput
```

### Step D: Configure Web Tab
1.  Go to the **Web** tab on PythonAnywhere.
2.  **Source code:** Enter the path to your project (e.g., `/home/yourusername/p22222`).
3.  **Virtualenv:** Enter the path to your venv (e.g., `/home/yourusername/p22222/venv`).
4.  **WSGI Configuration File:** Click the link to edit it, and update it to point to your project's settings.
    - Delete everything and add:
      ```python
      import os
      import sys

      path = '/home/yourusername/p22222'
      if path not in sys.path:
          sys.path.append(path)

      os.environ['DJANGO_SETTINGS_MODULE'] = 'portfolio_project.settings'

      from django.core.wsgi import get_wsgi_application
      application = get_wsgi_application()
      ```

5.  **Reload** the web app!

## 3. Environment Variables (Security)
For a truly professional setup, don't hardcode secrets. In the WSGI file or environment settings, set:
- `SECRET_KEY`: A long random string.
- `DEBUG`: Set to `False` for production.

Your site is now ready to scale! 🚀
