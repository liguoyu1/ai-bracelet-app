#!/usr/bin/env python3
"""Generate SQL migration from 1688 scraped data."""
import json, re, sys
from hashlib import md5

def parse_price(s: str) -> int:
    """Parse '¥22.92' or '¥2,197.23' -> cents (2292 or 219723)."""
    s = s.replace('¥', '').replace(',', '').strip()
    try:
        cents = int(round(float(s) * 100))
        return max(cents, 1)
    except ValueError:
        return 1

def make_slug(title: str) -> str:
    """Generate a unique slug from the title."""
    # Take first ~60 chars of alphanumeric + hyphen
    cleaned = re.sub(r'[^a-zA-Z0-9\u4e00-\u9fff]+', '-', title).strip('-').lower()
    # Truncate to 80 chars, strip trailing hyphen
    slug = cleaned[:80].rstrip('-')
    if not slug:
        slug = 'product'
    # Add hash suffix for uniqueness
    h = md5(title.encode('utf-8')).hexdigest()[:8]
    return f'{slug}-{h}'

def esc(val: str) -> str:
    """Escape single quotes for SQL."""
    return val.replace("'", "''")

with open('assets/bracelets_data.json', 'r') as f:
    data = json.load(f)

products = data['products']
sql_lines = [
    "-- 005_import_1688.sql - Import scraped 1688 products",
    f"-- Generated from bracelets_data.json ({len(products)} products)",
    "",
    "INSERT INTO products (name, slug, description, price_cents, images, category, tags, materials, stock, sales_count, is_active) VALUES",
]

vals = []
for p in products:
    name = esc(p['title'][:255])
    slug = make_slug(p['title'])
    desc = esc(p['description'][:500]) if p.get('description') else ''
    price = parse_price(p.get('price', '0'))
    img = p.get('image_url', '')
    cat = esc(p.get('category', 'general'))
    keyword = esc(p.get('search_keyword', ''))
    tags = f"'{{{keyword}}}'::text[]" if keyword else "'{}'::text[]"
    # materials as empty JSONB
    materials = "'{}'::jsonb"
    # source info in description
    if not desc:
        desc = f"From 1688, category: {cat}"
    stock = 999
    sales_str = p.get('sales', '0')
    try:
        sales = int(re.sub(r'[^0-9]', '', sales_str)) if sales_str else 0
    except:
        sales = 0
    
    vals.append(
        f"('{name}', '{slug}', '{desc}', {price}, ARRAY['{img}'], '{cat}', {tags}, {materials}, {stock}, {sales}, true)"
    )

sql_lines.append(",\n".join(vals))
sql_lines.append("ON CONFLICT (slug) DO NOTHING;")
sql_lines.append("")

out = '\n'.join(sql_lines)
with open('backend/database/migrations/005_import_1688.sql', 'w') as f:
    f.write(out)

print(f"Generated 005_import_1688.sql with {len(products)} products")
