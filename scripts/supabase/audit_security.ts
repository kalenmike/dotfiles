import { createClient } from '@supabase/supabase-js'

// Use your PUBLIC anon key and URL
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

const supabase = createClient(supabaseUrl, supabaseAnonKey)

const tables = [
  'actividades_economicas',
  'avisos',
  'calendario_fiscal',
  'cliente_despacho',
  'clientes',

  'clientes_activos_view',
  'clientes_con_lifecycle',

  'contactos',
  'cuentas_bancarias',
  'despachos',
  'ejercicios_fiscales',
  'logs_sincronizacion',
  'mapeos_externos',
  'modelos_tributarios',
  'obligaciones_fiscales',
  'perfil_tributario',
  'profiles',
  'recent_sync_changes',
  'sync_changes',
  'sync_client_status',
  'sync_health_log',
  'sync_metrics',
  'sync_performance',

  'v_avisos_dashboard',
  'v_client_discovery_status',
  'v_obligaciones_dashboard',
  'v_problematic_clients',
  'vista_trabajo_gestor',
]

async function runAudit() {
  console.log('🚀 Starting Security Audit (Unauthenticated)...\n')
  const checks = []

  for (const table of tables) {
    const result = {
      table,
      state: '',
    }
    // Attempt to SELECT as a guest
    const { data, error } = await supabase.from(table).select('*').limit(1)

    if (error) {
      console.log(`✅ ${table.padEnd(18)}: LOCKED (Error: ${error.code})`)
      result.state = 'LOCKED'
    } else if (data && data.length > 0) {
      console.log(`❌ ${table.padEnd(18)}: EXPOSED! (Found ${data.length} rows)`)
      result.state = 'EXPOSED'
    } else {
      console.log(`✅ ${table.padEnd(18)}: SECURE (Returned empty array)`)
      result.state = 'SECURE'
    }

    checks.push(result)
  }

  const isExposed = checks.some((c) => c.state === 'EXPOSED')

  console.log('\n---')
  if (isExposed) {
    console.log('🛑 AUDIT FAILED: One or more tables are EXPOSED to the public!')
    console.log('Do not deploy until RLS policies or View security is fixed.')
    process.exit(1) // Exit with error code to stop CI/CD pipelines if needed
  } else {
    console.log('🔒 AUDIT PASSED: All tables are properly locked down.')
    console.log('Your database is ready for deployment.')
  }
}

runAudit()
