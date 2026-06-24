-- Seed data: products + design elements
-- Run after 001_init.sql

-- Products (pre-made bracelets)
INSERT INTO products (name, slug, description, price_cents, images, category, tags, materials, stock) VALUES
('Crystal Harmony Bracelet', 'crystal-harmony',
 'Handcrafted with natural amethyst and clear quartz crystals. Promotes emotional balance and spiritual awareness. Each bead is ethically sourced and individually selected for quality.',
 4999, ARRAY['https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=600', 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=600'],
 'crystal', ARRAY['amethyst', 'quartz', 'harmony', 'popular'], '{"main_stone": "Amethyst", "secondary": "Clear Quartz", "string": "Elastic silk", "bead_size": "8mm"}', 50),

('Lava Stone Grounding', 'lava-stone-grounding',
 'Natural lava stone beads infused with grounding essential oils. Each bead absorbs your favorite oils for aromatherapy on the go. Perfect for meditation and mindfulness practice.',
 3999, ARRAY['https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=600'],
 'stone', ARRAY['lava', 'grounding', 'meditation', 'essential-oils'], '{"main_stone": "Lava Stone", "bead_size": "8mm", "string": "Wax cord"}', 60),

('Jade Wisdom Bracelet', 'jade-wisdom',
 'Authentic green jade beads symbolizing wisdom, balance, and protection. A classic choice for those seeking harmony in their daily life. Jade has been treasured for millennia across cultures.',
 6999, ARRAY['https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=600', 'https://images.unsplash.com/photo-1611930022073-b7a4ba5fcccd?w=600'],
 'jade', ARRAY['jade', 'wisdom', 'classic', 'protection'], '{"main_stone": "Nephrite Jade", "bead_size": "10mm", "string": "Silk cord with tassel"}', 30),

('Tiger Eye Success', 'tiger-eye-success',
 'Golden-brown tiger eye beads known for their protective and grounding properties. Worn by leaders and entrepreneurs for courage and clear decision-making.',
 4499, ARRAY['https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=600'],
 'crystal', ARRAY['tiger-eye', 'success', 'protection', 'business'], '{"main_stone": "Tiger Eye", "bead_size": "8mm", "string": "Leather cord"}', 40),

('Rose Quartz Love', 'rose-quartz-love',
 'Gentle rose quartz beads promoting self-love, compassion, and emotional healing. A beautiful gift for yourself or someone special. Each bead is a natural untreated stone.',
 5499, ARRAY['https://images.unsplash.com/photo-1600612253971-422e7f7faeb6?w=600'],
 'crystal', ARRAY['rose-quartz', 'love', 'healing', 'gift'], '{"main_stone": "Rose Quartz", "bead_size": "8mm", "string": "Elastic silk"}', 35),

('Black Obsidian Shield', 'black-obsidian-shield',
 'Powerful black obsidian beads for psychic protection and spiritual grounding. This volcanic glass forms a protective shield against negativity and emotional stress.',
 3799, ARRAY['https://images.unsplash.com/photo-1602173574767-37ac01994b2a?w=600'],
 'stone', ARRAY['obsidian', 'protection', 'shield', 'grounding'], '{"main_stone": "Black Obsidian", "bead_size": "10mm", "string": "Wax cord"}', 25),

('Citrine Abundance', 'citrine-abundance',
 'Bright citrine crystal beads carrying the energy of prosperity and abundance. Known as the "Merchant''s Stone", it attracts wealth, success, and positive energy.',
 5999, ARRAY['https://images.unsplash.com/photo-1602411149397-2e5c6d1e7d0b?w=600'],
 'crystal', ARRAY['citrine', 'abundance', 'wealth', 'success'], '{"main_stone": "Citrine", "bead_size": "8mm", "string": "Gold-filled wire"}', 20),

('Aromatherapy Essential Bracelet', 'aromatherapy-essential',
 'Handwoven lava stone and diffuser bead bracelet. Add 2-3 drops of your favorite essential oil daily. Comes with a starter set of lavender, peppermint, and eucalyptus oils.',
 4599, ARRAY['https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=600'],
 'aromatherapy', ARRAY['lava', 'aromatherapy', 'essential-oils', 'wellness'], '{"main_stone": "Lava Stone", "accents": "Howlite", "bead_size": "8mm", "includes": "3 essential oils"}', 45);

-- Design Elements (beads catalog for design studio)
INSERT INTO design_elements (name, type, color, material, shape, size_mm, image_url, price_cents, stock) VALUES
('Amethyst Round', 'bead', '#7B2D8B', 'Natural Amethyst', 'round', 8, 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=200', 150, 200),
('Clear Quartz Round', 'bead', '#E8E8E8', 'Clear Quartz', 'round', 8, '', 120, 200),
('Rose Quartz Round', 'bead', '#F7C0D0', 'Rose Quartz', 'round', 8, '', 180, 150),
('Jade Round', 'bead', '#4A7C59', 'Nephrite Jade', 'round', 10, '', 250, 100),
('Tiger Eye Round', 'bead', '#B8860B', 'Tiger Eye', 'round', 8, '', 160, 180),
('Lava Stone Round', 'bead', '#2F2F2F', 'Lava Stone', 'round', 8, '', 100, 300),
('Black Obsidian Round', 'bead', '#1A1A1A', 'Obsidian', 'round', 10, '', 140, 200),
('Citrine Round', 'bead', '#FFBF00', 'Citrine', 'round', 8, '', 220, 120),
('Lapis Lazuli Round', 'bead', '#2E5090', 'Lapis Lazuli', 'round', 8, '', 200, 100),
('Carnelian Round', 'bead', '#B31B1B', 'Carnelian', 'round', 8, '', 130, 180),
('Moonstone Round', 'bead', '#D4D4D8', 'Moonstone', 'round', 8, '', 280, 80),
('Howlite Round', 'bead', '#F0F0F0', 'Howlite', 'round', 8, '', 90, 250),
('Gold Spacer', 'spacer', '#D4AF37', 'Gold-filled', 'round', 4, '', 80, 300),
('Silver Spacer', 'spacer', '#C0C0C0', 'Sterling Silver', 'round', 4, '', 90, 300),
('Wood Round', 'bead', '#8B6914', 'Sandalwood', 'round', 8, '', 70, 350),
('Buddha Charm', 'charm', '#D4AF37', 'Gold-filled', 'pendant', 15, '', 350, 50),
('Evil Eye Charm', 'charm', '#4169E1', 'Enamel + Silver', 'round', 12, '', 280, 80),
('Tree of Life Charm', 'charm', '#8B6914', 'Sterling Silver', 'round', 12, '', 320, 60),
('Om Symbol Charm', 'charm', '#D4AF37', 'Gold-filled', 'round', 12, '', 300, 70),
('Lotus Flower Pendant', 'pendant', '#F5F5DC', 'Sterling Silver', 'flower', 18, '', 500, 40),
('Crystal Point Pendant', 'pendant', '#E8E8E8', 'Clear Quartz', 'point', 20, '', 600, 30),
('Adjustable Sliding Knot', 'clasp', '#8B4513', 'Waxed Cotton', 'knot', 0, '', 150, 200),
('Magnetic Clasp', 'clasp', '#C0C0C0', 'Stainless Steel', 'round', 6, '', 250, 100),
('Lobster Clasp', 'clasp', '#D4AF37', 'Gold-filled', 'classic', 8, '', 200, 150),
('Hematite Round', 'bead', '#36454F', 'Hematite', 'round', 8, '', 110, 200),
('Sodalite Round', 'bead', '#1E3A5F', 'Sodalite', 'round', 8, '', 150, 150),
('Amazonite Round', 'bead', '#7FCDCD', 'Amazonite', 'round', 8, '', 170, 120),
('Labradorite Round', 'bead', '#2F4F4F', 'Labradorite', 'round', 10, '', 350, 80);
