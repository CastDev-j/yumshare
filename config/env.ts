export const env = {
  supabase: {
    url: process.env.NEXT_PUBLIC_SUPABASE_URL!,
    anonKey: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
  },
  site: {
    url: process.env.NEXT_PUBLIC_SITE_URL || "http://localhost:3000",
  },
  nodeEnv: process.env.NODE_ENV,
  isDevelopment: process.env.NODE_ENV === "development",
  isProduction: process.env.NODE_ENV === "production",
} as const;
