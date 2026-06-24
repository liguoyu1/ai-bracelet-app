#!/usr/bin/env python3
"""Curate final Unsplash image mapping for all 63 products + generate SQL."""
import json, os

# 7 Verified Unsplash Photos (HTTP 200 confirmed)
PHOTOS = {
    "amethyst": "1611591437281-460bfbe1220a",     # purple crystal - for amethyst, lavender products
    "rose_quartz": "1600612253971-422e7f7faeb6",   # pink - for rose quartz, pink products
    "obsidian": "1602173574767-37ac01994b2a",       # black shiny - for obsidian, onyx, hematite, lava
    "lapis_lazuli": "1605100804763-247f67b3557e",   # deep blue with gold - for lapis, sodalite
    "jade_green": "1573408301185-9146fe634ad0",      # green jade - for jade, aventurine, green stones
    "clear_quartz": "1611930022073-b7a4ba5fcccd",    # white/clear - for quartz, moonstone, howlite
    "amazonite": "1599643478518-a784e5dc4c8f",       # teal/green - for amazonite, turquoise
}

def url(pid):
    return f"https://images.unsplash.com/photo-{pid}?w=600&h=600&fit=crop"

# All 63 unique product slugs with their color-assigned photos
# Format: slug -> [primary_photo_key, secondary_photo_key]
PRODUCT_MAP = {
    # Original 8 products (from 002_seed.sql - these have DIFFERENT slugs)
    "crystal-harmony": ["amethyst", "clear_quartz"],
    "lava-stone-grounding": ["obsidian", "amethyst"],
    "jade-wisdom": ["jade_green", "clear_quartz"],
    "tiger-eye-success": ["amethyst", "rose_quartz"],  # tiger-eye fallback
    "rose-quartz-love": ["rose_quartz", "amethyst"],
    "black-obsidian-shield": ["obsidian", "lapis_lazuli"],
    "citrine-abundance": ["amazonite", "clear_quartz"],  # citrine fallback
    "aromatherapy-essential": ["obsidian", "rose_quartz"],
    
    # 20 products from seed_real_products.sql
    "amethyst-spiritual-protection": ["amethyst", "lapis_lazuli"],
    "tiger-eye-confidence": ["obsidian", "rose_quartz"],  # tiger eye=golden brown, closest fallback
    "black-obsidian-protection": ["obsidian", "lapis_lazuli"],
    "citrine-wealth-attraction": ["amazonite", "clear_quartz"],  # citrine=golden, closest
    "green-aventurine-luck": ["jade_green", "amazonite"],
    "carnelian-creativity": ["rose_quartz", "amethyst"],  # carnelian=orange/red
    "lapis-lazuli-wisdom": ["lapis_lazuli", "amazonite"],
    "howlite-calming": ["clear_quartz", "rose_quartz"],
    "sodalite-logic-communication": ["lapis_lazuli", "clear_quartz"],
    "natural-turquoise-wrap": ["amazonite", "lapis_lazuli"],
    "moonstone-intuition": ["clear_quartz", "rose_quartz"],
    "red-jasper-grounding": ["obsidian", "rose_quartz"],
    "clear-quartz-master-healer": ["clear_quartz", "amethyst"],
    "amazonite-courage-truth": ["amazonite", "lapis_lazuli"],
    "hematite-magnetic-grounding": ["obsidian", "lapis_lazuli"],
    "black-onyx-self-control": ["obsidian", "clear_quartz"],
    "fluorite-focus-balance": ["amethyst", "jade_green"],
    "jade-prosperity-charm": ["jade_green", "amazonite"],
    "lavender-aromatherapy-bracelet": ["obsidian", "amethyst"],
    
    # Pearl products (8)
    "akoya-pearl-elegance": ["clear_quartz", "rose_quartz"],
    "freshwater-pearl-drops": ["clear_quartz", "rose_quartz"],
    "tahitian-black-pearl": ["obsidian", "lapis_lazuli"],
    "south-sea-golden-pearl": ["amazonite", "clear_quartz"],
    "baroque-pearl-charm": ["clear_quartz", "amethyst"],
    "rice-pearl-minimalist": ["clear_quartz", "rose_quartz"],
    "coin-pearl-statement": ["clear_quartz", "lapis_lazuli"],
    "biwa-pearl-wrap": ["clear_quartz", "obsidian"],
    
    # Jade products (8)
    "hetian-jade-bangle": ["jade_green", "clear_quartz"],
    "jadeite-imperial-green": ["jade_green", "amazonite"],
    "dushan-jade-bracelet": ["jade_green", "amethyst"],
    "xiuyan-jade-bracelet": ["jade_green", "obsidian"],
    "lantian-jade-wisdom": ["jade_green", "clear_quartz"],
    "nanyang-jade-bracelet": ["jade_green", "obsidian"],
    "yellow-jade-prosperity": ["amazonite", "jade_green"],
    "lavender-jade-bracelet": ["amethyst", "jade_green"],
    
    # Fragrance products (6)
    "agarwood-zen-bracelet": ["obsidian", "jade_green"],
    "sandalwood-meditation": ["obsidian", "clear_quartz"],
    "jasmine-scented-bead": ["rose_quartz", "clear_quartz"],
    "rose-fragrance-bracelet": ["rose_quartz", "amethyst"],
    "musk-sandalwood-bracelet": ["obsidian", "rose_quartz"],
    "tibetan-incense-bead": ["obsidian", "lapis_lazuli"],
    
    # Crystal products (8)
    "smoky-quartz-grounding": ["obsidian", "clear_quartz"],
    "rutilated-quartz-bracelet": ["clear_quartz", "amethyst"],
    "sunstone-joy": ["amazonite", "rose_quartz"],
    "labradorite-magic": ["lapis_lazuli", "amazonite"],
    "prehnite-angel-light": ["jade_green", "clear_quartz"],
    "unakite-balance": ["jade_green", "rose_quartz"],
    "chrysoprase-success": ["jade_green", "amazonite"],
    "serpentine-calming": ["jade_green", "obsidian"],
    
    # Wood products (6)
    "red-sandalwood-bracelet": ["obsidian", "rose_quartz"],
    "bodhi-seed-prayer": ["obsidian", "clear_quartz"],
    "ebony-minimalist": ["obsidian", "lapis_lazuli"],
    "olive-wood-bracelet": ["jade_green", "obsidian"],
    "multi-gemstone-treasure": ["amethyst", "jade_green"],
    "amethyst-pearl-fusion": ["amethyst", "clear_quartz"],
}

# Deduplicate slugs (only unique)
seen = set()
unique_map = {}
for slug, photos in PRODUCT_MAP.items():
    if slug not in seen:
        seen.add(slug)
        unique_map[slug] = photos

print(f"Total unique products: {len(unique_map)}")

# Build the mapping JSON
mapping = {}
for slug, (p1, p2) in unique_map.items():
    mapping[slug] = [url(PHOTOS[p1]), url(PHOTOS[p2])]

# Write mapping
out_path = os.path.join(os.path.dirname(__file__), "real_images_mapping.json")
with open(out_path, "w") as f:
    json.dump(mapping, f, indent=2)
print(f"✅ Written {len(mapping)} products to {out_path}")

# Generate SQL
sql_lines = ["-- UPDATE all products with real Unsplash images",
             "-- All URLs verified HTTP 200",
             ""]

for slug, urls in mapping.items():
    # PostgreSQL text array format
    arr = '{' + ','.join(f'"{u}"' for u in urls) + '}'
    sql_lines.append(f"UPDATE products SET images = '{arr}'::text[] WHERE slug = '{slug}';")

sql = "\n".join(sql_lines)
sql_path = os.path.join(os.path.dirname(__file__), "update_real_images.sql")
with open(sql_path, "w") as f:
    f.write(sql + "\n")
print(f"✅ Written SQL to {sql_path} ({len(unique_map)} UPDATE statements)")

# Also print a condensed version for verification
print("\n=== IMAGE ASSIGNMENT SUMMARY ===")
for slug, (p1, p2) in unique_map.items():
    print(f"  {slug:40s} → {p1:15s} + {p2:15s}")
