"use server";

import { createClient } from "@/utils/supabase/server";
import { redirect } from "next/navigation";

export async function signInWithGoogle(currentPath: string) {
  const supabase = await createClient();
  const origin = process.env.NEXT_PUBLIC_SITE_URL || "http://localhost:3000";

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
