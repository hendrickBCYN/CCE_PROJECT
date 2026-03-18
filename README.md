# CCE Project — EHPAD Room Configurator

Repository for **CCE (EHPAD Room Configurator)** project, a full-stack web application for configuring medical facility rooms with Unity WebGL 3D visualization and PDF floor plan generation.

> **CDA Context**: this project serves as the foundation for the *Concepteur Développeur d'Applications* professional certification (RNCP Level 6)


## Overview

The project is organized as a **mono-repo with Git submodules**, orchestrated by **Docker Compose** (3 containers):

```
CCE_PROJECT/
├── CCE_FRONTEND/          # Submodule — React + Vite + Unity WebGL application
├── CCE_BACKEND/           # Submodule — Node.js/Express REST API + Sequelize
├── docker-compose.yml     # Orchestration of 3 services (frontend, backend, db)
├── .gitmodules            
├── .gitignore             
└── README.md
```


## Software Architecture

The application follows a containerized **3-tier architecture**:

| Layer | Role | Technologies |
|-------|------|--------------|
| **Presentation** | User interface + 3D Configurator | React 19, Vite, react-router-dom, react-unity-webgl, Unity 2022.3 WebGL |
| **Business Logic** | REST API, authentication, CRUD logic | Node.js, Express 5, google-auth-library, jsonwebtoken, cors |
| **Persistence** | Data storage | MySQL 8.0, Sequelize 6 ORM, persistent Docker volume |

**Cross-cutting security**: Google OAuth 2.0 (SSO), JWT (stateless authentication), CORS (restrictive policy).

**Unity ↔ React communication**: bidirectional bridge via `ReactBridge.jslib` (Unity → React) and `sendMessage` (React → Unity), managed by `NetworkManager.cs` on the Unity side and the `useUnity` hook on the React side.


## Stack

| Component | Technology | Version |
|-----------|------------|---------|
| Frontend | React | 19.x |
| Bundler | Vite | 7.x |
| Routing | react-router-dom | 7.x |
| Google Auth (client) | @react-oauth/google | 0.13.x |
| HTTP Client | Axios | 1.13.x |
| 3D Integration | react-unity-webgl | 10.1.x |
| 3D Engine | Unity | 2022.3 (WebGL) |
| Backend | Express | 5.x |
| ORM | Sequelize | 6.x |
| DBMS | MySQL | 8.0 |
| Google Auth (server) | google-auth-library | 10.x |
| JWT | jsonwebtoken | 9.x |
| Containerization | Docker + Docker Compose | — |


## Prerequisites

- **Node.js** ≥ 20 and **npm** ≥ 9
- **Docker** and **Docker Compose** (for containerized deployment)
- **MySQL 8.0** (if running locally without Docker)
- A **Google OAuth 2.0 Client ID** (Google Cloud Console)
- A **Unity WebGL build** placed in `CCE_FRONTEND/public/unity-build/Build/`


## Quick Start

### 1. Clone with submodules

```bash
git clone --recurse-submodules https://github.com/hendrickBCYN/CCE_PROJECT.git
cd CCE_PROJECT
```

If the repository was already cloned without submodules:

```bash
git submodule init
git submodule update
```

### 2. Launch with Docker Compose

```bash
# Set the Google Client ID
export GOOGLE_CLIENT_ID=your-google-client-id.apps.googleusercontent.com

# Start all 3 services
docker-compose up --build
```

| Service | Exposed Port | Description |
|---------|-------------|-------------|
| `db` | `3307` → 3306 | MySQL 8.0 (`cce_db` database) |
| `backend` | `3001` → 3000 | Express API |

### 3. Local development (without Docker)

**Backend**:

```bash
cd CCE_BACKEND
npm install
cp .env.example .env    # Fill in DB_PASSWORD, JWT_SECRET, GOOGLE_CLIENT_ID
npm run dev             # Starts on port 3000
```

**Frontend**:

```bash
cd CCE_FRONTEND
npm install
cp env.example .env     # Fill in VITE_GOOGLE_CLIENT_ID
npm run dev             # Starts on port 5173
```

The Vite proxy automatically forwards `/api` requests to `http://localhost:3000`.


## Environment Variables

### Frontend (`CCE_FRONTEND/.env`)

| Variable | Description |
|----------|-------------|
| `VITE_GOOGLE_CLIENT_ID` | Google OAuth 2.0 Client ID |
| `VITE_API_URL` | Backend API URL (default: `http://localhost:3000/api`) |

### Backend (`CCE_BACKEND/.env`)

| Variable | Description |
|----------|-------------|
| `PORT` | Express server port (default: `3000`) |
| `DB_HOST` | MySQL host (default: `localhost`, Docker: `db`) |
| `DB_PORT` | MySQL port (default: `3306`) |
| `DB_NAME` | Database name (default: `cce_db`) |
| `DB_USER` | MySQL user |
| `DB_PASSWORD` | MySQL password |
| `JWT_SECRET` | JWT signing secret |
| `GOOGLE_CLIENT_ID` | Google OAuth 2.0 Client ID |


## API Endpoints

### Authentication

| Method | Route | Description | Auth |
|--------|-------|-------------|:----:|
| `POST` | `/api/auth/google` | Login via Google credential → application JWT | No |
| `GET` | `/api/auth/verify` | Verify JWT validity | Yes | 

### Configurations

| Method | Route | Description | Auth |
|--------|-------|-------------|:----:|
| `GET` | `/api/configurations` | List the authenticated user's configurations | Yes |
| `GET` | `/api/configurations/:id` | Retrieve a configuration by ID | Yes |
| `POST` | `/api/configurations` | Create a new configuration | Yes | 


## Data Model

Two entities linked by a **0:N** relationship (one user owns 0 to N configurations):

| Table | Main Fields |
|-------|-------------|
| **users** | `id`, `google_id`, `email`, `display_name`, `avatar_url`, `role`, `created_at`, `updated_at` |
| **configurations** | `id`, `user_id` (FK), `name`, `unity_data` (JSON), `is_latest`, `created_at`, `updated_at` |


## Submodule Management

```bash
# Update submodules to their latest version
git submodule update --remote

# After pulling the parent repository
git submodule update --init --recursive
```

Each submodule points to its own GitHub repository with its own commit history, branches, and README:

| Submodule | Repository |
|-----------|------------|
| `CCE_FRONTEND` | [hendrickBCYN/CCE_FRONTEND](https://github.com/hendrickBCYN/CCE_FRONTEND) |
| `CCE_BACKEND` | [hendrickBCYN/CCE_BACKEND](https://github.com/hendrickBCYN/CCE_BACKEND) |


## Planned Improvements

- **Configuration management UI**: full CRUD on the React side (list, select, delete)
- **CI/CD**: continuous integration pipeline 
