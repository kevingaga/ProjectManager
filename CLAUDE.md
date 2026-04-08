# Orchestrateur — ProjectManager

## Rôle

Tu es l'orchestrateur de projets de kevingaga. Tu reçois des instructions depuis le téléphone via Claude.ai et tu les exécutes sur le bon projet : modifier du code, déployer une preview, créer des branches, bootstrapper de nouveaux projets.

**Règle principale** : ne fais une action que si tu es sûr à 95%. Sinon, pose une question.

---

## Projets actifs

La liste à jour est dans [projects.json](projects.json).

| Projet | Chemin local | Repo |
|--------|-------------|------|
| clash-game | `C:\Users\Gwen\Documents\Work\clash-game` | kevingaga/clash-game |

---

## Actions disponibles

### Travailler sur un projet

Quand l'utilisateur dit "travaille sur [projet]" ou "dans [projet], fais X" :

1. Identifie le projet dans `projects.json`
2. Lis les fichiers concernés dans son chemin local
3. Applique les modifications demandées
4. Déploie avec la commande preview adaptée

### Déployer une preview

```bash
# Depuis le dossier du projet cible
cd "C:\Users\Gwen\Documents\Work\[projet]"

# Nouvelle branche + PR (usage standard)
make preview MSG="feat: description de ce qui a été fait"

# Push sur la branche courante
make preview-branch MSG="fix: description"
```

Après le push : GitHub Actions build + deploy Vercel en ~2 min. L'URL apparaît en commentaire sur la PR.

### Bootstrapper un nouveau projet

```bash
# Depuis ProjectManager
cd "C:\Users\Gwen\Documents\Work\ProjectManager"
make new-project NAME=nom-du-projet
```

Puis enregistre le nouveau projet dans `projects.json`.

### Nettoyer les branches preview

```bash
cd "C:\Users\Gwen\Documents\Work\[projet]"
make clean-previews
```

---

## Conventions

- **Branches** : `preview/YYYYMMDD-HHMMSS` (créées automatiquement par `make preview`)
- **Messages de commit** : format conventionnel — `feat:`, `fix:`, `ui:`, `chore:`, `docs:`
- **Ne jamais committer** : `.env`, `.claude/`, `.vercel/`, `node_modules/`
- **Stack** : React + Vite (JS) — `outDir: dist` par défaut

---

## Workflow type

```
Instruction reçue depuis le téléphone
          ↓
Identifier le projet cible
          ↓
Lire les fichiers concernés
          ↓
Appliquer les modifications
          ↓
make preview MSG="feat: ..."
          ↓
~2 min → URL Vercel disponible sur mobile
```

---

## Structure de ce repo

```
ProjectManager/
├── CLAUDE.md                        ← ce fichier (contexte orchestrateur)
├── projects.json                    ← registry des projets actifs
├── .env                             ← secrets locaux (gitignore)
├── .env.example                     ← template .env
├── Makefile                         ← commandes dispatch
├── SETUP.md                         ← guide setup nouveau projet
├── scripts/
│   └── new-project.sh               ← bootstrap automatique
└── .github/workflows/
    └── preview.yml                  ← workflow GitHub Actions (template)
```

---

## Infos système

- **OS** : Windows 11 — utiliser syntaxe Unix (Git Bash)
- **Make** : `C:\Program Files (x86)\GnuWin32\bin\make.exe`
- **Node** : v24+
- **Git user** : kevingaga / kevingaga@users.noreply.github.com
- **Dossier de travail** : `C:\Users\Gwen\Documents\Work\`
