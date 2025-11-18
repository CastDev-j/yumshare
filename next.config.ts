import type { NextConfig } from "next";
import path from "path/win32";

const nextConfig: NextConfig = {
  turbopack: {
    root: path.join(__dirname, ".."),
  },
};

export default nextConfig;
