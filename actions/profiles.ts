"use server";

import { createClient } from "@/utils/supabase/server";

export interface CreateProfileData {
  id: string;
  username: string;
  email: string;
}

export async function createUserProfile(data: CreateProfileData) {
  const supabase = await createClient();

  let username = data.email.split("@")[0];

  const { data: existingUsername } = await supabase
    .from("profiles")
    .select("username")
    .eq("username", username)
    .single();

  if (existingUsername) {
    const timestamp = Date.now().toString().slice(-4);
    username = `${username}${timestamp}`;
  }

  const { data: profile, error } = await supabase
    .from("profiles")
    .insert({
      id: data.id,
      username: username,
      experience_level: "beginner",
      bio: "",
      profile_picture: null,
      location: null,
    })
    .select()
    .single();

  if (error) {
    console.error("Error creating profile:", error);
    return { error: error.message };
  }

  return { profile };
}

export async function checkProfileExists(userId: string) {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("profiles")
    .select("id")
    .eq("id", userId)
    .single();

  if (error) {
    return false;
  }

  return !!data;
}
