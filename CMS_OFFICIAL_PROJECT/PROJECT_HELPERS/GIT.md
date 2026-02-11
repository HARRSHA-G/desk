# Git - Quick Reference Guide

A complete guide with all Git commands and workflows needed for the Construction Management System.

---

## 🔧 GIT SETUP - Initial Repository Configuration

### Step 1: Initialize a New Git Repository
```powershell
cd Construction-Management-System
git init
```

### Step 2: Add README File (Optional)
```powershell
echo "# CMS_OFFICIAL" >> README.md
```

### Step 3: Add All Files to Staging
```powershell
git add .
```

### Step 4: Create First Commit
```powershell
git commit -m "first commit"
```

### Step 5: Rename Main Branch to 'main'
```powershell
git branch -M main
```

### Step 6: Add Remote Repository (GitHub)
Replace with your actual repository URL:
```powershell
git remote add origin https://github.com/HARRSHA-G/CMS_OFFICIAL.git
```

### Step 7: Push to GitHub
```powershell
git push -u origin main
```

---

## 📤 PUSH CHANGES TO GITHUB

### After Making Changes to Files

**Step 1:** Check what files changed
```powershell
git status
```

**Step 2:** Stage all changes
```powershell
git add .
```

**Step 3:** Commit with a message describing your changes
```powershell
git commit -m "Your commit message here"
```

**Step 4:** Push to GitHub
```powershell
git push origin main
```

---

## 📥 PULL LATEST CHANGES FROM GITHUB

### Before Starting Work

```powershell
git pull origin main
```

This downloads all the latest changes from GitHub to your local computer.

---

## 🌿 WORKING WITH BRANCHES

### Create a New Branch
```powershell
git branch feature-name
```

### Switch to a Branch
```powershell
git checkout feature-name
```

### Create and Switch to New Branch (One Command)
```powershell
git checkout -b feature-name
```

### List All Branches
```powershell
git branch
```

### List Remote Branches
```powershell
git branch -r
```

### Delete a Local Branch
```powershell
git branch -d branch-name
```

### Delete Remote Branch
```powershell
git push origin --delete branch-name
```

### Merge Branch into Main
```powershell
# Switch to main first
git checkout main

# Then merge your feature branch
git merge feature-name
```

---

## 💾 COMMON WORKFLOWS

### Complete Workflow: Edit → Commit → Push

```powershell
# 1. Make changes to your files in your editor
# 2. Check what changed
git status

# 3. Stage your changes
git add .

# 4. Commit with message
git commit -m "Added new feature"

# 5. Push to GitHub
git push origin main
```

### When You Get Conflicts During Merge

```powershell
# 1. Try to merge
git merge feature-branch

# 2. If conflict, check status
git status

# 3. Edit the conflicted files manually in your editor
# 4. Mark as resolved
git add .

# 5. Commit the merge
git commit -m "Resolved merge conflicts"

# 6. Push to GitHub
git push origin main
```

---

## 🔍 VIEW GIT HISTORY

### See All Commits
```powershell
git log
```

### See Commits in One Line (Cleaner View)
```powershell
git log --oneline
```

### See Changes in Last Commit
```powershell
git show HEAD
```

### See Diff Between Branches
```powershell
git diff main feature-branch
```

---

## ↩️ UNDO CHANGES

### Undo Changes (Not Staged Yet)
```powershell
git checkout -- filename.py
```

### Undo Staged Changes
```powershell
git reset HEAD filename.py
```

### Undo Last Commit (Keep Changes)
```powershell
git reset --soft HEAD~1
```

### Undo Last Commit (Delete Changes)
```powershell
git reset --hard HEAD~1
```

### Revert Last Commit (Create New Commit)
```powershell
git revert HEAD
```

---

## 🏷️ TAGS - Mark Important Versions

### Create a Tag
```powershell
git tag v1.0.0
```

### Push Tag to GitHub
```powershell
git push origin v1.0.0
```

### Push All Tags to GitHub
```powershell
git push origin --tags
```

### List All Tags
```powershell
git tag
```

### Delete Local Tag
```powershell
git tag -d v1.0.0
```

### Delete Remote Tag
```powershell
git push origin --delete v1.0.0
```

---

## 🔐 CONFIGURE GIT USER

### Set Your Name (One Time Setup)
```powershell
git config --global user.name "Your Name"
```

### Set Your Email (One Time Setup)
```powershell
git config --global user.email "your.email@example.com"
```

### Check Current Configuration
```powershell
git config --global user.name
git config --global user.email
```

---

## 📋 QUICK REFERENCE COMMANDS

| Task | Command |
| --- | --- |
| **Initialize git** | `git init` |
| **Add files** | `git add .` |
| **Commit** | `git commit -m "message"` |
| **Push to GitHub** | `git push origin main` |
| **Pull from GitHub** | `git pull origin main` |
| **Check status** | `git status` |
| **View history** | `git log --oneline` |
| **Create branch** | `git branch branch-name` |
| **Switch branch** | `git checkout branch-name` |
| **Merge branch** | `git merge branch-name` |
| **Rename main branch** | `git branch -M main` |
| **Add remote** | `git remote add origin URL` |
| **View remotes** | `git remote -v` |

---

## 📚 FULL INITIAL SETUP EXAMPLE

Complete commands from zero to GitHub:

```powershell
# 1. Initialize repository
git init

# 2. Configure user (first time only)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 3. Add all files
git add .

# 4. Create first commit
git commit -m "first commit"

# 5. Rename branch to main
git branch -M main

# 6. Add GitHub repository
git remote add origin https://github.com/YOUR-USERNAME/CMS_OFFICIAL.git

# 7. Push to GitHub
git push -u origin main
```

---

## ⚠️ IMPORTANT TIPS

✅ **DO:**
- Commit frequently with meaningful messages
- Pull before starting work to avoid conflicts
- Create branches for new features
- Use `.gitignore` to exclude files (`.venv`, `*.pyc`, `__pycache__`, `db.sqlite3`)

❌ **DON'T:**
- Commit sensitive files (`.env` with passwords)
- Commit large files (videos, databases)
- Force push without understanding consequences (`git push --force`)
- Commit directly to main in team projects (use feature branches)

---


## 🆘 COMMON ISSUES & SOLUTIONS

### Issue 1: "fatal: not a git repository"
**Solution:** You're not in a git folder. Run:
```powershell
git init
```

### Issue 2: "Please tell me who you are" Error
**Solution:** Configure your user:
```powershell
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Issue 3: "Permission denied" When Pushing
**Solution:** Set up SSH keys or use GitHub personal access token for HTTPS.

### Issue 4: "Conflict" During Merge
**Solution:** Edit the conflicted files, mark as resolved, then commit:
```powershell
git add .
git commit -m "Resolved merge conflicts"
git push origin main
```

### Issue 5: Accidentally Committed Sensitive File
**Solution:** Remove from history:
```powershell
git rm --cached .env
git commit -m "Remove .env file"
git push origin main
```

---

## 📌 GITHUB URL FORMATS

### HTTPS (Easier for Beginners)
```
https://github.com/HARRSHA-G/CMS_OFFICIAL.git
```

### SSH (More Secure)
```
git@github.com:HARRSHA-G/CMS_OFFICIAL.git
```

---

**That's all you need for Git! 🚀**
