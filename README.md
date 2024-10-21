# Time Manager

[![Build Status](https://img.shields.io/github/actions/workflow/status/xRezio/LIL10-time-manager-CI/ci.yml?branch=main&style=flat-square)](https://github.com/xRezio/LIL10-time-manager-CI/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/xrezio/app-backend?style=flat-square)](https://hub.docker.com/r/xrezio/app-backend)
[![Docker Frontend Pulls](https://img.shields.io/docker/pulls/xrezio/app-frontend?style=flat-square)](https://hub.docker.com/r/xrezio/app-frontend)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-v13-blue?style=flat-square)](https://www.postgresql.org)
[![Elixir](https://img.shields.io/badge/Elixir-v1.12.3-purple?style=flat-square)](https://elixir-lang.org)
[![Vue.js](https://img.shields.io/badge/Vue.js-v3.5.10-green?style=flat-square)](https://vuejs.org)

## Description

Time Manager is a powerful tool designed to manage working times and user clocks. It provides a structured API backend using Elixir and Phoenix, along with a Vue.js-powered frontend for seamless user experience.

The application uses:
- **Backend:** Elixir and Phoenix Framework
- **Frontend:** Vue.js 3
- **Database:** PostgreSQL

## Features

- User and Clock management
- Working time tracking
- JWT-based authentication
- CI/CD pipelines integrated with Docker and GitHub Actions
- PostgreSQL database with relational mappings
- Vue.js frontend with a responsive UI

## Architecture

The system is composed of:
- **Backend Service:** Provides RESTful APIs built in Elixir using the Phoenix Framework.
- **Frontend Service:** A Vue.js application served with Nginx.
- **Database:** PostgreSQL for relational data storage.

## Installation

### Prerequisites

- Docker
- Docker Compose
- PostgreSQL

### Steps to Run Locally

1. **Clone the repository:**

   ```bash
   git clone git@github.com:xRezio/LIL10-time-manager-CI.git
   cd LIL10-time-manager-CI
   ```

2. **Setup environment variables:**

Create a .env file based on .env.example and fill in the necessary environment variables.

3. **Build and run the services using Docker Compose:**

    ```bash
    docker-compose --profile dev up -d --build
    ```

4. **Run migrations (for the backend service):**

    ```bash
    docker-compose exec app mix ecto.create
    docker-compose exec app mix ecto.migrate
    ```

5. **Access the application:**
   - **Backend:** [http://localhost:4000](http://localhost:4000)
   - **Frontend:** [http://localhost:3000](http://localhost:3000)

## CI/CD Pipeline

This project is configured to automatically build and deploy via GitHub Actions and Docker Hub.

- **Build & Push Images:** Every push to `main` triggers a GitHub Action that builds and pushes Docker images for both backend and frontend.
- **Deployment:** After a successful build, the app is deployed using Docker Compose on a Google Cloud VM.