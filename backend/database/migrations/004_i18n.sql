-- 004_i18n.sql - Add multilingual support columns
ALTER TABLE products ADD COLUMN IF NOT EXISTS i18n JSONB DEFAULT '{}';
ALTER TABLE design_elements ADD COLUMN IF NOT EXISTS i18n JSONB DEFAULT '{}';

-- Seed i18n data for existing products (Chinese as example)
UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"水晶和谐手串"') WHERE slug = 'crystal-harmony';
UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"熔岩接地手串"') WHERE slug = 'lava-stone-grounding';
UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"玉石智慧手串"') WHERE slug = 'jade-wisdom';
UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"虎眼成功手串"') WHERE slug = 'tiger-eye-success';
UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"粉晶爱情手串"') WHERE slug = 'rose-quartz-love';
UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"黑曜石护盾手串"') WHERE slug = 'black-obsidian-shield';
UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"黄晶丰盛手串"') WHERE slug = 'citrine-abundance';
UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"芳香精油手串"') WHERE slug = 'aromatherapy-essential';

-- Seed i18n for design_elements (Chinese)
UPDATE design_elements SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"紫水晶圆珠"') WHERE name = 'Amethyst Round';
UPDATE design_elements SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"白水晶圆珠"') WHERE name = 'Clear Quartz Round';
UPDATE design_elements SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"粉水晶圆珠"') WHERE name = 'Rose Quartz Round';
UPDATE design_elements SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"玉石圆珠"') WHERE name = 'Jade Round';
UPDATE design_elements SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"虎眼石圆珠"') WHERE name = 'Tiger Eye Round';
UPDATE design_elements SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"熔岩石圆珠"') WHERE name = 'Lava Stone Round';
UPDATE design_elements SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"黑曜石圆珠"') WHERE name = 'Black Obsidian Round';
UPDATE design_elements SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"黄水晶圆珠"') WHERE name = 'Citrine Round';
