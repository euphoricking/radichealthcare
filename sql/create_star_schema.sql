-- Create diagnoses table
CREATE TABLE IF NOT EXISTS `seraphic-disk-459415-k0.radichealthcaredataset.diagnoses` (
  `id` INT64,
  `icd_code` STRING NOT NULL,
  `description` STRING,
  `category` STRING,
  `is_chronic` BOOL DEFAULT FALSE,
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`)
);

-- Create encounters table
CREATE TABLE IF NOT EXISTS `seraphic-disk-459415-k0.radichealthcaredataset.encounters` (
  `id` INT64,
  `patient_id` INT64,
  `provider_id` INT64,
  `facility_id` INT64,
  `primary_diagnosis_id` INT64,
  `encounter_type` STRING NOT NULL,
  `admission_date` TIMESTAMP NOT NULL,
  `discharge_date` TIMESTAMP,
  `total_charges` NUMERIC,
  `total_payments` NUMERIC,
  `insurance_type` STRING,
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  FOREIGN KEY (`patient_id`) REFERENCES `seraphic-disk-459415-k0.radichealthcaredataset.patients` (`id`),
  FOREIGN KEY (`provider_id`) REFERENCES `seraphic-disk-459415-k0.radichealthcaredataset.providers` (`id`),
  FOREIGN KEY (`facility_id`) REFERENCES `seraphic-disk-459415-k0.radichealthcaredataset.facilities` (`id`),
  FOREIGN KEY (`primary_diagnosis_id`) REFERENCES `seraphic-disk-459415-k0.radichealthcaredataset.diagnoses` (`id`)
);

-- Create index on encounters table
CREATE INDEX `idx_encounters_patient_id` ON `seraphic-disk-459415-k0.radichealthcaredataset.encounters` (`patient_id`);
CREATE INDEX `idx_encounters_admission_date` ON `seraphic-disk-459415-k0.radichealthcaredataset.encounters` (`admission_date`);

-- Create facilities table
CREATE TABLE IF NOT EXISTS `seraphic-disk-459415-k0.radichealthcaredataset.facilities` (
  `id` INT64,
  `facility_name` STRING NOT NULL,
  `facility_type` STRING,
  `address` STRING,
  `city` STRING,
  `state` STRING,
  `zip_code` STRING,
  `phone_number` STRING,
  `bed_count` INT64,
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`)
);

-- Create patients table
CREATE TABLE IF NOT EXISTS `seraphic-disk-459415-k0.radichealthcaredataset.patients` (
  `id` INT64,
  `medical_record_number` STRING NOT NULL,
  `first_name` STRING NOT NULL,
  `last_name` STRING NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `gender` STRING,
  `address_line1` STRING,
  `city` STRING,
  `state` STRING,
  `zip_code` STRING,
  `primary_phone` STRING,
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  UNIQUE (`medical_record_number`)
);

-- Create index on patients table
CREATE INDEX `idx_patients_last_updated` ON `seraphic-disk-459415-k0.radichealthcaredataset.patients` (`last_updated`);

-- Create providers table
CREATE TABLE IF NOT EXISTS `seraphic-disk-459415-k0.radichealthcaredataset.providers` (
  `id` INT64,
  `npi_number` STRING NOT NULL,
  `first_name` STRING NOT NULL,
  `last_name` STRING NOT NULL,
  `specialty` STRING,
  `department` STRING,
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  UNIQUE (`npi_number`)
);

-- Create index on providers table
CREATE INDEX `idx_providers_last_updated` ON `seraphic-disk-459415-k0.radichealthcaredataset.providers` (`last_updated`);
