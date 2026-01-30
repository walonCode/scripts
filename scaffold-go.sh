#!/usr/bin/env bash

if ! command -v go >/dev/null 2>&1; then 
    echo "go not found, please install"
    exit 1
fi

BASE_DIR="$(pwd)"

project_name="${1:-.}"
project_name="${project_name// /-}"

# make the dir
if ! mkdir $project_name; then
    echo "fail to make the project directory"
    exit 1
fi    

# moving in to that dir
cd "$BASE_DIR/$project_name"

#initializing the go project 
if ! go mod init "$project_name"; then
    echo "fail to initialized the project"
    exit 1
fi

# making the folder structure
if ! mkdir cmd internal pkg; then
    echo "fail to create the folder"
    exit 1
fi

# moving in to cmd
cd cmd

if mkdir server; then
    cd server && touch main.go
    cd ../
fi

#exiting cmd
cd ../

# moving it to internal
cd internal && if ! mkdir handlers services dto respository model config; then 
    echo "fail to create the folder in internal"
    exit 1
fi

# exiting internal
cd ../

# moving in to pkg 
cd pkg && if ! mkdir logger middleware utils; then 
    echo "fail to create the folder in pkg"
    exit 1
fi

# exiting pkg
cd ../

# creating .gitignore docker-compose .env .env.example
if ! touch .gitignore docker-compose.yml .env .env.example; then 
    echo "fail to create the need files"
    exit 1
fi

cat <<EOF > .gitignore
.env
temp/
vendor/
EOF


# installing the need go module
packages=(github.com/gin-gonic/gin@latest github.com/golang-jwt/jwt/v5@latest github.com/jackc/pgx/v5@latest github.com/joho/godotenv@latest)

for package in "${packages[@]}"; do
    if ! go get "$package"; then
        echo "fail to install $package"
        exit 1
        break
    fi
done    

echo ".............................................."
echo "................Go/Gin APP Created............"
echo ".............................................."