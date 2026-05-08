import pkg from 'enquirer'
const { Select, Input } = pkg as any
import { execSync } from 'child_process'
import fs from 'fs'
import * as dotenv from 'dotenv'

// Load environment variables from .env
dotenv.config()

const PROJECT_ID = process.env.SUPABASE_PROJECT_REF || ''

const patchGeneratedSchema = (filePath: string) => {
  console.log(`\n> Patching Generated Schema: ${filePath}`)
  let content = fs.readFileSync(filePath, 'utf8')
  let modified = false

  // 1. Add the Import if missing
  const importLine = `import { users } from './references';\n`
  if (!content.startsWith('import { users }')) {
    content = importLine + content
    console.log('> Prepended import.')
    modified = true
  }

  // 2. Fix the Drizzle "securityInvoker" string-to-boolean issue
  // Matches: .with({"securityInvoker":"on"})
  // Replaces with: .with({ securityInvoker: true })
  const securityInvokerRegex = /\.with\({"securityInvoker":"on"}\)/g

  if (securityInvokerRegex.test(content)) {
    content = content.replace(securityInvokerRegex, '.with({ securityInvoker: true })')
    console.log('> Patched securityInvoker types.')
    modified = true
  }

  // 3. Write back only if changes were made
  if (modified) {
    fs.writeFileSync(filePath, content)
    console.log('> File updated successfully.')
  } else {
    console.log('> No changes needed.')
  }
}

const run = (command: string) => {
  try {
    console.log(`\n> Executing: ${command}\n`)
    // 'inherit' ensures you see the Supabase CLI output/spinners
    execSync(command, { stdio: 'inherit' })
  } catch (error) {
    console.error(`\n× Command failed: ${error}`)
  }
}

/**
 * Clears the terminal screen entirely
 */
const clear = () => {
  process.stdout.write('\x1Bc')
}

/**
 * Clears a specific number of lines from the terminal upwards
 */
const clearLines = (count: number) => {
  for (let i = 0; i < count; i++) {
    // Move cursor up one line and clear the line
    process.stdout.write('\x1b[1A\x1b[2K')
  }
}

async function mainMenu() {
  const getSeparator = (message: string) => {
    return { role: 'separator' as 'seperator', message }
  }

  const choices = [{ message: '🏠 Local Development', value: 'local' }]
  if (PROJECT_ID) {
    choices.push(
      { message: `🌐 Remote / Origin Server (${PROJECT_ID})`, value: 'remote' },
      { message: '🔑 Authentication & Profile', value: 'auth' }
    )
  }
  choices.push({ message: '❌ Exit', value: 'exit' })
  // 1. Choose Scope
  const scopePrompt = new Select({
    name: 'scope',
    message: 'Select your work scope:\n',
    header: 'Supabase CLI Helper\n',
    symbols: { prefix: '⚡', pointer: '❯' },
    choices,
  })

  try {
    const scope = await scopePrompt.run()

    if (scope === 'exit') {
      console.log('Goodbye!')
      process.exit(0)
    }

    clearLines(2)

    interface Choice {
      role?: 'seperator'
      message: string
      value?: string
    }

    // 2. Define Actions based on Scope
    let actionChoices: Choice[] = []

    if (scope === 'local') {
      actionChoices = [
        {
          message: 'Export local types & schema',
          value: 'export_types_and_schema',
        },
        getSeparator('Destructive Actions'),
        {
          message: 'Reset local DB & Seed ⚠️ Data loss',
          value: 'supabase db reset && tsx scripts/supabase/seeders/main.ts',
        },
        {
          message: 'Reset local DB ⚠️ Data loss',
          value: 'supabase db reset && tsx scripts/supabase/seeders/only_auth.ts',
        },
        getSeparator('Changes'),
        { message: 'Status', value: 'supabase status' },
        { message: 'Create an empty migration', value: 'create_migration' },
        { message: 'Run new migrations', value: 'supabase migration up' },
        getSeparator('Security'),
        { message: 'Audit security', value: 'tsx scripts/supabase/audit_security.ts' },
      ]
    } else if (scope === 'remote') {
      actionChoices = [
        { message: 'Change remote project', value: 'supabase link' },
        { message: 'Audit Security', value: 'tsx scripts/supabase/audit_security.ts' },
        { message: 'Reset DB - 🔴 Warning: Data loss', value: 'supabase db reset --linked' },
        { message: 'Push migrations to origin', value: 'supabase db push' },
        { message: 'Overwrite migration by timestamp', value: 'overwrite_migration' },

        {
          message: 'Export origin types',
          value: `supabase gen types typescript --project-id ${PROJECT_ID} --schema "public,sync" > src/types/supabase.ts`,
        },
      ]
    } else if (scope === 'auth') {
      actionChoices = [{ message: 'Login to Supabase CLI', value: 'supabase login' }]
    }

    // 3. Choose Action
    const actionPrompt = new Select({
      name: 'action',
      header: `\nScope: ${scope} (${PROJECT_ID})`,
      message: `What would you like to do?\n`,
      symbols: { prefix: '🚀', pointer: '❯' },
      choices: [
        ...actionChoices,
        { role: 'separator' } as any,
        { message: '↩ Back to main menu', value: 'back' },
      ],
    })

    const action = await actionPrompt.run()

    clearLines(2)

    if (action === 'back') {
      return mainMenu()
    } else if (action === 'overwrite_migration') {
      const migrationsDir = './supabase/migrations'

      // 1. Read the migration files
      if (!fs.existsSync(migrationsDir)) {
        console.error(`\n× Migrations directory not found at ${migrationsDir}`)
        return mainMenu()
      }

      const files = fs
        .readdirSync(migrationsDir)
        .filter((file) => file.endsWith('.sql'))
        .sort((a, b) => b.localeCompare(a)) // Newest first

      if (files.length === 0) {
        console.log('\n! No migration files found.')
        return mainMenu()
      }

      // 2. Let the user select which one to repair
      const migrationPrompt = new Select({
        name: 'file',
        message: 'Select the migration to mark as applied (Repair):',
        choices: files.map((f) => ({ message: f, value: f })),
      })

      const selectedFile = await migrationPrompt.run()

      // 3. Extract the timestamp (everything before the first underscore)
      const timestamp = selectedFile.split('_')[0]

      if (timestamp) {
        console.log(`\n> Repairing checksum for: ${selectedFile}`)
        // We use --status applied to force the server to match the local file content
        run(`supabase migration repair --status applied ${timestamp}`)
      } else {
        console.error('\n× Could not extract timestamp from filename.')
      }

      return mainMenu()
    } else if (action === 'create_migration') {
      const inputPrompt = new Input({
        name: 'value',
        symbols: { prefix: '📃', pointer: '❯' },
        message: 'Enter the name (timestamp applied automatically):',
      })
      const name = await inputPrompt.run()
      const formatted_name = name
        .toLowerCase()
        .replace(/[-\s]/g, '_')
        .replace(/[^a-z_]/g, '')
      run(`supabase migration new ${formatted_name}`)
      return mainMenu()
    } else if (action === 'export_types_and_schema') {
      const schemaPath = './src/lib/supabase/schema/_generated_schema.ts'
      run('supabase gen types typescript --local --schema "public,sync" > src/types/supabase.ts')
      run('drizzle-kit introspect')
      run(`mv ./.drizzle/schema.ts ${schemaPath}`)
      patchGeneratedSchema(schemaPath)

      return mainMenu()
    }

    // Execute
    run(action)

    console.log('\n--- Action Complete ---\n')
    await mainMenu()
  } catch (err) {
    console.log('\nCancelled.')
    process.exit(0)
  }
}

const initialize = () => {
  if (!PROJECT_ID) {
    console.log('‼️ Remote configuration not set. Remote features disabled.')
    console.log('Enable your env and restart for remote features.')
  } else {
    run(`supabase link --project-ref ${PROJECT_ID}`)
  }
  mainMenu()
}

initialize()
