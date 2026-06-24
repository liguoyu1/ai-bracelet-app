#!/usr/bin/env python3
"""Seed products & design elements - self-contained."""
import json, os, sys, urllib.parse

DB = os.environ.get('DATABASE_URL')
if not DB: print("FATAL: DATABASE_URL not set"); sys.exit(1)

import psycopg2

PRODUCTS = json.loads(r'''
[
  {"name":"Amethyst Spiritual Protection Bracelet","slug":"amethyst-spiritual-protection","description":"Hand-strung natural amethyst beads in deep violet hues, known for spiritual protection and intuitive clarity.","price_cents":4499,"category":"crystal","tags":["amethyst","protection","spiritual","chakra"],"materials":"{\"main_stone\":\"Amethyst\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"Brazil\"}","stock":65,"unsplash_queries":["crystal bracelet amethyst close-up","purple gemstone bracelet hand"]},
  {"name":"Rose Quartz Love Bracelet","slug":"rose-quartz-love","description":"Soft pink rose quartz beads promoting love and self-compassion. Gentle rose tones complement any outfit while healing the heart chakra.","price_cents":3999,"category":"crystal","tags":["rose quartz","love","heart chakra","self-care"],"materials":"{\"main_stone\":\"Rose Quartz\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"Brazil\"}","stock":80,"unsplash_queries":["rose quartz bracelet pink","pink gemstone bracelet fashion"]},
  {"name":"Tiger Eye Confidence Bracelet","slug":"tiger-eye-confidence","description":"Bold golden-brown tiger eye beads with silky chatoyancy. Known as stone of courage and willpower, grounding the wearer while boosting confidence.","price_cents":4299,"category":"stone","tags":["tiger eye","confidence","grounding","courage"],"materials":"{\"main_stone\":\"Tiger Eye\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"South Africa\"}","stock":55,"unsplash_queries":["tiger eye bracelet gold brown","golden stone bracelet macro"]},
  {"name":"Black Obsidian Protection Bracelet","slug":"black-obsidian-protection","description":"Sleek black obsidian beads polished to mirror-like sheen, powerful psychic shield against negative energy. Dark glassy surface absorbs low vibrations.","price_cents":3699,"category":"stone","tags":["obsidian","protection","grounding","black stone"],"materials":"{\"main_stone\":\"Black Obsidian\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"Mexico\"}","stock":90,"unsplash_queries":["black obsidian bracelet","black stone beaded bracelet"]},
  {"name":"Citrine Wealth Attraction Bracelet","slug":"citrine-wealth-attraction","description":"Warm golden citrine beads radiating solar energy, the merchant's stone for abundance and success. Sunny yellow-orange tones manifest prosperity.","price_cents":4799,"category":"crystal","tags":["citrine","abundance","wealth","solar plexus"],"materials":"{\"main_stone\":\"Citrine\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"Brazil\"}","stock":45,"unsplash_queries":["citrine bracelet yellow gold","golden crystal bracelet hand"]},
  {"name":"Green Aventurine Luck Bracelet","slug":"green-aventurine-luck","description":"Vibrant green aventurine flecked with natural shimmer, believed to attract luck and open opportunities. Soothing sage-green for heart-centered calm.","price_cents":3899,"category":"crystal","tags":["aventurine","luck","prosperity","heart chakra"],"materials":"{\"main_stone\":\"Green Aventurine\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"India\"}","stock":70,"unsplash_queries":["green aventurine bracelet","green stone crystal bracelet"]},
  {"name":"Carnelian Creativity Bracelet","slug":"carnelian-creativity","description":"Fiery orange-red carnelian with translucent glow that energizes creative flow. Boosts motivation and courage, ignites the sacral chakra.","price_cents":3999,"category":"crystal","tags":["carnelian","creativity","motivation","sacral chakra"],"materials":"{\"main_stone\":\"Carnelian\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"Madagascar\"}","stock":50,"unsplash_queries":["carnelian bracelet orange red","fiery crystal bracelet close-up"]},
  {"name":"Lapis Lazuli Wisdom Bracelet","slug":"lapis-lazuli-wisdom","description":"Deep royal blue lapis lazuli flecked with golden pyrite, worn since antiquity for wisdom and truth. Aligns throat and third eye chakras.","price_cents":5299,"category":"stone","tags":["lapis lazuli","wisdom","intuition","throat chakra"],"materials":"{\"main_stone\":\"Lapis Lazuli\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"Afghanistan\"}","stock":35,"unsplash_queries":["lapis lazuli bracelet blue gold","blue gemstone bracelet hand"]},
  {"name":"Howlite Calming Bracelet","slug":"howlite-calming","description":"White howlite with delicate grey veining evoking peaceful stillness. Calms overactive mind, promotes restful sleep. Marble-like neutral appearance.","price_cents":3599,"category":"stone","tags":["howlite","calming","anxiety","meditation"],"materials":"{\"main_stone\":\"Howlite\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"USA\"}","stock":60,"unsplash_queries":["white howlite bracelet","marble stone bracelet"]},
  {"name":"Sodalite Logic & Communication Bracelet","slug":"sodalite-logic-communication","description":"Navy blue sodalite streaked with white calcite promoting rational thought and clear expression. Aligns throat chakra for articulate communication.","price_cents":4199,"category":"stone","tags":["sodalite","communication","logic","throat chakra"],"materials":"{\"main_stone\":\"Sodalite\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"Canada\"}","stock":40,"unsplash_queries":["sodalite bracelet blue white","blue crystal bracelet macro"]},
  {"name":"Natural Turquoise Wrap Bracelet","slug":"natural-turquoise-wrap","description":"Genuine turquoise nuggets multi-wrap design with warm copper accents, Southwestern artisan tradition. Each stone unique matrix veining.","price_cents":6999,"category":"stone","tags":["turquoise","wrap bracelet","southwestern","protection"],"materials":"{\"main_stone\":\"Turquoise\",\"bead_size\":\"6-10mm nugget\",\"string_type\":\"Waxed cotton cord\",\"accent\":\"Copper beads\",\"origin\":\"USA\"}","stock":25,"unsplash_queries":["turquoise bracelet wrap style","blue turquoise jewelry hand"]},
  {"name":"Moonstone Intuition Bracelet","slug":"moonstone-intuition","description":"Pearly white moonstone with ethereal blue adularescence. Connects to lunar energy and divine feminine intuition. Subtle shimmer enchanting all day.","price_cents":4899,"category":"crystal","tags":["moonstone","intuition","feminine","third eye"],"materials":"{\"main_stone\":\"Moonstone\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"India\"}","stock":30,"unsplash_queries":["moonstone bracelet white blue","iridescent crystal bracelet"]},
  {"name":"Red Jasper Grounding Bracelet","slug":"red-jasper-grounding","description":"Rich brick-red jasper with earthy patterning connecting to root chakra and vitality. Stabilizing stone prized for endurance and steady energy.","price_cents":3799,"category":"stone","tags":["red jasper","grounding","root chakra","vitality"],"materials":"{\"main_stone\":\"Red Jasper\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"South Africa\"}","stock":55,"unsplash_queries":["red jasper bracelet","red stone beaded bracelet"]},
  {"name":"Clear Quartz Master Healer Bracelet","slug":"clear-quartz-master-healer","description":"Crystal-clear quartz with rainbow fractures that amplify intention. Master healer stone works with all chakras. Bright translucent daily companion.","price_cents":4599,"category":"crystal","tags":["clear quartz","master healer","versatile","amplification"],"materials":"{\"main_stone\":\"Clear Quartz\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"Brazil\"}","stock":75,"unsplash_queries":["clear quartz bracelet crystal","transparent gemstone bracelet"]},
  {"name":"Amazonite Courage & Truth Bracelet","slug":"amazonite-courage-truth","description":"Turquoise-green amazonite soothing the nervous system, encouraging authentic self-expression. Cool pastel hue filters stress while speaking truth.","price_cents":4399,"category":"stone","tags":["amazonite","truth","courage","throat chakra"],"materials":"{\"main_stone\":\"Amazonite\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"Brazil\"}","stock":40,"unsplash_queries":["amazonite bracelet turquoise green","calming blue green crystal bracelet"]},
  {"name":"Hematite Magnetic Grounding Bracelet","slug":"hematite-magnetic-grounding","description":"Silver-grey hematite with high-polish metallic mirror finish. Grounds excess energy, improves focus. Neutral metallic, minimalist favorite.","price_cents":3499,"category":"stone","tags":["hematite","grounding","focus","minimalist"],"materials":"{\"main_stone\":\"Hematite\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"Brazil\"}","stock":85,"unsplash_queries":["hematite bracelet silver grey","metallic stone bracelet macro"]},
  {"name":"Black Onyx Self-Control Bracelet","slug":"black-onyx-self-control","description":"Deep black onyx polished to vitreous gloss for self-mastery and wise decisions under pressure. Sophisticated streamlined daily wear.","price_cents":3999,"category":"stone","tags":["black onyx","self-control","protection","professional"],"materials":"{\"main_stone\":\"Black Onyx\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"India\"}","stock":65,"unsplash_queries":["black onyx bracelet","onyx beaded bracelet close-up"]},
  {"name":"Fluorite Focus & Balance Bracelet","slug":"fluorite-focus-balance","description":"Multicolored fluorite in green, purple, blue bands enhancing concentration and mental clarity. Rainbow crystal harmonizes scattered thoughts.","price_cents":4499,"category":"crystal","tags":["fluorite","focus","balance","third eye"],"materials":"{\"main_stone\":\"Fluorite\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic silk\",\"origin\":\"China\"}","stock":45,"unsplash_queries":["fluorite bracelet multi color","rainbow crystal bracelet"]},
  {"name":"Jade Prosperity Charm Bracelet","slug":"jade-prosperity-charm","description":"Smooth green jade paired with gold-plated prosperity charm, centuries of tradition for luck and abundance. Timeless cultural heritage piece.","price_cents":5799,"category":"jade","tags":["jade","prosperity","charm","harmony"],"materials":"{\"main_stone\":\"Jade\",\"bead_size\":\"8mm\",\"string_type\":\"Silk cord with knotting\",\"accent\":\"Gold-plated charm\",\"origin\":\"Myanmar\"}","stock":30,"unsplash_queries":["green jade bracelet charm","green stone prosperity bracelet"]},
  {"name":"Lavender Aromatherapy Essential Oil Bracelet","slug":"lavender-aromatherapy-bracelet","description":"Diffuser bracelet with porous lava stone bead absorbing lavender essential oil, combined with soothing amethyst. Aromatherapy on-the-go.","price_cents":4999,"category":"aromatherapy","tags":["aromatherapy","lavender","lava stone","calming"],"materials":"{\"main_stone\":\"Lava Stone\",\"accent_stone\":\"Amethyst\",\"bead_size\":\"8mm\",\"string_type\":\"Elastic cord\"}","stock":50,"unsplash_queries":["aromatherapy bracelet lava stone","essential oil diffuser bracelet"]}
]
''')

conn = psycopg2.connect(DB)
cur = conn.cursor()

# Seed products
ins = 0
for p in PRODUCTS:
    qs = p.get('unsplash_queries', [])
    imgs = '{%s}' % ','.join(
        f'"https://source.unsplash.com/600x600/?{urllib.parse.quote(q)}"'
        for q in qs[:2]
    )
    tags = '{%s}' % ','.join(f'"{t}"' for t in p['tags'])
    try:
        cur.execute("""
            INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock)
            VALUES (%s,%s,%s,%s,%s::text[],%s,%s::text[],%s,%s)
            ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, description=EXCLUDED.description
        """, (p['name'],p['slug'],p['description'],p['price_cents'],
              imgs,p['category'],tags,p['materials'],p['stock']))
        ins += 1
        print(f"  ✓ {p['name']}")
    except Exception as e:
        print(f"  ✗ {p['name']}: {e}")

# Seed design elements
ELEMENTS = [
    ('Amethyst Round','bead','#7B2D8B','Natural Amethyst','round',8,150,200),
    ('Clear Quartz Round','bead','#E8E8E8','Clear Quartz','round',8,120,200),
    ('Rose Quartz Round','bead','#F7C0D0','Rose Quartz','round',8,180,150),
    ('Tiger Eye Round','bead','#B8860B','Tiger Eye','round',8,160,180),
    ('Black Obsidian Round','bead','#1A1A1A','Black Obsidian','round',8,100,250),
    ('Citrine Round','bead','#F5C542','Citrine','round',8,200,120),
    ('Green Aventurine Round','bead','#8FBC8F','Green Aventurine','round',8,130,170),
    ('Lapis Lazuli Round','bead','#2E5090','Lapis Lazuli','round',8,220,100),
    ('Jade Round','bead','#2E8B57','Nephrite Jade','round',10,350,80),
    ('Carnelian Round','bead','#D2691E','Carnelian','round',8,140,160),
    ('Howlite Round','bead','#E8E4D4','Howlite','round',8,110,200),
    ('Lava Stone Round','bead','#3C3C3C','Lava Stone','round',8,90,300),
    ('Sodalite Round','bead','#1E3F66','Sodalite','round',8,170,130),
    ('Moonstone Round','bead','#E8E0F0','Moonstone','round',8,250,90),
    ('Red Jasper Round','bead','#B22222','Red Jasper','round',8,160,140),
    ('Gold Spacer Bead','bead','#C8A45C','Gold-Filled','round',4,80,500),
    ('Silver Spacer Bead','bead','#C0C0C0','Sterling Silver','round',4,120,300),
    ('Gold Lobster Clasp','clasp','#C8A45C','Gold-Plated Alloy','lobster',0,200,500),
    ('Silver Lobster Clasp','clasp','#C0C0C0','Sterling Silver','lobster',0,350,200),
    ('Magnetic Gold Clasp','clasp','#C8A45C','Gold-Plated','magnetic',0,300,300),
    ('Gold Star Charm','charm','#C8A45C','Gold-Filled','star',0,500,150),
    ('Gold Moon Charm','charm','#C8A45C','Gold-Filled','moon',0,600,120),
    ('Gold Heart Charm','charm','#C8A45C','Gold-Filled','heart',0,450,180),
    ('Silver Tree of Life','charm','#C0C0C0','Sterling Silver','tree',0,800,80),
    ('Gold Evil Eye Charm','charm','#C8A45C','Gold-Filled','evil-eye',0,550,200),
]
el_ins = 0
for e in ELEMENTS:
    name,typ,color,material,shape,size,price,stock = e
    try:
        cur.execute("""
            INSERT INTO design_elements (name,type,color,material,shape,size_mm,image_url,price_cents,stock)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)
            ON CONFLICT (name, type) DO NOTHING
        """, (name,typ,color,material,shape,size,'',price,stock))
        el_ins += 1
    except Exception as ex:
        print(f"  ✗ {name}: {ex}")

conn.commit()
cur.close()
conn.close()
print(f"\n✅ {ins} products, {el_ins} elements seeded!")
