-- 006_fix_energy.sql - Add missing columns used by EnergyHandler.Assess
ALTER TABLE energy_assessments ADD COLUMN IF NOT EXISTS preferred_element TEXT DEFAULT '';
ALTER TABLE energy_assessments ADD COLUMN IF NOT EXISTS concerns TEXT DEFAULT '';
ALTER TABLE energy_assessments ADD COLUMN IF NOT EXISTS lifestyle TEXT DEFAULT '';
ALTER TABLE energy_assessments ADD COLUMN IF NOT EXISTS preferred_element TEXT DEFAULT '';
