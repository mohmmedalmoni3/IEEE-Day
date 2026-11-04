-- Add event branch/community details and expected attendance without rewriting existing rows.
ALTER TABLE registrants
  ADD COLUMN IF NOT EXISTS organization_type TEXT NOT NULL DEFAULT 'فرع',
  ADD COLUMN IF NOT EXISTS organization_name TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS attendee_count INTEGER NOT NULL DEFAULT 1;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'registrants'::regclass
      AND conname = 'registrants_attendee_count_range'
  ) THEN
    ALTER TABLE registrants
      ADD CONSTRAINT registrants_attendee_count_range
      CHECK (attendee_count BETWEEN 1 AND 10000) NOT VALID;
  END IF;
END $$;

ALTER TABLE registrants
  VALIDATE CONSTRAINT registrants_attendee_count_range;
