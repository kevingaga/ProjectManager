#!/usr/bin/env bash
set -e

NAME="${1:?Usage: make new-project NAME=my-app}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
WORK_DIR="C:/Users/Gwen/Documents/Work"
PROJECT_DIR="$WORK_DIR/$NAME"

# ── Load .env ──────────────────────────────────────────────
if [ -f "$ROOT_DIR/.env" ]; then
  source "$ROOT_DIR/.env"
fi

if [ -z "$VERCEL_TOKEN" ]; then
  echo "❌  VERCEL_TOKEN manquant."
  echo "    Ajoute-le dans ProjectManager/.env :"
  echo "    VERCEL_TOKEN=ton_token"
  exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Bootstrap : $NAME"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ── 1. GitHub repo ─────────────────────────────────────────
echo ""
echo "→ [1/7] Création du repo GitHub kevingaga/$NAME..."
gh repo create "kevingaga/$NAME" --public 2>/dev/null && echo "  ✓ Repo créé" || echo "  (repo existe déjà)"

# ── 2. Clone ───────────────────────────────────────────────
echo ""
echo "→ [2/7] Clone..."
if [ -d "$PROJECT_DIR/.git" ]; then
  echo "  (dossier git existe déjà, skip clone)"
  cd "$PROJECT_DIR"
else
  git clone "https://github.com/kevingaga/$NAME.git" "$PROJECT_DIR"
  cd "$PROJECT_DIR"
fi

# ── 3. Scaffold React+Vite ─────────────────────────────────
echo ""
if [ ! -f "package.json" ]; then
  echo "→ [3/7] Scaffold React+Vite..."
  # Backup any existing files, scaffold, restore
  mkdir -p /tmp/bootstrap_backup
  ls -A | grep -v '.git' | xargs -I{} mv {} /tmp/bootstrap_backup/ 2>/dev/null || true
  printf "\n" | npm create vite@latest . -- --template react
  # Restore
  cp -r /tmp/bootstrap_backup/. . 2>/dev/null || true
  rm -rf /tmp/bootstrap_backup
else
  echo "→ [3/7] package.json existe, skip scaffold"
fi

# ── 4. Fichiers workflow ───────────────────────────────────
echo ""
echo "→ [4/7] Copie des fichiers workflow..."
mkdir -p .github/workflows
cp "$ROOT_DIR/.github/workflows/preview.yml" .github/workflows/
cp "$ROOT_DIR/Makefile" .

# .gitignore entries
grep -q "\.claude/" .gitignore 2>/dev/null || echo -e "\n.claude/" >> .gitignore
grep -q "^\.vercel$" .gitignore 2>/dev/null || echo ".vercel" >> .gitignore

# ── 5. npm install ─────────────────────────────────────────
echo ""
echo "→ [5/7] npm install..."
npm install

# ── 6. Commit initial ─────────────────────────────────────
echo ""
echo "→ [6/7] Commit initial..."
git config user.name "kevingaga"
git config user.email "kevingaga@users.noreply.github.com"
git branch -M main
git add .
git commit -m "chore: init React+Vite + preview deploy workflow" --allow-empty
git push -u origin main
echo "  ✓ Push effectué"

# ── 7. Vercel link + secrets ───────────────────────────────
echo ""
echo "→ [7/7] Lien Vercel..."
vercel link --yes --token="$VERCEL_TOKEN" 2>/dev/null || vercel link --token="$VERCEL_TOKEN"

ORG_ID=$(node -e "const f=require('./.vercel/project.json'); console.log(f.orgId)")
PROJECT_ID=$(node -e "const f=require('./.vercel/project.json'); console.log(f.projectId)")

echo "  Setting GitHub secrets..."
printf "%s" "$VERCEL_TOKEN"  | gh secret set VERCEL_TOKEN     --repo "kevingaga/$NAME"
printf "%s" "$ORG_ID"        | gh secret set VERCEL_ORG_ID    --repo "kevingaga/$NAME"
printf "%s" "$PROJECT_ID"    | gh secret set VERCEL_PROJECT_ID --repo "kevingaga/$NAME"
echo "  ✓ Secrets configurés"

# ── Register in projects.json ──────────────────────────────
node -e "
const fs = require('fs');
const p = '$ROOT_DIR/projects.json';
const data = JSON.parse(fs.readFileSync(p, 'utf8'));
if (!data.projects.find(x => x.name === '$NAME')) {
  data.projects.push({
    name: '$NAME',
    repo: 'kevingaga/$NAME',
    path: '$PROJECT_DIR',
    description: ''
  });
  fs.writeFileSync(p, JSON.stringify(data, null, 2) + '\n');
  console.log('  ✓ Enregistré dans projects.json');
}
"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅  $NAME est prêt !"
echo "  Path : $PROJECT_DIR"
echo "  Repo : https://github.com/kevingaga/$NAME"
echo ""
echo "  Test : cd $PROJECT_DIR && make preview MSG=\"feat: init\""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
