#!/usr/bin/env python3
"""Execute real image UPDATEs on Railway PostgreSQL via psycopg2"""
import json, os, sys

DB_URL = os.environ.get("DATABASE_URL")
if not DB_URL:
    print("FATAL: DATABASE_URL not set. Run via: railway run python3 scripts/exec_update_sql.py")
    sys.exit(1)

import psycopg2

# Load mapping
mapping_path = os.path.join(os.path.dirname(__file__), "real_images_mapping.json")
with open(mapping_path) as f:
    mapping = json.load(f)

print(f"Loaded {len(mapping)} product mappings")
print(f"Connecting to PostgreSQL...")

conn = psycopg2.connect(DB_URL)
cur = conn.cursor()

# Count products before
cur.execute("SELECT COUNT(*) FROM products")
before = cur.fetchone()[0]
print(f"Products in DB: {before}")

# Execute updates
updated = 0
errors = 0
for slug, urls in mapping.items():
    # PostgreSQL text array
    arr = '{' + ','.join(f'"{u}"' for u in urls) + '}'
    try:
        cur.execute(
            "UPDATE products SET images = %s::text[] WHERE slug = %s",
            (arr, slug)
        )
        if cur.rowcount > 0:
            updated += 1
        else:
            print(f"  ⚠ No row for slug: {slug}")
    except Exception as e:
        print(f"  ✗ {slug}: {e}")
        errors += 1

conn.commit()

# Verify
cur.execute("SELECT slug, images FROM products ORDER BY slug")
rows = cur.fetchall()
print(f"\n=== VERIFICATION ===")
placehold_count = 0
real_count = 0
for slug, images in rows:
    has_placehold = any('placehold.co' in (img or '') for img in (images or []))
    has_unsplash = any('images.unsplash.com' in (img or '') for img in (images or []))
    if has_placehold:
        placehold_count += 1
    if has_unsplash:
        real_count += 1
    if has_placehold:
        print(f"  STILL PLACEHOLD: {slug}")

print(f"\n✅ {updated} products updated, {errors} errors")
print(f"Products with Unsplash images: {real_count}/{len(rows)}")
print(f"Products still with placehold URLs: {placehold_count}/{len(rows)}")

cur.close()
conn.close()
print("Done!")
