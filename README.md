# Sawti صوتي 🗳️
**Vote électronique sécurisé — CENI Mauritanie**

Application Flutter bilingue (Français / Arabe) pour la gestion du vote électronique.

## 🌐 Application en ligne
> **[https://mohamedoubabe9.github.io/sawti_v2/](https://mohamedoubabe9.github.io/sawti_v2/)**

---

## ⚙️ Stack technique
| Couche | Technologie |
|--------|------------|
| Frontend | Flutter 3.22 (Web + Android) |
| Backend | Supabase (PostgreSQL + Auth) |
| Auth | OTP par SMS (Supabase + Twilio) |
| Cartes | Google Maps Flutter |
| Déploiement | GitHub Actions → GitHub Pages |

---

## 🚀 Installation locale

```bash
# 1. Cloner
git clone https://github.com/mohamedoubabe9/sawti_v2.git
cd sawti_v2

# 2. Configurer l'environnement
cp .env.example .env
# Remplir SUPABASE_URL et SUPABASE_ANON_KEY

# 3. Lancer
flutter pub get
flutter run -d chrome
```

## 🗄️ Base de données
Exécuter `supabase_schema.sql` dans le SQL Editor de votre projet Supabase.

---

*Développé pour la CENI Mauritanie — 2026*
