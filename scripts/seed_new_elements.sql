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
