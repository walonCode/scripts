#!/usr/bin/env bash

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

if ! "${PACKAGE_MANAGER[$found_tool]} create hono@latest $project_name"; then
    echo "fail to create the hono app"
fi

# moving in to the project root dir 
cd "$BASE_DIR/$project_name"

# adding zod, drizzle stuff bun-types
if ! "${PACKAGE_MANAGER[$found_tool]} add zod drizzle-orm pg"; then
    echo "fail to install zod, drizzle-orm pg"
    exit 1
fi

if ! "${PACKAGE_MANAGER[$found_tool]} -D add bun-types @biomejs/biome drizzle-kit @types/pg"; then
    echo "fail to install bun-types drizzle-kit @biomejs/biome and @types/pg"
    exit 1
fi

#setting up biome
if ! "${PACKAGE_MANAGER[$found_tool]} exec biome init"; then
    echo "fail to initialize biome"
    exit 1
fi

# adding the test dir 

if ! mkdir test; then
    echo "fail to create the test dir"
    exit 1
fi 

# adding the .gitignore, env and env.example drizzle.config.ts, docker-compose.yml
if ! touch .gitignore .env .env.example drizzle.config.ts docker-compose.yml; then
    echo "fail to create needed files"
    exit 1
fi    

#moving in to the test dir
cd test

if ! mkdir unit e2e; then
    echo "fail to create the unit and e2e dir"
    exit 1
fi

# moving to root of the project again
cd ../

#making the different folders in the src

cd src/

if ! mkdir validator routes db middlewares lib types scripts utils; then
    echo "fail to create the validator routes types scripts db middleware libs and utils folders"
    exit 1
fi    
