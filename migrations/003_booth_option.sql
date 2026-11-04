-- Store the branch/community booth preference without changing existing registrations.
ALTER TABLE registrants
  ADD COLUMN IF NOT EXISTS booth_option TEXT NOT NULL DEFAULT 'بدون بوث';

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'registrants'::regclass
      AND conname = 'registrants_booth_option_valid'
  ) THEN
    ALTER TABLE registrants
      ADD CONSTRAINT registrants_booth_option_valid
      CHECK (booth_option IN ('مع بوث', 'بدون بوث')) NOT VALID;
  END IF;
END $$;

ALTER TABLE registrants
  VALIDATE CONSTRAINT registrants_booth_option_valid;
