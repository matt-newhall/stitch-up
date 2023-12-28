#!/bin/bash

# Script arguments
repoName=$1
isFullstack=$2

# Constants
tsConfig="tsconfig.json"

# Create fullstack directory
pnpm create vite $repoName --template react-ts
cd $repoName
pnpm add vite

# Initialise pnpm workspace
pnpm i
json -I -f "package.json" -e "this.scripts.preinstall='npx only-allow pnpm'"

# Exclude TS checking on node modules
sed '/\/\*/d' "$tsConfig" > temp_file && mv temp_file "$tsConfig"
json -I -f "$tsConfig" -e "this.exclude=['node_modules']"

# Update app version
json -I -f "package.json" -e "this.version='0.1.0'"

# Setup local VSCode settings
mkdir .vscode
cd .vscode
echo '{
  "editor.codeActionsOnSave": {
    "source.fixAll": true,
    "source.organizeImports": true
  },
  "editor.defaultFormatter": "esbenp.prettier-vscode"
}' > settings.json
cd ..

# Add Prettier
echo '{
  "arrowParens": "avoid",
  "bracketSpacing": true,
  "insertPragma": false,
  "jsxBracketSameLine": false,
  "jsxSingleQuote": false,
  "printWidth": 80,
  "proseWrap": "always",
  "quoteProps": "as-needed",
  "requirePragma": false,
  "semi": false,
  "singleQuote": false,
  "tabWidth": 2,
  "trailingComma": "all",
  "useTabs": false
}' > .prettierrc

# End script if frontend-only - continue if making a monorepo
if [ "$isFullstack" == "false" ]; then
  cd 'apps/frontend'
  pnpm add -D tailwindcss
  pnpm exec tailwindcss init
  echo "Repository created - happy developing!"
  exit 0
fi

# TODO: add support for fullstack
# # Move frontend to an apps/frontend location
# mkdir apps
# mkdir apps/frontend
# cp -r src ./apps/frontend/src
# cp -r public ./apps/frontend/public
# cp index.html ./apps/frontend/index.html
# rm -r src
# rm -r public
# rm index.html

# # Point vite config to the new path
# rm vite.config.js
# echo 'import { defineConfig } from "vite"
# import react from "@vitejs/plugin-react"

# export default defineConfig({
#   plugins: [react()],
#   root: 'apps/frontend/src',
# })' > vite.config.js

# # Update tsconfig with new frontend src/ folder location
# json -I -f "$repoName/tsconfig.json" -e "this.include=['apps/frontend/src']"
