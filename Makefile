# ─────────────────────────────────────────────
#  Dispatch — preview deploy workflow
#  Usage : make preview MSG="description"
#          make preview-branch MSG="description"
#          make new-project NAME=my-app
# ─────────────────────────────────────────────

-include .env
export

BRANCH ?= preview/$(shell date +%Y%m%d-%H%M%S)
MSG    ?= "chore: preview deploy"
NAME   ?=

.PHONY: preview preview-branch status clean-previews new-project

## Crée une branche preview et push (déclenche le déploiement)
preview:
	@echo "→ Création de la branche $(BRANCH)"
	git checkout -b $(BRANCH) 2>/dev/null || git checkout $(BRANCH)
	git add -A
	git commit -m "$(MSG)" --allow-empty
	git push -u origin $(BRANCH)
	@echo ""
	@echo "✓ Push effectué. La preview sera disponible dans ~2 min."
	@echo "  Suivre : https://github.com/$(shell git remote get-url origin | sed 's/.*github.com[:/]//' | sed 's/.git//')/actions"

## Push sur une branche existante
preview-branch:
	git add -A
	git commit -m "$(MSG)" --allow-empty
	git push -u origin $(shell git branch --show-current)
	@echo "✓ Push effectué sur $(shell git branch --show-current)"

## Voir les derniers déploiements Vercel
status:
	@vercel ls --token=$(VERCEL_TOKEN) 2>/dev/null || echo "Installe vercel CLI : npm i -g vercel"

## Bootstrap un nouveau projet (repo GitHub + Vite + workflow + secrets Vercel)
new-project:
	@bash scripts/new-project.sh $(NAME)

## Supprimer les branches preview/* locales et distantes
clean-previews:
	@echo "Suppression des branches preview/* locales..."
	@git branch | grep 'preview/' | xargs -r git branch -D
	@echo "Suppression des branches preview/* distantes..."
	@git branch -r | grep 'origin/preview/' | sed 's/origin\///' | xargs -r -I{} git push origin --delete {}
	@echo "✓ Nettoyage terminé"
