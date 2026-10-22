# Bulo App Specifications
A photo-sharing app for close friends, inspired by Locket. Snap a photo and it lands straight on your friends' home-screen widget.

Bulo is a personal full-stack project: a React Native (Expo) app plus its own backend, built from scratch to practise real-world software engineering, from database design and auth to file uploads, testing, CI and deployment.

## Features (planned)
- Accounts with secure auth (hashed passwords, short-lived JWT access tokens, rotating refresh tokens)
- Friend requests and friendships
- Photo sharing via direct-to-storage presigned uploads, fanned out to each friend's feed
- A fast, cursor-paginated feed
- A home-screen widget showing your friends' latest photo

## Tech stack
- **Backend:** Node.js, TypeScript, Express 5, PostgreSQL (raw SQL with `pg`, no ORM), zod
- **Mobile:** Expo (React Native), TypeScript
- **Storage:** S3-compatible object storage (MinIO locally)
- **Tooling:** Docker Compose, node-pg-migrate, Vitest + Supertest, GitHub Actions

## Status
Work in progress. The database schema is done; the server skeleton is next.

## License
MIT