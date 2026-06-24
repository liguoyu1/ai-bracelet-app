#!/usr/bin/env python3
"""Seed real products into Railway PostgreSQL database."""
import json
import os
import psycopg2
import urllib.request

DATABASE_URL = os.environ.get('DATABASE_URL')
if not DATABASE_URL:
    print("FATAL: DATABASE_URL not set")
    exit(1)

print("Connecting to database...")
conn = psycopg2.connect(DATABASE_URL)
cur = conn.cursor()

# Load seed data
seed_path = '/app/scripts/product_seed_data.json'
if not os.path.exists(seed_path):
    # Try relative to project root
    seed_path = 'scripts/product_seed_data.json'
    
with open(seed_path) as f:
    products = json.load(f)

print(f"Seeding {len(products)} products...")

# Download real images from Unsplash
def get_unsplash_image(query, idx):
    """Get a real Unsplash image URL from search."""
    url = f"https://source.unsplash.com/600x600/?{urllib.parse.quote(query)}"
    return url

inserted = 0
for p in products:
    # Get 2 real image URLs
    queries = p.get('unsplash_queries', [])
    img_urls = []
    for q in queries[:2]:
        img_urls.append(get_unsplash_image(q, len(img_urls)))
    
    # PostgreSQL array syntax
    images_array = '{' + ','.join(f'"{u}"' for u in img_urls) + '}'
    tags_array = '{' + ','.join(f'"{t}"' for t in p['tags']) + '}'
    
    try:
        cur.execute("""
            INSERT INTO products (name, slug, description, price_cents, images, category, tags, materials, stock)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (slug) DO UPDATE SET
                stock = EXCLUDED.stock,
                description = EXCLUDED.description,
                images = EXCLUDED.images,
                tags = EXCLUDED.tags
        """, (
            p['name'], p['slug'], p['description'],
            p['price_cents'], images_array, p['category'],
            tags_array, p['materials'], p['stock']
        ))
        inserted += 1
        print(f"  ✓ {p['name']}")
    except Exception as e:
        print(f"  ✗ {p['name']}: {e}")

# Also seed design elements
print("\nSeeding design elements...")
elements = [
    # Beads
    ('Amethyst Round', 'bead', '#7B2D8B', 'Natural Amethyst', 'round', 8, 150, 200),
    ('Clear Quartz Round', 'bead', '#E8E8E8', 'Clear Quartz', 'round', 8, 120, 200),
    ('Rose Quartz Round', 'bead', '#F7C0D0', 'Rose Quartz', 'round', 8, 180, 150),
    ('Tiger Eye Round', 'bead', '#B8860B', 'Tiger Eye', 'round', 8, 160, 180),
    ('Black Obsidian Round', 'bead', '#1A1A1A', 'Black Obsidian', 'round', 8, 100, 250),
    ('Citrine Round', 'bead', '#F5C542', 'Citrine', 'round', 8, 200, 120),
    ('Green Aventurine Round', 'bead', '#8FBC8F', 'Green Aventurine', 'round', 8, 130, 170),
    ('Lapis Lazuli Round', 'bead', '#2E5090', 'Lapis Lazuli', 'round', 8, 220, 100),
    ('Jade Round', 'bead', '#2E8B57', 'Nephrite Jade', 'round', 10, 350, 80),
    ('Carnelian Round', 'bead', '#D2691E', 'Carnelian', 'round', 8, 140, 160),
    ('Howlite Round', 'bead', '#E8E4D4', 'Howlite', 'round', 8, 110, 200),
    ('Lava Stone Round', 'bead', '#3C3C3C', 'Lava Stone', 'round', 8, 90, 300),
    ('Sodalite Round', 'bead', '#1E3F66', 'Sodalite', 'round', 8, 170, 130),
    ('Moonstone Round', 'bead', '#E8E0F0', 'Moonstone', 'round', 8, 250, 90),
    ('Red Jasper Round', 'bead', '#B22222', 'Red Jasper', 'round', 8, 160, 140),
    ('Gold Spacer Bead', 'bead', '#C8A45C', 'Gold-Filled', 'round', 4, 80, 500),
    ('Silver Spacer Bead', 'bead', '#C0C0C0', 'Sterling Silver', 'round', 4, 120, 300),
    # Clasps
    ('Gold Lobster Clasp', 'clasp', '#C8A45C', 'Gold-Plated Alloy', 'lobster', 0, 200, 500),
    ('Silver Lobster Clasp', 'clasp', '#C0C0C0', 'Sterling Silver', 'lobster', 0, 350, 200),
    ('Magnetic Gold Clasp', 'clasp', '#C8A45C', 'Gold-Plated', 'magnetic', 0, 300, 300),
    ('Magnetic Silver Clasp', 'clasp', '#C0C0C0', 'Silver-Plated', 'magnetic', 0, 280, 300),
    # Charms
    ('Gold Star Charm', 'charm', '#C8A45C', 'Gold-Filled', 'star', 0, 500, 150),
    ('Gold Moon Charm', 'charm', '#C8A45C', 'Gold-Filled', 'moon', 0, 600, 120),
    ('Gold Heart Charm', 'charm', '#C8A45C', 'Gold-Filled', 'heart', 0, 450, 180),
    ('Silver Tree of Life', 'charm', '#C0C0C0', 'Sterling Silver', 'tree', 0, 800, 80),
    ('Gold Evil Eye Charm', 'charm', '#C8A45C', 'Gold-Filled', 'evil-eye', 0, 550, 200),
    ('Silver Om Charm', 'charm', '#C0C0C0', 'Sterling Silver', 'om', 0, 400, 120),
]

el_inserted = 0
for el in elements:
    name, el_type, color, material, shape, size_mm, price_cents, stock = el
    try:
        cur.execute("""
            INSERT INTO design_elements (name, type, color, material, shape, size_mm, image_url, price_cents, stock)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (name, type) DO NOTHING
        """, (name, el_type, color, material, shape, size_mm, '', price_cents, stock))
        el_inserted += 1
    except Exception as e:
        print(f"  ✗ {name}: {e}")

conn.commit()
cur.close()
conn.close()
print(f"\n✅ Done! {inserted} products, {el_inserted} elements seeded.")
