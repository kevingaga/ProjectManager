# Setup — Nouveau projet

## Méthode rapide (recommandée)

Depuis le dossier `ProjectManager` :

```bash
make new-project NAME=mon-app
```

Le script fait tout automatiquement :
1. Crée le repo GitHub `kevingaga/mon-app`
2. Clone en local dans `C:\Users\Gwen\Documents\Work\mon-app`
3. Scaffold React + Vite
4. Copie `Makefile` + `.github/workflows/preview.yml`
5. npm install + commit initial + push
6. Lie le projet à Vercel (`vercel link`)
7. Configure les 3 secrets GitHub automatiquement
8. Enregistre le projet dans `projects.json`

### Prérequis avant la première fois

```bash
# 1. GitHub CLI
winget install GitHub.cli
gh auth login   # → GitHub.com → HTTPS → Login with a web browser

# 2. Vercel CLI
npm i -g vercel

# 3. Fichier .env à la racine de ProjectManager
# (copier .env.example → .env et remplir les valeurs)
VERCEL_TOKEN=ton_token      # vercel.com/account/tokens
VERCEL_ORG_ID=ton_org_id   # voir ci-dessous
```

### Trouver VERCEL_TOKEN et VERCEL_ORG_ID

**VERCEL_TOKEN**
→ vercel.com/account/tokens → "Create Token"

**VERCEL_ORG_ID** (méthode fiable via `vercel link`)
```bash
vercel link   # dans n'importe quel projet déjà lié
cat .vercel/project.json
# → orgId = VERCEL_ORG_ID
```

> `.vercel/` et `.env` sont gitignorés — ne jamais les committer.

---

## Méthode manuelle (si besoin)

### 1. Structure à créer

```
mon-projet/
├── .github/
│   └── workflows/
│       └── preview.yml
├── .gitignore          ← inclure .claude/ et .vercel
└── Makefile
```

Copier `preview.yml` et `Makefile` depuis ce repo.

### 2. Secrets GitHub

Dans le repo GitHub du projet :
→ Settings → Secrets and variables → Actions → "New repository secret"

| Secret | Valeur |
|--------|--------|
| `VERCEL_TOKEN` | token Vercel |
| `VERCEL_ORG_ID` | orgId depuis `.vercel/project.json` |
| `VERCEL_PROJECT_ID` | projectId depuis `.vercel/project.json` |

Obtenir les IDs :
```bash
cd mon-projet
vercel link   # sélectionner le projet Vercel
cat .vercel/project.json
```

### 3. Désactiver la protection Vercel (accès mobile)

→ vercel.com → projet → Settings → Deployment Protection
→ "Vercel Authentication" → **Disabled**

---

## Utilisation au quotidien

```bash
# Déployer (nouvelle branche + PR automatique)
make preview MSG="feat: nouvelle fonctionnalité"

# Push rapide sur la branche courante
make preview-branch MSG="fix: correction"

# Nettoyer les vieilles branches preview/*
make clean-previews
```

### Ce qui se passe après un push

1. GitHub Actions se déclenche (~30 sec)
2. `npm ci` + `npm run build` (~1-2 min)
3. Deploy Vercel preview (~30 sec)
4. Commentaire sur la PR avec l'URL
5. Ouvrir le lien depuis le mobile

---

## Make non reconnu sur Windows

```powershell
# Installer make
winget install GnuWin32.Make

# Ajouter au PATH (dans PowerShell)
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files (x86)\GnuWin32\bin", "User")
```

Relancer le terminal, puis utiliser **Git Bash** pour lancer les commandes `make`.
