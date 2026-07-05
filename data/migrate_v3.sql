-- =============================================================
-- Retrieval Quiz Online — migrate_v3.sql
-- Adds tblLookup (standardised Subject / Topic / Year / Unit lists)
-- and seeds it from the distinct values already in tblquiz.
-- Run once against an existing v2 database.
-- =============================================================

USE `retrieval`;

CREATE TABLE IF NOT EXISTS `tblLookup` (
    `id`       INT NOT NULL AUTO_INCREMENT,
    `category` ENUM('subject','topic','year','unit') NOT NULL,
    `value`    VARCHAR(100) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_category_value` (`category`, `value`)
) ENGINE=InnoDB
  CHARACTER SET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  ROW_FORMAT=DYNAMIC;

INSERT IGNORE INTO tblLookup (category, value) SELECT 'subject', quizSubject FROM tblquiz WHERE quizSubject IS NOT NULL AND quizSubject <> '';
INSERT IGNORE INTO tblLookup (category, value) SELECT 'topic',   quizTopic   FROM tblquiz WHERE quizTopic   IS NOT NULL AND quizTopic   <> '';
INSERT IGNORE INTO tblLookup (category, value) SELECT 'year',    quizYear    FROM tblquiz WHERE quizYear    IS NOT NULL AND quizYear    <> '';
INSERT IGNORE INTO tblLookup (category, value) SELECT 'unit',    quizUnit    FROM tblquiz WHERE quizUnit    IS NOT NULL AND quizUnit    <> '';
