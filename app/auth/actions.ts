"use server";

import { createClient } from "@/utils/supabase/server";
import { redirect } from "next/navigation";
import { env } from "@/config/env";

export async function signInWithGoogle(currentPath: string) {
  const supabase = await createClient();
  const origin = env.site.url;

  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: "google",
    options: {
      redirectTo: `${origin}/auth/callback?next=${encodeURIComponent(
        currentPath
      )}`,
    },
  });

  if (error) {
    console.error("Error signing in:", error);
    return { error: error.message };
  }

  if (data.url) {
    redirect(data.url);
  }
}
