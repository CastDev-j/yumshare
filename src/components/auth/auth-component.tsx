"use client";

import React, { useEffect, useMemo, useState } from "react";
import { signInWithGoogle } from "@/app/auth/actions";
import { useRouter } from "next/navigation";
import { createClient } from "@/utils/supabase/client";
import { Button } from "../ui/button";

const AuthComponent = () => {
  const router = useRouter();
  const supabase = useMemo(() => createClient(), []);
  const [loading, setLoading] = useState(false);
  const [isAuthed, setIsAuthed] = useState<boolean | null>(null);

  useEffect(() => {
    let mounted = true;

    const init = async () => {
      const { data } = await supabase.auth.getSession();

      console.log(data);

      if (!mounted) return;
      setIsAuthed(!!data.session?.user);
    };

    init();

    const { data: sub } = supabase.auth.onAuthStateChange((_event, session) => {
      if (!mounted) return;
      setIsAuthed(!!session?.user);
    });

    return () => {
      mounted = false;
      sub.subscription.unsubscribe();
    };
  }, [supabase]);

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
          <Button
            onClick={handleSignOut}
            disabled={loading}
            variant={"outline"}
          >
            {loading ? "Cerrando…" : "Cerrar sesión"}
          </Button>
        </>
      ) : (
        <Button onClick={handleSignIn} disabled={loading}>
          {loading ? "Abriendo Google…" : "Iniciar sesión con Google"}
        </Button>
      )}
    </div>
  );
};

export default AuthComponent;
