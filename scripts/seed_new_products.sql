-- seed_new_products.sql - 36 new products (pearl, jade, fragrance, crystal, wood/mixed)
-- All use placehold.co/600x600/1a1a1a/C8A45C?text= for images
-- Idempotent via ON CONFLICT (slug) DO UPDATE

-- ===== A. 珍珠 (Pearl) - 8 products =====
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Akoya Pearl Elegance Bracelet','akoya-pearl-elegance','Classic Japanese Akoya cultured pearls with luminous white lustre, hand-knotted on silk for timeless elegance.',6999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Akoya+Pearl","https://placehold.co/600x600/1a1a1a/C8A45C?text=Pearl+Elegance"}','pearl','{"akoya","pearl","elegance","classic","white pearl"}','{"main_stone":"Akoya Pearl","bead_size":"7mm","string_type":"Silk cord","origin":"Japan"}',50)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Freshwater Pearl Drops Bracelet','freshwater-pearl-drops','Irresistible teardrop freshwater pearls in creamy white, a romantic and whimsical design for everyday luxury.',4499,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Freshwater+Pearl","https://placehold.co/600x600/1a1a1a/C8A45C?text=Pearl+Drops"}','pearl','{"freshwater pearl","teardrop","romantic","everyday"}','{"main_stone":"Freshwater Pearl","bead_size":"6x9mm drop","string_type":"Elastic silk","origin":"China"}',80)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Tahitian Black Pearl Bracelet','tahitian-black-pearl','Exotic Tahitian black pearls with iridescent peacock-green overtones, nature''s most dramatic gemstone.',9999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Tahitian+Pearl","https://placehold.co/600x600/1a1a1a/C8A45C?text=Black+Pearl"}','pearl','{"tahitian","black pearl","exotic","peacock","luxury"}','{"main_stone":"Tahitian Black Pearl","bead_size":"9mm","string_type":"Silk cord","origin":"French Polynesia"}',30)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('South Sea Golden Pearl Bracelet','south-sea-golden-pearl','Rare golden South Sea pearls with deep satiny lustre, the ultimate statement of luxury and sophistication.',12999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Golden+Pearl","https://placehold.co/600x600/1a1a1a/C8A45C?text=South+Sea"}','pearl','{"south sea","golden pearl","rare","luxury","statement"}','{"main_stone":"South Sea Golden Pearl","bead_size":"10mm","string_type":"Silk cord","origin":"Australia"}',20)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Baroque Pearl Charm Bracelet','baroque-pearl-charm','Unique baroque freshwater pearls paired with gold-plated charms, celebrating organic beauty and individuality.',5499,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Baroque+Pearl","https://placehold.co/600x600/1a1a1a/C8A45C?text=Pearl+Charm"}','pearl','{"baroque pearl","charm bracelet","organic","artisan","unique"}','{"main_stone":"Baroque Pearl","bead_size":"8-12mm","string_type":"Gold-plated chain","accent":"Gold-plated charms","origin":"China"}',45)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Rice Pearl Minimalist Bracelet','rice-pearl-minimalist','Delicate rice-shaped freshwater pearls on a fine chain, understated elegance for the modern minimalist.',3499,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Rice+Pearl","https://placehold.co/600x600/1a1a1a/C8A45C?text=Minimalist"}','pearl','{"rice pearl","minimalist","delicate","everyday","simple"}','{"main_stone":"Rice Pearl","bead_size":"4x6mm rice","string_type":"Stainless steel chain","origin":"China"}',100)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Coin Pearl Statement Bracelet','coin-pearl-statement','Flat coin-shaped freshwater pearls in shimmering white-gold tones, a bold contemporary design that turns heads.',7999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Coin+Pearl","https://placehold.co/600x600/1a1a1a/C8A45C?text=Statement"}','pearl','{"coin pearl","statement","bold","contemporary","fashion"}','{"main_stone":"Coin Pearl","bead_size":"12mm coin","string_type":"Elastic cord","origin":"China"}',35)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Biwa Pearl Wrap Bracelet','biwa-pearl-wrap','Long Biwa pearl strand designed for multi-wrap styling, featuring unique elongated baroque pearls with stunning lustre.',6499,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Biwa+Pearl","https://placehold.co/600x600/1a1a1a/C8A45C?text=Wrap+Bracelet"}','pearl','{"biwa pearl","wrap","baroque","creative","layered"}','{"main_stone":"Biwa Pearl","bead_size":"5x12mm baroque","string_type":"Waxed cotton cord","origin":"Japan"}',40)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

-- ===== B. 玉石 (Jade) - 8 additional products =====
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Hetian Jade Bangle Bracelet','hetian-jade-bangle','Classic Hetian jade bangle in creamy white with warm translucence, revered in Chinese culture for purity and virtue.',9999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Hetian+Jade","https://placehold.co/600x600/1a1a1a/C8A45C?text=Jade+Bangle"}','jade','{"hetian jade","bangle","nephrite","traditional","auspicious"}','{"main_stone":"Hetian Jade","bead_size":"Bangle 58mm","string_type":"N/A","origin":"China"}',25)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Jadeite Imperial Green Bracelet','jadeite-imperial-green','Rare imperial green jadeite beads with vivid emerald colour, the most prized jade in the world.',12999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Jadeite+Green","https://placehold.co/600x600/1a1a1a/C8A45C?text=Imperial+Jade"}','jade','{"jadeite","imperial green","emerald","rare","collector"}','{"main_stone":"Jadeite Jade","bead_size":"8mm","string_type":"Silk cord","origin":"Myanmar"}',15)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Dushan Jade Bracelet','dushan-jade-bracelet','Unique Dushan jade from Henan province in multi-colour tones of green, purple, white and yellow.',5899,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Dushan+Jade","https://placehold.co/600x600/1a1a1a/C8A45C?text=Multi+Color+Jade"}','jade','{"dushan jade","multi-color","unique","henan","chinese jade"}','{"main_stone":"Dushan Jade","bead_size":"10mm","string_type":"Elastic silk","origin":"China"}',30)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Xiuyan Jade Bracelet','xiuyan-jade-bracelet','Serpentine-based Xiuyan jade in soothing olive-green tones, known for its smooth waxy lustre since Neolithic times.',4499,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Xiuyan+Jade","https://placehold.co/600x600/1a1a1a/C8A45C?text=Olive+Jade"}','jade','{"xiuyan jade","olive green","serpentine","historical","smooth"}','{"main_stone":"Xiuyan Jade","bead_size":"8mm","string_type":"Elastic silk","origin":"China"}',50)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Lantian Jade Wisdom Bracelet','lantian-jade-wisdom','Ancient Lantian jade from Shaanxi in subtle yellow-green hues, one of China''s oldest jade sources used for 4,000 years.',5199,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Lantian+Jade","https://placehold.co/600x600/1a1a1a/C8A45C?text=Wisdom+Jade"}','jade','{"lantian jade","yellow green","ancient","wisdom","shaanxi"}','{"main_stone":"Lantian Jade","bead_size":"8mm","string_type":"Silk cord","origin":"China"}',35)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Nanyang Jade Bracelet','nanyang-jade-bracelet','Earthy Nanyang jade (Dushan variety) with distinctive mottled patterns in greens, browns and yellows.',4799,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Nanyang+Jade","https://placehold.co/600x600/1a1a1a/C8A45C?text=Earthy+Jade"}','jade','{"nanyang jade","earthy","mottled","dushan","natural"}','{"main_stone":"Nanyang Jade","bead_size":"10mm","string_type":"Elastic cord","origin":"China"}',40)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Yellow Jade Prosperity Bracelet','yellow-jade-prosperity','Golden-yellow nephrite jade beads symbolising wealth and prosperity, warm and uplifting energy for success.',5799,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Yellow+Jade","https://placehold.co/600x600/1a1a1a/C8A45C?text=Prosperity+Jade"}','jade','{"yellow jade","prosperity","wealth","golden","auspicious"}','{"main_stone":"Yellow Jade","bead_size":"8mm","string_type":"Elastic silk","origin":"China"}',45)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Lavender Jade Bracelet','lavender-jade-bracelet','Exquisite lavender jadeite beads in soft lilac-purple tones, rare and highly sought after by collectors.',8999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Lavender+Jade","https://placehold.co/600x600/1a1a1a/C8A45C?text=Purple+Jade"}','jade','{"lavender jade","jadeite","purple","rare","collector","feminine"}','{"main_stone":"Lavender Jade","bead_size":"8mm","string_type":"Silk cord","origin":"Myanmar"}',20)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

-- ===== C. 香珠 (Fragrance/Aromatherapy) - 6 additional products =====
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Agarwood Zen Bracelet','agarwood-zen-bracelet','Premium Vietnamese agarwood beads with rich woody and sweet notes, used for meditation and spiritual grounding for centuries.',7999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Agarwood","https://placehold.co/600x600/1a1a1a/C8A45C?text=Zen+Fragrance"}','aromatherapy','{"agarwood","oud","meditation","zen","spiritual","wood"}','{"main_stone":"Agarwood","bead_size":"8mm","string_type":"Elastic cord","origin":"Vietnam"}',25)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Sandalwood Meditation Bracelet','sandalwood-meditation','Mysore sandalwood beads with classic warm-woody fragrance, naturally calming and centering for yoga and meditation practice.',5299,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Sandalwood","https://placehold.co/600x600/1a1a1a/C8A45C?text=Meditation"}','aromatherapy','{"sandalwood","meditation","yoga","calming","woody","natural"}','{"main_stone":"Sandalwood","bead_size":"8mm","string_type":"Elastic cord","origin":"India"}',60)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Jasmine Scented Bead Bracelet','jasmine-scented-bead','Infused jasmine-scented wooden beads with delicate floral fragrance, layered with natural howlite for elegant contrast.',3999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Jasmine+Bead","https://placehold.co/600x600/1a1a1a/C8A45C?text=Floral+Fragrance"}','aromatherapy','{"jasmine","floral","scented","howlite","relaxing"}','{"main_stone":"Scented Wood","accent_stone":"Howlite","bead_size":"8mm","string_type":"Elastic cord","fragrance":"Jasmine"}',70)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Rose Fragrance Bracelet','rose-fragrance-bracelet','Romantic rose-scented beads with genuine rose quartz accents, combining beautiful fragrance with love-attracting crystal energy.',4599,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Rose+Fragrance","https://placehold.co/600x600/1a1a1a/C8A45C?text=Love+Rose"}','aromatherapy','{"rose","fragrance","romantic","rose quartz","floral"}','{"main_stone":"Scented Wood","accent_stone":"Rose Quartz","bead_size":"8mm","string_type":"Elastic cord","fragrance":"Rose"}',65)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Musk Sandalwood Bracelet','musk-sandalwood-bracelet','Warm sensual musk combined with creamy sandalwood, a deep earthy fragrance blend for grounding and confidence.',5599,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Musk+Sandalwood","https://placehold.co/600x600/1a1a1a/C8A45C?text=Earthy+Fragrance"}','aromatherapy','{"musk","sandalwood","earthy","sensual","grounding","confident"}','{"main_stone":"Scented Wood","bead_size":"10mm","string_type":"Elastic cord","fragrance":"Musk Sandalwood"}',40)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Tibetan Incense Bead Bracelet','tibetan-incense-bead','Traditional Tibetan incense-infused beads with warm herbal-spicy aroma, spiritually protective with brass accent beads.',4999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Tibetan+Incense","https://placehold.co/600x600/1a1a1a/C8A45C?text=Incense+Bead"}','aromatherapy','{"tibetan","incense","herbal","spicy","protective","spiritual"}','{"main_stone":"Incense Wood","bead_size":"8mm","string_type":"Elastic cord","accent":"Brass beads","origin":"Tibet"}',50)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

-- ===== D. 水晶 (Crystal) - 8 additional products =====
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Smoky Quartz Grounding Bracelet','smoky-quartz-grounding','Earthy brown-grey smoky quartz beads with natural transparency, powerful grounding stone that neutralises electromagnetic stress.',4499,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Smoky+Quartz","https://placehold.co/600x600/1a1a1a/C8A45C?text=Grounding"}','crystal','{"smoky quartz","grounding","protection","root chakra","natural"}','{"main_stone":"Smoky Quartz","bead_size":"8mm","string_type":"Elastic silk","origin":"Switzerland"}',60)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Rutilated Quartz Bracelet','rutilated-quartz-bracelet','Clear quartz with golden rutile needles frozen inside, amplifying energy and manifesting intentions with laser-like focus.',6499,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Rutilated+Quartz","https://placehold.co/600x600/1a1a1a/C8A45C?text=Golden+Rutile"}','crystal','{"rutilated quartz","rutile","golden","amplifier","manifestation"}','{"main_stone":"Rutilated Quartz","bead_size":"8mm","string_type":"Elastic silk","origin":"Brazil"}',30)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Sunstone Joy Bracelet','sunstone-joy','Sparkling golden sunstone with aventurescent glitter, radiating warmth and joy like captured sunlight.',4799,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Sunstone","https://placehold.co/600x600/1a1a1a/C8A45C?text=Joy+Sparkle"}','crystal','{"sunstone","joy","happiness","aventurescent","golden","warmth"}','{"main_stone":"Sunstone","bead_size":"8mm","string_type":"Elastic silk","origin":"India"}',45)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Labradorite Magic Bracelet','labradorite-magic','Labradorite with striking blue-green labradorescence, the stone of magic and transformation that reveals hidden inner light.',6999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Labradorite","https://placehold.co/600x600/1a1a1a/C8A45C?text=Magic+Blue"}','crystal','{"labradorite","magic","transformation","aura","iridescent","third eye"}','{"main_stone":"Labradorite","bead_size":"8mm","string_type":"Elastic silk","origin":"Madagascar"}',35)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Prehnite Angel Light Bracelet','prehnite-angel-light','Pale green prehnite with pearly lustre, known as the stone of angelic connection and unconditional love.',5499,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Prehnite","https://placehold.co/600x600/1a1a1a/C8A45C?text=Angel+Light"}','crystal','{"prehnite","angel light","unconditional love","pale green","heart chakra"}','{"main_stone":"Prehnite","bead_size":"8mm","string_type":"Elastic silk","origin":"South Africa"}',30)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Unakite Balance Bracelet','unakite-balance','Mottled green and pink unakite balancing heart and root chakras, promoting emotional healing and inner harmony.',4199,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Unakite","https://placehold.co/600x600/1a1a1a/C8A45C?text=Balance"}','crystal','{"unakite","balance","emotional healing","green pink","harmony"}','{"main_stone":"Unakite","bead_size":"8mm","string_type":"Elastic silk","origin":"South Africa"}',50)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Chrysoprase Success Bracelet','chrysoprase-success','Vibrant apple-green chrysoprase the stone of success and entrepreneurship, opening new opportunities and financial prosperity.',5999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Chrysoprase","https://placehold.co/600x600/1a1a1a/C8A45C?text=Success+Green"}','crystal','{"chrysoprase","success","prosperity","apple green","nickel","heart chakra"}','{"main_stone":"Chrysoprase","bead_size":"8mm","string_type":"Elastic silk","origin":"Australia"}',30)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Serpentine Calming Bracelet','serpentine-calming','Smooth serpentine in olive-green tones with subtle wavy patterns, gently calming the mind and soothing emotional stress.',3499,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Serpentine","https://placehold.co/600x600/1a1a1a/C8A45C?text=Calming+Green"}','crystal','{"serpentine","calming","stress relief","olive green","soothing"}','{"main_stone":"Serpentine","bead_size":"8mm","string_type":"Elastic silk","origin":"China"}',70)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

-- ===== E. 木质/多宝 (Wood/Mixed) - 6 products =====
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Red Sandalwood Bracelet','red-sandalwood-bracelet','Rich red sandalwood beads with natural woody fragrance, each bead develops a deeper patina over time with wear.',3999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Red+Sandalwood","https://placehold.co/600x600/1a1a1a/C8A45C?text=Wood+Fragrance"}','wood','{"red sandalwood","wood","fragrant","patina","natural","woody"}','{"main_stone":"Red Sandalwood","bead_size":"8mm","string_type":"Elastic cord","origin":"India"}',80)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Bodhi Seed Prayer Bracelet','bodhi-seed-prayer','Authentic Bodhi seeds with natural texture, traditionally used for Buddhist prayer malas and meditation counting.',2999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Bodhi+Seed","https://placehold.co/600x600/1a1a1a/C8A45C?text=Prayer+Bracelet"}','wood','{"bodhi seed","prayer","mala","buddhist","meditation","traditional"}','{"main_stone":"Bodhi Seed","bead_size":"8mm","string_type":"Waxed cotton cord","origin":"India"}',100)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Ebony Minimalist Bracelet','ebony-minimalist','Sleek black African ebony wood beads with glass-like polish, ultra-modern minimalist design for discerning men and women.',4599,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Ebony+Wood","https://placehold.co/600x600/1a1a1a/C8A45C?text=Minimalist+Black"}','wood','{"ebony","minimalist","black","modern","men","sleek"}','{"main_stone":"Ebony Wood","bead_size":"8mm","string_type":"Elastic cord","origin":"Africa"}',55)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Olive Wood Bracelet','olive-wood-bracelet','Natural olive wood beads with beautiful grain patterns, a sustainable and unique piece connecting to Mediterranean tradition.',3499,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Olive+Wood","https://placehold.co/600x600/1a1a1a/C8A45C?text=Natural+Grain"}','wood','{"olive wood","natural","sustainable","mediterranean","grain","unique"}','{"main_stone":"Olive Wood","bead_size":"10mm","string_type":"Elastic cord","origin":"Greece"}',90)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Multi-Gemstone Treasure Bracelet','multi-gemstone-treasure','Assorted gemstone beads including amethyst, citrine, rose quartz, tiger eye and aventurine on one vibrant bracelet.',4999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Multi+Gemstone","https://placehold.co/600x600/1a1a1a/C8A45C?text=Treasure+Bracelet"}','mixed','{"multi-gemstone","assorted","treasure","colorful","vibrant","healing"}','{"main_stone":"Assorted Gemstones","bead_size":"8mm","string_type":"Elastic silk","composition":"Amethyst, Citrine, Rose Quartz, Tiger Eye, Aventurine"}',60)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Amethyst & Pearl Fusion Bracelet','amethyst-pearl-fusion','Luxurious fusion of deep purple amethyst and lustrous white pearls, combining spiritual protection with timeless elegance.',6999,'{"https://placehold.co/600x600/1a1a1a/C8A45C?text=Amethyst+Pearl","https://placehold.co/600x600/1a1a1a/C8A45C?text=Fusion+Bracelet"}','mixed','{"amethyst","pearl","fusion","luxury","purple white","chakra"}','{"main_stone":"Amethyst","accent_stone":"Freshwater Pearl","bead_size":"8mm","string_type":"Silk cord","origin":"Brazil/China"}',35)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images, tags=EXCLUDED.tags, materials=EXCLUDED.materials, description=EXCLUDED.description, price_cents=EXCLUDED.price_cents;
