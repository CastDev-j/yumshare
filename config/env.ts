const getEnvVar = (key: string, defaultValue?: string): string => {
  const value = process.env[key];
  if (!value && !defaultValue) {
    throw new Error(`Missing environment variable: ${key}`);
  }
  return value || defaultValue!;
};

export const env = {
  supabase: {
    get url() {
      return getEnvVar("NEXT_PUBLIC_SUPABASE_URL");
    },
    get anonKey() {
      return getEnvVar("NEXT_PUBLIC_SUPABASE_ANON_KEY");
    },
  },
  site: {
    get url() {
      return getEnvVar("NEXT_PUBLIC_SITE_URL", "http://localhost:3000");
    },
  },
  get nodeEnv() {
    return process.env.NODE_ENV;
  },
  get isDevelopment() {
    return process.env.NODE_ENV === "development";
  },
  get isProduction() {
    return process.env.NODE_ENV === "production";
  },
} as const;
