#!/usr/bin/env bash

# Check if a name was provided
if [ -z "$1" ]; then
    echo "Usage: ./setup-next.sh <project-name>"
    exit 1
fi

PROJECT_NAME=$1

echo "🚀 Creating Next.js project: $PROJECT_NAME..."

# 1. Create Next.js project with recommended defaults
# --yes uses: TS, ESLint, Tailwind, App Router, src/ directory, and Turbopack
npx create-next-app@latest "$PROJECT_NAME" --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --use-pnpm --yes

cd "$PROJECT_NAME" || exit

echo "🧹 Gutting the template site..."

# 1. Reset the global CSS to just Tailwind directives
cat <<EOF >src/app/globals.css
@import "tailwindcss";

:root {
  --foreground-rgb: 0, 0, 0;
  --background-start-rgb: 214, 219, 220;
  --background-end-rgb: 255, 255, 255;
}

body {
  color: rgb(var(--foreground-rgb));
  background: white;
}
EOF

# 2. Create a clean, empty root page
cat <<EOF >src/app/page.tsx
export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <h1 className="text-4xl font-bold">Project Ready</h1>
      <p className="mt-4 text-muted-foreground">Lets Get Building</p>
    </main>
  )
}
EOF

# 3. Delete the default favicon and public assets if you want a total fresh start
rm -f public/next.svg public/vercel.svg public/file.svg public/globe.svg public/window.svg

# 2. Install Dependencies
echo "📦 Installing Prettier, Husky, and lint-staged..."
pnpm add -D husky lint-staged prettier eslint-config-prettier

npx husky init

# 3. Configure Prettier
cat <<EOF >.prettierrc
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "es5",
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false
}
EOF

# 4. Create the lint-staged configuration file
cat <<EOF >.lintstagedrc.json
{
  "src/**/*.{js,jsx,ts,tsx}": [
    "eslint --fix",
    "prettier --write"
  ]
}
EOF

# 5. Setup Husky Hooks
echo "🪝 Setting up Husky hooks..."

# Update the husky pre-commit hook to run lint-staged
echo "npx lint-staged" >.husky/pre-commit

# Pre-push: Run build to ensure nothing is broken
cat <<EOF >.husky/pre-push
#!/bin/sh
. "\$(dirname "\$0")/_/husky.sh"

echo "Checking build before push..."
pnpm build
EOF
chmod +x .husky/pre-push

echo "⌨️ Adding type-check scripts..."

# We use 'tsc --noEmit' for type checking.
# We also create a 'check' command that runs both linting and typing.
cat <<EOF >scripts-patch.json
{
  "dev": "next dev",
  "build": "next build",
  "start": "next start --port 4000",
  "lint": "next lint",
  "type-check": "tsc --noEmit",
  "typecheck": "pnpm type-check",
  "check": "pnpm lint && pnpm type-check",
  "prepare": "husky"
}
EOF

# Use node to merge the scripts back into package.json safely
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
const newScripts = JSON.parse(fs.readFileSync('scripts-patch.json', 'utf8'));
pkg.scripts = { ...pkg.scripts, ...newScripts };
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
"
rm scripts-patch.json

# 3. Overwrite ESLint with specific rules
# Next.js 15+ uses the new Flat Config (eslint.config.mjs)
echo "🔧 Applying custom ESLint rules..."
cat <<EOF >eslint.config.mjs
import { dirname } from "path";
import { fileURLToPath } from "url";
import { FlatCompat } from "@eslint/eslintrc";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const compat = new FlatCompat({
  baseDirectory: __dirname,
});

const eslintConfig = [
  ...compat.extends("next/core-web-vitals", "next/typescript"),
  {
    rules: {
      "no-console": "warn",
      "prefer-const": "error",
      "@typescript-eslint/no-explicit-any": "error",
      "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
      "react/self-closing-comp": "error",
      "max-lines": [
        "error",
        {
          max: 200,
          skipBlankLines: true,
          skipComments: true,
        },
      ],
    },
  },
];

export default eslintConfig;
EOF

cat <<EOF >.agentrules
# Project Standards
- Architecture: Next.js 16 (App Router), Tailwind CSS, TypeScript.
- Tech Stack: shadcn/ui for components, CSS for animations.
- Rules:
  - Always use 'pnpm' for package management.
  - No 'any' types; strictly define interfaces.
  - 200 maximum lines per file, modulize and use components.
  - Use 'lucide-react' for all iconography.
  - When creating new components, place them in 'src/components/'.
  - Always run 'pnpm type-check' and 'pnpm lint' to verify your work.
EOF

cat <<EOF >.agentignore
.next/
node_modules/
.pnpm-store/
*.tsbuildinfo
EOF

# Update README with a "Project Map" for Agent Context
cat <<EOF >README.md
# ${PROJECT_NAME}

## 🏗 Project Map
- \`src/app\`: Routing & Server components.
- \`src/components\`: UI & Feature components.
- \`src/lib\`: Shared utilities.
- \`src/hooks\`: React hooks.

## 🛠 Commands
- \`pnpm dev\`: Run with Turbopack.
- \`pnpm build\`: Production build & Type check.
EOF

echo "🎬 Reseting Git repository..."
rm -rf .git
git init >/dev/null
git add . >/dev/null
git commit -m "chore: initial setup" >/dev/null

echo "✅ Project $PROJECT_NAME is ready!"
echo "Next steps: cd $PROJECT_NAME && pnpm dev"
