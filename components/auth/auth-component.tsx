"use client";

import React, { useEffect, useState } from "react";
import { signInWithGoogle } from "@/app/auth/actions";
import { supabase } from "@/utils/supabase/browser";
import { useRouter } from "next/navigation";

const AuthComponent = () => {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [isAuthed, setIsAuthed] = useState<boolean | null>(null);
  const [email, setEmail] = useState<string | null>(null);

  useEffect(() => {
    let mounted = true;

    const init = async () => {
      const { data } = await supabase.auth.getSession();
      if (!mounted) return;
      setIsAuthed(!!data.session?.user);
      setEmail(data.session?.user?.email ?? null);
    };

    init();

    const { data: sub } = supabase.auth.onAuthStateChange((_event, session) => {
      if (!mounted) return;
      setIsAuthed(!!session?.user);
      setEmail(session?.user?.email ?? null);
    });

    return () => {
      mounted = false;
      sub.subscription.unsubscribe();
    };
  }, []);

  const handleSignIn = async () => {
    setLoading(true);
    try {
      const currentPath = window.location.pathname;
      await signInWithGoogle(currentPath);
    } catch (error) {
      console.error("Error signing in:", error);
      setLoading(false);
    }
  };

  const handleSignOut = async () => {
    setLoading(true);
    try {
      await supabase.auth.signOut();
      router.refresh();
    } catch (error) {
      console.error("Error signing out:", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex items-center gap-3">
      {isAuthed ? (
        <>
          <span className="text-sm text-neutral-600">{email ?? "Usuario"}</span>
          <button
            onClick={handleSignOut}
            disabled={loading}
            className="px-3 py-1.5 rounded bg-neutral-200 hover:bg-neutral-300 text-sm"
          >
            {loading ? "Cerrando…" : "Cerrar sesión"}
          </button>
        </>
      ) : (
        <button
          onClick={handleSignIn}
          disabled={loading}
          className="px-3 py-1.5 rounded bg-black text-white hover:bg-neutral-800 text-sm"
        >
          {loading ? "Abriendo Google…" : "Iniciar sesión con Google"}
        </button>
      )}
    </div>
  );
};

export default AuthComponent;
