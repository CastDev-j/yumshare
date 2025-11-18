Setup

- Create a `.env.local` in the project root with:

	NEXT_PUBLIC_SUPABASE_URL=your-project-url
	NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
	NEXT_PUBLIC_SITE_URL=http://localhost:3000

	Get URL and anon key in Supabase Dashboard → Project → Settings → API.

- Install deps and run:

	npm install
	npm run dev

Frontend & Framework

Next.js 16 (App Router)
React 19
TypeScript
Tailwind CSS
shadcn/ui

Backend & Base de Datos

Supabase (Database + Auth + Storage)
PostgreSQL

APIs Externas

Spoonacular API (recetas externas)
Edamam Recipe API (alternativa/complemento)

Librerías UI/UX

Lucide React (iconos)
Radix UI (componentes base)
React Hook Form
Zod (validación)
date-fns (manejo de fechas)

Funcionalidades Específicas

@dnd-kit (drag & drop para meal planner)
react-dropzone (subir imágenes)
@tanstack/react-query (cache y data fetching)

Extras Opcionales

Resend (emails)
jsPDF (exportar PDFs)
GSAP (animaciones avanzadas)

DevOps & Deploy

Vercel (hosting)
Git & GitHub
