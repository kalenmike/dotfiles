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

echo "✅ Project $PROJECT_NAME is ready!"
echo "Next steps: cd $PROJECT_NAME && pnpm dev"
