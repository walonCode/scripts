#!/usr/bin/env bash
set -e

# checking we the user has bun or node or deno install

declare -A INSTALL_HINTS=(
    [node]="https://node.org"
    [bun]="https://bun.sh"
)

declare -A PACKAGE_MANAGER=(
    [node]="pnpm"
    [bun]="bunx"
)

project_name="${1:-.}"
project_name="${project_name// /-}"

TOOLS=(node bun deno)
found=false

found_tool=""
BASE_DIR="$(pwd)"

for tool in "${TOOLS[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        found=true
        found_tool="$tool"
        break
    fi
done

if ! $found;then
    for tool in "${TOOLS[@]}";do
        echo "$tool missing, download from -> ${INSTALL_HINTS[$tool]}"
    done
    exit 1
fi
    
 # install the nextjs using it cli 

if ! "${PACKAGE_MANAGER[$found_tool]}" create next-app@latest "$project_name"; then
     echo "create-next-app failed"
     exit 1
fi

cd "$BASE_DIR/$project_name"

#adding the tools i need
if ! mkdir db validators; then 
    echo "failed to create the db and validator dir"
    exit 1
fi

cd db

#adding the setup for postgres sql
# drizzle
cat <<EOF > drizzle.ts
import { drizzle } from "drizzle-orm/node-postgres";
import { Pool } from "pg";
import * as schema from "@/db/schema";

const pool = new Pool({
	connectionString: process.env.DATABASE_URL,
});

export const db = drizzle(pool, { schema, casing: "snake_case" });
EOF

#demo schema
cat <<EOF > schema.ts
import { pgTable } from "drizzle-orm/pg-core"

export const userTable = pgTable("user_table",{});
EOF

# going back to home
cd ../

# adding the tool to use drizzle and postgres sql with docker
if ! pnpm add pg drizzle-orm; then
    echo "fail to add pg and drizzle-orm"
    exit 1
fi    

if ! pnpm add -D drizzle-kit @types/pg; then
    echo "fail to add drizzle-ki and @types/pg"
    exit 1
fi

#adding the docker-compose file
touch docker-compose.yml


# adding the drizzle config file
cat <<EOF > drizzle.config.ts
import { defineConfig } from "drizzle-kit";
export default defineConfig({
	out: "./src/db/migrations",
	schema: "./src/db/schema.ts",
	dialect: "sqlite",
	strict: true,
	verbose: true,
	dbCredentials: {
	    url:process.env.DATABASE_URL
	},
});
EOF

#
