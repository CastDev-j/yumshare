-- 1. PROFILES (Usuarios)
CREATE TABLE profiles (
id UUID PRIMARY KEY,
username TEXT UNIQUE NOT NULL,
experience_level TEXT CHECK (
experience_level IN ('beginner', 'intermediate', 'advanced', 'professional')
),
bio TEXT,
profile_picture TEXT,
location TEXT,
created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. RECIPES (Recetas)
CREATE TABLE recipes (
id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
title TEXT NOT NULL,
description TEXT NOT NULL,
preparation_time INT CHECK (preparation_time > 0),
cooking_time INT CHECK (cooking_time >= 0),
servings INT CHECK (servings >= 1),
difficulty TEXT CHECK (difficulty IN ('easy', 'medium', 'hard')),
is_public BOOLEAN DEFAULT TRUE,
main_image TEXT,
created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
author_id UUID REFERENCES profiles(id) ON DELETE RESTRICT,
external_api_id TEXT
);

-- 3. INGREDIENTS (Catálogo de ingredientes)
CREATE TABLE ingredients (
id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
name TEXT UNIQUE NOT NULL,
category TEXT NOT NULL,
default_unit TEXT CHECK (
default_unit IN ('grams', 'kg', 'ml', 'liters', 'cups', 'tablespoons', 'teaspoons', 'pieces', 'to taste')
)
);

-- 4. RECIPE_INGREDIENTS (N:M Recetas-Ingredientes)
CREATE TABLE recipe_ingredients (
recipe_id BIGINT REFERENCES recipes(id) ON DELETE CASCADE,
ingredient_id BIGINT REFERENCES ingredients(id) ON DELETE RESTRICT,
quantity NUMERIC CHECK (quantity > 0),
unit TEXT CHECK (
unit IN ('grams', 'kg', 'ml', 'liters', 'cups', 'tablespoons', 'teaspoons', 'pieces', 'to taste')
),
PRIMARY KEY (recipe_id, ingredient_id)
);

-- 5. RECIPE_STEPS (Pasos de recetas)
CREATE TABLE recipe_steps (
id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
recipe_id BIGINT REFERENCES recipes(id) ON DELETE CASCADE,
step_number INT NOT NULL,
description TEXT NOT NULL,
image TEXT,
estimated_time INT CHECK (estimated_time >= 0),
UNIQUE (recipe_id, step_number)
);

-- 6. CATEGORIES (Categorías de recetas)
CREATE TABLE categories (
id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
name TEXT UNIQUE NOT NULL,
icon TEXT,
color TEXT
);

-- 7. CUISINES (Tipos de cocina)
CREATE TABLE cuisines (
id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
name TEXT UNIQUE NOT NULL
);

-- 8. RECIPE_CATEGORIES (N:M Recetas-Categorías)
CREATE TABLE recipe_categories (
recipe_id BIGINT REFERENCES recipes(id) ON DELETE CASCADE,
category_id BIGINT REFERENCES categories(id) ON DELETE RESTRICT,
PRIMARY KEY (recipe_id, category_id)
);

-- 9. RECIPE_CUISINES (N:M Recetas-Cocinas)
CREATE TABLE recipe_cuisines (
recipe_id BIGINT REFERENCES recipes(id) ON DELETE CASCADE,
cuisine_id BIGINT REFERENCES cuisines(id) ON DELETE RESTRICT,
PRIMARY KEY (recipe_id, cuisine_id)
);

-- 10. RATINGS (Valoraciones de recetas)
CREATE TABLE ratings (
id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
recipe_id BIGINT REFERENCES recipes(id) ON DELETE CASCADE,
rating INT CHECK (rating BETWEEN 1 AND 5),
comment TEXT,
created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
UNIQUE (user_id, recipe_id)
);

-- 11. FAVORITES (Recetas favoritas)
CREATE TABLE favorites (
user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
recipe_id BIGINT REFERENCES recipes(id) ON DELETE CASCADE,
PRIMARY KEY (user_id, recipe_id)
);

-- 12. MEAL_PLANS (Planes de comidas)
CREATE TABLE meal_plans (
id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
start_date DATE NOT NULL,
end_date DATE NOT NULL,
is_active BOOLEAN DEFAULT TRUE,
created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 13. MEAL_PLAN_RECIPES (Recetas en planes)
CREATE TABLE meal_plan_recipes (
meal_plan_id BIGINT REFERENCES meal_plans(id) ON DELETE CASCADE,
recipe_id BIGINT REFERENCES recipes(id) ON DELETE CASCADE,
meal_date DATE NOT NULL,
meal_type TEXT CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack')),
PRIMARY KEY (meal_plan_id, recipe_id, meal_date, meal_type)
);

-- 14. SHOPPING_LISTS (Listas de compras)
CREATE TABLE shopping_lists (
id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
is_shared BOOLEAN DEFAULT FALSE
);

-- 15. SHOPPING_LIST_ITEMS (Items de listas)
CREATE TABLE shopping_list_items (
shopping_list_id BIGINT REFERENCES shopping_lists(id) ON DELETE CASCADE,
ingredient_id BIGINT REFERENCES ingredients(id),
quantity NUMERIC CHECK (quantity > 0),
unit TEXT CHECK (
unit IN ('grams', 'kg', 'ml', 'liters', 'cups', 'tablespoons', 'teaspoons', 'pieces', 'to taste')
),
is_purchased BOOLEAN DEFAULT FALSE,
purchase_date TIMESTAMP WITH TIME ZONE,
PRIMARY KEY (shopping_list_id, ingredient_id)
);

-- 16. PANTRY (Despensa personal)
CREATE TABLE pantry (
user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
ingredient_id BIGINT REFERENCES ingredients(id),
current_quantity NUMERIC CHECK (current_quantity >= 0),
expiration_date DATE,
minimum_quantity NUMERIC CHECK (minimum_quantity >= 0),
location TEXT,
last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
PRIMARY KEY (user_id, ingredient_id)
);

-- 17. COOKING_SESSIONS (Sesiones de cocina)
CREATE TABLE cooking_sessions (
id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
recipe_id BIGINT REFERENCES recipes(id) ON DELETE SET NULL,
cooking_date DATE NOT NULL,
rating INT CHECK (rating BETWEEN 1 AND 5),
notes TEXT,
result_image TEXT,
actual_preparation_time INT CHECK (actual_preparation_time >= 0),
created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


CREATE INDEX idx_recipes_author ON recipes(author_id);
CREATE INDEX idx_recipes_public ON recipes(is_public);
CREATE INDEX idx_ratings_recipe ON ratings(recipe_id);
CREATE INDEX idx_favorites_user ON favorites(user_id);
CREATE INDEX idx_meal_plans_user ON meal_plans(user_id);
CREATE INDEX idx_shopping_lists_user ON shopping_lists(user_id);
CREATE INDEX idx_pantry_user ON pantry(user_id);
CREATE INDEX idx_cooking_sessions_user ON cooking_sessions(user_id);
