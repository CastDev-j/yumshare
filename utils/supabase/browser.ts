import { createClient } from "./client";
import type { SupabaseClient } from "@supabase/supabase-js";

// Singleton del cliente Supabase para uso en el navegador (lazy initialization)
let supabaseInstance: SupabaseClient | null = null;

export const supabase = (() => {
  if (typeof window === "undefined") {
    throw new Error("supabase browser client can only be used in the browser");
  }
  if (!supabaseInstance) {
    supabaseInstance = createClient();
  }
  return supabaseInstance;
})();
