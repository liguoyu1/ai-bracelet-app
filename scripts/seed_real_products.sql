-- Real product seed data (idempotent with ON CONFLICT)
INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES

('Amethyst Spiritual Protection Bracelet','amethyst-spiritual-protection','Hand-strung natural amethyst beads in deep violet hues, known for spiritual protection and intuitive clarity.',4499,'{"https://source.unsplash.com/600x600/?crystal+bracelet+amethyst+close-up","https://source.unsplash.com/600x600/?purple+gemstone+bracelet+hand"}','crystal','{"amethyst","protection","spiritual","chakra"}','{"main_stone":"Amethyst","bead_size":"8mm","string_type":"Elastic silk","origin":"Brazil"}',65)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Rose Quartz Love Bracelet','rose-quartz-love','Soft pink rose quartz beads promoting love and self-compassion.',3999,'{"https://source.unsplash.com/600x600/?rose+quartz+bracelet+pink","https://source.unsplash.com/600x600/?pink+gemstone+bracelet+fashion"}','crystal','{"rose quartz","love","heart chakra","self-care"}','{"main_stone":"Rose Quartz","bead_size":"8mm","string_type":"Elastic silk","origin":"Brazil"}',80)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Tiger Eye Confidence Bracelet','tiger-eye-confidence','Bold golden-brown tiger eye beads with silky chatoyancy, known as stone of courage and willpower.',4299,'{"https://source.unsplash.com/600x600/?tiger+eye+bracelet+gold+brown","https://source.unsplash.com/600x600/?golden+stone+bracelet+macro"}','stone','{"tiger eye","confidence","grounding","courage"}','{"main_stone":"Tiger Eye","bead_size":"8mm","string_type":"Elastic silk","origin":"South Africa"}',55)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Black Obsidian Protection Bracelet','black-obsidian-protection','Sleek black obsidian beads polished to mirror-like sheen, powerful psychic shield against negative energy.',3699,'{"https://source.unsplash.com/600x600/?black+obsidian+bracelet","https://source.unsplash.com/600x600/?dark+gemstone+bracelet"}','stone','{"obsidian","protection","grounding","black stone"}','{"main_stone":"Black Obsidian","bead_size":"8mm","string_type":"Elastic silk","origin":"Mexico"}',90)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Citrine Wealth Attraction Bracelet','citrine-wealth-attraction','Warm golden citrine beads radiating solar energy, the merchants stone for abundance and success.',4799,'{"https://source.unsplash.com/600x600/?citrine+bracelet+yellow+gold","https://source.unsplash.com/600x600/?golden+crystal+bracelet+hand"}','crystal','{"citrine","abundance","wealth","solar plexus"}','{"main_stone":"Citrine","bead_size":"8mm","string_type":"Elastic silk","origin":"Brazil"}',45)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Green Aventurine Luck Bracelet','green-aventurine-luck','Vibrant green aventurine flecked with natural shimmer, believed to attract luck and open opportunities.',3899,'{"https://source.unsplash.com/600x600/?green+aventurine+bracelet","https://source.unsplash.com/600x600/?green+stone+crystal+bracelet"}','crystal','{"aventurine","luck","prosperity","heart chakra"}','{"main_stone":"Green Aventurine","bead_size":"8mm","string_type":"Elastic silk","origin":"India"}',70)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Carnelian Creativity Bracelet','carnelian-creativity','Fiery orange-red carnelian with translucent glow that energizes creative flow and boosts motivation.',3999,'{"https://source.unsplash.com/600x600/?carnelian+bracelet+orange+red","https://source.unsplash.com/600x600/?fiery+crystal+bracelet+close-up"}','crystal','{"carnelian","creativity","motivation","sacral chakra"}','{"main_stone":"Carnelian","bead_size":"8mm","string_type":"Elastic silk","origin":"Madagascar"}',50)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Lapis Lazuli Wisdom Bracelet','lapis-lazuli-wisdom','Deep royal blue lapis lazuli flecked with golden pyrite, worn since antiquity for wisdom and truth.',5299,'{"https://source.unsplash.com/600x600/?lapis+lazuli+bracelet+blue+gold","https://source.unsplash.com/600x600/?blue+gemstone+bracelet+hand"}','stone','{"lapis lazuli","wisdom","intuition","throat chakra"}','{"main_stone":"Lapis Lazuli","bead_size":"8mm","string_type":"Elastic silk","origin":"Afghanistan"}',35)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Howlite Calming Bracelet','howlite-calming','White howlite with delicate grey veining evoking peaceful stillness, calms overactive mind.',3599,'{"https://source.unsplash.com/600x600/?white+howlite+bracelet","https://source.unsplash.com/600x600/?marble+stone+bracelet"}','stone','{"howlite","calming","anxiety","meditation"}','{"main_stone":"Howlite","bead_size":"8mm","string_type":"Elastic silk","origin":"USA"}',60)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Sodalite Logic & Communication Bracelet','sodalite-logic-communication','Navy blue sodalite streaked with white calcite promoting rational thought and clear expression.',4199,'{"https://source.unsplash.com/600x600/?sodalite+bracelet+blue+white","https://source.unsplash.com/600x600/?blue+crystal+bracelet+macro"}','stone','{"sodalite","communication","logic","throat chakra"}','{"main_stone":"Sodalite","bead_size":"8mm","string_type":"Elastic silk","origin":"Canada"}',40)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Natural Turquoise Wrap Bracelet','natural-turquoise-wrap','Genuine turquoise nuggets multi-wrap design with warm copper accents, Southwestern artisan tradition.',6999,'{"https://source.unsplash.com/600x600/?turquoise+bracelet+wrap+style","https://source.unsplash.com/600x600/?blue+turquoise+jewelry+hand"}','stone','{"turquoise","wrap bracelet","southwestern","protection"}','{"main_stone":"Turquoise","bead_size":"6-10mm nugget","string_type":"Waxed cotton cord","accent":"Copper beads","origin":"USA"}',25)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Moonstone Intuition Bracelet','moonstone-intuition','Pearly white moonstone with ethereal blue adularescence, connects to lunar energy and divine feminine intuition.',4899,'{"https://source.unsplash.com/600x600/?moonstone+bracelet+white+blue","https://source.unsplash.com/600x600/?iridescent+crystal+bracelet"}','crystal','{"moonstone","intuition","feminine","third eye"}','{"main_stone":"Moonstone","bead_size":"8mm","string_type":"Elastic silk","origin":"India"}',30)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Red Jasper Grounding Bracelet','red-jasper-grounding','Rich brick-red jasper with earthy patterning connecting to root chakra and physical vitality.',3799,'{"https://source.unsplash.com/600x600/?red+jasper+bracelet","https://source.unsplash.com/600x600/?red+stone+beaded+bracelet"}','stone','{"red jasper","grounding","root chakra","vitality"}','{"main_stone":"Red Jasper","bead_size":"8mm","string_type":"Elastic silk","origin":"South Africa"}',55)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Clear Quartz Master Healer Bracelet','clear-quartz-master-healer','Crystal-clear quartz with rainbow fractures that amplify intention, master healer stone for all chakras.',4599,'{"https://source.unsplash.com/600x600/?clear+quartz+bracelet+crystal","https://source.unsplash.com/600x600/?transparent+gemstone+bracelet"}','crystal','{"clear quartz","master healer","versatile","amplification"}','{"main_stone":"Clear Quartz","bead_size":"8mm","string_type":"Elastic silk","origin":"Brazil"}',75)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Amazonite Courage & Truth Bracelet','amazonite-courage-truth','Turquoise-green amazonite soothing the nervous system, encouraging authentic self-expression.',4399,'{"https://source.unsplash.com/600x600/?amazonite+bracelet+turquoise+green","https://source.unsplash.com/600x600/?calming+blue+green+crystal+bracelet"}','stone','{"amazonite","truth","courage","throat chakra"}','{"main_stone":"Amazonite","bead_size":"8mm","string_type":"Elastic silk","origin":"Brazil"}',40)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Hematite Magnetic Grounding Bracelet','hematite-magnetic-grounding','Silver-grey hematite with high-polish metallic mirror finish, grounds excess energy and improves focus.',3499,'{"https://source.unsplash.com/600x600/?hematite+bracelet+silver+grey","https://source.unsplash.com/600x600/?metallic+stone+bracelet+macro"}','stone','{"hematite","grounding","focus","minimalist"}','{"main_stone":"Hematite","bead_size":"8mm","string_type":"Elastic silk","origin":"Brazil"}',85)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Black Onyx Self-Control Bracelet','black-onyx-self-control','Deep black onyx polished to vitreous gloss for self-mastery and wise decisions under pressure.',3999,'{"https://source.unsplash.com/600x600/?black+onyx+bracelet","https://source.unsplash.com/600x600/?onyx+beaded+bracelet+close-up"}','stone','{"black onyx","self-control","protection","professional"}','{"main_stone":"Black Onyx","bead_size":"8mm","string_type":"Elastic silk","origin":"India"}',65)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Fluorite Focus & Balance Bracelet','fluorite-focus-balance','Multicolored fluorite in green, purple, blue bands enhancing concentration and mental clarity.',4499,'{"https://source.unsplash.com/600x600/?fluorite+bracelet+multi+color","https://source.unsplash.com/600x600/?rainbow+crystal+bracelet"}','crystal','{"fluorite","focus","balance","third eye"}','{"main_stone":"Fluorite","bead_size":"8mm","string_type":"Elastic silk","origin":"China"}',45)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Jade Prosperity Charm Bracelet','jade-prosperity-charm','Smooth green jade paired with gold-plated prosperity charm, centuries of tradition for luck and abundance.',5799,'{"https://source.unsplash.com/600x600/?green+jade+bracelet+charm","https://source.unsplash.com/600x600/?green+stone+prosperity+bracelet"}','jade','{"jade","prosperity","charm","harmony"}','{"main_stone":"Jade","bead_size":"8mm","string_type":"Silk cord with knotting","accent":"Gold-plated charm","origin":"Myanmar"}',30)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

INSERT INTO products (name,slug,description,price_cents,images,category,tags,materials,stock) VALUES
('Lavender Aromatherapy Essential Oil Bracelet','lavender-aromatherapy-bracelet','Diffuser bracelet with porous lava stone bead absorbing lavender essential oil, combined with soothing amethyst.',4999,'{"https://source.unsplash.com/600x600/?aromatherapy+bracelet+lava+stone","https://source.unsplash.com/600x600/?essential+oil+diffuser+bracelet"}','aromatherapy','{"aromatherapy","lavender","lava stone","calming"}','{"main_stone":"Lava Stone","accent_stone":"Amethyst","bead_size":"8mm","string_type":"Elastic cord"}',50)
ON CONFLICT (slug) DO UPDATE SET stock=EXCLUDED.stock;

-- Design elements
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
