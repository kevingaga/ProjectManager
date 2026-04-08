# ProjectManager

Hub de gestion des projets — deploy preview mobile-first via Claude + Vercel + GitHub Actions.

## Architecture

```
kevingaga/ProjectManager   ← ce repo (hub, templates, registry)
kevingaga/clash-game       ← jeu Clash — mécaniques de map
kevingaga/...              ← futurs projets
```

Chaque projet est un repo indépendant avec React+Vite, le même workflow de preview, et ses propres secrets Vercel.

## Workflow quotidien

```
Claude modifie le code dans un projet
              ↓
cd mon-projet && make preview MSG="feat: ..."
              ↓
        ~2 min
              ↓
URL Vercel dans la PR → test sur mobile
```

## Commandes

### Dans n'importe quel projet

```bash
# Nouvelle branche preview + push (usage principal)
make preview MSG="feat: ajout fonctionnalité"

# Push rapide sur la branche courante
make preview-branch MSG="fix: correction bug"

# Nettoyer les vieilles branches preview/*
make clean-previews
```

### Dans ProjectManager (hub)

```bash
# Bootstrapper un nouveau projet complet
make new-project NAME=mon-app
# → crée repo GitHub + clone + React+Vite + workflow + secrets Vercel
```

## Projets actifs

Voir [projects.json](projects.json) pour la liste complète.

| Projet | Repo | Description |
|--------|------|-------------|
| clash-game | [kevingaga/clash-game](https://github.com/kevingaga/clash-game) | Jeu Clash — mécaniques de map modulable |

## Prérequis

- Node.js 20+
- Git
- `make` — [GnuWin32](https://gnuwin32.sourceforge.net/packages/make.htm) (Windows)
- `gh` CLI — `winget install GitHub.cli`
- `vercel` CLI — `npm i -g vercel`

## Setup d'un nouveau projet

Voir [SETUP.md](SETUP.md) pour le guide complet.

```bash
make new-project NAME=mon-app
```
