-- 003_seed_real.sql - 20 real sellable crystal bracelet products + design elements
-- Uses ON CONFLICT for idempotent re-runs

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Amethyst Spiritual Protection Bracelet','amethyst-spiritual-protection','Hand-strung natural amethyst beads in deep violet hues, known for spiritual protection and intuitive clarity.',4499,'{"https://source.unsplash.com/600x600/?crystal+bracelet+amethyst+close-up","https://source.unsplash.com/600x600/?purple+gemstone+bracelet+hand"}','crystal','{"amethyst","protection","spiritual","chakra"}','{"main_stone":"Amethyst","bead_size":"8mm","string_type":"Elastic silk","origin":"Brazil"}',65)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Rose Quartz Love Bracelet','rose-quartz-love','Soft pink rose quartz beads promoting love and self-compassion.',3999,'{"https://source.unsplash.com/600x600/?rose+quartz+bracelet+pink","https://source.unsplash.com/600x600/?pink+gemstone+bracelet+fashion"}','crystal','{"rose quartz","love","heart chakra","self-care"}','{"main_stone":"Rose Quartz","bead_size":"8mm","string_type":"Elastic silk","origin":"Brazil"}',80)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Tiger Eye Confidence Bracelet','tiger-eye-confidence','Bold golden-brown tiger eye beads with silky chatoyancy, stone of courage and willpower.',4299,'{"https://source.unsplash.com/600x600/?tiger+eye+bracelet+gold+brown","https://source.unsplash.com/600x600/?golden+stone+bracelet+macro"}','stone','{"tiger eye","confidence","grounding","courage"}','{"main_stone":"Tiger Eye","bead_size":"8mm","string_type":"Elastic silk","origin":"South Africa"}',55)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Black Obsidian Protection Bracelet','black-obsidian-protection','Sleek black obsidian beads polished to mirror-like sheen, powerful psychic shield against negative energy.',3699,'{"https://source.unsplash.com/600x600/?black+obsidian+bracelet","https://source.unsplash.com/600x600/?dark+gemstone+bracelet"}','stone','{"obsidian","protection","grounding","black stone"}','{"main_stone":"Black Obsidian","bead_size":"8mm","string_type":"Elastic silk","origin":"Mexico"}',90)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Citrine Wealth Attraction Bracelet','citrine-wealth-attraction','Warm golden citrine beads radiating solar energy, the merchants stone for abundance and success.',4799,'{"https://source.unsplash.com/600x600/?citrine+bracelet+yellow+gold","https://source.unsplash.com/600x600/?golden+crystal+bracelet+hand"}','crystal','{"citrine","abundance","wealth","solar plexus"}','{"main_stone":"Citrine","bead_size":"8mm","string_type":"Elastic silk","origin":"Brazil"}',45)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Green Aventurine Luck Bracelet','green-aventurine-luck','Vibrant green aventurine flecked with natural shimmer, believed to attract luck and open opportunities.',3899,'{"https://source.unsplash.com/600x600/?green+aventurine+bracelet","https://source.unsplash.com/600x600/?green+stone+crystal+bracelet"}','crystal','{"aventurine","luck","prosperity","heart chakra"}','{"main_stone":"Green Aventurine","bead_size":"8mm","string_type":"Elastic silk","origin":"India"}',70)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Carnelian Creativity Bracelet','carnelian-creativity','Fiery orange-red carnelian with translucent glow that energizes creative flow.',3999,'{"https://source.unsplash.com/600x600/?carnelian+bracelet+orange+red","https://source.unsplash.com/600x600/?fiery+crystal+bracelet+close-up"}','crystal','{"carnelian","creativity","motivation","sacral chakra"}','{"main_stone":"Carnelian","bead_size":"8mm","string_type":"Elastic silk","origin":"Madagascar"}',50)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Lapis Lazuli Wisdom Bracelet','lapis-lazuli-wisdom','Deep royal blue lapis lazuli flecked with golden pyrite, worn since antiquity for wisdom and truth.',5299,'{"https://source.unsplash.com/600x600/?lapis+lazuli+bracelet+blue+gold","https://source.unsplash.com/600x600/?blue+gemstone+bracelet+hand"}','stone','{"lapis lazuli","wisdom","intuition","throat chakra"}','{"main_stone":"Lapis Lazuli","bead_size":"8mm","string_type":"Elastic silk","origin":"Afghanistan"}',35)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Howlite Calming Bracelet','howlite-calming','White howlite with delicate grey veining evoking peaceful stillness, calms overactive mind.',3599,'{"https://source.unsplash.com/600x600/?white+howlite+bracelet","https://source.unsplash.com/600x600/?marble+stone+bracelet"}','stone','{"howlite","calming","anxiety","meditation"}','{"main_stone":"Howlite","bead_size":"8mm","string_type":"Elastic silk","origin":"USA"}',60)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Sodalite Logic & Communication Bracelet','sodalite-logic-communication','Navy blue sodalite streaked with white calcite promoting rational thought and clear expression.',4199,'{"https://source.unsplash.com/600x600/?sodalite+bracelet+blue+white","https://source.unsplash.com/600x600/?blue+crystal+bracelet+macro"}','stone','{"sodalite","communication","logic","throat chakra"}','{"main_stone":"Sodalite","bead_size":"8mm","string_type":"Elastic silk","origin":"Canada"}',40)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Natural Turquoise Wrap Bracelet','natural-turquoise-wrap','Genuine turquoise nuggets multi-wrap design with warm copper accents, Southwestern artisan tradition.',6999,'{"https://source.unsplash.com/600x600/?turquoise+bracelet+wrap+style","https://source.unsplash.com/600x600/?blue+turquoise+jewelry+hand"}','stone','{"turquoise","wrap bracelet","southwestern","protection"}','{"main_stone":"Turquoise","bead_size":"6-10mm nugget","string_type":"Waxed cotton cord","accent":"Copper beads","origin":"USA"}',25)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Moonstone Intuition Bracelet','moonstone-intuition','Pearly white moonstone with ethereal blue adularescence, connects to lunar energy and divine feminine intuition.',4899,'{"https://source.unsplash.com/600x600/?moonstone+bracelet+white+blue","https://source.unsplash.com/600x600/?iridescent+crystal+bracelet"}','crystal','{"moonstone","intuition","feminine","third eye"}','{"main_stone":"Moonstone","bead_size":"8mm","string_type":"Elastic silk","origin":"India"}',30)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Red Jasper Grounding Bracelet','red-jasper-grounding','Rich brick-red jasper with earthy patterning connecting to root chakra and physical vitality.',3799,'{"https://source.unsplash.com/600x600/?red+jasper+bracelet","https://source.unsplash.com/600x600/?red+stone+beaded+bracelet"}','stone','{"red jasper","grounding","root chakra","vitality"}','{"main_stone":"Red Jasper","bead_size":"8mm","string_type":"Elastic silk","origin":"South Africa"}',55)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Clear Quartz Master Healer Bracelet','clear-quartz-master-healer','Crystal-clear quartz with rainbow fractures that amplify intention, master healer stone for all chakras.',4599,'{"https://source.unsplash.com/600x600/?clear+quartz+bracelet+crystal","https://source.unsplash.com/600x600/?transparent+gemstone+bracelet"}','crystal','{"clear quartz","master healer","versatile","amplification"}','{"main_stone":"Clear Quartz","bead_size":"8mm","string_type":"Elastic silk","origin":"Brazil"}',75)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Amazonite Courage & Truth Bracelet','amazonite-courage-truth','Turquoise-green amazonite soothing the nervous system, encouraging authentic self-expression.',4399,'{"https://source.unsplash.com/600x600/?amazonite+bracelet+turquoise+green","https://source.unsplash.com/600x600/?calming+blue+green+crystal+bracelet"}','stone','{"amazonite","truth","courage","throat chakra"}','{"main_stone":"Amazonite","bead_size":"8mm","string_type":"Elastic silk","origin":"Brazil"}',40)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Hematite Magnetic Grounding Bracelet','hematite-magnetic-grounding','Silver-grey hematite with high-polish metallic mirror finish, grounds excess energy and improves focus.',3499,'{"https://source.unsplash.com/600x600/?hematite+bracelet+silver+grey","https://source.unsplash.com/600x600/?metallic+stone+bracelet+macro"}','stone','{"hematite","grounding","focus","minimalist"}','{"main_stone":"Hematite","bead_size":"8mm","string_type":"Elastic silk","origin":"Brazil"}',85)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Black Onyx Self-Control Bracelet','black-onyx-self-control','Deep black onyx polished to vitreous gloss for self-mastery and wise decisions under pressure.',3999,'{"https://source.unsplash.com/600x600/?black+onyx+bracelet","https://source.unsplash.com/600x600/?onyx+beaded+bracelet+close-up"}','stone','{"black onyx","self-control","protection","professional"}','{"main_stone":"Black Onyx","bead_size":"8mm","string_type":"Elastic silk","origin":"India"}',65)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Fluorite Focus & Balance Bracelet','fluorite-focus-balance','Multicolored fluorite in green, purple, blue bands enhancing concentration and mental clarity.',4499,'{"https://source.unsplash.com/600x600/?fluorite+bracelet+multi+color","https://source.unsplash.com/600x600/?rainbow+crystal+bracelet"}','crystal','{"fluorite","focus","balance","third eye"}','{"main_stone":"Fluorite","bead_size":"8mm","string_type":"Elastic silk","origin":"China"}',45)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Jade Prosperity Charm Bracelet','jade-prosperity-charm','Smooth green jade paired with gold-plated prosperity charm, centuries of tradition for luck and abundance.',5799,'{"https://source.unsplash.com/600x600/?green+jade+bracelet+charm","https://source.unsplash.com/600x600/?green+stone+prosperity+bracelet"}','jade','{"jade","prosperity","charm","harmony"}','{"main_stone":"Jade","bead_size":"8mm","string_type":"Silk cord with knotting","accent":"Gold-plated charm","origin":"Myanmar"}',30)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Lavender Aromatherapy Essential Oil Bracelet','lavender-aromatherapy-bracelet','Diffuser bracelet with porous lava stone bead absorbing lavender essential oil, combined with soothing amethyst.',4999,'{"https://source.unsplash.com/600x600/?aromatherapy+bracelet+lava+stone","https://source.unsplash.com/600x600/?essential+oil+diffuser+bracelet"}','aromatherapy','{"aromatherapy","lavender","lava stone","calming"}','{"main_stone":"Lava Stone","accent_stone":"Amethyst","bead_size":"8mm","string_type":"Elastic cord"}',50)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock, images=EXCLUDED.images;

-- Design elements (25 items)
ALTER TABLE design_elements ADD CONSTRAINT IF NOT EXISTS unique_name_type UNIQUE (name, type);
INSERT INTO design_elements (name,type,color,material,shape,size_mm,image_url,price_cents,stock) VALUES
('Amethyst Round','bead','#7B2D8B','Natural Amethyst','round',8,'',150,200),
('Clear Quartz Round','bead','#E8E8E8','Clear Quartz','round',8,'',120,200),
('Rose Quartz Round','bead','#F7C0D0','Rose Quartz','round',8,'',180,150),
('Tiger Eye Round','bead','#B8860B','Tiger Eye','round',8,'',160,180),
('Black Obsidian Round','bead','#1A1A1A','Black Obsidian','round',8,'',100,250),
('Citrine Round','bead','#F5C542','Citrine','round',8,'',200,120),
('Green Aventurine Round','bead','#8FBC8F','Green Aventurine','round',8,'',130,170),
('Lapis Lazuli Round','bead','#2E5090','Lapis Lazuli','round',8,'',220,100),
('Jade Round','bead','#2E8B57','Nephrite Jade','round',10,'',350,80),
('Carnelian Round','bead','#D2691E','Carnelian','round',8,'',140,160),
('Howlite Round','bead','#E8E4D4','Howlite','round',8,'',110,200),
('Lava Stone Round','bead','#3C3C3C','Lava Stone','round',8,'',90,300),
('Sodalite Round','bead','#1E3F66','Sodalite','round',8,'',170,130),
('Moonstone Round','bead','#E8E0F0','Moonstone','round',8,'',250,90),
('Red Jasper Round','bead','#B22222','Red Jasper','round',8,'',160,140),
('Gold Spacer Bead','bead','#C8A45C','Gold-Filled','round',4,'',80,500),
('Silver Spacer Bead','bead','#C0C0C0','Sterling Silver','round',4,'',120,300),
('Gold Lobster Clasp','clasp','#C8A45C','Gold-Plated Alloy','lobster',0,'',200,500),
('Silver Lobster Clasp','clasp','#C0C0C0','Sterling Silver','lobster',0,'',350,200),
('Magnetic Gold Clasp','clasp','#C8A45C','Gold-Plated','magnetic',0,'',300,300),
('Gold Star Charm','charm','#C8A45C','Gold-Filled','star',0,'',500,150),
('Gold Moon Charm','charm','#C8A45C','Gold-Filled','moon',0,'',600,120),
('Gold Heart Charm','charm','#C8A45C','Gold-Filled','heart',0,'',450,180),
('Silver Tree of Life','charm','#C0C0C0','Sterling Silver','tree',0,'',800,80),
('Gold Evil Eye Charm','charm','#C8A45C','Gold-Filled','evil-eye',0,'',550,200)
ON CONFLICT (name, type) DO NOTHING;
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
-- seed_new_elements.sql - 47 new design elements (strings, beads, charms, pendants, clasps)
-- Idempotent via ON CONFLICT (name, type) DO NOTHING
-- First ensure unique constraint exists
ALTER TABLE design_elements ADD CONSTRAINT IF NOT EXISTS unique_name_type UNIQUE (name, type);

-- ===== Strings (type: 'string') - 10 types =====
INSERT INTO design_elements (name,type,color,material,shape,size_mm,image_url,price_cents,stock) VALUES
('Black Elastic Cord','string','#000000','Elastic Polyester','round',1.0,'',50,500),
('White Elastic Cord','string','#FFFFFF','Elastic Polyester','round',1.0,'',50,500),
('Clear Stretch Cord','string','#F5F5F5','Elastic Nylon','round',0.8,'',40,600),
('Brown Leather Cord','string','#8B4513','Genuine Leather','round',2.0,'',150,200),
('Gold Silk Cord','string','#C8A45C','Silk','round',1.5,'',200,150),
('Waxed Cotton Cord (Black)','string','#1A1A1A','Waxed Cotton','round',1.5,'',80,400),
('Stainless Steel Chain','string','#C0C0C0','Stainless Steel','chain',1.2,'',250,200),
('Silver Plated Chain','string','#E0E0E0','Silver-Plated Brass','chain',1.0,'',180,250),
('Adjustable Knot Cord (Beige)','string','#D2B48C','Cotton Blend','round',2.5,'',60,350),
('Memory Wire','string','#C0C0C0','Stainless Steel','coil',0.8,'',120,300)
ON CONFLICT (name, type) DO NOTHING;

-- ===== More Beads - 15 types =====
INSERT INTO design_elements (name,type,color,material,shape,size_mm,image_url,price_cents,stock) VALUES
('White Pearl Bead 6mm','bead','#F5F0E8','Freshwater Pearl','round',6.0,'',300,200),
('White Pearl Bead 8mm','bead','#F5F0E8','Freshwater Pearl','round',8.0,'',400,180),
('White Pearl Bead 10mm','bead','#F5F0E8','Freshwater Pearl','round',10.0,'',550,120),
('Black Pearl Bead 8mm','bead','#2F2F2F','Tahitian Cultured Pearl','round',8.0,'',800,80),
('Golden Pearl Bead 8mm','bead','#D4A84B','South Sea Cultured Pearl','round',8.0,'',1200,50),
('Baroque Pearl 8-12mm','bead','#F0E6D0','Freshwater Baroque Pearl','baroque',10.0,'',350,150),
('Glass Crystal Bead (Clear)','bead','#F0F0F0','Crystal Glass','round',8.0,'',60,500),
('Glass Crystal Bead (Gold)','bead','#C8A45C','Crystal Glass','round',8.0,'',80,500),
('Wooden Round Bead','bead','#8B6914','Natural Wood','round',10.0,'',30,600),
('Sandalwood Bead 8mm','bead','#C4A265','Sandalwood','round',8.0,'',120,300),
('Nephrite Jade Bead','bead','#5B8C3E','Nephrite Jade','round',10.0,'',400,100),
('Agate Slice','bead','#A0845C','Natural Agate','slice',12.0,'',200,200),
('Shell Bead White','bead','#FFF5E6','Mother of Pearl','round',8.0,'',80,400),
('Ceramic Bead Blue Glaze','bead','#4169E1','Ceramic','round',10.0,'',100,300),
('Lava Stone Bead (Black)','bead','#2C2C2C','Lava Stone','round',8.0,'',60,500)
ON CONFLICT (name, type) DO NOTHING;

-- ===== More Beads - continuation (spacer/gemstone) =====
INSERT INTO design_elements (name,type,color,material,shape,size_mm,image_url,price_cents,stock) VALUES
('Silver Spacer Bead 3mm','bead','#C0C0C0','Sterling Silver','round',3.0,'',100,400),
('Gold-Plated Spacer 3mm','bead','#C8A45C','Gold-Plated Brass','round',3.0,'',70,500),
('Gemstone Chip Assorted','bead','#E0D5C0','Mixed Gemstone Chips','chip',4.0,'',60,400),
('Howlite Oval Bead','bead','#E8E4D4','Howlite','oval',10.0,'',100,250),
('Hematite Round Bead','bead','#808080','Hematite','round',8.0,'',80,300),
('Unakite Round Bead','bead','#B5A08C','Unakite','round',8.0,'',120,200)
ON CONFLICT (name, type) DO NOTHING;

-- ===== More Charms - 10 types =====
INSERT INTO design_elements (name,type,color,material,shape,size_mm,image_url,price_cents,stock) VALUES
('Mini Tree of Life Charm','charm','#C8A45C','Gold-Plated Brass','tree',0,'',350,200),
('Elephant Charm (Gold)','charm','#C8A45C','Gold-Plated Brass','elephant',0,'',300,180),
('Hamsa Hand Charm','charm','#C8A45C','Gold-Plated Brass','hamsa',0,'',400,150),
('Evil Eye Charm (Blue)','charm','#4169E1','Enamel on Brass','evil-eye',0,'',250,250),
('Lotus Flower Charm','charm','#C8A45C','Gold-Plated Brass','lotus',0,'',350,180),
('Om Symbol Charm','charm','#C0C0C0','Sterling Silver','om',0,'',500,100),
('Buddha Charm (Gold)','charm','#C8A45C','Gold-Plated Brass','buddha',0,'',450,120),
('Heart Charm (Rose Gold)','charm','#D4A5A5','Rose Gold-Filled','heart',0,'',280,250),
('Star Charm (Silver)','charm','#C0C0C0','Sterling Silver','star',0,'',320,200),
('Moon Charm (Gold Crescent)','charm','#C8A45C','Gold-Filled','crescent',0,'',380,180)
ON CONFLICT (name, type) DO NOTHING;

-- ===== More Pendants - 8 types =====
INSERT INTO design_elements (name,type,color,material,shape,size_mm,image_url,price_cents,stock) VALUES
('Large Tree of Life Pendant','pendant','#C8A45C','Gold-Plated Brass','tree',25.0,'',800,80),
('Crystal Point Pendant (Clear)','pendant','#F0F0F0','Natural Clear Quartz','point',30.0,'',600,100),
('Coin Pendant (Gold)','pendant','#C8A45C','Gold-Plated Brass','coin',20.0,'',500,120),
('Cross Pendant (Silver)','pendant','#C0C0C0','Sterling Silver','cross',25.0,'',700,80),
('Feather Pendant (Gold)','pendant','#C8A45C','Gold-Plated Brass','feather',28.0,'',550,100),
('Key Pendant (Antique Bronze)','pendant','#CD7F32','Bronze','key',22.0,'',450,90),
('Circle Pendant (Silver)','pendant','#C0C0C0','Sterling Silver','circle',18.0,'',500,120),
('Teardrop Pendant (Rose Gold)','pendant','#D4A5A5','Rose Gold-Filled','teardrop',20.0,'',480,100)
ON CONFLICT (name, type) DO NOTHING;

-- ===== More Clasps - 4 types =====
INSERT INTO design_elements (name,type,color,material,shape,size_mm,image_url,price_cents,stock) VALUES
('Magnetic Clasp (Silver)','clasp','#C0C0C0','Stainless Steel','magnetic',0,'',280,300),
('Lobster Clasp (Gold)','clasp','#C8A45C','Gold-Plated','lobster',0,'',250,400),
('Toggle Clasp (Antique Bronze)','clasp','#CD7F32','Bronze','toggle',0,'',350,200),
('Screw Clasp (Silver)','clasp','#C0C0C0','Stainless Steel','screw',0,'',300,250)
ON CONFLICT (name, type) DO NOTHING;
