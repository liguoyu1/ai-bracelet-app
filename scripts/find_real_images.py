#!/usr/bin/env python3
"""Find real Unsplash photos for all 63 AURA bracelet products."""
import json, os, sys, re, urllib.request, urllib.parse, ssl, time

# Known verified Unsplash photo IDs (HTTP 200 confirmed)
KNOWN_PHOTOS = {
    "amethyst": "1611591437281-460bfbe1220a",
    "rose_quartz": "1600612253971-422e7f7faeb6",
    "obsidian": "1602173574767-37ac01994b2a",
    "lapis_lazuli": "1605100804763-247f67b3557e",
    "jade_green": "1573408301185-9146fe634ad0",
    "clear_quartz": "1611930022073-b7a4ba5fcccd",
    "amazonite": "1599643478518-a784e5dc4c8f",
}

def discover_photos(query, max_ids=5):
    """Try to discover Unsplash photo IDs by searching unsplash.com"""
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    
    url = f"https://unsplash.com/napi/search/photos?query={urllib.parse.quote(query)}&per_page={max_ids}&xp="
    req = urllib.request.Request(url)
    req.add_header("User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36")
    req.add_header("Accept", "application/json")
    
    try:
        with urllib.request.urlopen(req, timeout=10, context=ctx) as resp:
            data = json.loads(resp.read())
            ids = []
            for r in data.get("results", []):
                pid = r.get("id")
                if pid:
                    ids.append(pid)
            return ids
    except Exception as e:
        print(f"  [X] discover({query}): {e}")
        return []

def verify_url(photo_id):
    """Check if an Unsplash URL returns HTTP 200"""
    url = f"https://images.unsplash.com/photo-{photo_id}?w=200"
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    try:
        req = urllib.request.Request(url)
        req.add_header("User-Agent", "Mozilla/5.0")
        with urllib.request.urlopen(req, timeout=10, context=ctx) as resp:
            return resp.status == 200
    except:
        return False

def format_url(photo_id):
    return f"https://images.unsplash.com/photo-{photo_id}?w=600&h=600&fit=crop"

# All 63 products with their search queries
PRODUCTS = [
    # Original 8 (from migrations/002_seed.sql)
    ("crystal-harmony", ["amethyst crystal", "clear quartz"], ["amethyst", "clear_quartz"]),
    ("lava-stone-grounding", ["lava stone", "volcanic rock"], ["obsidian"]),
    ("jade-wisdom", ["jade green", "jade stone"], ["jade_green"]),
    ("tiger-eye-success", ["tiger eye gold", "tiger eye stone"], [""]),
    ("rose-quartz-love", ["rose quartz pink", "rose quartz"], ["rose_quartz"]),
    ("black-obsidian-shield", ["black obsidian", "obsidian"], ["obsidian"]),
    ("citrine-abundance", ["citrine yellow", "citrine crystal"], [""]),
    ("aromatherapy-essential", ["aromatherapy bracelet", "lava stone"], ["obsidian", "rose_quartz"]),
    
    # 20 from seed_real_products.sql
    ("amethyst-spiritual-protection", ["amethyst crystal bracelet", "purple amethyst"], ["amethyst"]),
    ("rose-quartz-love", ["rose quartz bracelet", "pink rose quartz"], ["rose_quartz"]),
    ("tiger-eye-confidence", ["tiger eye stone", "golden tiger eye"], [""]),
    ("black-obsidian-protection", ["black obsidian", "obsidian stone"], ["obsidian"]),
    ("citrine-wealth-attraction", ["citrine crystal", "yellow citrine"], [""]),
    ("green-aventurine-luck", ["green aventurine", "green crystal"], [""]),
    ("carnelian-creativity", ["carnelian red", "carnelian stone"], [""]),
    ("lapis-lazuli-wisdom", ["lapis lazuli blue gold", "lapis lazuli"], ["lapis_lazuli"]),
    ("howlite-calming", ["howlite white", "white howlite stone"], [""]),
    ("sodalite-logic-communication", ["sodalite blue white", "sodalite stone"], [""]),
    ("natural-turquoise-wrap", ["turquoise stone", "blue turquoise"], [""]),
    ("moonstone-intuition", ["moonstone white blue", "moonstone"], [""]),
    ("red-jasper-grounding", ["red jasper", "red jasper stone"], [""]),
    ("clear-quartz-master-healer", ["clear quartz crystal", "clear quartz"], ["clear_quartz"]),
    ("amazonite-courage-truth", ["amazonite stone", "amazonite green"], ["amazonite"]),
    ("hematite-magnetic-grounding", ["hematite silver", "hematite stone"], [""]),
    ("black-onyx-self-control", ["black onyx", "onyx stone"], [""]),
    ("fluorite-focus-balance", ["fluorite crystal", "fluorite multicolor"], [""]),
    ("jade-prosperity-charm", ["jade green stone", "jade bracelet"], ["jade_green"]),
    ("lavender-aromatherapy-bracelet", ["lava stone aromatherapy", "aromatherapy bracelet"], ["obsidian"]),
    
    # Pearl products (8 from seed_new_products.sql)
    ("akoya-pearl-elegance", ["akoya pearl", "white pearl"], [""]),
    ("freshwater-pearl-drops", ["freshwater pearl", "pearl jewelry"], [""]),
    ("tahitian-black-pearl", ["tahitian black pearl", "black pearl"], [""]),
    ("south-sea-golden-pearl", ["golden south sea pearl", "gold pearl"], [""]),
    ("baroque-pearl-charm", ["baroque pearl", "pearl charm"], [""]),
    ("rice-pearl-minimalist", ["rice pearl", "small pearl"], [""]),
    ("coin-pearl-statement", ["coin pearl", "pearl statement"], [""]),
    ("biwa-pearl-wrap", ["biwa pearl", "pearl wrap"], [""]),
    
    # Jade products (8 from seed_new_products.sql)
    ("hetian-jade-bangle", ["hetian jade", "white jade bangle"], ["jade_green"]),
    ("jadeite-imperial-green", ["jadeite imperial green", "emerald jade"], ["jade_green"]),
    ("dushan-jade-bracelet", ["dushan jade", "multicolored jade"], ["jade_green"]),
    ("xiuyan-jade-bracelet", ["xiuyan jade", "serpentine jade"], [""]),
    ("lantian-jade-wisdom", ["lantian jade", "yellow green jade"], [""]),
    ("nanyang-jade-bracelet", ["nanyang jade", "earthy jade"], [""]),
    ("yellow-jade-prosperity", ["yellow jade", "golden jade"], [""]),
    ("lavender-jade-bracelet", ["lavender jade", "purple jade"], [""]),
    
    # Fragrance products (6 from seed_new_products.sql)
    ("agarwood-zen-bracelet", ["agarwood", "oud wood beads"], [""]),
    ("sandalwood-meditation", ["sandalwood beads", "sandalwood"], [""]),
    ("jasmine-scented-bead", ["scented wood beads", "jasmine wood"], [""]),
    ("rose-fragrance-bracelet", ["rose fragrance beads", "rose quartz"], ["rose_quartz"]),
    ("musk-sandalwood-bracelet", ["musk sandalwood", "wood beads"], [""]),
    ("tibetan-incense-bead", ["tibetan incense", "incense beads"], [""]),
    
    # Crystal products (8 from seed_new_products.sql)
    ("smoky-quartz-grounding", ["smoky quartz", "brown quartz"], [""]),
    ("rutilated-quartz-bracelet", ["rutilated quartz", "golden rutile"], [""]),
    ("sunstone-joy", ["sunstone", "golden sunstone"], [""]),
    ("labradorite-magic", ["labradorite", "iridescent labradorite"], [""]),
    ("prehnite-angel-light", ["prehnite", "pale green prehnite"], [""]),
    ("unakite-balance", ["unakite", "unakite stone"], [""]),
    ("chrysoprase-success", ["chrysoprase", "apple green chrysoprase"], [""]),
    ("serpentine-calming", ["serpentine stone", "olive serpentine"], [""]),
    
    # Wood products (6 from seed_new_products.sql)
    ("red-sandalwood-bracelet", ["red sandalwood", "sandalwood beads"], [""]),
    ("bodhi-seed-prayer", ["bodhi seeds", "bodhi seed mala"], [""]),
    ("ebony-minimalist", ["ebony wood", "black wood beads"], [""]),
    ("olive-wood-bracelet", ["olive wood", "olive wood grain"], [""]),
    ("multi-gemstone-treasure", ["mixed gemstones", "assorted crystals"], ["amethyst", "rose_quartz", "jade_green"]),
    ("amethyst-pearl-fusion", ["amethyst pearl", "purple white beads"], ["amethyst"]),
]

def main():
    results = {}
    
    # First, verify all known photos work
    print("=== Verifying known photos ===")
    verified_known = {}
    for name, pid in KNOWN_PHOTOS.items():
        ok = verify_url(pid)
        print(f"  {name}: photo-{pid} -> {'✓' if ok else '✗'}")
        if ok:
            verified_known[name] = pid
    print(f"\nVerified known: {len(verified_known)}/{len(KNOWN_PHOTOS)}\n")
    
    # Try to discover more photos via search
    print("=== Discovering photos via Unsplash search ===")
    discovered = {}
    search_queries = [
        "amethyst crystal", "rose quartz pink", "tiger eye stone", "black obsidian",
        "citrine yellow", "green aventurine", "carnelian red", "lapis lazuli",
        "howlite white", "sodalite blue", "turquoise stone", "moonstone white",
        "red jasper", "clear quartz", "amazonite green", "hematite silver",
        "black onyx", "fluorite crystal", "jade green", "lava stone",
        "white pearl jewelry", "black pearl", "golden pearl",
        "wood beads bracelet", "sandalwood beads", "labradorite crystal",
        "smoky quartz", "chrysoprase green", "serpentine stone",
        "mixed gemstones bracelet", "crystal bracelet jewelry",
    ]
    
    for q in search_queries:
        ids = discover_photos(q, 3)
        if ids:
            # Verify each
            valid = []
            for pid in ids:
                if verify_url(pid):
                    valid.append(pid)
                    if len(valid) >= 2:
                        break
            if valid:
                discovered[q] = valid
                print(f"  {q}: {valid}")
        time.sleep(0.5)
    
    print(f"\nDiscovered: {len(discovered)} search queries with results\n")
    
    # Build final mapping
    print("=== Building product mapping ===")
    all_known = {**verified_known}
    
    for slug, queries, known_refs in PRODUCTS:
        urls = []
        
        # 1. Try known refs
        for ref in known_refs:
            if ref in all_known:
                urls.append(format_url(all_known[ref]))
                if len(urls) >= 2:
                    break
        
        # 2. Try discovered photos from search
        if len(urls) < 2:
            for q in queries:
                if q in discovered and discovered[q]:
                    for pid in discovered[q]:
                        url = format_url(pid)
                        if url not in urls:
                            urls.append(url)
                            if len(urls) >= 2:
                                break
                if len(urls) >= 2:
                    break
        
        # 3. Fallback: use any known photo
        if len(urls) == 0:
            # Use amethyst as generic crystal
            urls.append(format_url(all_known.get("amethyst", "")))
        if len(urls) == 1:
            # Add rose quartz as second fallback
            second = format_url(all_known.get("rose_quartz", ""))
            if second != urls[0]:
                urls.append(second)
        
        results[slug] = urls
        print(f"  {slug}: {len(urls)} URLs")
    
    # Write mapping file
    out_path = os.path.join(os.path.dirname(__file__), "real_images_mapping.json")
    with open(out_path, "w") as f:
        json.dump(results, f, indent=2)
    print(f"\n✅ Written {len(results)} products to {out_path}")
    
    # Print all URLs for verification
    print("\n=== ALL URLS ===")
    for slug, url_list in results.items():
        for u in url_list:
            print(f"{slug}|{u}")

if __name__ == "__main__":
    main()
