-- =============================================================
-- Retrieval Quiz Online — Complete Database Schema
-- Compatible with MariaDB (Laragon)
-- Run this to create a fresh installation.
-- For upgrading an existing v1 database, run migrate_v2.sql instead.
-- =============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS `retrieval`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE `retrieval`;

-- ----------------------------
-- tbluser — teacher / admin accounts
-- Students are anonymous; only teachers log in.
-- ----------------------------
DROP TABLE IF EXISTS `tbluser`;
CREATE TABLE `tbluser` (
    `id`           INT          NOT NULL AUTO_INCREMENT,
    `email`        VARCHAR(255) NOT NULL,
    `passwordHash` VARCHAR(255) NOT NULL,
    `studentName`  VARCHAR(255)     NULL,
    `schoolName`   VARCHAR(255)     NULL,
    `classNamen`   VARCHAR(255)     NULL,
    `admin`        TINYINT      NOT NULL DEFAULT 0 COMMENT '1 = admin',
    `teacher`      TINYINT      NOT NULL DEFAULT 0 COMMENT '1 = teacher',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB
  CHARACTER SET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  ROW_FORMAT=DYNAMIC;

-- Default teacher account (password: 1234 — change immediately)
-- MD5('1234') = 81dc9bdb52d04dc20036dbd8313ed055
INSERT INTO `tbluser` (`email`, `passwordHash`, `studentName`, `schoolName`, `admin`, `teacher`)
VALUES ('name@school.ac.uk', '81dc9bdb52d04dc20036dbd8313ed055', 'Administrator', 'Exeter College', 1, 1);

-- ----------------------------
-- tblquiz — quiz definitions
-- quizType: 1 = Match Definitions (drag-and-drop)
--           2 = Multiple Choice
-- quizData: JSON (structure depends on quizType)
-- ----------------------------
DROP TABLE IF EXISTS `tblquiz`;
CREATE TABLE `tblquiz` (
    `id`              INT          NOT NULL AUTO_INCREMENT,
    `quizCode`        VARCHAR(10)  NOT NULL,
    `quizType`        TINYINT      NOT NULL DEFAULT 1 COMMENT '1=Match, 2=MC',
    `quizName`        VARCHAR(255) NOT NULL,
    `quizSetBy`       INT          NOT NULL COMMENT 'tbluser.id',
    `quizSubject`     VARCHAR(255)     NULL,
    `quizDescription` VARCHAR(255)     NULL,
    `quizTopic`       VARCHAR(255)     NULL,
    `quizYear`        VARCHAR(50)      NULL,
    `quizUnit`        VARCHAR(100)     NULL,
    `quizData`        LONGTEXT     NOT NULL COMMENT 'JSON quiz content',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_quizCode` (`quizCode`)
) ENGINE=InnoDB
  CHARACTER SET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- tblstatus — student quiz attempts (anonymous; no account required)
-- One row per progress event; watchStatus.php aggregates by studentName.
-- ----------------------------
DROP TABLE IF EXISTS `tblstatus`;
CREATE TABLE `tblstatus` (
    `id`           INT          NOT NULL AUTO_INCREMENT,
    `studentName`  VARCHAR(100) NOT NULL,
    `quizCode`     VARCHAR(10)  NOT NULL,
    `score`        INT          NOT NULL DEFAULT 0,
    `quizComplete` TINYINT      NOT NULL DEFAULT 0 COMMENT '1 = finished',
    `lastUpdate`   DATETIME     NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_quizCode`   (`quizCode`),
    INDEX `idx_studentQuiz` (`studentName`, `quizCode`)
) ENGINE=InnoDB
  CHARACTER SET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- tblsession — timed quiz sessions created by teachers
-- Students fetch this to sync their countdown timer.
-- ----------------------------
DROP TABLE IF EXISTS `tblsession`;
CREATE TABLE `tblsession` (
    `id`           INT         NOT NULL AUTO_INCREMENT,
    `quizCode`     VARCHAR(10) NOT NULL,
    `startTime`    DATETIME    NOT NULL,
    `durationSecs` INT         NOT NULL DEFAULT 600 COMMENT 'Session length in seconds',
    `createdBy`    INT         NOT NULL COMMENT 'tbluser.id',
    PRIMARY KEY (`id`),
    INDEX `idx_quizCode` (`quizCode`)
) ENGINE=InnoDB
  CHARACTER SET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  ROW_FORMAT=DYNAMIC;

SET FOREIGN_KEY_CHECKS = 1;
