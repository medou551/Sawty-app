#!/bin/bash
# ============================================================
#  SAWTI صوتي — Script de déploiement GitHub
#  Usage : bash setup_github.sh
# ============================================================

set -e

GITHUB_USER="mohamedoubabe9"         # votre compte GitHub
REPO_NAME="sawti_v2"
GITHUB_EMAIL="mohamedoubabe9@gmail.com"
REMOTE_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  Sawti صوتي — Setup GitHub + Deploy  ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── 1. Vérifier Git ─────────────────────────────────────────
if ! command -v git &> /dev/null; then
  echo "❌ Git non installé. Installez-le sur https://git-scm.com"
  exit 1
fi
echo "✅ Git détecté"

# ── 2. Configurer Git ───────────────────────────────────────
git config --global user.email "$GITHUB_EMAIL"
git config --global user.name "$GITHUB_USER"
echo "✅ Git configuré pour $GITHUB_EMAIL"

# ── 3. Initialiser le dépôt ─────────────────────────────────
if [ ! -d ".git" ]; then
  git init
  echo "✅ Dépôt Git initialisé"
else
  echo "✅ Dépôt Git existant détecté"
fi

# ── 4. Créer .gitignore ─────────────────────────────────────
cat > .gitignore << 'GITIGNORE'
# Flutter
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.pub-cache/
.pub/
build/

# Environnement (NE PAS commiter les secrets !)
.env

# IDE
.idea/
.vscode/
*.iml

# OS
.DS_Store
Thumbs.db
GITIGNORE
echo "✅ .gitignore créé (le fichier .env est protégé)"

# ── 5. Premier commit ────────────────────────────────────────
git add .
git commit -m "🚀 feat: Migration Supabase complète — Sawti v2 bilingue" 2>/dev/null || \
git commit --allow-empty -m "🚀 feat: Migration Supabase complète — Sawti v2 bilingue"
echo "✅ Commit initial créé"

# ── 6. Connecter au dépôt GitHub ────────────────────────────
if git remote get-url origin &>/dev/null; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi
git branch -M main
echo "✅ Remote configuré : $REMOTE_URL"

# ── 7. Push ─────────────────────────────────────────────────
echo ""
echo "📤 Envoi vers GitHub..."
echo "   (GitHub va demander votre mot de passe ou token personnel)"
echo "   → Créez un token sur : https://github.com/settings/tokens/new"
echo "     (cochez : repo + workflow)"
echo ""
git push -u origin main

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ Code envoyé sur GitHub !                         ║"
echo "║                                                      ║"
echo "║  Prochaines étapes dans GitHub :                     ║"
echo "║  1. Settings → Pages → Source: GitHub Actions        ║"
echo "║  2. Settings → Secrets → Actions → ajouter :         ║"
echo "║       SUPABASE_URL                                   ║"
echo "║       SUPABASE_ANON_KEY                              ║"
echo "║       MAPS_API_KEY                                   ║"
echo "║  3. Le déploiement démarre automatiquement !         ║"
echo "║                                                      ║"
echo "║  🌐 URL finale :                                     ║"
echo "║  https://mohamedoubabe9.github.io/sawti_v2/          ║"
echo "╚══════════════════════════════════════════════════════╝"
