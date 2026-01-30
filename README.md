
# Project scaffolding scripts

This repository contains small shell scripts to quickly scaffold starter projects for common stacks.

Prerequisites
- Bash (Unix-like environment)
- `git` (recommended)
- For Go scaffolding: `go` (>=1.20)
- For Hono/Next scaffolding: `node` or `bun` (the scripts prefer `pnpm` when using Node or `bunx` when using Bun)

Make scripts executable (once):

```bash
chmod +x scaffold-go.sh scaffold-honjs.sh scaffold-nextjs.sh
```

Usage
- Scaffold a Go/Gin app:

```bash
./scaffold-go.sh my-go-app
```

- Scaffold a Hono app (uses `pnpm` or `bunx` depending on environment):

```bash
./scaffold-honjs.sh my-hono-app
```

- Scaffold a Next.js app (uses `pnpm` or `bunx` depending on environment):

```bash
./scaffold-nextjs.sh my-next-app
```

What each script does
- `scaffold-go.sh`: initializes a Go module, creates `cmd`, `internal`, and `pkg` layouts, creates `.env`/`.env.example`/`.gitignore` and a `docker-compose.yml`, and installs common packages (Gin, jwt, pgx, godotenv).
- `scaffold-honjs.sh`: bootstraps a Hono project via `pnpm`/`bunx`, installs `zod`, `drizzle-orm`, sets up `biome` and testing folders, and creates a recommended `src` layout plus DB files.
- `scaffold-nextjs.sh`: creates a Next.js app via `pnpm`/`bunx`, adds `db`, `validators`, and `test` folders, scaffolds example `drizzle` DB files and a `docker-compose.yml`, and installs DB/test tooling.

Notes & tips
- The scripts check for required CLI tools and will print install hints if missing.
- Provide a project name as the first argument; otherwise `.` (current directory) is used.
- Inspect each script before running if you need to customize dependencies or directories.

License
See the LICENSE file in the repository.

Issues or contributions
- Open an issue or submit a PR with improvements or fixes to the scripts.
