
# :whale: Docker - Time Manager Project
Ce fichier documente l'utilisation de Docker pour gérer les services backend (Phoenix) et frontend (Vue.js) avec plusieurs profils (dev et prod)

## :rocket:  Lancer le projet avec Docker Compose


Ce projet utilise Docker Compose pour orchestrer plusieurs services :

- PostgreSQL : Base de données.
- Adminer : Interface web pour gérer la base de données (profil dev).
- Backend Phoenix (Elixir) : API pour gérer les données.
- Frontend Vue.js (Vite) : Interface utilisateur.
## :construction: Lancer en mode développement

- Renseigner les fichiers .env.dev
- Créer un fichier .env.dev à la racine du répertoire :

 #### Fichier .env.dev
```sh
#BACK
POSTGRES_DB=
POSTGRES_USER=
POSTGRES_PASSWORD=
POSTGRES_HOST=
POSTGRES_PORT=
MIX_ENV=dev

#FRONT
VITE_BASE_URL=FRONT_URL
VITE_API_URL=BACK_URL
```
- Lancer / Arrêter  les services avec Docker Compose
```sh
docker compose --profile dev --env-file .env.dev up -d --build

docker compose --profile dev --env-file .env.dev down
```
 #### Accéder aux services

- Adminer : http://localhost:8080
- Frontend Vue.js : http://localhost:3000
- Backend Phoenix (API) : http://localhost:4000/api


## :construction: Lancer en mode production

- Renseigner les fichiers .env.prod
- Créer un fichier .env.prod à la racine du répertoire :

 #### Fichier .env.dev
```sh
POSTGRES_DB=
POSTGRES_USER=
POSTGRES_PASSWORD=
POSTGRES_HOST=
POSTGRES_PORT=
MIX_ENV=prod
SECRET_KEY_BASE= #clé secrete générée par mix phx.gen.secret
DATABASE_URL=ecto://user:password@host/database

#FRONT
VITE_BASE_URL=FRONT_URL
VITE_API_URL=BACK_URL/api
```
- Lancer / Arrêter  les services avec Docker Compose
```sh
docker compose --profile prod --env-file .env.prod up -d --build

docker compose --profile prod --env-file .env.prod down
```
 #### Accéder aux services

- Frontend Vue.js : http://time-manager.io:3000
- Backend Phoenix (API) : http://time-manager.io:4000/api
## :bookmark: FAQ
#### Comment générer une clé secrète pour Phoenix ?
```sh
mix phx.gen.secret
```
#### Comment s'assurer que le bon profil est utilisé lors du lancement ?
Utilisez le flag ``` --profile ``` avec Docker Compose et précisez le fichier .env avec ``` --env-file ```.