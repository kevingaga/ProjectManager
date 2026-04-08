# Setup preview deploy — React (Vite) + Vercel + GitHub Actions

## 1. Copier les fichiers dans votre projet

```
votre-projet/
├── .github/
│   └── workflows/
│       └── preview.yml   ← copier ici
└── Makefile              ← copier à la racine
```

## 2. Récupérer vos IDs Vercel

### VERCEL_TOKEN
→ https://vercel.com/account/tokens
→ "Create Token" → donner un nom → copier la valeur

### VERCEL_ORG_ID + VERCEL_PROJECT_ID (méthode fiable)

Plutôt que de chercher les IDs manuellement, utiliser `vercel link` :

```bash
npm i -g vercel
vercel link   # se connecter + sélectionner le projet existant
cat .vercel/project.json
```

Le fichier retourne exactement :
```json
{
  "projectId": "prj_xxxx",   ← VERCEL_PROJECT_ID
  "orgId":     "xxxx"        ← VERCEL_ORG_ID
}
```

> `.vercel/` est gitignore — ne jamais committer ce fichier.

## 3. Ajouter les secrets GitHub

Dans votre repo GitHub :
→ Settings → Secrets and variables → Actions → "New repository secret"

Ajouter les 3 secrets :
- `VERCEL_TOKEN`    = valeur copiée à l'étape 2
- `VERCEL_ORG_ID`  = valeur copiée à l'étape 2
- `VERCEL_PROJECT_ID` = valeur copiée à l'étape 2

## 4. Vérifier votre vite.config.js

Assurez-vous que votre build output est bien `dist/` :
```js
// vite.config.js
export default {
  build: {
    outDir: 'dist'   // doit correspondre à ce que Vercel attend
  }
}
```

## 5. Utilisation au quotidien

```bash
# Déployer depuis le PC (crée une branche + push automatiquement)
make preview MSG="feat: nouvelle page home"

# Push rapide sur la branche courante
make preview-branch MSG="fix: correction bouton"

# Nettoyer les vieilles branches preview
make clean-previews
```

## Ce qui se passe ensuite

1. GitHub Actions se déclenche (~30 sec)
2. `npm ci` + `npm run build` (~1-2 min)
3. Deploy sur Vercel (~30 sec)
4. Un commentaire apparaît sur la PR avec l'URL
5. Vous ouvrez le lien depuis votre mobile

## Workflow complet avec Claude

```
Claude génère le code
       ↓
Vous copiez dans votre projet local
       ↓
make preview MSG="feat: ce que claude a fait"
       ↓
2 min plus tard → lien dans la PR → test mobile
```
