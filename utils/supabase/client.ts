import { createBrowserClient } from "@supabase/ssr";
import { env } from "@/config/env";

export const createClient = () =>
  createBrowserClient(env.supabase.url, env.supabase.anonKey);

export const supabase = createClient();
