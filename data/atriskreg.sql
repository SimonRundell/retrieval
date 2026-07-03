/*
 Navicat Premium Dump SQL

 Source Server         : LOCALHOST
 Source Server Type    : MySQL
 Source Server Version : 80403 (8.4.3)
 Source Host           : localhost:3306
 Source Schema         : atriskreg

 Target Server Type    : MySQL
 Target Server Version : 80403 (8.4.3)
 File Encoding         : 65001

 Date: 30/06/2026 15:38:34
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tblassessment
-- ----------------------------
DROP TABLE IF EXISTS `tblassessment`;
CREATE TABLE `tblassessment`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` int UNSIGNED NOT NULL,
  `assessment_def_id` int UNSIGNED NOT NULL,
  `status` enum('NOT_SET','SET','HANDED_IN_1','RETURNED','HANDED_IN_2','COMPLETE','INCOMPLETE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NOT_SET',
  `date_set` date NULL DEFAULT NULL,
  `date_deadline` date NULL DEFAULT NULL,
  `date_resubmission` date NULL DEFAULT NULL,
  `date_completed` date NULL DEFAULT NULL,
  `set_by_id` int UNSIGNED NULL DEFAULT NULL COMMENT 'Staff member who first set the date_set',
  `updated_by` int UNSIGNED NULL DEFAULT NULL COMMENT 'Staff member who last saved this row',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_assessment`(`student_id` ASC, `assessment_def_id` ASC) USING BTREE,
  INDEX `assessment_def_id`(`assessment_def_id` ASC) USING BTREE,
  INDEX `set_by_id`(`set_by_id` ASC) USING BTREE,
  INDEX `updated_by`(`updated_by` ASC) USING BTREE,
  CONSTRAINT `tblassessment_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `tblstudent` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tblassessment_ibfk_2` FOREIGN KEY (`assessment_def_id`) REFERENCES `tblassessment_def` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tblassessment_ibfk_3` FOREIGN KEY (`set_by_id`) REFERENCES `tbluser` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `tblassessment_ibfk_4` FOREIGN KEY (`updated_by`) REFERENCES `tbluser` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Per-student per-part assessment tracking' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblassessment
-- ----------------------------

-- ----------------------------
-- Table structure for tblassessment_def
-- ----------------------------
DROP TABLE IF EXISTS `tblassessment_def`;
CREATE TABLE `tblassessment_def`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `unit_id` int UNSIGNED NOT NULL,
  `part_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'e.g. \"Unit Assessment\", \"Part A\"',
  `sort_order` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `unit_id`(`unit_id` ASC) USING BTREE,
  CONSTRAINT `tblassessment_def_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `tblunit` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Assessment part definitions per unit' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblassessment_def
-- ----------------------------
INSERT INTO `tblassessment_def` VALUES (1, 8, 'Part A', 0, '2026-06-22 19:53:14');
INSERT INTO `tblassessment_def` VALUES (2, 8, 'Part B', 0, '2026-06-22 19:53:20');
INSERT INTO `tblassessment_def` VALUES (3, 11, 'Part A', 0, '2026-06-22 19:53:30');
INSERT INTO `tblassessment_def` VALUES (4, 11, 'Part B', 0, '2026-06-22 19:53:35');
INSERT INTO `tblassessment_def` VALUES (7, 1, 'Final Assessment', 0, '2026-06-22 19:54:06');
INSERT INTO `tblassessment_def` VALUES (8, 2, 'Final Assessment', 0, '2026-06-22 19:54:18');
INSERT INTO `tblassessment_def` VALUES (9, 3, 'Final Assessment', 0, '2026-06-22 19:54:30');
INSERT INTO `tblassessment_def` VALUES (10, 4, 'Final Assessment', 0, '2026-06-22 19:54:45');
INSERT INTO `tblassessment_def` VALUES (11, 5, 'Final Assessment', 0, '2026-06-22 19:54:56');
INSERT INTO `tblassessment_def` VALUES (12, 10, 'Part A', 0, '2026-06-22 19:55:06');
INSERT INTO `tblassessment_def` VALUES (13, 10, 'Part B', 0, '2026-06-22 19:55:11');
INSERT INTO `tblassessment_def` VALUES (14, 9, 'Part A', 0, '2026-06-22 19:55:23');
INSERT INTO `tblassessment_def` VALUES (15, 9, 'Part B', 0, '2026-06-22 19:55:27');
INSERT INTO `tblassessment_def` VALUES (16, 6, 'Part A', 0, '2026-06-22 19:55:38');
INSERT INTO `tblassessment_def` VALUES (19, 6, 'Part B', 0, '2026-06-22 19:56:06');
INSERT INTO `tblassessment_def` VALUES (20, 17, 'Part A', 0, '2026-06-22 19:56:17');
INSERT INTO `tblassessment_def` VALUES (21, 17, 'Part B', 0, '2026-06-22 19:56:21');
INSERT INTO `tblassessment_def` VALUES (22, 13, 'Part A', 0, '2026-06-22 19:56:29');
INSERT INTO `tblassessment_def` VALUES (23, 13, 'Part B', 0, '2026-06-22 19:56:33');
INSERT INTO `tblassessment_def` VALUES (26, 15, 'Part A', 0, '2026-06-22 19:57:02');
INSERT INTO `tblassessment_def` VALUES (27, 15, 'Part B', 0, '2026-06-22 19:57:06');
INSERT INTO `tblassessment_def` VALUES (28, 12, 'Part A', 0, '2026-06-22 19:57:15');
INSERT INTO `tblassessment_def` VALUES (29, 12, 'Part B', 0, '2026-06-22 19:57:20');
INSERT INTO `tblassessment_def` VALUES (30, 19, 'Part A', 0, '2026-06-25 08:42:51');
INSERT INTO `tblassessment_def` VALUES (31, 19, 'Part B', 10, '2026-06-25 08:42:56');

-- ----------------------------
-- Table structure for tblconcern
-- ----------------------------
DROP TABLE IF EXISTS `tblconcern`;
CREATE TABLE `tblconcern`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `concern` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblconcern
-- ----------------------------
INSERT INTO `tblconcern` VALUES (1, 'No Concern');
INSERT INTO `tblconcern` VALUES (2, 'Attendance');
INSERT INTO `tblconcern` VALUES (3, 'Engagement');
INSERT INTO `tblconcern` VALUES (4, 'Late Submissions');
INSERT INTO `tblconcern` VALUES (5, 'Grade Borderline');
INSERT INTO `tblconcern` VALUES (6, 'Personal Circumstances');
INSERT INTO `tblconcern` VALUES (7, 'Student Withdrawn from Course');

-- ----------------------------
-- Table structure for tblcourse
-- ----------------------------
DROP TABLE IF EXISTS `tblcourse`;
CREATE TABLE `tblcourse`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `coursename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `qual_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'other' COMMENT 'FK to tblqualificationtype.code',
  `total_credits` int UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Total qualification credits',
  `pass_points` int UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Min points for overall Pass',
  `merit_points` int UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Min points for overall Merit',
  `distinction_points` int UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Min points for overall Distinction',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblcourse
-- ----------------------------
INSERT INTO `tblcourse` VALUES (1, 'BTEC Ext Dip 2025-2026', 'btec_ext_dip', 120, 108, 156, 216);
INSERT INTO `tblcourse` VALUES (2, '2025-2026 NCFE Level 2 Introduction to the Principles of Coding', 'ncfe', 155, 0, 0, 0);
INSERT INTO `tblcourse` VALUES (3, 'BTEC Ext Cert AAQ 2025-2026', 'other', 60, 52, 74, 90);
INSERT INTO `tblcourse` VALUES (4, '2025-2026 NCFE Level 2 Introduction to the Principles of Cybersecurity', 'ncfe', 110, 0, 0, 0);
INSERT INTO `tblcourse` VALUES (5, '2025-2026 NCFE Level 2 Data Analysis', 'ncfe', 120, 0, 0, 0);

-- ----------------------------
-- Table structure for tblcourseunit
-- ----------------------------
DROP TABLE IF EXISTS `tblcourseunit`;
CREATE TABLE `tblcourseunit`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `course_id` int UNSIGNED NOT NULL,
  `unit_id` int UNSIGNED NOT NULL,
  `year_taken` int UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Column display order in grade grid',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_course_unit`(`course_id` ASC, `unit_id` ASC) USING BTREE,
  INDEX `unit_id`(`unit_id` ASC) USING BTREE,
  CONSTRAINT `tblcourseunit_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `tblcourse` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tblcourseunit_ibfk_2` FOREIGN KEY (`unit_id`) REFERENCES `tblunit` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblcourseunit
-- ----------------------------
INSERT INTO `tblcourseunit` VALUES (6, 1, 6, 1);
INSERT INTO `tblcourseunit` VALUES (7, 2, 1, 1);
INSERT INTO `tblcourseunit` VALUES (8, 2, 2, 1);
INSERT INTO `tblcourseunit` VALUES (9, 2, 3, 1);
INSERT INTO `tblcourseunit` VALUES (10, 2, 4, 1);
INSERT INTO `tblcourseunit` VALUES (11, 2, 5, 1);
INSERT INTO `tblcourseunit` VALUES (13, 1, 7, 1);
INSERT INTO `tblcourseunit` VALUES (14, 1, 8, 1);
INSERT INTO `tblcourseunit` VALUES (15, 1, 9, 1);
INSERT INTO `tblcourseunit` VALUES (16, 1, 10, 1);
INSERT INTO `tblcourseunit` VALUES (17, 1, 11, 1);
INSERT INTO `tblcourseunit` VALUES (18, 1, 12, 2);
INSERT INTO `tblcourseunit` VALUES (19, 1, 13, 2);
INSERT INTO `tblcourseunit` VALUES (20, 1, 14, 2);
INSERT INTO `tblcourseunit` VALUES (21, 1, 15, 2);
INSERT INTO `tblcourseunit` VALUES (22, 1, 16, 2);
INSERT INTO `tblcourseunit` VALUES (23, 1, 17, 2);
INSERT INTO `tblcourseunit` VALUES (24, 1, 18, 2);
INSERT INTO `tblcourseunit` VALUES (25, 3, 7, 1);
INSERT INTO `tblcourseunit` VALUES (26, 3, 14, 1);
INSERT INTO `tblcourseunit` VALUES (27, 3, 6, 1);
INSERT INTO `tblcourseunit` VALUES (28, 3, 19, 1);
INSERT INTO `tblcourseunit` VALUES (29, 4, 20, 1);
INSERT INTO `tblcourseunit` VALUES (30, 4, 21, 1);
INSERT INTO `tblcourseunit` VALUES (31, 4, 22, 1);
INSERT INTO `tblcourseunit` VALUES (32, 4, 23, 1);
INSERT INTO `tblcourseunit` VALUES (33, 4, 24, 1);
INSERT INTO `tblcourseunit` VALUES (34, 4, 25, 1);
INSERT INTO `tblcourseunit` VALUES (35, 5, 26, 1);
INSERT INTO `tblcourseunit` VALUES (36, 5, 27, 1);
INSERT INTO `tblcourseunit` VALUES (37, 5, 28, 1);
INSERT INTO `tblcourseunit` VALUES (38, 5, 29, 1);
INSERT INTO `tblcourseunit` VALUES (39, 5, 30, 1);

-- ----------------------------
-- Table structure for tblcriteria
-- ----------------------------
DROP TABLE IF EXISTS `tblcriteria`;
CREATE TABLE `tblcriteria`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `section_id` int UNSIGNED NOT NULL,
  `code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'e.g. 1.1, P1, M3',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'Full criterion wording',
  `sort_order` int UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_criteria`(`section_id` ASC, `code` ASC) USING BTREE,
  CONSTRAINT `tblcriteria_ibfk_1` FOREIGN KEY (`section_id`) REFERENCES `tblunitsection` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 126 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Individual assessment criteria within a section' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblcriteria
-- ----------------------------
INSERT INTO `tblcriteria` VALUES (17, 2, '1.1', 'Define what is meant by imperative coding', 0);
INSERT INTO `tblcriteria` VALUES (18, 2, '1.2', 'Define what is meant by declarative coding', 0);
INSERT INTO `tblcriteria` VALUES (19, 2, '1.3', 'Define what is meant by functional coding', 0);
INSERT INTO `tblcriteria` VALUES (20, 2, '1.4', 'Define what is meant by object-orientated coding', 0);
INSERT INTO `tblcriteria` VALUES (21, 2, '1.5', 'Identify other coding types', 0);
INSERT INTO `tblcriteria` VALUES (22, 2, '1.6', 'State the advantages and disadvantages of functional, object-orientated and other coding types', 0);
INSERT INTO `tblcriteria` VALUES (25, 2, '2.1', 'Define the term compiled code', 0);
INSERT INTO `tblcriteria` VALUES (26, 2, '2.2', 'Define the term interpreted code', 0);
INSERT INTO `tblcriteria` VALUES (27, 2, '2.3', 'Explain the principles of a) compiled code b) interpreted code', 0);
INSERT INTO `tblcriteria` VALUES (28, 2, '2.4', 'Explain the advantages and disadvantages of a) compiled code b) interpreted code', 0);
INSERT INTO `tblcriteria` VALUES (29, 2, '3.1', 'Define the term \'pure function\'', 0);
INSERT INTO `tblcriteria` VALUES (30, 2, '3.2', 'Define the term \'impure function\'', 0);
INSERT INTO `tblcriteria` VALUES (31, 2, '3.3', 'Identify potential dependencies/needs in pure function', 0);
INSERT INTO `tblcriteria` VALUES (32, 2, '3.4', 'Explain the benefits of pure function', 0);
INSERT INTO `tblcriteria` VALUES (33, 2, '3.5', 'Explain the term parallelisation', 0);
INSERT INTO `tblcriteria` VALUES (34, 2, '3.6', 'Describe how parallelisation is managed', 0);
INSERT INTO `tblcriteria` VALUES (35, 3, '1.1', 'Define the term \'coding\'', 0);
INSERT INTO `tblcriteria` VALUES (36, 3, '1.2', 'Define what is meant by a coding language', 0);
INSERT INTO `tblcriteria` VALUES (37, 3, '1.3', 'Identify two different coding languages available with a brief description of each one', 0);
INSERT INTO `tblcriteria` VALUES (38, 3, '1.4', 'State the difference between procedural and object-oriented language', 0);
INSERT INTO `tblcriteria` VALUES (39, 3, '1.5', 'Define what is meant by syntax', 0);
INSERT INTO `tblcriteria` VALUES (40, 3, '1.6', 'Identify different technologies that use code to run', 0);
INSERT INTO `tblcriteria` VALUES (41, 3, '2.1', 'Identify the key job functions of a coding professional', 0);
INSERT INTO `tblcriteria` VALUES (42, 3, '2.2', 'Identify key skills requirements for a coding professional', 0);
INSERT INTO `tblcriteria` VALUES (43, 3, '2.3', 'Explain why project management skills are important in coding', 0);
INSERT INTO `tblcriteria` VALUES (44, 3, '2.4', 'Identify different roles within a coding team', 0);
INSERT INTO `tblcriteria` VALUES (45, 3, '2.5', 'Explain why team working is important in coding', 0);
INSERT INTO `tblcriteria` VALUES (46, 3, '2.6', 'Identify different careers and career progression available', 0);
INSERT INTO `tblcriteria` VALUES (47, 3, '3.1', 'Identify the key stages of the software development lifecycle', 0);
INSERT INTO `tblcriteria` VALUES (48, 3, '3.2', 'Explain the different stages of the software development lifecycle', 0);
INSERT INTO `tblcriteria` VALUES (49, 3, '3.3', 'Describe the importance of the planning stage', 0);
INSERT INTO `tblcriteria` VALUES (50, 3, '3.4', 'Identify actions that may take place during the implementation stage', 0);
INSERT INTO `tblcriteria` VALUES (51, 3, '3.5', 'Explain the importance of the testing stage', 0);
INSERT INTO `tblcriteria` VALUES (52, 3, '3.6', 'Describe actions that may take place during the deployment stage', 0);
INSERT INTO `tblcriteria` VALUES (53, 3, '3.7', 'Explain the importance of the maintenance stage', 0);
INSERT INTO `tblcriteria` VALUES (54, 4, '1.1', 'Describe what is meant by the KISS principle', 0);
INSERT INTO `tblcriteria` VALUES (55, 4, '1.2', 'Give examples of the disadvantages of writing complicated code', 0);
INSERT INTO `tblcriteria` VALUES (56, 4, '1.3', 'Define what is meant by the single responsibility principle', 0);
INSERT INTO `tblcriteria` VALUES (57, 4, '1.4', 'Describe what is meant by separation of concerns', 0);
INSERT INTO `tblcriteria` VALUES (58, 4, '1.5', 'Define what is meant by abstraction', 0);
INSERT INTO `tblcriteria` VALUES (59, 4, '2.1', 'Explain what is meant by testing code', 0);
INSERT INTO `tblcriteria` VALUES (60, 4, '2.2', 'Explain why it is important to test code (at least 3 different reasons)', 0);
INSERT INTO `tblcriteria` VALUES (61, 4, '2.3', 'Identify methods of testing code (at least 4)', 0);
INSERT INTO `tblcriteria` VALUES (62, 4, '2.4', 'Describe the characteristics of a test-driven development (at least 3)', 0);
INSERT INTO `tblcriteria` VALUES (63, 4, '2.5', 'Explain the benefits of a test-driven development (at least 3)', 0);
INSERT INTO `tblcriteria` VALUES (64, 4, '2.6', 'Identify what is meant by a bug in relation to code', 0);
INSERT INTO `tblcriteria` VALUES (65, 4, '3.1', 'Define what is meant by continuous integration', 0);
INSERT INTO `tblcriteria` VALUES (66, 4, '3.2', 'Define what is meant by continuous delivery', 0);
INSERT INTO `tblcriteria` VALUES (67, 4, '3.3', 'Define what is meant by continuous deployment', 0);
INSERT INTO `tblcriteria` VALUES (68, 4, '3.4', 'Identify the steps required for: a) Continuous integration b) Continuous delivery c) Continuous deployment', 0);
INSERT INTO `tblcriteria` VALUES (69, 4, '3.5', 'Identify the differences between: a) Continuous integration b) Continuous delivery c) Continuous deployment', 0);
INSERT INTO `tblcriteria` VALUES (73, 5, '1.1', 'Describe what is meant by the KISS principle', 0);
INSERT INTO `tblcriteria` VALUES (74, 5, '1.2', 'Give examples of the disadvantages of writing complicated code', 0);
INSERT INTO `tblcriteria` VALUES (75, 5, '1.3', 'Define what is meant by the single responsibility principle', 0);
INSERT INTO `tblcriteria` VALUES (76, 5, '1.4', 'Describe what is meant by separation of concerns', 0);
INSERT INTO `tblcriteria` VALUES (77, 5, '1.5', 'Define what is meant by abstraction', 0);
INSERT INTO `tblcriteria` VALUES (78, 5, '1.6', 'Describe what is meant by solid principles', 0);
INSERT INTO `tblcriteria` VALUES (79, 5, '2.1', 'Explain what is meant by testing code', 0);
INSERT INTO `tblcriteria` VALUES (80, 5, '2.2', 'Explain why it is important to test code (at least 3 different reasons)', 0);
INSERT INTO `tblcriteria` VALUES (81, 5, '2.3', 'Identify methods of testing code (at least 4)', 0);
INSERT INTO `tblcriteria` VALUES (82, 5, '2.4', 'Describe the characteristics of a test-driven development (at least 3)', 0);
INSERT INTO `tblcriteria` VALUES (89, 5, '2.5', 'Explain the benefits of a test-driven development (at least 3)', 0);
INSERT INTO `tblcriteria` VALUES (90, 5, '2.6', 'Identify what is meant by a bug in relation to code', 0);
INSERT INTO `tblcriteria` VALUES (91, 5, '3.1', 'Define what is meant by continuous integration', 0);
INSERT INTO `tblcriteria` VALUES (92, 5, '3.2', 'Define what is meant by continuous delivery', 0);
INSERT INTO `tblcriteria` VALUES (93, 5, '3.3', 'Define what is meant by continuous deployment', 0);
INSERT INTO `tblcriteria` VALUES (94, 5, '3.4', 'Identify the steps required for: a) Continuous integration b) Continuous delivery c) Continuous deployment', 0);
INSERT INTO `tblcriteria` VALUES (95, 5, '3.5', 'Identify the differences between: a) Continuous integration b) Continuous delivery c) Continuous deployment', 0);
INSERT INTO `tblcriteria` VALUES (96, 5, '4.1', 'Explain what is meant by exception handling', 0);
INSERT INTO `tblcriteria` VALUES (97, 5, '4.2', 'Explain what is meant by defensive programming', 0);
INSERT INTO `tblcriteria` VALUES (98, 6, '1.1', 'Explain the importance of communication', 0);
INSERT INTO `tblcriteria` VALUES (99, 6, '1.2', 'Describe different methods of communication. Should include, but are not limited to: a) Interpersonal communication b) Verbal communication c) Nonverbal communication d) Written communication e) Presentations f) Other', 0);
INSERT INTO `tblcriteria` VALUES (100, 6, '1.3', 'Identify when to use different methods of communication', 0);
INSERT INTO `tblcriteria` VALUES (101, 6, '1.4', 'Explain the importance of adapting communication for different audiences', 0);
INSERT INTO `tblcriteria` VALUES (102, 6, '1.5', 'Define what is meant by active listening', 0);
INSERT INTO `tblcriteria` VALUES (103, 6, '1.6', 'Describe methods of active listening', 0);
INSERT INTO `tblcriteria` VALUES (104, 6, '1.7', 'Describe ways of verbally presenting information and ideas clearly', 0);
INSERT INTO `tblcriteria` VALUES (105, 6, '1.8', 'Explain how release notes are used to communicate information to others. a) Explain what release notes are b) Create release notes for an imaginary small app.', 0);
INSERT INTO `tblcriteria` VALUES (106, 6, '2.1', 'Describe ways of seeking feedback on communications', 0);
INSERT INTO `tblcriteria` VALUES (107, 6, '2.2', 'Explain the purpose of using feedback to develop communication skills. Why is feedback important? Give an example of how you have improved your communication skills following feedback.', 0);
INSERT INTO `tblcriteria` VALUES (108, 6, '2.3', 'Explain what is meant by productive feedback. After explaining, give an example of productive feedback you have given to someone else and why it was productive.', 0);
INSERT INTO `tblcriteria` VALUES (109, 6, '3.1', 'Define what is meant by project management', 0);
INSERT INTO `tblcriteria` VALUES (110, 6, '3.2', 'Define the role of a Project Manager', 0);
INSERT INTO `tblcriteria` VALUES (111, 6, '3.3', 'Identify the principles of Lean project management', 0);
INSERT INTO `tblcriteria` VALUES (112, 6, '3.4', 'Identify the principles of Waterfall project management', 0);
INSERT INTO `tblcriteria` VALUES (113, 6, '3.5', 'Explain what is meant by the triple constraint. Must include: a) Project scope b) Time c) Cost', 0);
INSERT INTO `tblcriteria` VALUES (114, 6, '4.1', 'Define what is meant by an Agile development', 0);
INSERT INTO `tblcriteria` VALUES (115, 6, '4.2', 'Identify the key characteristics of an Agile development', 0);
INSERT INTO `tblcriteria` VALUES (116, 6, '4.3', 'Identify the advantages and disadvantages of an Agile development', 0);
INSERT INTO `tblcriteria` VALUES (117, 6, '4.4', 'Describe what is meant by Scrum', 0);
INSERT INTO `tblcriteria` VALUES (118, 6, '4.5', 'Explain the role of a: a) Product Owner b) Scrum Master c) Scrum team', 0);
INSERT INTO `tblcriteria` VALUES (119, 6, '4.6', 'Describe different Scrum events. a) Sprint b) Sprint Planning c) Daily Scrum d) Sprint Review e) Sprint Retrospective.', 0);

-- ----------------------------
-- Table structure for tblevidence
-- ----------------------------
DROP TABLE IF EXISTS `tblevidence`;
CREATE TABLE `tblevidence`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` int UNSIGNED NOT NULL,
  `criteria_id` int UNSIGNED NOT NULL,
  `achieved` tinyint(1) NOT NULL DEFAULT 0,
  `achieved_date` date NULL DEFAULT NULL COMMENT 'Date criterion was signed off',
  `assessor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Name or initials of signing assessor',
  `portfolio_ref` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Portfolio or page reference',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` int UNSIGNED NULL DEFAULT NULL COMMENT 'FK to tbluser.id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_evidence`(`student_id` ASC, `criteria_id` ASC) USING BTREE,
  INDEX `criteria_id`(`criteria_id` ASC) USING BTREE,
  INDEX `updated_by`(`updated_by` ASC) USING BTREE,
  CONSTRAINT `tblevidence_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `tblstudent` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tblevidence_ibfk_2` FOREIGN KEY (`criteria_id`) REFERENCES `tblcriteria` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tblevidence_ibfk_3` FOREIGN KEY (`updated_by`) REFERENCES `tbluser` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1736 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Student evidence against individual criteria' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblevidence
-- ----------------------------
INSERT INTO `tblevidence` VALUES (241, 50, 22, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (242, 50, 17, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (243, 50, 19, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (244, 50, 18, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (245, 50, 26, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (246, 50, 21, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (247, 50, 20, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (248, 50, 25, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (249, 50, 28, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (250, 50, 27, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (251, 50, 30, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (252, 50, 31, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (253, 50, 32, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (254, 50, 29, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (255, 50, 34, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (256, 50, 33, 1, NULL, NULL, NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblevidence` VALUES (257, 51, 20, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (258, 51, 17, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (259, 51, 18, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (260, 51, 19, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (261, 51, 21, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (262, 51, 25, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (263, 51, 26, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (264, 51, 22, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (265, 51, 28, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (266, 51, 27, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (267, 51, 29, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (268, 51, 30, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (269, 51, 31, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (270, 51, 32, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (271, 51, 33, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (272, 51, 34, 1, NULL, NULL, NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblevidence` VALUES (273, 53, 19, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (274, 53, 20, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (275, 53, 22, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (276, 53, 18, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (277, 53, 17, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (278, 53, 21, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (279, 53, 27, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (280, 53, 26, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (281, 53, 25, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (282, 53, 30, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (283, 53, 28, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (284, 53, 29, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (285, 53, 33, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (286, 53, 31, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (287, 53, 32, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (288, 53, 34, 1, NULL, NULL, NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblevidence` VALUES (289, 54, 17, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (290, 54, 21, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (291, 54, 22, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (292, 54, 20, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (293, 54, 18, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (294, 54, 19, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (295, 54, 29, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (296, 54, 26, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (297, 54, 27, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (298, 54, 25, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (299, 54, 28, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (300, 54, 30, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (301, 54, 33, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (302, 54, 31, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (303, 54, 34, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (304, 54, 32, 1, NULL, NULL, NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblevidence` VALUES (305, 55, 17, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (306, 55, 18, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (307, 55, 19, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (308, 55, 21, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (309, 55, 25, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (310, 55, 20, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (311, 55, 26, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (312, 55, 27, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (313, 55, 22, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (314, 55, 28, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (315, 55, 29, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (316, 55, 33, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (317, 55, 30, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (318, 55, 31, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (319, 55, 32, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (320, 55, 34, 1, NULL, NULL, NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblevidence` VALUES (321, 56, 17, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (322, 56, 20, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (323, 56, 25, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (324, 56, 18, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (325, 56, 21, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (326, 56, 22, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (327, 56, 19, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (328, 56, 31, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (329, 56, 27, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (330, 56, 26, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (331, 56, 28, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (332, 56, 30, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (333, 56, 29, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (334, 56, 34, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (335, 56, 32, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (336, 56, 33, 1, NULL, NULL, NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblevidence` VALUES (337, 59, 18, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (338, 59, 20, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (339, 59, 17, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (340, 59, 21, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (341, 59, 26, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (342, 59, 22, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (343, 59, 19, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (344, 59, 28, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (345, 59, 27, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (346, 59, 25, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (347, 59, 30, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (348, 59, 31, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (349, 59, 29, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (350, 59, 34, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (351, 59, 33, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (352, 59, 32, 1, NULL, NULL, NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblevidence` VALUES (353, 60, 18, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (354, 60, 19, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (355, 60, 17, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (356, 60, 26, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (357, 60, 20, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (358, 60, 21, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (359, 60, 22, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (360, 60, 25, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (361, 60, 27, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (362, 60, 28, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (363, 60, 29, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (364, 60, 31, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (365, 60, 30, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (366, 60, 33, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (367, 60, 32, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (368, 60, 34, 1, NULL, NULL, NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblevidence` VALUES (369, 61, 17, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (370, 61, 21, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (371, 61, 18, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (372, 61, 20, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (373, 61, 22, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (374, 61, 19, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (375, 61, 27, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (376, 61, 29, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (377, 61, 26, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (378, 61, 28, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (379, 61, 25, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (380, 61, 30, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (381, 61, 31, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (382, 61, 34, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (383, 61, 33, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (384, 61, 32, 1, NULL, NULL, NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblevidence` VALUES (385, 62, 17, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (386, 62, 25, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (387, 62, 18, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (388, 62, 19, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (389, 62, 22, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (390, 62, 20, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (391, 62, 27, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (392, 62, 28, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (393, 62, 21, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (394, 62, 30, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (395, 62, 26, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (396, 62, 29, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (397, 62, 31, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (398, 62, 32, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (399, 62, 33, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (400, 62, 34, 1, NULL, NULL, NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblevidence` VALUES (401, 63, 18, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (402, 63, 20, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (403, 63, 17, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (404, 63, 25, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (405, 63, 21, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (406, 63, 19, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (407, 63, 22, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (408, 63, 26, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (409, 63, 27, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (410, 63, 30, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (411, 63, 32, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (412, 63, 29, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (413, 63, 28, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (414, 63, 33, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (415, 63, 31, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (416, 63, 34, 1, NULL, NULL, NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblevidence` VALUES (417, 64, 20, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (418, 64, 25, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (419, 64, 17, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (420, 64, 18, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (421, 64, 22, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (422, 64, 19, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (423, 64, 21, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (424, 64, 28, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (425, 64, 26, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (426, 64, 27, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (427, 64, 30, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (428, 64, 29, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (429, 64, 31, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (430, 64, 33, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (431, 64, 32, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (432, 64, 34, 1, NULL, NULL, NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblevidence` VALUES (433, 65, 21, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (434, 65, 22, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (435, 65, 18, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (436, 65, 20, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (437, 65, 17, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (438, 65, 19, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (439, 65, 25, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (440, 65, 27, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (441, 65, 26, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (442, 65, 28, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (443, 65, 29, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (444, 65, 30, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (445, 65, 32, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (446, 65, 31, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (447, 65, 33, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (448, 65, 34, 1, NULL, NULL, NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblevidence` VALUES (449, 66, 18, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (450, 66, 20, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (451, 66, 21, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (452, 66, 17, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (453, 66, 19, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (454, 66, 22, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (455, 66, 25, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (456, 66, 26, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (457, 66, 30, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (458, 66, 29, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (459, 66, 31, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (460, 66, 28, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (461, 66, 32, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (462, 66, 27, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (463, 66, 34, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (464, 66, 33, 1, NULL, NULL, NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblevidence` VALUES (465, 50, 37, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (466, 50, 42, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (467, 50, 38, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (468, 50, 36, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (469, 50, 39, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (470, 50, 35, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (471, 50, 46, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (472, 50, 43, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (473, 50, 45, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (474, 50, 44, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (475, 50, 41, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (476, 50, 40, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (477, 50, 51, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (478, 50, 48, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (479, 50, 50, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (480, 50, 49, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (481, 50, 47, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (482, 50, 52, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (483, 50, 53, 1, NULL, NULL, NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblevidence` VALUES (484, 50, 56, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (485, 50, 59, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (486, 50, 55, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (487, 50, 54, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (488, 50, 58, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (489, 50, 57, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (490, 50, 63, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (491, 50, 60, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (492, 50, 61, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (493, 50, 65, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (494, 50, 62, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (495, 50, 64, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (496, 50, 66, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (497, 50, 67, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (498, 50, 68, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (501, 50, 69, 1, NULL, NULL, NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblevidence` VALUES (503, 50, 76, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (504, 50, 78, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (505, 50, 74, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (506, 50, 75, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (507, 50, 77, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (508, 50, 73, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (509, 50, 80, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (510, 50, 79, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (511, 50, 81, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (512, 50, 89, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (513, 50, 82, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (514, 50, 90, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (515, 50, 91, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (516, 50, 92, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (517, 50, 93, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (518, 50, 94, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (519, 50, 96, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (520, 50, 95, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (521, 50, 97, 1, NULL, NULL, NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblevidence` VALUES (522, 50, 100, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (523, 50, 98, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (524, 50, 99, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (525, 50, 104, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (526, 50, 103, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (527, 50, 102, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (528, 50, 101, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (529, 50, 107, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (530, 50, 106, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (531, 50, 105, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (532, 50, 108, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (533, 50, 109, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (534, 50, 112, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (535, 50, 110, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (536, 50, 111, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (537, 50, 113, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (538, 50, 114, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (539, 50, 115, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (540, 50, 116, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (541, 50, 117, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (542, 50, 119, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (543, 50, 118, 1, NULL, NULL, NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblevidence` VALUES (544, 51, 37, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (545, 51, 38, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (546, 51, 40, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (547, 51, 36, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (548, 51, 35, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (549, 51, 39, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (550, 51, 42, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (551, 51, 46, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (552, 51, 43, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (553, 51, 41, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (554, 51, 44, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (555, 51, 45, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (556, 51, 47, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (557, 51, 48, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (558, 51, 52, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (559, 51, 51, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (560, 51, 49, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (561, 51, 50, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (562, 51, 53, 1, NULL, NULL, NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblevidence` VALUES (563, 51, 57, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (564, 51, 56, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (565, 51, 58, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (566, 51, 59, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (567, 51, 55, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (568, 51, 54, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (569, 51, 60, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (570, 51, 62, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (571, 51, 61, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (572, 51, 63, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (573, 51, 65, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (574, 51, 64, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (575, 51, 66, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (576, 51, 67, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (577, 51, 69, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (578, 51, 68, 1, NULL, NULL, NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblevidence` VALUES (582, 51, 76, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (583, 51, 77, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (584, 51, 78, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (585, 51, 75, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (586, 51, 73, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (587, 51, 74, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (588, 51, 79, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (589, 51, 80, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (590, 51, 82, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (591, 51, 81, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (592, 51, 89, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (593, 51, 90, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (594, 51, 92, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (595, 51, 91, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (596, 51, 93, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (597, 51, 94, 1, NULL, NULL, NULL, '2026-05-21 20:33:09', 1);
INSERT INTO `tblevidence` VALUES (598, 51, 97, 1, NULL, NULL, NULL, '2026-05-21 20:33:10', 1);
INSERT INTO `tblevidence` VALUES (599, 51, 96, 1, NULL, NULL, NULL, '2026-05-21 20:33:10', 1);
INSERT INTO `tblevidence` VALUES (600, 51, 95, 1, NULL, NULL, NULL, '2026-05-21 20:33:10', 1);
INSERT INTO `tblevidence` VALUES (601, 51, 101, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (602, 51, 98, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (603, 51, 100, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (604, 51, 102, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (605, 51, 103, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (606, 51, 99, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (607, 51, 106, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (608, 51, 104, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (609, 51, 105, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (610, 51, 107, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (611, 51, 108, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (612, 51, 109, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (613, 51, 112, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (614, 51, 111, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (615, 51, 113, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (616, 51, 110, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (617, 51, 114, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (618, 51, 115, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (619, 51, 116, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (620, 51, 117, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (621, 51, 119, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (622, 51, 118, 1, NULL, NULL, NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblevidence` VALUES (623, 52, 37, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (624, 52, 36, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (625, 52, 35, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (626, 52, 38, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (627, 52, 40, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (628, 52, 39, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (629, 52, 43, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (630, 52, 44, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (631, 52, 41, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (632, 52, 42, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (633, 52, 45, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (634, 52, 46, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (635, 52, 49, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (636, 52, 48, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (637, 52, 47, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (638, 52, 50, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (639, 52, 51, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (640, 52, 52, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (641, 52, 53, 1, NULL, NULL, NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblevidence` VALUES (642, 52, 59, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (643, 52, 55, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (644, 52, 54, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (645, 52, 58, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (646, 52, 57, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (647, 52, 56, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (648, 52, 63, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (649, 52, 60, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (650, 52, 61, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (651, 52, 62, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (652, 52, 64, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (653, 52, 69, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (654, 52, 66, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (655, 52, 65, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (657, 52, 67, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (658, 52, 68, 1, NULL, NULL, NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblevidence` VALUES (661, 53, 36, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (662, 53, 35, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (663, 53, 37, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (664, 53, 42, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (665, 53, 40, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (666, 53, 39, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (667, 53, 41, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (668, 53, 45, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (669, 53, 38, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (670, 53, 43, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (671, 53, 44, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (672, 53, 46, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (673, 53, 47, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (674, 53, 48, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (675, 53, 49, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (676, 53, 50, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (677, 53, 51, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (678, 53, 52, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (679, 53, 53, 1, NULL, NULL, NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblevidence` VALUES (680, 53, 59, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (681, 53, 54, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (682, 53, 55, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (683, 53, 56, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (684, 53, 57, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (685, 53, 58, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (686, 53, 60, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (687, 53, 61, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (688, 53, 62, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (689, 53, 66, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (690, 53, 63, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (691, 53, 64, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (692, 53, 68, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (693, 53, 65, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (694, 53, 69, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (696, 53, 67, 1, NULL, NULL, NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblevidence` VALUES (699, 54, 35, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (700, 54, 36, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (701, 54, 37, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (702, 54, 39, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (703, 54, 42, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (704, 54, 41, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (705, 54, 38, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (706, 54, 43, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (707, 54, 44, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (708, 54, 40, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (709, 54, 47, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (710, 54, 46, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (711, 54, 45, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (712, 54, 48, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (713, 54, 50, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (714, 54, 49, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (715, 54, 53, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (716, 54, 52, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (717, 54, 51, 1, NULL, NULL, NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblevidence` VALUES (718, 54, 54, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (719, 54, 55, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (720, 54, 58, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (721, 54, 57, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (722, 54, 62, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (723, 54, 59, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (724, 54, 56, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (725, 54, 63, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (726, 54, 61, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (727, 54, 60, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (728, 54, 65, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (729, 54, 64, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (731, 54, 67, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (732, 54, 66, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (733, 54, 69, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (734, 54, 68, 1, NULL, NULL, NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblevidence` VALUES (737, 54, 73, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (738, 54, 75, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (739, 54, 74, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (740, 54, 79, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (741, 54, 78, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (742, 54, 77, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (743, 54, 76, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (744, 54, 80, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (745, 54, 81, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (746, 54, 89, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (747, 54, 82, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (748, 54, 90, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (749, 54, 91, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (750, 54, 93, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (751, 54, 92, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (752, 54, 96, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (753, 54, 97, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (754, 54, 94, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (755, 54, 95, 1, NULL, NULL, NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblevidence` VALUES (756, 54, 98, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (757, 54, 101, 1, NULL, NULL, NULL, '2026-06-06 14:23:32', 1);
INSERT INTO `tblevidence` VALUES (758, 54, 100, 1, NULL, NULL, NULL, '2026-06-06 14:23:32', 1);
INSERT INTO `tblevidence` VALUES (759, 54, 99, 1, NULL, NULL, NULL, '2026-06-06 14:23:32', 1);
INSERT INTO `tblevidence` VALUES (760, 54, 103, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (761, 54, 104, 1, NULL, NULL, NULL, '2026-06-06 14:23:32', 1);
INSERT INTO `tblevidence` VALUES (762, 54, 102, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (763, 54, 107, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (764, 54, 108, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (765, 54, 106, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (766, 54, 105, 1, NULL, NULL, NULL, '2026-06-06 14:23:32', 1);
INSERT INTO `tblevidence` VALUES (767, 54, 111, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (768, 54, 109, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (769, 54, 110, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (770, 54, 112, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (771, 54, 114, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (772, 54, 113, 1, NULL, NULL, NULL, '2026-06-06 14:23:32', 1);
INSERT INTO `tblevidence` VALUES (773, 54, 115, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (774, 54, 118, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (775, 54, 119, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (776, 54, 117, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (777, 54, 116, 1, NULL, NULL, NULL, '2026-05-21 20:34:05', 1);
INSERT INTO `tblevidence` VALUES (784, 55, 39, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (785, 55, 40, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (786, 55, 38, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (787, 55, 35, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (788, 55, 37, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (789, 55, 36, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (790, 55, 41, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (791, 55, 42, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (792, 55, 46, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (793, 55, 47, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (794, 55, 45, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (795, 55, 44, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (796, 55, 43, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (797, 55, 48, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (798, 55, 53, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (799, 55, 52, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (800, 55, 51, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (801, 55, 49, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (802, 55, 50, 1, NULL, NULL, NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblevidence` VALUES (803, 55, 56, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (804, 55, 58, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (805, 55, 55, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (806, 55, 59, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (807, 55, 57, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (808, 55, 54, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (809, 55, 60, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (810, 55, 62, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (811, 55, 61, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (812, 55, 65, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (813, 55, 64, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (814, 55, 63, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (815, 55, 67, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (816, 55, 68, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (817, 55, 66, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (818, 55, 69, 1, NULL, NULL, NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblevidence` VALUES (822, 55, 79, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (823, 55, 77, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (824, 55, 76, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (825, 55, 74, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (826, 55, 75, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (827, 55, 73, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (828, 55, 78, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (829, 55, 80, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (830, 55, 82, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (831, 55, 89, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (832, 55, 90, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (833, 55, 81, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (834, 55, 91, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (835, 55, 92, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (836, 55, 95, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (837, 55, 97, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (838, 55, 96, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (839, 55, 93, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (840, 55, 94, 1, NULL, NULL, NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblevidence` VALUES (841, 55, 98, 1, NULL, NULL, NULL, '2026-05-21 20:35:17', 1);
INSERT INTO `tblevidence` VALUES (842, 56, 37, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (843, 56, 39, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (844, 56, 38, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (845, 56, 35, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (846, 56, 43, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (847, 56, 40, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (848, 56, 36, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (849, 56, 44, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (850, 56, 42, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (851, 56, 41, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (852, 56, 49, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (853, 56, 48, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (854, 56, 46, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (855, 56, 47, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (856, 56, 45, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (857, 56, 50, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (858, 56, 51, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (859, 56, 53, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (860, 56, 52, 1, NULL, NULL, NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblevidence` VALUES (861, 56, 58, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (862, 56, 59, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (863, 56, 56, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (864, 56, 54, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (865, 56, 55, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (866, 56, 57, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (867, 56, 61, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (868, 56, 60, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (869, 56, 62, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (870, 56, 64, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (871, 56, 65, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (872, 56, 63, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (873, 56, 67, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (874, 56, 66, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (875, 56, 68, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (876, 56, 69, 1, NULL, NULL, NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblevidence` VALUES (880, 56, 75, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (881, 56, 76, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (882, 56, 80, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (883, 56, 74, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (884, 56, 73, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (885, 56, 77, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (886, 56, 79, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (887, 56, 91, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (888, 56, 90, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (889, 56, 81, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (890, 56, 89, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (891, 56, 82, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (892, 56, 78, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (893, 56, 93, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (894, 56, 92, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (895, 56, 94, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (896, 56, 96, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (897, 56, 95, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (898, 56, 97, 1, NULL, NULL, NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblevidence` VALUES (899, 56, 103, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (900, 56, 102, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (901, 56, 98, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (902, 56, 101, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (903, 56, 99, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (904, 56, 100, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (905, 56, 104, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (906, 56, 105, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (907, 56, 106, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (908, 56, 108, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (909, 56, 110, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (910, 56, 107, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (911, 56, 109, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (912, 56, 112, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (913, 56, 111, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (914, 56, 116, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (915, 56, 115, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (916, 56, 114, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (917, 56, 113, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (918, 56, 118, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (919, 56, 117, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (920, 56, 119, 1, NULL, NULL, NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblevidence` VALUES (921, 57, 37, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (922, 57, 36, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (923, 57, 42, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (924, 57, 39, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (925, 57, 38, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (926, 57, 40, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (927, 57, 35, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (928, 57, 41, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (929, 57, 43, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (930, 57, 44, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (931, 57, 45, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (932, 57, 46, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (933, 57, 47, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (934, 57, 49, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (935, 57, 48, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (936, 57, 53, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (937, 57, 50, 1, NULL, NULL, NULL, '2026-05-21 20:35:53', 1);
INSERT INTO `tblevidence` VALUES (938, 57, 51, 1, NULL, NULL, NULL, '2026-05-21 20:35:54', 1);
INSERT INTO `tblevidence` VALUES (939, 57, 52, 1, NULL, NULL, NULL, '2026-05-21 20:35:54', 1);
INSERT INTO `tblevidence` VALUES (940, 57, 56, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (941, 57, 57, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (942, 57, 58, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (943, 57, 54, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (944, 57, 55, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (945, 57, 59, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (946, 57, 60, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (947, 57, 62, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (948, 57, 61, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (949, 57, 63, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (950, 57, 67, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (951, 57, 66, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (952, 57, 65, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (953, 57, 64, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (954, 57, 68, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (955, 57, 69, 1, NULL, NULL, NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblevidence` VALUES (959, 57, 76, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (960, 57, 79, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (961, 57, 75, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (962, 57, 78, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (963, 57, 73, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (964, 57, 74, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (965, 57, 77, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (966, 57, 91, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (967, 57, 90, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (968, 57, 80, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (969, 57, 89, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (970, 57, 81, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (971, 57, 82, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (972, 57, 92, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (973, 57, 95, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (974, 57, 96, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (975, 57, 94, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (976, 57, 93, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (977, 57, 97, 1, NULL, NULL, NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblevidence` VALUES (978, 57, 101, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (979, 57, 103, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (980, 57, 105, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (981, 57, 100, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (982, 57, 99, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (983, 57, 98, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (984, 57, 102, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (985, 57, 107, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (986, 57, 104, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (987, 57, 110, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (988, 57, 108, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (989, 57, 111, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (990, 57, 109, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (991, 57, 106, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (992, 57, 112, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (993, 57, 114, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (994, 57, 115, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (995, 57, 117, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (996, 57, 116, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (997, 57, 113, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (998, 57, 118, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (999, 57, 119, 1, NULL, NULL, NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblevidence` VALUES (1000, 58, 36, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1001, 58, 39, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1002, 58, 37, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1003, 58, 35, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1004, 58, 40, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1005, 58, 38, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1006, 58, 42, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1007, 58, 41, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1008, 58, 44, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1009, 58, 46, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1010, 58, 47, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1011, 58, 43, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1012, 58, 45, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1013, 58, 48, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1014, 58, 49, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1015, 58, 52, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1016, 58, 50, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1017, 58, 53, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1018, 58, 51, 1, NULL, NULL, NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblevidence` VALUES (1019, 58, 54, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1020, 58, 56, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1021, 58, 59, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1022, 58, 57, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1023, 58, 58, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1024, 58, 55, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1025, 58, 61, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1026, 58, 64, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1027, 58, 60, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1028, 58, 63, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1029, 58, 62, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1030, 58, 65, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1031, 58, 68, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1032, 58, 69, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1033, 58, 66, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1034, 58, 67, 1, NULL, NULL, NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblevidence` VALUES (1038, 58, 75, 1, NULL, NULL, NULL, '2026-05-21 20:36:21', 1);
INSERT INTO `tblevidence` VALUES (1039, 58, 78, 1, NULL, NULL, NULL, '2026-05-21 20:36:21', 1);
INSERT INTO `tblevidence` VALUES (1040, 58, 76, 1, NULL, NULL, NULL, '2026-05-21 20:36:21', 1);
INSERT INTO `tblevidence` VALUES (1041, 58, 79, 1, NULL, NULL, NULL, '2026-05-21 20:36:21', 1);
INSERT INTO `tblevidence` VALUES (1042, 58, 73, 1, NULL, NULL, NULL, '2026-05-21 20:36:21', 1);
INSERT INTO `tblevidence` VALUES (1043, 58, 74, 1, NULL, NULL, NULL, '2026-05-21 20:36:21', 1);
INSERT INTO `tblevidence` VALUES (1044, 58, 77, 1, NULL, NULL, NULL, '2026-05-21 20:36:21', 1);
INSERT INTO `tblevidence` VALUES (1045, 58, 80, 1, NULL, NULL, NULL, '2026-05-21 20:36:21', 1);
INSERT INTO `tblevidence` VALUES (1046, 58, 82, 1, NULL, NULL, NULL, '2026-05-21 20:36:21', 1);
INSERT INTO `tblevidence` VALUES (1047, 58, 81, 1, NULL, NULL, NULL, '2026-05-21 20:36:21', 1);
INSERT INTO `tblevidence` VALUES (1048, 58, 90, 1, NULL, NULL, NULL, '2026-05-21 20:36:21', 1);
INSERT INTO `tblevidence` VALUES (1049, 58, 89, 1, NULL, NULL, NULL, '2026-05-21 20:36:22', 1);
INSERT INTO `tblevidence` VALUES (1050, 58, 92, 1, NULL, NULL, NULL, '2026-05-21 20:36:22', 1);
INSERT INTO `tblevidence` VALUES (1051, 58, 91, 1, NULL, NULL, NULL, '2026-05-21 20:36:22', 1);
INSERT INTO `tblevidence` VALUES (1052, 58, 93, 1, NULL, NULL, NULL, '2026-05-21 20:36:22', 1);
INSERT INTO `tblevidence` VALUES (1053, 58, 94, 1, NULL, NULL, NULL, '2026-05-21 20:36:22', 1);
INSERT INTO `tblevidence` VALUES (1054, 58, 95, 1, NULL, NULL, NULL, '2026-05-21 20:36:22', 1);
INSERT INTO `tblevidence` VALUES (1055, 58, 97, 1, NULL, NULL, NULL, '2026-05-21 20:36:22', 1);
INSERT INTO `tblevidence` VALUES (1056, 58, 96, 1, NULL, NULL, NULL, '2026-05-21 20:36:22', 1);
INSERT INTO `tblevidence` VALUES (1057, 58, 98, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1058, 58, 99, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1059, 58, 100, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1060, 58, 105, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1061, 58, 101, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1062, 58, 104, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1063, 58, 102, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1064, 58, 103, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1065, 58, 106, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1066, 58, 109, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1067, 58, 107, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1068, 58, 111, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1069, 58, 108, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1070, 58, 110, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1071, 58, 112, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1072, 58, 113, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1073, 58, 115, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1074, 58, 118, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1075, 58, 114, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1076, 58, 116, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1077, 58, 119, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1078, 58, 117, 1, NULL, NULL, NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblevidence` VALUES (1079, 59, 37, 1, NULL, NULL, NULL, '2026-05-21 20:36:29', 1);
INSERT INTO `tblevidence` VALUES (1080, 59, 35, 1, NULL, NULL, NULL, '2026-05-21 20:36:29', 1);
INSERT INTO `tblevidence` VALUES (1081, 59, 38, 1, NULL, NULL, NULL, '2026-05-21 20:36:29', 1);
INSERT INTO `tblevidence` VALUES (1082, 59, 40, 1, NULL, NULL, NULL, '2026-05-21 20:36:29', 1);
INSERT INTO `tblevidence` VALUES (1083, 59, 36, 1, NULL, NULL, NULL, '2026-05-21 20:36:29', 1);
INSERT INTO `tblevidence` VALUES (1084, 59, 41, 1, NULL, NULL, NULL, '2026-05-21 20:36:29', 1);
INSERT INTO `tblevidence` VALUES (1085, 59, 39, 1, NULL, NULL, NULL, '2026-05-21 20:36:29', 1);
INSERT INTO `tblevidence` VALUES (1086, 59, 43, 1, NULL, NULL, NULL, '2026-05-21 20:36:29', 1);
INSERT INTO `tblevidence` VALUES (1087, 59, 42, 1, NULL, NULL, NULL, '2026-05-21 20:36:29', 1);
INSERT INTO `tblevidence` VALUES (1088, 59, 44, 1, NULL, NULL, NULL, '2026-05-21 20:36:29', 1);
INSERT INTO `tblevidence` VALUES (1089, 59, 48, 1, NULL, NULL, NULL, '2026-05-21 20:36:29', 1);
INSERT INTO `tblevidence` VALUES (1090, 59, 47, 1, NULL, NULL, NULL, '2026-05-21 20:36:29', 1);
INSERT INTO `tblevidence` VALUES (1091, 59, 45, 1, NULL, NULL, NULL, '2026-05-21 20:36:29', 1);
INSERT INTO `tblevidence` VALUES (1092, 59, 46, 1, NULL, NULL, NULL, '2026-05-21 20:36:29', 1);
INSERT INTO `tblevidence` VALUES (1093, 59, 49, 1, NULL, NULL, NULL, '2026-05-21 20:36:30', 1);
INSERT INTO `tblevidence` VALUES (1094, 59, 50, 1, NULL, NULL, NULL, '2026-05-21 20:36:30', 1);
INSERT INTO `tblevidence` VALUES (1095, 59, 52, 1, NULL, NULL, NULL, '2026-05-21 20:36:30', 1);
INSERT INTO `tblevidence` VALUES (1096, 59, 51, 1, NULL, NULL, NULL, '2026-05-21 20:36:30', 1);
INSERT INTO `tblevidence` VALUES (1097, 59, 53, 1, NULL, NULL, NULL, '2026-05-21 20:36:30', 1);
INSERT INTO `tblevidence` VALUES (1098, 59, 56, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1099, 59, 59, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1100, 59, 54, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1101, 59, 57, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1102, 59, 55, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1103, 59, 61, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1104, 59, 60, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1105, 59, 58, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1106, 59, 63, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1107, 59, 64, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1108, 59, 65, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1109, 59, 62, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1110, 59, 67, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1111, 59, 66, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1112, 59, 68, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1114, 59, 69, 1, NULL, NULL, NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblevidence` VALUES (1117, 59, 77, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1118, 59, 73, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1119, 59, 78, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1120, 59, 75, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1121, 59, 74, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1122, 59, 76, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1123, 59, 80, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1124, 59, 89, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1125, 59, 79, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1126, 59, 81, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1127, 59, 82, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1128, 59, 90, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1129, 59, 95, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1130, 59, 91, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1131, 59, 92, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1132, 59, 94, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1133, 59, 93, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1134, 59, 96, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1135, 59, 97, 1, NULL, NULL, NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblevidence` VALUES (1136, 59, 99, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1137, 59, 98, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1138, 59, 101, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1139, 59, 100, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1140, 59, 103, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1141, 59, 102, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1142, 59, 105, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1143, 59, 107, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1144, 59, 106, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1145, 59, 104, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1146, 59, 108, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1147, 59, 109, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1148, 59, 110, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1149, 59, 113, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1150, 59, 111, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1151, 59, 112, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1152, 59, 115, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1153, 59, 114, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1154, 59, 116, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1155, 59, 117, 1, NULL, NULL, NULL, '2026-05-21 20:36:38', 1);
INSERT INTO `tblevidence` VALUES (1156, 59, 119, 1, NULL, NULL, NULL, '2026-05-21 20:36:39', 1);
INSERT INTO `tblevidence` VALUES (1157, 59, 118, 1, NULL, NULL, NULL, '2026-05-21 20:36:39', 1);
INSERT INTO `tblevidence` VALUES (1158, 60, 40, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1159, 60, 37, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1160, 60, 35, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1161, 60, 36, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1162, 60, 39, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1163, 60, 38, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1164, 60, 41, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1165, 60, 46, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1166, 60, 47, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1167, 60, 45, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1168, 60, 42, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1169, 60, 43, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1170, 60, 44, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1171, 60, 53, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1172, 60, 50, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1173, 60, 49, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1174, 60, 48, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1175, 60, 52, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1176, 60, 51, 1, NULL, NULL, NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblevidence` VALUES (1177, 60, 57, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1178, 60, 56, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1179, 60, 55, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1180, 60, 54, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1181, 60, 59, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1182, 60, 61, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1183, 60, 60, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1184, 60, 58, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1185, 60, 63, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1186, 60, 64, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1187, 60, 65, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1188, 60, 62, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1189, 60, 66, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1190, 60, 67, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1191, 60, 68, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1195, 60, 69, 1, NULL, NULL, NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblevidence` VALUES (1196, 60, 73, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1197, 60, 76, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1198, 60, 74, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1199, 60, 75, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1200, 60, 78, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1201, 60, 77, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1202, 60, 80, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1203, 60, 82, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1204, 60, 90, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1205, 60, 79, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1206, 60, 81, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1207, 60, 89, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1208, 60, 93, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1209, 60, 96, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1210, 60, 92, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1211, 60, 91, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1212, 60, 94, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1213, 60, 95, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1214, 60, 97, 1, NULL, NULL, NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblevidence` VALUES (1215, 60, 99, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1216, 60, 101, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1217, 60, 102, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1218, 60, 98, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1219, 60, 106, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1220, 60, 105, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1221, 60, 100, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1222, 60, 104, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1223, 60, 103, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1224, 60, 107, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1225, 60, 110, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1226, 60, 108, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1227, 60, 111, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1228, 60, 109, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1229, 60, 112, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1230, 60, 114, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1231, 60, 115, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1232, 60, 113, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1233, 60, 116, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1234, 60, 117, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1235, 60, 119, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1236, 60, 118, 1, NULL, NULL, NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblevidence` VALUES (1237, 61, 36, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1238, 61, 41, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1239, 61, 39, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1240, 61, 38, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1241, 61, 37, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1242, 61, 35, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1243, 61, 40, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1244, 61, 42, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1245, 61, 44, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1246, 61, 46, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1247, 61, 43, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1248, 61, 45, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1249, 61, 47, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1250, 61, 49, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1251, 61, 48, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1252, 61, 50, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1253, 61, 51, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1254, 61, 53, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1255, 61, 52, 1, NULL, NULL, NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblevidence` VALUES (1256, 61, 54, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1257, 61, 57, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1258, 61, 60, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1259, 61, 58, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1260, 61, 56, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1261, 61, 55, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1262, 61, 59, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1263, 61, 62, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1264, 61, 61, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1265, 61, 63, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1266, 61, 66, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1267, 61, 65, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1268, 61, 64, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1269, 61, 68, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1270, 61, 67, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1272, 61, 69, 1, NULL, NULL, NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblevidence` VALUES (1275, 61, 76, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1276, 61, 78, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1277, 61, 79, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1278, 61, 75, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1279, 61, 73, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1280, 61, 74, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1281, 61, 89, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1282, 61, 82, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1283, 61, 81, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1284, 61, 77, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1285, 61, 80, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1286, 61, 90, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1287, 61, 92, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1288, 61, 91, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1289, 61, 93, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1290, 61, 94, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1291, 61, 96, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1292, 61, 95, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1293, 61, 97, 1, NULL, NULL, NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblevidence` VALUES (1294, 61, 101, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1295, 61, 104, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1296, 61, 99, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1297, 61, 103, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1298, 61, 98, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1299, 61, 100, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1300, 61, 102, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1301, 61, 105, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1302, 61, 108, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1303, 61, 106, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1304, 61, 111, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1305, 61, 110, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1306, 61, 107, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1307, 61, 109, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1308, 61, 115, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1309, 61, 114, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1310, 61, 113, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1311, 61, 112, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1312, 61, 117, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1313, 61, 118, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1314, 61, 116, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1315, 61, 119, 1, NULL, NULL, NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblevidence` VALUES (1316, 62, 36, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1317, 62, 35, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1318, 62, 41, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1319, 62, 42, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1320, 62, 38, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1321, 62, 39, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1322, 62, 37, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1323, 62, 40, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1324, 62, 45, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1325, 62, 44, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1326, 62, 43, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1327, 62, 46, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1328, 62, 48, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1329, 62, 47, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1330, 62, 49, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1331, 62, 50, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1332, 62, 51, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1333, 62, 52, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1334, 62, 53, 1, NULL, NULL, NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblevidence` VALUES (1335, 62, 54, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1336, 62, 55, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1337, 62, 60, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1338, 62, 58, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1339, 62, 57, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1340, 62, 59, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1341, 62, 56, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1342, 62, 63, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1343, 62, 62, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1344, 62, 61, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1345, 62, 64, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1346, 62, 66, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1347, 62, 65, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1348, 62, 68, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1349, 62, 67, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1353, 62, 69, 1, NULL, NULL, NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblevidence` VALUES (1354, 62, 74, 1, NULL, NULL, NULL, '2026-05-21 20:37:30', 1);
INSERT INTO `tblevidence` VALUES (1355, 62, 73, 1, NULL, NULL, NULL, '2026-05-21 20:37:30', 1);
INSERT INTO `tblevidence` VALUES (1356, 62, 77, 1, NULL, NULL, NULL, '2026-05-21 20:37:30', 1);
INSERT INTO `tblevidence` VALUES (1357, 62, 76, 1, NULL, NULL, NULL, '2026-05-21 20:37:30', 1);
INSERT INTO `tblevidence` VALUES (1358, 62, 80, 1, NULL, NULL, NULL, '2026-05-21 20:37:30', 1);
INSERT INTO `tblevidence` VALUES (1359, 62, 79, 1, NULL, NULL, NULL, '2026-05-21 20:37:30', 1);
INSERT INTO `tblevidence` VALUES (1360, 62, 78, 1, NULL, NULL, NULL, '2026-05-21 20:37:30', 1);
INSERT INTO `tblevidence` VALUES (1361, 62, 75, 1, NULL, NULL, NULL, '2026-05-21 20:37:30', 1);
INSERT INTO `tblevidence` VALUES (1362, 62, 82, 1, NULL, NULL, NULL, '2026-05-21 20:37:31', 1);
INSERT INTO `tblevidence` VALUES (1363, 62, 81, 1, NULL, NULL, NULL, '2026-05-21 20:37:31', 1);
INSERT INTO `tblevidence` VALUES (1364, 62, 92, 1, NULL, NULL, NULL, '2026-05-21 20:37:31', 1);
INSERT INTO `tblevidence` VALUES (1365, 62, 89, 1, NULL, NULL, NULL, '2026-05-21 20:37:31', 1);
INSERT INTO `tblevidence` VALUES (1366, 62, 90, 1, NULL, NULL, NULL, '2026-05-21 20:37:31', 1);
INSERT INTO `tblevidence` VALUES (1367, 62, 91, 1, NULL, NULL, NULL, '2026-05-21 20:37:31', 1);
INSERT INTO `tblevidence` VALUES (1368, 62, 93, 1, NULL, NULL, NULL, '2026-05-21 20:37:31', 1);
INSERT INTO `tblevidence` VALUES (1369, 62, 94, 1, NULL, NULL, NULL, '2026-05-21 20:37:31', 1);
INSERT INTO `tblevidence` VALUES (1370, 62, 97, 1, NULL, NULL, NULL, '2026-05-21 20:37:31', 1);
INSERT INTO `tblevidence` VALUES (1371, 62, 95, 1, NULL, NULL, NULL, '2026-05-21 20:37:31', 1);
INSERT INTO `tblevidence` VALUES (1372, 62, 96, 1, NULL, NULL, NULL, '2026-05-21 20:37:31', 1);
INSERT INTO `tblevidence` VALUES (1373, 62, 100, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1374, 62, 102, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1375, 62, 101, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1376, 62, 103, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1377, 62, 98, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1378, 62, 99, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1379, 62, 105, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1380, 62, 104, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1381, 62, 106, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1382, 62, 109, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1383, 62, 108, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1384, 62, 107, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1385, 62, 110, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1386, 62, 111, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1387, 62, 112, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1388, 62, 113, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1389, 62, 116, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1390, 62, 118, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1391, 62, 115, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1392, 62, 114, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1393, 62, 117, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1394, 62, 119, 1, NULL, NULL, NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblevidence` VALUES (1395, 63, 39, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1396, 63, 37, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1397, 63, 38, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1398, 63, 35, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1399, 63, 36, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1400, 63, 42, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1401, 63, 40, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1402, 63, 41, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1403, 63, 44, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1404, 63, 45, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1405, 63, 43, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1406, 63, 46, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1407, 63, 47, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1408, 63, 50, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1409, 63, 48, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1410, 63, 51, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1411, 63, 49, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1412, 63, 52, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1413, 63, 53, 1, NULL, NULL, NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblevidence` VALUES (1414, 63, 54, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1415, 63, 55, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1416, 63, 56, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1417, 63, 58, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1418, 63, 59, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1419, 63, 57, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1420, 63, 60, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1421, 63, 61, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1422, 63, 65, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1423, 63, 62, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1424, 63, 63, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1425, 63, 64, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1426, 63, 67, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1427, 63, 66, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1428, 63, 68, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1432, 63, 69, 1, NULL, NULL, NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblevidence` VALUES (1433, 63, 74, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1434, 63, 73, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1435, 63, 76, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1436, 63, 78, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1437, 63, 75, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1438, 63, 77, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1439, 63, 81, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1440, 63, 79, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1441, 63, 80, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1442, 63, 82, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1443, 63, 91, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1444, 63, 90, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1445, 63, 89, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1446, 63, 93, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1447, 63, 94, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1448, 63, 92, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1449, 63, 97, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1450, 63, 96, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1451, 63, 95, 1, NULL, NULL, NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblevidence` VALUES (1452, 64, 35, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1453, 64, 39, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1454, 64, 36, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1455, 64, 38, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1456, 64, 41, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1457, 64, 40, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1458, 64, 37, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1459, 64, 43, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1460, 64, 44, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1461, 64, 42, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1462, 64, 47, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1463, 64, 48, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1464, 64, 45, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1465, 64, 46, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1466, 64, 50, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1467, 64, 49, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1468, 64, 51, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1469, 64, 52, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1470, 64, 53, 1, NULL, NULL, NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblevidence` VALUES (1471, 64, 58, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1472, 64, 57, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1473, 64, 56, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1474, 64, 60, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1475, 64, 54, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1476, 64, 55, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1477, 64, 59, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1478, 64, 61, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1479, 64, 62, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1480, 64, 64, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1481, 64, 63, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1482, 64, 65, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1483, 64, 67, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1484, 64, 66, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1485, 64, 68, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1486, 64, 69, 1, NULL, NULL, NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblevidence` VALUES (1490, 64, 76, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1491, 64, 75, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1492, 64, 73, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1493, 64, 74, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1494, 64, 77, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1495, 64, 78, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1496, 64, 79, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1497, 64, 80, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1498, 64, 82, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1499, 64, 89, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1500, 64, 90, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1501, 64, 81, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1502, 64, 91, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1503, 64, 95, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1504, 64, 96, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1505, 64, 94, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1506, 64, 93, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1507, 64, 92, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1508, 64, 97, 1, NULL, NULL, NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblevidence` VALUES (1509, 64, 98, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1510, 64, 100, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1511, 64, 102, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1512, 64, 99, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1513, 64, 101, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1514, 64, 105, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1515, 64, 104, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1516, 64, 103, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1517, 64, 107, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1518, 64, 106, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1519, 64, 109, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1520, 64, 110, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1521, 64, 111, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1522, 64, 108, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1523, 64, 113, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1524, 64, 112, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1525, 64, 114, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1526, 64, 115, 1, NULL, NULL, NULL, '2026-05-21 20:41:53', 1);
INSERT INTO `tblevidence` VALUES (1527, 64, 118, 1, NULL, NULL, NULL, '2026-05-21 20:41:54', 1);
INSERT INTO `tblevidence` VALUES (1528, 64, 116, 1, NULL, NULL, NULL, '2026-05-21 20:41:54', 1);
INSERT INTO `tblevidence` VALUES (1529, 64, 117, 1, NULL, NULL, NULL, '2026-05-21 20:41:54', 1);
INSERT INTO `tblevidence` VALUES (1530, 64, 119, 1, NULL, NULL, NULL, '2026-05-21 20:41:54', 1);
INSERT INTO `tblevidence` VALUES (1531, 65, 35, 1, NULL, NULL, NULL, '2026-05-21 20:41:56', 1);
INSERT INTO `tblevidence` VALUES (1532, 65, 37, 1, NULL, NULL, NULL, '2026-05-21 20:41:56', 1);
INSERT INTO `tblevidence` VALUES (1533, 65, 40, 1, NULL, NULL, NULL, '2026-05-21 20:41:56', 1);
INSERT INTO `tblevidence` VALUES (1534, 65, 38, 1, NULL, NULL, NULL, '2026-05-21 20:41:56', 1);
INSERT INTO `tblevidence` VALUES (1535, 65, 39, 1, NULL, NULL, NULL, '2026-05-21 20:41:56', 1);
INSERT INTO `tblevidence` VALUES (1536, 65, 36, 1, NULL, NULL, NULL, '2026-05-21 20:41:56', 1);
INSERT INTO `tblevidence` VALUES (1537, 65, 42, 1, NULL, NULL, NULL, '2026-05-21 20:41:56', 1);
INSERT INTO `tblevidence` VALUES (1538, 65, 41, 1, NULL, NULL, NULL, '2026-05-21 20:41:56', 1);
INSERT INTO `tblevidence` VALUES (1539, 65, 43, 1, NULL, NULL, NULL, '2026-05-21 20:41:56', 1);
INSERT INTO `tblevidence` VALUES (1540, 65, 45, 1, NULL, NULL, NULL, '2026-05-21 20:41:56', 1);
INSERT INTO `tblevidence` VALUES (1541, 65, 46, 1, NULL, NULL, NULL, '2026-05-21 20:41:56', 1);
INSERT INTO `tblevidence` VALUES (1542, 65, 44, 1, NULL, NULL, NULL, '2026-05-21 20:41:56', 1);
INSERT INTO `tblevidence` VALUES (1543, 65, 47, 1, NULL, NULL, NULL, '2026-05-21 20:41:57', 1);
INSERT INTO `tblevidence` VALUES (1544, 65, 48, 1, NULL, NULL, NULL, '2026-05-21 20:41:57', 1);
INSERT INTO `tblevidence` VALUES (1545, 65, 50, 1, NULL, NULL, NULL, '2026-05-21 20:41:57', 1);
INSERT INTO `tblevidence` VALUES (1546, 65, 49, 1, NULL, NULL, NULL, '2026-05-21 20:41:57', 1);
INSERT INTO `tblevidence` VALUES (1547, 65, 51, 1, NULL, NULL, NULL, '2026-05-21 20:41:57', 1);
INSERT INTO `tblevidence` VALUES (1548, 65, 53, 1, NULL, NULL, NULL, '2026-05-21 20:41:57', 1);
INSERT INTO `tblevidence` VALUES (1549, 65, 52, 1, NULL, NULL, NULL, '2026-05-21 20:41:57', 1);
INSERT INTO `tblevidence` VALUES (1550, 65, 60, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1551, 65, 54, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1552, 65, 56, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1553, 65, 55, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1554, 65, 59, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1555, 65, 57, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1556, 65, 63, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1557, 65, 58, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1558, 65, 61, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1559, 65, 62, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1560, 65, 65, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1561, 65, 64, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1562, 65, 68, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1563, 65, 67, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1564, 65, 66, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1566, 65, 69, 1, NULL, NULL, NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblevidence` VALUES (1569, 65, 77, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1570, 65, 79, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1571, 65, 80, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1572, 65, 76, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1573, 65, 75, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1574, 65, 73, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1575, 65, 78, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1576, 65, 74, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1577, 65, 81, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1578, 65, 91, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1579, 65, 92, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1580, 65, 93, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1581, 65, 89, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1582, 65, 82, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1583, 65, 90, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1584, 65, 94, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1585, 65, 95, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1586, 65, 96, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1587, 65, 97, 1, NULL, NULL, NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblevidence` VALUES (1588, 65, 103, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1589, 65, 98, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1590, 65, 101, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1591, 65, 99, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1592, 65, 105, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1593, 65, 106, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1594, 65, 102, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1595, 65, 104, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1596, 65, 100, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1597, 65, 107, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1598, 65, 108, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1599, 65, 113, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1600, 65, 112, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1601, 65, 110, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1602, 65, 111, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1603, 65, 109, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1604, 65, 114, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1605, 65, 117, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1606, 65, 118, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1607, 65, 116, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1608, 65, 119, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1609, 65, 115, 1, NULL, NULL, NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblevidence` VALUES (1610, 66, 37, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1611, 66, 40, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1612, 66, 38, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1613, 66, 39, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1614, 66, 36, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1615, 66, 35, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1616, 66, 44, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1617, 66, 43, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1618, 66, 42, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1619, 66, 45, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1620, 66, 46, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1621, 66, 41, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1622, 66, 49, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1623, 66, 51, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1624, 66, 50, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1625, 66, 48, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1626, 66, 47, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1627, 66, 52, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1628, 66, 53, 1, NULL, NULL, NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblevidence` VALUES (1629, 66, 59, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1630, 66, 61, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1631, 66, 56, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1632, 66, 55, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1633, 66, 54, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1634, 66, 58, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1635, 66, 57, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1636, 66, 60, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1637, 66, 65, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1638, 66, 63, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1639, 66, 66, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1640, 66, 64, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1641, 66, 67, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1642, 66, 62, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1643, 66, 68, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1646, 66, 69, 1, NULL, NULL, NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblevidence` VALUES (1648, 66, 74, 1, NULL, NULL, NULL, '2026-05-21 20:42:17', 1);
INSERT INTO `tblevidence` VALUES (1649, 66, 78, 1, NULL, NULL, NULL, '2026-05-21 20:42:17', 1);
INSERT INTO `tblevidence` VALUES (1650, 66, 73, 1, NULL, NULL, NULL, '2026-05-21 20:42:17', 1);
INSERT INTO `tblevidence` VALUES (1651, 66, 77, 1, NULL, NULL, NULL, '2026-05-21 20:42:17', 1);
INSERT INTO `tblevidence` VALUES (1652, 66, 76, 1, NULL, NULL, NULL, '2026-05-21 20:42:17', 1);
INSERT INTO `tblevidence` VALUES (1653, 66, 75, 1, NULL, NULL, NULL, '2026-05-21 20:42:17', 1);
INSERT INTO `tblevidence` VALUES (1654, 66, 89, 1, NULL, NULL, NULL, '2026-05-21 20:42:17', 1);
INSERT INTO `tblevidence` VALUES (1655, 66, 80, 1, NULL, NULL, NULL, '2026-05-21 20:42:17', 1);
INSERT INTO `tblevidence` VALUES (1656, 66, 79, 1, NULL, NULL, NULL, '2026-05-21 20:42:17', 1);
INSERT INTO `tblevidence` VALUES (1657, 66, 81, 1, NULL, NULL, NULL, '2026-05-21 20:42:17', 1);
INSERT INTO `tblevidence` VALUES (1658, 66, 82, 1, NULL, NULL, NULL, '2026-05-21 20:42:17', 1);
INSERT INTO `tblevidence` VALUES (1659, 66, 91, 1, NULL, NULL, NULL, '2026-05-21 20:42:18', 1);
INSERT INTO `tblevidence` VALUES (1660, 66, 90, 1, NULL, NULL, NULL, '2026-05-21 20:42:18', 1);
INSERT INTO `tblevidence` VALUES (1661, 66, 96, 1, NULL, NULL, NULL, '2026-05-21 20:42:18', 1);
INSERT INTO `tblevidence` VALUES (1662, 66, 95, 1, NULL, NULL, NULL, '2026-05-21 20:42:18', 1);
INSERT INTO `tblevidence` VALUES (1663, 66, 94, 1, NULL, NULL, NULL, '2026-05-21 20:42:18', 1);
INSERT INTO `tblevidence` VALUES (1664, 66, 93, 1, NULL, NULL, NULL, '2026-05-21 20:42:18', 1);
INSERT INTO `tblevidence` VALUES (1665, 66, 92, 1, NULL, NULL, NULL, '2026-05-21 20:42:18', 1);
INSERT INTO `tblevidence` VALUES (1666, 66, 97, 1, NULL, NULL, NULL, '2026-05-21 20:42:18', 1);
INSERT INTO `tblevidence` VALUES (1667, 66, 98, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1668, 66, 105, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1669, 66, 103, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1670, 66, 102, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1671, 66, 100, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1672, 66, 101, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1673, 66, 99, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1674, 66, 106, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1675, 66, 111, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1676, 66, 104, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1677, 66, 110, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1678, 66, 109, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1679, 66, 108, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1680, 66, 107, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1681, 66, 113, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1682, 66, 116, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1683, 66, 112, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1684, 66, 117, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1685, 66, 118, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1686, 66, 114, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1687, 66, 115, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1688, 66, 119, 1, NULL, NULL, NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblevidence` VALUES (1689, 52, 77, 1, NULL, NULL, NULL, '2026-06-06 14:23:21', 1);
INSERT INTO `tblevidence` VALUES (1690, 52, 75, 1, NULL, NULL, NULL, '2026-06-06 14:23:21', 1);
INSERT INTO `tblevidence` VALUES (1691, 52, 76, 1, NULL, NULL, NULL, '2026-06-06 14:23:21', 1);
INSERT INTO `tblevidence` VALUES (1692, 52, 73, 1, NULL, NULL, NULL, '2026-06-06 14:23:21', 1);
INSERT INTO `tblevidence` VALUES (1693, 52, 74, 1, NULL, NULL, NULL, '2026-06-06 14:23:21', 1);
INSERT INTO `tblevidence` VALUES (1694, 52, 78, 1, NULL, NULL, NULL, '2026-06-06 14:23:21', 1);
INSERT INTO `tblevidence` VALUES (1695, 52, 81, 1, NULL, NULL, NULL, '2026-06-06 14:23:21', 1);
INSERT INTO `tblevidence` VALUES (1696, 52, 79, 1, NULL, NULL, NULL, '2026-06-06 14:23:21', 1);
INSERT INTO `tblevidence` VALUES (1697, 52, 90, 1, NULL, NULL, NULL, '2026-06-06 14:23:22', 1);
INSERT INTO `tblevidence` VALUES (1698, 52, 80, 1, NULL, NULL, NULL, '2026-06-06 14:23:22', 1);
INSERT INTO `tblevidence` VALUES (1699, 52, 89, 1, NULL, NULL, NULL, '2026-06-06 14:23:22', 1);
INSERT INTO `tblevidence` VALUES (1700, 52, 82, 1, NULL, NULL, NULL, '2026-06-06 14:23:22', 1);
INSERT INTO `tblevidence` VALUES (1701, 52, 93, 1, NULL, NULL, NULL, '2026-06-06 14:23:22', 1);
INSERT INTO `tblevidence` VALUES (1702, 52, 95, 1, NULL, NULL, NULL, '2026-06-06 14:23:22', 1);
INSERT INTO `tblevidence` VALUES (1703, 52, 91, 1, NULL, NULL, NULL, '2026-06-06 14:23:22', 1);
INSERT INTO `tblevidence` VALUES (1704, 52, 92, 1, NULL, NULL, NULL, '2026-06-06 14:23:22', 1);
INSERT INTO `tblevidence` VALUES (1705, 52, 97, 1, NULL, NULL, NULL, '2026-06-06 14:23:22', 1);
INSERT INTO `tblevidence` VALUES (1706, 52, 96, 1, NULL, NULL, NULL, '2026-06-06 14:23:22', 1);
INSERT INTO `tblevidence` VALUES (1707, 52, 94, 1, NULL, NULL, NULL, '2026-06-06 14:23:22', 1);
INSERT INTO `tblevidence` VALUES (1708, 52, 99, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1709, 52, 101, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1710, 52, 100, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1711, 52, 98, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1712, 52, 102, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1713, 52, 103, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1714, 52, 106, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1715, 52, 107, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1716, 52, 105, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1717, 52, 104, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1718, 52, 108, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1719, 52, 109, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1720, 52, 111, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1721, 52, 110, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1722, 52, 112, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1723, 52, 113, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1724, 52, 114, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1725, 52, 115, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1726, 52, 116, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1727, 52, 117, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1728, 52, 118, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblevidence` VALUES (1729, 52, 119, 1, NULL, NULL, NULL, '2026-06-06 14:23:25', 1);

-- ----------------------------
-- Table structure for tblgrade_audit
-- ----------------------------
DROP TABLE IF EXISTS `tblgrade_audit`;
CREATE TABLE `tblgrade_audit`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` int UNSIGNED NOT NULL,
  `unit_id` int UNSIGNED NOT NULL,
  `old_result` enum('NS','OU','U','NP','P','M','D') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'NULL = first time this grade was set',
  `new_result` enum('NS','OU','U','NP','P','M','D') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `old_raw_mark` smallint UNSIGNED NULL DEFAULT NULL,
  `new_raw_mark` smallint UNSIGNED NULL DEFAULT NULL,
  `changed_by` int UNSIGNED NOT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `student_id`(`student_id` ASC) USING BTREE,
  INDEX `unit_id`(`unit_id` ASC) USING BTREE,
  INDEX `changed_by`(`changed_by` ASC) USING BTREE,
  CONSTRAINT `tblgrade_audit_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `tblstudent` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tblgrade_audit_ibfk_2` FOREIGN KEY (`unit_id`) REFERENCES `tblunit` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tblgrade_audit_ibfk_3` FOREIGN KEY (`changed_by`) REFERENCES `tbluser` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 238 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Append-only log of every grade change' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblgrade_audit
-- ----------------------------
INSERT INTO `tblgrade_audit` VALUES (1, 5, 1, NULL, 'U', NULL, NULL, 1, '2026-05-21 18:54:15');
INSERT INTO `tblgrade_audit` VALUES (2, 5, 2, NULL, 'U', NULL, NULL, 1, '2026-05-21 18:54:19');
INSERT INTO `tblgrade_audit` VALUES (3, 5, 3, NULL, 'OU', NULL, NULL, 1, '2026-05-21 18:54:23');
INSERT INTO `tblgrade_audit` VALUES (4, 5, 5, NULL, 'OU', NULL, NULL, 1, '2026-05-21 18:54:32');
INSERT INTO `tblgrade_audit` VALUES (5, 5, 6, NULL, 'OU', NULL, NULL, 1, '2026-05-21 18:54:35');
INSERT INTO `tblgrade_audit` VALUES (6, 1, 2, NULL, 'U', NULL, NULL, 1, '2026-05-21 18:55:03');
INSERT INTO `tblgrade_audit` VALUES (7, 1, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 18:55:06');
INSERT INTO `tblgrade_audit` VALUES (8, 1, 5, NULL, 'OU', NULL, NULL, 1, '2026-05-21 18:55:14');
INSERT INTO `tblgrade_audit` VALUES (9, 1, 6, NULL, 'OU', NULL, NULL, 1, '2026-05-21 18:55:16');
INSERT INTO `tblgrade_audit` VALUES (10, 2, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 18:55:21');
INSERT INTO `tblgrade_audit` VALUES (11, 2, 3, NULL, 'D', NULL, NULL, 1, '2026-05-21 18:55:29');
INSERT INTO `tblgrade_audit` VALUES (12, 2, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 18:55:34');
INSERT INTO `tblgrade_audit` VALUES (13, 2, 6, NULL, 'M', NULL, NULL, 1, '2026-05-21 18:55:40');
INSERT INTO `tblgrade_audit` VALUES (14, 3, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 18:56:16');
INSERT INTO `tblgrade_audit` VALUES (15, 3, 3, NULL, 'D', NULL, NULL, 1, '2026-05-21 18:56:42');
INSERT INTO `tblgrade_audit` VALUES (16, 3, 6, NULL, 'D', NULL, NULL, 1, '2026-05-21 18:56:30');
INSERT INTO `tblgrade_audit` VALUES (17, 4, 2, NULL, 'M', NULL, NULL, 1, '2026-05-21 18:57:13');
INSERT INTO `tblgrade_audit` VALUES (18, 4, 3, NULL, 'D', NULL, NULL, 1, '2026-05-21 18:57:19');
INSERT INTO `tblgrade_audit` VALUES (19, 4, 4, NULL, 'M', NULL, NULL, 1, '2026-05-21 18:57:24');
INSERT INTO `tblgrade_audit` VALUES (20, 4, 5, NULL, 'M', NULL, NULL, 1, '2026-05-21 18:57:28');
INSERT INTO `tblgrade_audit` VALUES (21, 4, 6, NULL, 'D', NULL, NULL, 1, '2026-05-21 18:57:36');
INSERT INTO `tblgrade_audit` VALUES (22, 6, 2, NULL, 'NP', NULL, NULL, 1, '2026-05-21 18:58:03');
INSERT INTO `tblgrade_audit` VALUES (23, 6, 3, NULL, 'OU', NULL, NULL, 1, '2026-05-21 18:58:09');
INSERT INTO `tblgrade_audit` VALUES (24, 6, 5, NULL, 'OU', NULL, NULL, 1, '2026-05-21 18:58:19');
INSERT INTO `tblgrade_audit` VALUES (25, 7, 2, NULL, 'M', NULL, NULL, 1, '2026-05-21 18:58:38');
INSERT INTO `tblgrade_audit` VALUES (26, 8, 2, NULL, 'M', NULL, NULL, 1, '2026-05-21 18:58:50');
INSERT INTO `tblgrade_audit` VALUES (27, 8, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 18:59:02');
INSERT INTO `tblgrade_audit` VALUES (28, 8, 5, NULL, 'D', NULL, NULL, 1, '2026-05-21 18:59:11');
INSERT INTO `tblgrade_audit` VALUES (29, 8, 6, NULL, 'P', NULL, NULL, 1, '2026-05-21 18:59:16');
INSERT INTO `tblgrade_audit` VALUES (30, 9, 2, NULL, 'M', NULL, NULL, 1, '2026-05-21 18:59:39');
INSERT INTO `tblgrade_audit` VALUES (31, 9, 4, NULL, 'M', NULL, NULL, 1, '2026-05-21 18:59:46');
INSERT INTO `tblgrade_audit` VALUES (32, 9, 6, NULL, 'D', NULL, NULL, 1, '2026-05-21 18:59:56');
INSERT INTO `tblgrade_audit` VALUES (33, 10, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 19:00:09');
INSERT INTO `tblgrade_audit` VALUES (34, 10, 5, NULL, 'OU', NULL, NULL, 1, '2026-05-21 19:00:16');
INSERT INTO `tblgrade_audit` VALUES (35, 10, 6, NULL, 'OU', NULL, NULL, 1, '2026-05-21 19:00:19');
INSERT INTO `tblgrade_audit` VALUES (36, 11, 2, NULL, 'M', NULL, NULL, 1, '2026-05-21 19:00:36');
INSERT INTO `tblgrade_audit` VALUES (37, 11, 4, NULL, 'D', NULL, NULL, 1, '2026-05-21 19:00:40');
INSERT INTO `tblgrade_audit` VALUES (38, 11, 5, NULL, 'D', NULL, NULL, 1, '2026-05-21 19:00:42');
INSERT INTO `tblgrade_audit` VALUES (39, 11, 6, NULL, 'D', NULL, NULL, 1, '2026-05-21 19:00:44');
INSERT INTO `tblgrade_audit` VALUES (40, 12, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 19:01:14');
INSERT INTO `tblgrade_audit` VALUES (41, 12, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 19:01:17');
INSERT INTO `tblgrade_audit` VALUES (42, 12, 5, NULL, 'D', NULL, NULL, 1, '2026-05-21 19:01:20');
INSERT INTO `tblgrade_audit` VALUES (43, 12, 6, NULL, 'P', NULL, NULL, 1, '2026-05-21 19:01:22');
INSERT INTO `tblgrade_audit` VALUES (44, 13, 2, NULL, 'NP', NULL, NULL, 1, '2026-05-21 19:01:35');
INSERT INTO `tblgrade_audit` VALUES (45, 13, 5, NULL, 'OU', NULL, NULL, 1, '2026-05-21 19:01:38');
INSERT INTO `tblgrade_audit` VALUES (46, 13, 6, NULL, 'OU', NULL, NULL, 1, '2026-05-21 19:01:41');
INSERT INTO `tblgrade_audit` VALUES (47, 14, 2, NULL, 'U', NULL, NULL, 1, '2026-05-21 19:49:21');
INSERT INTO `tblgrade_audit` VALUES (48, 14, 6, NULL, 'P', NULL, NULL, 1, '2026-05-21 19:49:28');
INSERT INTO `tblgrade_audit` VALUES (49, 15, 2, NULL, 'M', NULL, NULL, 1, '2026-05-21 19:49:38');
INSERT INTO `tblgrade_audit` VALUES (50, 15, 5, NULL, 'D', NULL, NULL, 1, '2026-05-21 19:49:42');
INSERT INTO `tblgrade_audit` VALUES (51, 15, 6, NULL, 'D', NULL, NULL, 1, '2026-05-21 19:49:44');
INSERT INTO `tblgrade_audit` VALUES (52, 16, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 19:50:01');
INSERT INTO `tblgrade_audit` VALUES (53, 16, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 19:50:04');
INSERT INTO `tblgrade_audit` VALUES (54, 16, 6, NULL, 'P', NULL, NULL, 1, '2026-05-21 19:50:07');
INSERT INTO `tblgrade_audit` VALUES (55, 17, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 19:50:16');
INSERT INTO `tblgrade_audit` VALUES (56, 18, 2, NULL, 'NP', NULL, NULL, 1, '2026-05-21 19:50:29');
INSERT INTO `tblgrade_audit` VALUES (57, 50, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:30:37');
INSERT INTO `tblgrade_audit` VALUES (58, 50, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:30:50');
INSERT INTO `tblgrade_audit` VALUES (59, 50, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:12:27');
INSERT INTO `tblgrade_audit` VALUES (60, 51, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:12:52');
INSERT INTO `tblgrade_audit` VALUES (61, 52, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:07:27');
INSERT INTO `tblgrade_audit` VALUES (62, 54, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:13:06');
INSERT INTO `tblgrade_audit` VALUES (63, 55, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:13:11');
INSERT INTO `tblgrade_audit` VALUES (64, 56, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:13:16');
INSERT INTO `tblgrade_audit` VALUES (65, 57, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:08:03');
INSERT INTO `tblgrade_audit` VALUES (66, 58, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:08:08');
INSERT INTO `tblgrade_audit` VALUES (67, 59, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:13:37');
INSERT INTO `tblgrade_audit` VALUES (68, 60, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:13:50');
INSERT INTO `tblgrade_audit` VALUES (69, 61, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:13:58');
INSERT INTO `tblgrade_audit` VALUES (70, 62, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:14:04');
INSERT INTO `tblgrade_audit` VALUES (71, 63, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:14:13');
INSERT INTO `tblgrade_audit` VALUES (72, 64, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:14:21');
INSERT INTO `tblgrade_audit` VALUES (73, 65, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:14:31');
INSERT INTO `tblgrade_audit` VALUES (74, 66, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:14:36');
INSERT INTO `tblgrade_audit` VALUES (75, 53, 3, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:12:58');
INSERT INTO `tblgrade_audit` VALUES (76, 50, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:32:07');
INSERT INTO `tblgrade_audit` VALUES (77, 50, 5, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:32:15');
INSERT INTO `tblgrade_audit` VALUES (78, 51, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:33:03');
INSERT INTO `tblgrade_audit` VALUES (79, 51, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:33:06');
INSERT INTO `tblgrade_audit` VALUES (80, 51, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:33:10');
INSERT INTO `tblgrade_audit` VALUES (81, 51, 5, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:33:14');
INSERT INTO `tblgrade_audit` VALUES (82, 52, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:33:21');
INSERT INTO `tblgrade_audit` VALUES (83, 52, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:33:24');
INSERT INTO `tblgrade_audit` VALUES (84, 53, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:33:30');
INSERT INTO `tblgrade_audit` VALUES (85, 53, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:33:34');
INSERT INTO `tblgrade_audit` VALUES (86, 54, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:33:41');
INSERT INTO `tblgrade_audit` VALUES (87, 54, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:33:44');
INSERT INTO `tblgrade_audit` VALUES (88, 54, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:33:49');
INSERT INTO `tblgrade_audit` VALUES (89, 54, 5, NULL, 'P', NULL, NULL, 1, '2026-06-06 14:23:32');
INSERT INTO `tblgrade_audit` VALUES (90, 55, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:35:07');
INSERT INTO `tblgrade_audit` VALUES (91, 55, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:35:10');
INSERT INTO `tblgrade_audit` VALUES (92, 55, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:35:13');
INSERT INTO `tblgrade_audit` VALUES (93, 55, 5, NULL, 'NS', NULL, NULL, 1, '2026-05-21 20:35:17');
INSERT INTO `tblgrade_audit` VALUES (94, 56, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:35:25');
INSERT INTO `tblgrade_audit` VALUES (95, 56, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:35:40');
INSERT INTO `tblgrade_audit` VALUES (96, 56, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:35:46');
INSERT INTO `tblgrade_audit` VALUES (97, 56, 5, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:35:49');
INSERT INTO `tblgrade_audit` VALUES (98, 57, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:35:54');
INSERT INTO `tblgrade_audit` VALUES (99, 57, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:35:57');
INSERT INTO `tblgrade_audit` VALUES (100, 57, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:36:01');
INSERT INTO `tblgrade_audit` VALUES (101, 57, 5, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:36:06');
INSERT INTO `tblgrade_audit` VALUES (102, 58, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:36:11');
INSERT INTO `tblgrade_audit` VALUES (103, 58, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:36:17');
INSERT INTO `tblgrade_audit` VALUES (104, 58, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:36:22');
INSERT INTO `tblgrade_audit` VALUES (105, 58, 5, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:36:25');
INSERT INTO `tblgrade_audit` VALUES (106, 59, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:36:30');
INSERT INTO `tblgrade_audit` VALUES (107, 59, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:36:32');
INSERT INTO `tblgrade_audit` VALUES (108, 59, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:36:35');
INSERT INTO `tblgrade_audit` VALUES (109, 59, 5, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:36:39');
INSERT INTO `tblgrade_audit` VALUES (110, 60, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:36:42');
INSERT INTO `tblgrade_audit` VALUES (111, 60, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:36:45');
INSERT INTO `tblgrade_audit` VALUES (112, 60, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:36:49');
INSERT INTO `tblgrade_audit` VALUES (113, 60, 5, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:36:54');
INSERT INTO `tblgrade_audit` VALUES (114, 61, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:37:11');
INSERT INTO `tblgrade_audit` VALUES (115, 61, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:37:14');
INSERT INTO `tblgrade_audit` VALUES (116, 61, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:37:17');
INSERT INTO `tblgrade_audit` VALUES (117, 61, 5, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:37:20');
INSERT INTO `tblgrade_audit` VALUES (118, 62, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:37:24');
INSERT INTO `tblgrade_audit` VALUES (119, 62, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:37:27');
INSERT INTO `tblgrade_audit` VALUES (120, 62, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:37:31');
INSERT INTO `tblgrade_audit` VALUES (121, 62, 5, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:37:33');
INSERT INTO `tblgrade_audit` VALUES (122, 63, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:41:30');
INSERT INTO `tblgrade_audit` VALUES (123, 63, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:41:33');
INSERT INTO `tblgrade_audit` VALUES (124, 63, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:41:40');
INSERT INTO `tblgrade_audit` VALUES (125, 64, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:41:43');
INSERT INTO `tblgrade_audit` VALUES (126, 64, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:41:47');
INSERT INTO `tblgrade_audit` VALUES (127, 64, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:41:50');
INSERT INTO `tblgrade_audit` VALUES (128, 64, 5, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:41:54');
INSERT INTO `tblgrade_audit` VALUES (129, 65, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:41:57');
INSERT INTO `tblgrade_audit` VALUES (130, 65, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:42:00');
INSERT INTO `tblgrade_audit` VALUES (131, 65, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:42:04');
INSERT INTO `tblgrade_audit` VALUES (132, 65, 5, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:42:07');
INSERT INTO `tblgrade_audit` VALUES (133, 66, 1, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:42:11');
INSERT INTO `tblgrade_audit` VALUES (134, 66, 2, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:42:14');
INSERT INTO `tblgrade_audit` VALUES (135, 66, 4, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:42:18');
INSERT INTO `tblgrade_audit` VALUES (136, 66, 5, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:42:21');
INSERT INTO `tblgrade_audit` VALUES (137, 1, 8, NULL, 'U', NULL, NULL, 1, '2026-05-21 20:53:15');
INSERT INTO `tblgrade_audit` VALUES (138, 1, 9, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:53:21');
INSERT INTO `tblgrade_audit` VALUES (139, 1, 11, NULL, 'OU', NULL, NULL, 1, '2026-05-21 20:53:27');
INSERT INTO `tblgrade_audit` VALUES (140, 2, 8, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:53:36');
INSERT INTO `tblgrade_audit` VALUES (141, 2, 9, NULL, 'D', NULL, NULL, 1, '2026-05-21 20:53:42');
INSERT INTO `tblgrade_audit` VALUES (142, 2, 10, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:53:45');
INSERT INTO `tblgrade_audit` VALUES (143, 3, 8, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:53:57');
INSERT INTO `tblgrade_audit` VALUES (144, 3, 9, NULL, 'D', NULL, NULL, 1, '2026-05-21 20:54:00');
INSERT INTO `tblgrade_audit` VALUES (145, 4, 8, NULL, 'M', NULL, NULL, 1, '2026-05-21 20:54:10');
INSERT INTO `tblgrade_audit` VALUES (146, 4, 9, NULL, 'D', NULL, NULL, 1, '2026-05-21 20:54:13');
INSERT INTO `tblgrade_audit` VALUES (147, 4, 10, NULL, 'M', NULL, NULL, 1, '2026-05-21 20:54:21');
INSERT INTO `tblgrade_audit` VALUES (148, 4, 11, NULL, 'M', NULL, NULL, 1, '2026-05-21 20:54:24');
INSERT INTO `tblgrade_audit` VALUES (149, 5, 7, NULL, 'U', NULL, NULL, 1, '2026-05-21 20:54:32');
INSERT INTO `tblgrade_audit` VALUES (150, 5, 8, NULL, 'U', NULL, NULL, 1, '2026-05-21 20:54:38');
INSERT INTO `tblgrade_audit` VALUES (151, 5, 9, NULL, 'OU', NULL, NULL, 1, '2026-05-21 20:54:43');
INSERT INTO `tblgrade_audit` VALUES (152, 5, 11, NULL, 'OU', NULL, NULL, 1, '2026-05-21 20:54:49');
INSERT INTO `tblgrade_audit` VALUES (153, 6, 7, NULL, 'NS', NULL, NULL, 1, '2026-05-21 20:55:05');
INSERT INTO `tblgrade_audit` VALUES (154, 6, 8, NULL, 'NP', NULL, NULL, 1, '2026-05-21 20:55:09');
INSERT INTO `tblgrade_audit` VALUES (155, 6, 9, NULL, 'OU', NULL, NULL, 1, '2026-05-21 20:55:13');
INSERT INTO `tblgrade_audit` VALUES (156, 6, 11, NULL, 'OU', NULL, NULL, 1, '2026-05-21 20:55:18');
INSERT INTO `tblgrade_audit` VALUES (157, 7, 8, NULL, 'M', NULL, NULL, 1, '2026-05-21 20:55:37');
INSERT INTO `tblgrade_audit` VALUES (158, 8, 8, NULL, 'M', NULL, NULL, 1, '2026-05-21 20:55:46');
INSERT INTO `tblgrade_audit` VALUES (159, 8, 10, NULL, 'M', NULL, NULL, 1, '2026-05-21 20:55:50');
INSERT INTO `tblgrade_audit` VALUES (160, 8, 11, NULL, 'D', NULL, NULL, 1, '2026-05-21 20:55:54');
INSERT INTO `tblgrade_audit` VALUES (161, 9, 8, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:56:02');
INSERT INTO `tblgrade_audit` VALUES (162, 9, 10, NULL, 'M', NULL, NULL, 1, '2026-05-21 20:56:05');
INSERT INTO `tblgrade_audit` VALUES (163, 10, 8, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:56:14');
INSERT INTO `tblgrade_audit` VALUES (164, 10, 11, NULL, 'OU', NULL, NULL, 1, '2026-05-21 20:56:17');
INSERT INTO `tblgrade_audit` VALUES (165, 11, 8, NULL, 'M', NULL, NULL, 1, '2026-05-21 20:56:24');
INSERT INTO `tblgrade_audit` VALUES (166, 11, 10, NULL, 'D', NULL, NULL, 1, '2026-05-21 20:56:29');
INSERT INTO `tblgrade_audit` VALUES (167, 11, 11, NULL, 'D', NULL, NULL, 1, '2026-05-21 20:56:31');
INSERT INTO `tblgrade_audit` VALUES (168, 12, 8, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:56:39');
INSERT INTO `tblgrade_audit` VALUES (169, 12, 10, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:56:49');
INSERT INTO `tblgrade_audit` VALUES (170, 12, 11, NULL, 'D', NULL, NULL, 1, '2026-05-21 20:56:54');
INSERT INTO `tblgrade_audit` VALUES (171, 13, 8, NULL, 'NP', NULL, NULL, 1, '2026-05-21 20:57:04');
INSERT INTO `tblgrade_audit` VALUES (172, 13, 11, NULL, 'OU', NULL, NULL, 1, '2026-05-21 20:57:14');
INSERT INTO `tblgrade_audit` VALUES (173, 14, 8, NULL, 'U', NULL, NULL, 1, '2026-05-21 20:57:26');
INSERT INTO `tblgrade_audit` VALUES (174, 15, 8, NULL, 'M', NULL, NULL, 1, '2026-05-21 20:57:48');
INSERT INTO `tblgrade_audit` VALUES (175, 15, 11, NULL, 'D', NULL, NULL, 1, '2026-05-21 20:57:50');
INSERT INTO `tblgrade_audit` VALUES (176, 16, 8, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:58:05');
INSERT INTO `tblgrade_audit` VALUES (177, 16, 10, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:58:08');
INSERT INTO `tblgrade_audit` VALUES (178, 17, 8, NULL, 'P', NULL, NULL, 1, '2026-05-21 20:58:14');
INSERT INTO `tblgrade_audit` VALUES (179, 18, 8, NULL, 'NP', NULL, NULL, 1, '2026-05-21 20:58:22');
INSERT INTO `tblgrade_audit` VALUES (180, 52, 4, NULL, 'P', NULL, NULL, 1, '2026-06-06 14:23:22');
INSERT INTO `tblgrade_audit` VALUES (181, 52, 5, NULL, 'P', NULL, NULL, 1, '2026-06-06 14:23:25');
INSERT INTO `tblgrade_audit` VALUES (182, 18, 7, NULL, 'M', NULL, 24, 1, '2026-06-07 11:15:47');
INSERT INTO `tblgrade_audit` VALUES (183, 18, 9, NULL, 'P', NULL, NULL, 1, '2026-06-07 11:15:59');
INSERT INTO `tblgrade_audit` VALUES (184, 18, 10, NULL, 'P', NULL, NULL, 1, '2026-06-07 11:16:03');
INSERT INTO `tblgrade_audit` VALUES (185, 18, 11, NULL, 'U', NULL, NULL, 1, '2026-06-07 11:16:09');
INSERT INTO `tblgrade_audit` VALUES (186, 18, 6, NULL, 'M', NULL, NULL, 1, '2026-06-07 11:16:14');
INSERT INTO `tblgrade_audit` VALUES (187, 18, 12, NULL, 'M', NULL, NULL, 1, '2026-06-07 11:16:17');
INSERT INTO `tblgrade_audit` VALUES (188, 18, 13, NULL, 'P', NULL, NULL, 1, '2026-06-07 11:16:27');
INSERT INTO `tblgrade_audit` VALUES (189, 18, 14, NULL, 'P', NULL, 11, 1, '2026-06-07 11:16:43');
INSERT INTO `tblgrade_audit` VALUES (190, 18, 15, NULL, 'M', NULL, NULL, 1, '2026-06-07 11:16:57');
INSERT INTO `tblgrade_audit` VALUES (191, 18, 18, NULL, 'P', NULL, 16, 1, '2026-06-07 11:17:03');
INSERT INTO `tblgrade_audit` VALUES (192, 18, 16, NULL, 'P', NULL, NULL, 1, '2026-06-07 11:17:10');
INSERT INTO `tblgrade_audit` VALUES (193, 18, 17, NULL, 'U', NULL, NULL, 1, '2026-06-07 11:17:14');
INSERT INTO `tblgrade_audit` VALUES (194, 4, 7, NULL, 'M', NULL, 27, 1, '2026-06-07 11:17:57');
INSERT INTO `tblgrade_audit` VALUES (195, 4, 12, NULL, 'NP', NULL, NULL, 1, '2026-06-07 11:21:13');
INSERT INTO `tblgrade_audit` VALUES (196, 4, 13, NULL, 'D', NULL, NULL, 1, '2026-06-07 11:20:41');
INSERT INTO `tblgrade_audit` VALUES (197, 4, 14, NULL, 'NP', NULL, 6, 1, '2026-06-07 11:18:37');
INSERT INTO `tblgrade_audit` VALUES (198, 4, 15, NULL, 'P', NULL, NULL, 1, '2026-06-07 11:18:43');
INSERT INTO `tblgrade_audit` VALUES (199, 4, 18, NULL, 'P', NULL, 12, 1, '2026-06-07 11:18:53');
INSERT INTO `tblgrade_audit` VALUES (200, 4, 16, NULL, 'M', NULL, NULL, 1, '2026-06-07 11:19:06');
INSERT INTO `tblgrade_audit` VALUES (201, 4, 17, NULL, 'D', NULL, NULL, 1, '2026-06-07 11:19:09');
INSERT INTO `tblgrade_audit` VALUES (202, 16, 8, 'P', 'M', NULL, NULL, 1, '2026-06-23 11:05:30');
INSERT INTO `tblgrade_audit` VALUES (203, 16, 8, 'M', 'P', NULL, NULL, 1, '2026-06-23 11:08:32');
INSERT INTO `tblgrade_audit` VALUES (204, 16, 14, NULL, 'P', NULL, 11, 1, '2026-06-23 11:38:06');
INSERT INTO `tblgrade_audit` VALUES (205, 16, 7, NULL, 'P', NULL, 16, 1, '2026-06-23 11:45:40');
INSERT INTO `tblgrade_audit` VALUES (206, 16, 8, 'P', 'NP', NULL, 8, 1, '2026-06-23 11:46:11');
INSERT INTO `tblgrade_audit` VALUES (207, 10, 7, NULL, 'NP', NULL, 9, 1, '2026-06-23 11:57:46');
INSERT INTO `tblgrade_audit` VALUES (208, 10, 9, NULL, 'P', NULL, NULL, 1, '2026-06-23 11:58:01');
INSERT INTO `tblgrade_audit` VALUES (209, 10, 10, NULL, 'M', NULL, NULL, 1, '2026-06-23 11:58:14');
INSERT INTO `tblgrade_audit` VALUES (210, 10, 12, NULL, 'P', NULL, NULL, 1, '2026-06-23 12:03:21');
INSERT INTO `tblgrade_audit` VALUES (211, 10, 13, NULL, 'M', NULL, NULL, 1, '2026-06-23 12:03:31');
INSERT INTO `tblgrade_audit` VALUES (212, 10, 14, NULL, 'P', NULL, 14, 1, '2026-06-23 12:03:43');
INSERT INTO `tblgrade_audit` VALUES (213, 5, 14, NULL, 'P', NULL, 11, 1, '2026-06-23 12:03:52');
INSERT INTO `tblgrade_audit` VALUES (214, 10, 15, NULL, 'P', NULL, NULL, 1, '2026-06-23 12:04:01');
INSERT INTO `tblgrade_audit` VALUES (215, 10, 18, NULL, 'P', NULL, 14, 1, '2026-06-23 12:04:14');
INSERT INTO `tblgrade_audit` VALUES (216, 10, 16, NULL, 'P', NULL, NULL, 1, '2026-06-23 12:04:22');
INSERT INTO `tblgrade_audit` VALUES (217, 10, 17, NULL, 'P', NULL, NULL, 1, '2026-06-23 12:13:05');
INSERT INTO `tblgrade_audit` VALUES (218, 10, 11, 'OU', 'P', NULL, NULL, 1, '2026-06-23 12:13:52');
INSERT INTO `tblgrade_audit` VALUES (219, 10, 6, 'OU', 'P', NULL, NULL, 1, '2026-06-23 12:13:59');
INSERT INTO `tblgrade_audit` VALUES (220, 16, 9, NULL, 'P', NULL, NULL, 1, '2026-06-23 12:14:17');
INSERT INTO `tblgrade_audit` VALUES (221, 16, 11, NULL, 'P', NULL, NULL, 1, '2026-06-23 12:14:24');
INSERT INTO `tblgrade_audit` VALUES (222, 16, 12, NULL, 'P', NULL, NULL, 1, '2026-06-23 12:14:30');
INSERT INTO `tblgrade_audit` VALUES (223, 16, 13, NULL, 'P', NULL, NULL, 1, '2026-06-23 12:14:35');
INSERT INTO `tblgrade_audit` VALUES (224, 16, 15, NULL, 'P', NULL, NULL, 1, '2026-06-23 12:14:41');
INSERT INTO `tblgrade_audit` VALUES (225, 16, 18, NULL, 'NP', NULL, 9, 1, '2026-06-23 12:14:52');
INSERT INTO `tblgrade_audit` VALUES (226, 16, 16, NULL, 'P', NULL, NULL, 1, '2026-06-23 12:15:00');
INSERT INTO `tblgrade_audit` VALUES (227, 16, 17, NULL, 'P', NULL, NULL, 1, '2026-06-23 12:15:05');
INSERT INTO `tblgrade_audit` VALUES (228, 5, 10, NULL, 'M', NULL, NULL, 1, '2026-06-23 12:20:59');
INSERT INTO `tblgrade_audit` VALUES (229, 5, 12, NULL, 'M', NULL, NULL, 1, '2026-06-23 12:21:06');
INSERT INTO `tblgrade_audit` VALUES (230, 5, 13, NULL, 'M', NULL, NULL, 1, '2026-06-23 12:21:11');
INSERT INTO `tblgrade_audit` VALUES (231, 5, 15, NULL, 'D', NULL, NULL, 1, '2026-06-23 12:21:26');
INSERT INTO `tblgrade_audit` VALUES (232, 5, 18, NULL, 'D', NULL, 32, 1, '2026-06-23 12:21:34');
INSERT INTO `tblgrade_audit` VALUES (233, 5, 16, NULL, 'D', NULL, NULL, 1, '2026-06-23 12:21:40');
INSERT INTO `tblgrade_audit` VALUES (234, 5, 17, NULL, 'D', NULL, NULL, 1, '2026-06-23 12:21:46');
INSERT INTO `tblgrade_audit` VALUES (235, 5, 6, 'OU', 'U', NULL, NULL, 1, '2026-06-23 12:22:34');
INSERT INTO `tblgrade_audit` VALUES (236, 5, 11, 'OU', 'U', NULL, NULL, 1, '2026-06-23 12:22:39');
INSERT INTO `tblgrade_audit` VALUES (237, 5, 9, 'OU', 'U', NULL, NULL, 1, '2026-06-23 12:22:44');

-- ----------------------------
-- Table structure for tblgroup
-- ----------------------------
DROP TABLE IF EXISTS `tblgroup`;
CREATE TABLE `tblgroup`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `course_id` int UNSIGNED NOT NULL,
  `groupname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `course_id`(`course_id` ASC) USING BTREE,
  CONSTRAINT `tblgroup_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `tblcourse` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblgroup
-- ----------------------------
INSERT INTO `tblgroup` VALUES (1, 1, 'Group A');
INSERT INTO `tblgroup` VALUES (2, 1, 'Group B');
INSERT INTO `tblgroup` VALUES (3, 1, 'Group C');
INSERT INTO `tblgroup` VALUES (4, 2, 'Group A');
INSERT INTO `tblgroup` VALUES (5, 2, 'Group B');
INSERT INTO `tblgroup` VALUES (6, 2, 'Group C');
INSERT INTO `tblgroup` VALUES (7, 4, 'Group A');
INSERT INTO `tblgroup` VALUES (8, 4, 'Group B');
INSERT INTO `tblgroup` VALUES (9, 4, 'Group C');
INSERT INTO `tblgroup` VALUES (10, 5, 'Group A');
INSERT INTO `tblgroup` VALUES (11, 5, 'Group B');
INSERT INTO `tblgroup` VALUES (12, 5, 'Group C');

-- ----------------------------
-- Table structure for tblqualificationtype
-- ----------------------------
DROP TABLE IF EXISTS `tblqualificationtype`;
CREATE TABLE `tblqualificationtype`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `display_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `default_total_credits` smallint UNSIGNED NOT NULL DEFAULT 0,
  `default_pass_points` smallint UNSIGNED NOT NULL DEFAULT 0,
  `default_merit_points` smallint UNSIGNED NOT NULL DEFAULT 0,
  `default_distinction_points` smallint UNSIGNED NOT NULL DEFAULT 0,
  `max_years` tinyint UNSIGNED NOT NULL DEFAULT 2,
  `is_btec` tinyint(1) NOT NULL DEFAULT 0,
  `is_ncfe` tinyint(1) NOT NULL DEFAULT 0,
  `btec_overall_grades` tinyint(1) NOT NULL DEFAULT 0,
  `show_predict` tinyint(1) NOT NULL DEFAULT 0,
  `sort_order` smallint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tblqualificationtype
-- ----------------------------
INSERT INTO `tblqualificationtype` VALUES (1, 'btec_ext_dip', 'BTec Extended Diploma', 120, 108, 156, 216, 2, 1, 0, 1, 1, 10);
INSERT INTO `tblqualificationtype` VALUES (2, 'btec_ext_cert', 'BTec Extended Certificate', 60, 52, 74, 90, 1, 1, 0, 0, 1, 20);
INSERT INTO `tblqualificationtype` VALUES (3, 'ncfe', 'NCFE', 0, 0, 0, 0, 1, 0, 1, 0, 0, 30);
INSERT INTO `tblqualificationtype` VALUES (4, 't_level', 'T Level', 0, 0, 0, 0, 2, 0, 0, 0, 1, 40);
INSERT INTO `tblqualificationtype` VALUES (5, 'other', 'Other', 0, 0, 0, 0, 2, 0, 0, 0, 0, 50);

-- ----------------------------
-- Table structure for tblresults
-- ----------------------------
DROP TABLE IF EXISTS `tblresults`;
CREATE TABLE `tblresults`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` int UNSIGNED NOT NULL,
  `unit_id` int UNSIGNED NOT NULL,
  `result` enum('NS','OU','U','NP','P','M','D') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NS' COMMENT 'NS=Not Submitted, OU=Ungraded Outstanding, U=Ungraded, NP=Near Pass, P=Pass, M=Merit, D=Distinction',
  `raw_mark` smallint UNSIGNED NULL DEFAULT NULL COMMENT 'Raw exam mark for externally-assessed BTec units',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` int UNSIGNED NULL DEFAULT NULL COMMENT 'FK to tbluser.id -- who last updated this result',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_student_unit`(`student_id` ASC, `unit_id` ASC) USING BTREE,
  INDEX `unit_id`(`unit_id` ASC) USING BTREE,
  INDEX `updated_by`(`updated_by` ASC) USING BTREE,
  CONSTRAINT `tblresults_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `tblstudent` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tblresults_ibfk_2` FOREIGN KEY (`unit_id`) REFERENCES `tblunit` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tblresults_ibfk_3` FOREIGN KEY (`updated_by`) REFERENCES `tbluser` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1986 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblresults
-- ----------------------------
INSERT INTO `tblresults` VALUES (1, 5, 1, 'U', NULL, '2026-05-21 18:54:15', 1);
INSERT INTO `tblresults` VALUES (2, 5, 2, 'U', NULL, '2026-05-21 18:54:19', 1);
INSERT INTO `tblresults` VALUES (3, 5, 3, 'OU', NULL, '2026-05-21 18:54:23', 1);
INSERT INTO `tblresults` VALUES (4, 5, 5, 'OU', NULL, '2026-05-21 18:54:32', 1);
INSERT INTO `tblresults` VALUES (5, 5, 6, 'U', NULL, '2026-06-23 12:22:34', 1);
INSERT INTO `tblresults` VALUES (6, 1, 2, 'U', NULL, '2026-05-21 18:55:03', 1);
INSERT INTO `tblresults` VALUES (7, 1, 3, 'P', NULL, '2026-05-21 18:55:06', 1);
INSERT INTO `tblresults` VALUES (8, 1, 5, 'OU', NULL, '2026-05-21 18:55:14', 1);
INSERT INTO `tblresults` VALUES (9, 1, 6, 'OU', NULL, '2026-05-21 18:55:16', 1);
INSERT INTO `tblresults` VALUES (10, 2, 2, 'P', NULL, '2026-05-21 18:55:21', 1);
INSERT INTO `tblresults` VALUES (11, 2, 3, 'D', NULL, '2026-05-21 18:55:29', 1);
INSERT INTO `tblresults` VALUES (12, 2, 4, 'P', NULL, '2026-05-21 18:55:34', 1);
INSERT INTO `tblresults` VALUES (13, 2, 6, 'M', NULL, '2026-05-21 18:55:40', 1);
INSERT INTO `tblresults` VALUES (14, 3, 2, 'P', NULL, '2026-05-21 18:56:16', 1);
INSERT INTO `tblresults` VALUES (15, 3, 3, 'D', NULL, '2026-05-21 18:56:42', 1);
INSERT INTO `tblresults` VALUES (16, 3, 6, 'D', NULL, '2026-05-21 18:56:30', 1);
INSERT INTO `tblresults` VALUES (18, 4, 2, 'M', NULL, '2026-05-21 18:57:13', 1);
INSERT INTO `tblresults` VALUES (19, 4, 3, 'D', NULL, '2026-05-21 18:57:19', 1);
INSERT INTO `tblresults` VALUES (20, 4, 4, 'M', NULL, '2026-05-21 18:57:24', 1);
INSERT INTO `tblresults` VALUES (21, 4, 5, 'M', NULL, '2026-05-21 18:57:28', 1);
INSERT INTO `tblresults` VALUES (22, 4, 6, 'D', NULL, '2026-05-21 18:57:36', 1);
INSERT INTO `tblresults` VALUES (23, 6, 2, 'NP', NULL, '2026-05-21 18:58:03', 1);
INSERT INTO `tblresults` VALUES (24, 6, 3, 'OU', NULL, '2026-05-21 18:58:09', 1);
INSERT INTO `tblresults` VALUES (25, 6, 5, 'OU', NULL, '2026-05-21 18:58:19', 1);
INSERT INTO `tblresults` VALUES (26, 7, 2, 'M', NULL, '2026-05-21 18:58:38', 1);
INSERT INTO `tblresults` VALUES (27, 8, 2, 'M', NULL, '2026-05-21 18:58:50', 1);
INSERT INTO `tblresults` VALUES (28, 8, 4, 'P', NULL, '2026-05-21 18:59:02', 1);
INSERT INTO `tblresults` VALUES (29, 8, 5, 'D', NULL, '2026-05-21 18:59:11', 1);
INSERT INTO `tblresults` VALUES (30, 8, 6, 'P', NULL, '2026-05-21 18:59:16', 1);
INSERT INTO `tblresults` VALUES (31, 9, 2, 'M', NULL, '2026-05-21 18:59:39', 1);
INSERT INTO `tblresults` VALUES (33, 9, 4, 'M', NULL, '2026-05-21 18:59:46', 1);
INSERT INTO `tblresults` VALUES (34, 9, 6, 'D', NULL, '2026-05-21 18:59:56', 1);
INSERT INTO `tblresults` VALUES (35, 10, 2, 'P', NULL, '2026-05-21 19:00:09', 1);
INSERT INTO `tblresults` VALUES (36, 10, 5, 'OU', NULL, '2026-05-21 19:00:16', 1);
INSERT INTO `tblresults` VALUES (37, 10, 6, 'P', NULL, '2026-06-23 12:13:59', 1);
INSERT INTO `tblresults` VALUES (38, 11, 2, 'M', NULL, '2026-05-21 19:00:36', 1);
INSERT INTO `tblresults` VALUES (39, 11, 4, 'D', NULL, '2026-05-21 19:00:40', 1);
INSERT INTO `tblresults` VALUES (40, 11, 5, 'D', NULL, '2026-05-21 19:00:42', 1);
INSERT INTO `tblresults` VALUES (41, 11, 6, 'D', NULL, '2026-05-21 19:00:44', 1);
INSERT INTO `tblresults` VALUES (42, 12, 2, 'P', NULL, '2026-05-21 19:01:14', 1);
INSERT INTO `tblresults` VALUES (43, 12, 4, 'P', NULL, '2026-05-21 19:01:17', 1);
INSERT INTO `tblresults` VALUES (44, 12, 5, 'D', NULL, '2026-05-21 19:01:20', 1);
INSERT INTO `tblresults` VALUES (45, 12, 6, 'P', NULL, '2026-05-21 19:01:22', 1);
INSERT INTO `tblresults` VALUES (46, 13, 2, 'NP', NULL, '2026-05-21 19:01:35', 1);
INSERT INTO `tblresults` VALUES (47, 13, 5, 'OU', NULL, '2026-05-21 19:01:38', 1);
INSERT INTO `tblresults` VALUES (48, 13, 6, 'OU', NULL, '2026-05-21 19:01:41', 1);
INSERT INTO `tblresults` VALUES (49, 14, 2, 'U', NULL, '2026-05-21 19:49:21', 1);
INSERT INTO `tblresults` VALUES (50, 14, 6, 'P', NULL, '2026-05-21 19:49:28', 1);
INSERT INTO `tblresults` VALUES (51, 15, 2, 'M', NULL, '2026-05-21 19:49:38', 1);
INSERT INTO `tblresults` VALUES (52, 15, 5, 'D', NULL, '2026-05-21 19:49:42', 1);
INSERT INTO `tblresults` VALUES (53, 15, 6, 'D', NULL, '2026-05-21 19:49:44', 1);
INSERT INTO `tblresults` VALUES (54, 16, 2, 'P', NULL, '2026-05-21 19:50:01', 1);
INSERT INTO `tblresults` VALUES (55, 16, 4, 'P', NULL, '2026-05-21 19:50:04', 1);
INSERT INTO `tblresults` VALUES (56, 16, 6, 'P', NULL, '2026-05-21 19:50:07', 1);
INSERT INTO `tblresults` VALUES (57, 17, 2, 'P', NULL, '2026-05-21 19:50:16', 1);
INSERT INTO `tblresults` VALUES (58, 18, 2, 'NP', NULL, '2026-05-21 19:50:29', 1);
INSERT INTO `tblresults` VALUES (59, 50, 1, 'P', NULL, '2026-05-21 20:30:37', 1);
INSERT INTO `tblresults` VALUES (60, 50, 2, 'P', NULL, '2026-05-21 20:30:50', 1);
INSERT INTO `tblresults` VALUES (61, 50, 3, 'P', NULL, '2026-05-21 20:12:27', 1);
INSERT INTO `tblresults` VALUES (77, 51, 3, 'P', NULL, '2026-05-21 20:12:52', 1);
INSERT INTO `tblresults` VALUES (93, 52, 3, 'P', NULL, '2026-05-21 20:07:27', 1);
INSERT INTO `tblresults` VALUES (109, 54, 3, 'P', NULL, '2026-05-21 20:13:06', 1);
INSERT INTO `tblresults` VALUES (125, 55, 3, 'P', NULL, '2026-05-21 20:13:11', 1);
INSERT INTO `tblresults` VALUES (141, 56, 3, 'P', NULL, '2026-05-21 20:13:16', 1);
INSERT INTO `tblresults` VALUES (157, 57, 3, 'P', NULL, '2026-05-21 20:08:03', 1);
INSERT INTO `tblresults` VALUES (173, 58, 3, 'P', NULL, '2026-05-21 20:08:08', 1);
INSERT INTO `tblresults` VALUES (190, 59, 3, 'P', NULL, '2026-05-21 20:13:37', 1);
INSERT INTO `tblresults` VALUES (205, 60, 3, 'P', NULL, '2026-05-21 20:13:50', 1);
INSERT INTO `tblresults` VALUES (221, 61, 3, 'P', NULL, '2026-05-21 20:13:58', 1);
INSERT INTO `tblresults` VALUES (237, 62, 3, 'P', NULL, '2026-05-21 20:14:04', 1);
INSERT INTO `tblresults` VALUES (253, 63, 3, 'P', NULL, '2026-05-21 20:14:13', 1);
INSERT INTO `tblresults` VALUES (269, 64, 3, 'P', NULL, '2026-05-21 20:14:21', 1);
INSERT INTO `tblresults` VALUES (285, 65, 3, 'P', NULL, '2026-05-21 20:14:31', 1);
INSERT INTO `tblresults` VALUES (301, 66, 3, 'P', NULL, '2026-05-21 20:14:36', 1);
INSERT INTO `tblresults` VALUES (349, 53, 3, 'P', NULL, '2026-05-21 20:12:58', 1);
INSERT INTO `tblresults` VALUES (579, 50, 4, 'P', NULL, '2026-05-21 20:32:07', 1);
INSERT INTO `tblresults` VALUES (599, 50, 5, 'P', NULL, '2026-05-21 20:32:15', 1);
INSERT INTO `tblresults` VALUES (622, 51, 1, 'P', NULL, '2026-05-21 20:33:03', 1);
INSERT INTO `tblresults` VALUES (642, 51, 2, 'P', NULL, '2026-05-21 20:33:06', 1);
INSERT INTO `tblresults` VALUES (662, 51, 4, 'P', NULL, '2026-05-21 20:33:10', 1);
INSERT INTO `tblresults` VALUES (682, 51, 5, 'P', NULL, '2026-05-21 20:33:14', 1);
INSERT INTO `tblresults` VALUES (705, 52, 1, 'P', NULL, '2026-05-21 20:33:21', 1);
INSERT INTO `tblresults` VALUES (726, 52, 2, 'P', NULL, '2026-05-21 20:33:24', 1);
INSERT INTO `tblresults` VALUES (745, 53, 1, 'P', NULL, '2026-05-21 20:33:30', 1);
INSERT INTO `tblresults` VALUES (765, 53, 2, 'P', NULL, '2026-05-21 20:33:34', 1);
INSERT INTO `tblresults` VALUES (785, 54, 1, 'P', NULL, '2026-05-21 20:33:41', 1);
INSERT INTO `tblresults` VALUES (806, 54, 2, 'P', NULL, '2026-05-21 20:33:44', 1);
INSERT INTO `tblresults` VALUES (825, 54, 4, 'P', NULL, '2026-05-21 20:33:49', 1);
INSERT INTO `tblresults` VALUES (845, 54, 5, 'P', NULL, '2026-06-06 14:23:32', 1);
INSERT INTO `tblresults` VALUES (873, 55, 1, 'P', NULL, '2026-05-21 20:35:07', 1);
INSERT INTO `tblresults` VALUES (893, 55, 2, 'P', NULL, '2026-05-21 20:35:10', 1);
INSERT INTO `tblresults` VALUES (913, 55, 4, 'P', NULL, '2026-05-21 20:35:13', 1);
INSERT INTO `tblresults` VALUES (933, 55, 5, 'NS', NULL, '2026-05-21 20:35:17', 1);
INSERT INTO `tblresults` VALUES (934, 56, 1, 'P', NULL, '2026-05-21 20:35:25', 1);
INSERT INTO `tblresults` VALUES (954, 56, 2, 'P', NULL, '2026-05-21 20:35:40', 1);
INSERT INTO `tblresults` VALUES (974, 56, 4, 'P', NULL, '2026-05-21 20:35:46', 1);
INSERT INTO `tblresults` VALUES (994, 56, 5, 'P', NULL, '2026-05-21 20:35:49', 1);
INSERT INTO `tblresults` VALUES (1017, 57, 1, 'P', NULL, '2026-05-21 20:35:54', 1);
INSERT INTO `tblresults` VALUES (1037, 57, 2, 'P', NULL, '2026-05-21 20:35:57', 1);
INSERT INTO `tblresults` VALUES (1057, 57, 4, 'P', NULL, '2026-05-21 20:36:01', 1);
INSERT INTO `tblresults` VALUES (1077, 57, 5, 'P', NULL, '2026-05-21 20:36:06', 1);
INSERT INTO `tblresults` VALUES (1100, 58, 1, 'P', NULL, '2026-05-21 20:36:11', 1);
INSERT INTO `tblresults` VALUES (1120, 58, 2, 'P', NULL, '2026-05-21 20:36:17', 1);
INSERT INTO `tblresults` VALUES (1140, 58, 4, 'P', NULL, '2026-05-21 20:36:22', 1);
INSERT INTO `tblresults` VALUES (1160, 58, 5, 'P', NULL, '2026-05-21 20:36:25', 1);
INSERT INTO `tblresults` VALUES (1183, 59, 1, 'P', NULL, '2026-05-21 20:36:30', 1);
INSERT INTO `tblresults` VALUES (1203, 59, 2, 'P', NULL, '2026-05-21 20:36:32', 1);
INSERT INTO `tblresults` VALUES (1223, 59, 4, 'P', NULL, '2026-05-21 20:36:35', 1);
INSERT INTO `tblresults` VALUES (1243, 59, 5, 'P', NULL, '2026-05-21 20:36:39', 1);
INSERT INTO `tblresults` VALUES (1266, 60, 1, 'P', NULL, '2026-05-21 20:36:42', 1);
INSERT INTO `tblresults` VALUES (1287, 60, 2, 'P', NULL, '2026-05-21 20:36:45', 1);
INSERT INTO `tblresults` VALUES (1306, 60, 4, 'P', NULL, '2026-05-21 20:36:49', 1);
INSERT INTO `tblresults` VALUES (1326, 60, 5, 'P', NULL, '2026-05-21 20:36:54', 1);
INSERT INTO `tblresults` VALUES (1349, 61, 1, 'P', NULL, '2026-05-21 20:37:11', 1);
INSERT INTO `tblresults` VALUES (1369, 61, 2, 'P', NULL, '2026-05-21 20:37:14', 1);
INSERT INTO `tblresults` VALUES (1389, 61, 4, 'P', NULL, '2026-05-21 20:37:17', 1);
INSERT INTO `tblresults` VALUES (1409, 61, 5, 'P', NULL, '2026-05-21 20:37:20', 1);
INSERT INTO `tblresults` VALUES (1432, 62, 1, 'P', NULL, '2026-05-21 20:37:24', 1);
INSERT INTO `tblresults` VALUES (1452, 62, 2, 'P', NULL, '2026-05-21 20:37:27', 1);
INSERT INTO `tblresults` VALUES (1472, 62, 4, 'P', NULL, '2026-05-21 20:37:31', 1);
INSERT INTO `tblresults` VALUES (1492, 62, 5, 'P', NULL, '2026-05-21 20:37:33', 1);
INSERT INTO `tblresults` VALUES (1515, 63, 1, 'P', NULL, '2026-05-21 20:41:30', 1);
INSERT INTO `tblresults` VALUES (1535, 63, 2, 'P', NULL, '2026-05-21 20:41:33', 1);
INSERT INTO `tblresults` VALUES (1555, 63, 4, 'P', NULL, '2026-05-21 20:41:40', 1);
INSERT INTO `tblresults` VALUES (1575, 64, 1, 'P', NULL, '2026-05-21 20:41:43', 1);
INSERT INTO `tblresults` VALUES (1595, 64, 2, 'P', NULL, '2026-05-21 20:41:47', 1);
INSERT INTO `tblresults` VALUES (1615, 64, 4, 'P', NULL, '2026-05-21 20:41:50', 1);
INSERT INTO `tblresults` VALUES (1636, 64, 5, 'P', NULL, '2026-05-21 20:41:54', 1);
INSERT INTO `tblresults` VALUES (1658, 65, 1, 'P', NULL, '2026-05-21 20:41:57', 1);
INSERT INTO `tblresults` VALUES (1678, 65, 2, 'P', NULL, '2026-05-21 20:42:00', 1);
INSERT INTO `tblresults` VALUES (1698, 65, 4, 'P', NULL, '2026-05-21 20:42:04', 1);
INSERT INTO `tblresults` VALUES (1718, 65, 5, 'P', NULL, '2026-05-21 20:42:07', 1);
INSERT INTO `tblresults` VALUES (1741, 66, 1, 'P', NULL, '2026-05-21 20:42:11', 1);
INSERT INTO `tblresults` VALUES (1761, 66, 2, 'P', NULL, '2026-05-21 20:42:14', 1);
INSERT INTO `tblresults` VALUES (1781, 66, 4, 'P', NULL, '2026-05-21 20:42:18', 1);
INSERT INTO `tblresults` VALUES (1801, 66, 5, 'P', NULL, '2026-05-21 20:42:21', 1);
INSERT INTO `tblresults` VALUES (1824, 1, 8, 'U', NULL, '2026-05-21 20:53:15', 1);
INSERT INTO `tblresults` VALUES (1825, 1, 9, 'P', NULL, '2026-05-21 20:53:21', 1);
INSERT INTO `tblresults` VALUES (1826, 1, 11, 'OU', NULL, '2026-05-21 20:53:27', 1);
INSERT INTO `tblresults` VALUES (1827, 2, 8, 'P', NULL, '2026-05-21 20:53:36', 1);
INSERT INTO `tblresults` VALUES (1828, 2, 9, 'D', NULL, '2026-05-21 20:53:42', 1);
INSERT INTO `tblresults` VALUES (1829, 2, 10, 'P', NULL, '2026-05-21 20:53:45', 1);
INSERT INTO `tblresults` VALUES (1830, 3, 8, 'P', NULL, '2026-05-21 20:53:57', 1);
INSERT INTO `tblresults` VALUES (1831, 3, 9, 'D', NULL, '2026-05-21 20:54:00', 1);
INSERT INTO `tblresults` VALUES (1832, 4, 8, 'M', NULL, '2026-05-21 20:54:10', 1);
INSERT INTO `tblresults` VALUES (1833, 4, 9, 'D', NULL, '2026-05-21 20:54:13', 1);
INSERT INTO `tblresults` VALUES (1834, 4, 10, 'M', NULL, '2026-05-21 20:54:21', 1);
INSERT INTO `tblresults` VALUES (1835, 4, 11, 'M', NULL, '2026-05-21 20:54:24', 1);
INSERT INTO `tblresults` VALUES (1836, 5, 7, 'U', NULL, '2026-05-21 20:54:32', 1);
INSERT INTO `tblresults` VALUES (1837, 5, 8, 'U', NULL, '2026-05-21 20:54:38', 1);
INSERT INTO `tblresults` VALUES (1838, 5, 9, 'U', NULL, '2026-06-23 12:22:44', 1);
INSERT INTO `tblresults` VALUES (1839, 5, 11, 'U', NULL, '2026-06-23 12:22:39', 1);
INSERT INTO `tblresults` VALUES (1840, 6, 7, 'NS', NULL, '2026-05-21 20:55:05', 1);
INSERT INTO `tblresults` VALUES (1842, 6, 8, 'NP', NULL, '2026-05-21 20:55:09', 1);
INSERT INTO `tblresults` VALUES (1843, 6, 9, 'OU', NULL, '2026-05-21 20:55:13', 1);
INSERT INTO `tblresults` VALUES (1844, 6, 11, 'OU', NULL, '2026-05-21 20:55:18', 1);
INSERT INTO `tblresults` VALUES (1845, 7, 8, 'M', NULL, '2026-05-21 20:55:37', 1);
INSERT INTO `tblresults` VALUES (1846, 8, 8, 'M', NULL, '2026-05-21 20:55:46', 1);
INSERT INTO `tblresults` VALUES (1847, 8, 10, 'M', NULL, '2026-05-21 20:55:50', 1);
INSERT INTO `tblresults` VALUES (1848, 8, 11, 'D', NULL, '2026-05-21 20:55:54', 1);
INSERT INTO `tblresults` VALUES (1849, 9, 8, 'P', NULL, '2026-05-21 20:56:02', 1);
INSERT INTO `tblresults` VALUES (1850, 9, 10, 'M', NULL, '2026-05-21 20:56:05', 1);
INSERT INTO `tblresults` VALUES (1851, 10, 8, 'P', NULL, '2026-05-21 20:56:14', 1);
INSERT INTO `tblresults` VALUES (1852, 10, 11, 'P', NULL, '2026-06-23 12:13:52', 1);
INSERT INTO `tblresults` VALUES (1853, 11, 8, 'M', NULL, '2026-05-21 20:56:24', 1);
INSERT INTO `tblresults` VALUES (1854, 11, 10, 'D', NULL, '2026-05-21 20:56:29', 1);
INSERT INTO `tblresults` VALUES (1855, 11, 11, 'D', NULL, '2026-05-21 20:56:31', 1);
INSERT INTO `tblresults` VALUES (1856, 12, 8, 'P', NULL, '2026-05-21 20:56:39', 1);
INSERT INTO `tblresults` VALUES (1857, 12, 10, 'P', NULL, '2026-05-21 20:56:49', 1);
INSERT INTO `tblresults` VALUES (1858, 12, 11, 'D', NULL, '2026-05-21 20:56:54', 1);
INSERT INTO `tblresults` VALUES (1859, 13, 8, 'NP', NULL, '2026-05-21 20:57:04', 1);
INSERT INTO `tblresults` VALUES (1860, 13, 11, 'OU', NULL, '2026-05-21 20:57:14', 1);
INSERT INTO `tblresults` VALUES (1861, 14, 8, 'U', NULL, '2026-05-21 20:57:26', 1);
INSERT INTO `tblresults` VALUES (1862, 15, 8, 'M', NULL, '2026-05-21 20:57:48', 1);
INSERT INTO `tblresults` VALUES (1863, 15, 11, 'D', NULL, '2026-05-21 20:57:50', 1);
INSERT INTO `tblresults` VALUES (1864, 16, 8, 'NP', 8, '2026-06-23 11:46:11', 1);
INSERT INTO `tblresults` VALUES (1865, 16, 10, 'P', NULL, '2026-05-21 20:58:08', 1);
INSERT INTO `tblresults` VALUES (1866, 17, 8, 'P', NULL, '2026-05-21 20:58:14', 1);
INSERT INTO `tblresults` VALUES (1867, 18, 8, 'NP', NULL, '2026-05-21 20:58:22', 1);
INSERT INTO `tblresults` VALUES (1868, 52, 4, 'P', NULL, '2026-06-06 14:23:22', 1);
INSERT INTO `tblresults` VALUES (1888, 52, 5, 'P', NULL, '2026-06-06 14:23:25', 1);
INSERT INTO `tblresults` VALUES (1918, 18, 7, 'M', 24, '2026-06-07 11:15:47', 1);
INSERT INTO `tblresults` VALUES (1922, 18, 9, 'P', NULL, '2026-06-07 11:15:59', 1);
INSERT INTO `tblresults` VALUES (1923, 18, 10, 'P', NULL, '2026-06-07 11:16:03', 1);
INSERT INTO `tblresults` VALUES (1924, 18, 11, 'U', NULL, '2026-06-07 11:16:09', 1);
INSERT INTO `tblresults` VALUES (1925, 18, 6, 'M', NULL, '2026-06-07 11:16:14', 1);
INSERT INTO `tblresults` VALUES (1926, 18, 12, 'M', NULL, '2026-06-07 11:16:17', 1);
INSERT INTO `tblresults` VALUES (1927, 18, 13, 'P', NULL, '2026-06-07 11:16:27', 1);
INSERT INTO `tblresults` VALUES (1928, 18, 14, 'P', 11, '2026-06-07 11:16:43', 1);
INSERT INTO `tblresults` VALUES (1930, 18, 15, 'M', NULL, '2026-06-07 11:16:57', 1);
INSERT INTO `tblresults` VALUES (1931, 18, 18, 'P', 16, '2026-06-07 11:17:03', 1);
INSERT INTO `tblresults` VALUES (1932, 18, 16, 'P', NULL, '2026-06-07 11:17:10', 1);
INSERT INTO `tblresults` VALUES (1933, 18, 17, 'U', NULL, '2026-06-07 11:17:14', 1);
INSERT INTO `tblresults` VALUES (1934, 4, 7, 'M', 27, '2026-06-07 11:17:57', 1);
INSERT INTO `tblresults` VALUES (1935, 4, 12, 'NP', NULL, '2026-06-07 11:21:13', 1);
INSERT INTO `tblresults` VALUES (1936, 4, 13, 'D', NULL, '2026-06-07 11:20:41', 1);
INSERT INTO `tblresults` VALUES (1937, 4, 14, 'NP', 6, '2026-06-07 11:18:37', 1);
INSERT INTO `tblresults` VALUES (1940, 4, 15, 'P', NULL, '2026-06-07 11:18:43', 1);
INSERT INTO `tblresults` VALUES (1941, 4, 18, 'P', 12, '2026-06-07 11:18:53', 1);
INSERT INTO `tblresults` VALUES (1943, 4, 16, 'M', NULL, '2026-06-07 11:19:06', 1);
INSERT INTO `tblresults` VALUES (1944, 4, 17, 'D', NULL, '2026-06-07 11:19:09', 1);
INSERT INTO `tblresults` VALUES (1952, 16, 14, 'P', 11, '2026-06-23 11:38:06', 1);
INSERT INTO `tblresults` VALUES (1953, 16, 7, 'P', 16, '2026-06-23 11:45:40', 1);
INSERT INTO `tblresults` VALUES (1955, 10, 7, 'NP', 9, '2026-06-23 11:57:46', 1);
INSERT INTO `tblresults` VALUES (1956, 10, 9, 'P', NULL, '2026-06-23 11:58:01', 1);
INSERT INTO `tblresults` VALUES (1957, 10, 10, 'M', NULL, '2026-06-23 11:58:14', 1);
INSERT INTO `tblresults` VALUES (1958, 10, 12, 'P', NULL, '2026-06-23 12:03:21', 1);
INSERT INTO `tblresults` VALUES (1959, 10, 13, 'M', NULL, '2026-06-23 12:03:31', 1);
INSERT INTO `tblresults` VALUES (1960, 10, 14, 'P', 14, '2026-06-23 12:03:43', 1);
INSERT INTO `tblresults` VALUES (1961, 5, 14, 'P', 11, '2026-06-23 12:03:52', 1);
INSERT INTO `tblresults` VALUES (1962, 10, 15, 'P', NULL, '2026-06-23 12:04:01', 1);
INSERT INTO `tblresults` VALUES (1963, 10, 18, 'P', 14, '2026-06-23 12:04:14', 1);
INSERT INTO `tblresults` VALUES (1964, 10, 16, 'P', NULL, '2026-06-23 12:04:22', 1);
INSERT INTO `tblresults` VALUES (1965, 10, 17, 'P', NULL, '2026-06-23 12:13:05', 1);
INSERT INTO `tblresults` VALUES (1968, 16, 9, 'P', NULL, '2026-06-23 12:14:17', 1);
INSERT INTO `tblresults` VALUES (1969, 16, 11, 'P', NULL, '2026-06-23 12:14:24', 1);
INSERT INTO `tblresults` VALUES (1970, 16, 12, 'P', NULL, '2026-06-23 12:14:30', 1);
INSERT INTO `tblresults` VALUES (1971, 16, 13, 'P', NULL, '2026-06-23 12:14:35', 1);
INSERT INTO `tblresults` VALUES (1972, 16, 15, 'P', NULL, '2026-06-23 12:14:41', 1);
INSERT INTO `tblresults` VALUES (1973, 16, 18, 'NP', 9, '2026-06-23 12:14:52', 1);
INSERT INTO `tblresults` VALUES (1974, 16, 16, 'P', NULL, '2026-06-23 12:15:00', 1);
INSERT INTO `tblresults` VALUES (1975, 16, 17, 'P', NULL, '2026-06-23 12:15:05', 1);
INSERT INTO `tblresults` VALUES (1976, 5, 10, 'M', NULL, '2026-06-23 12:20:59', 1);
INSERT INTO `tblresults` VALUES (1977, 5, 12, 'M', NULL, '2026-06-23 12:21:06', 1);
INSERT INTO `tblresults` VALUES (1978, 5, 13, 'M', NULL, '2026-06-23 12:21:11', 1);
INSERT INTO `tblresults` VALUES (1979, 5, 15, 'D', NULL, '2026-06-23 12:21:26', 1);
INSERT INTO `tblresults` VALUES (1980, 5, 18, 'D', 32, '2026-06-23 12:21:34', 1);
INSERT INTO `tblresults` VALUES (1981, 5, 16, 'D', NULL, '2026-06-23 12:21:40', 1);
INSERT INTO `tblresults` VALUES (1982, 5, 17, 'D', NULL, '2026-06-23 12:21:46', 1);

-- ----------------------------
-- Table structure for tblstudent
-- ----------------------------
DROP TABLE IF EXISTS `tblstudent`;
CREATE TABLE `tblstudent`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `firstname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cisnumber` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'College CIS reference number',
  `notes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'Rich-text staff notes (HTML from TipTap editor)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `cisnumber`(`cisnumber` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblstudent
-- ----------------------------
INSERT INTO `tblstudent` VALUES (1, 'JAMES', 'HARTLEY', '9900512341', NULL);
INSERT INTO `tblstudent` VALUES (2, 'SOPHIE', 'WHITFIELD', '9900523187', NULL);
INSERT INTO `tblstudent` VALUES (3, 'OLIVER', 'PEMBERTON', '9900534092', NULL);
INSERT INTO `tblstudent` VALUES (4, 'EMILY', 'ASHWORTH', '9900541765', NULL);
INSERT INTO `tblstudent` VALUES (5, 'THOMAS', 'GREAVES', '9900558234', NULL);
INSERT INTO `tblstudent` VALUES (6, 'JESSICA', 'HOLLINGWORTH', '9900562901', NULL);
INSERT INTO `tblstudent` VALUES (7, 'SAMUEL', 'THISTLEWOOD', '9900571438', NULL);
INSERT INTO `tblstudent` VALUES (8, 'LAUREN', 'PICKERING', '9900583672', NULL);
INSERT INTO `tblstudent` VALUES (9, 'DANIEL', 'MOORHOUSE', '9900591047', NULL);
INSERT INTO `tblstudent` VALUES (10, 'CHARLOTTE', 'FEATHERSTONE', '9900604319', NULL);
INSERT INTO `tblstudent` VALUES (11, 'PRIYA', 'PATEL', '9900612856', NULL);
INSERT INTO `tblstudent` VALUES (12, 'ARJUN', 'SHARMA', '9900623491', NULL);
INSERT INTO `tblstudent` VALUES (13, 'AISHA', 'HUSSAIN', '9900631074', NULL);
INSERT INTO `tblstudent` VALUES (14, 'RAVI', 'KRISHNAMURTHY', '9900642387', NULL);
INSERT INTO `tblstudent` VALUES (15, 'MEERA', 'NAIR', '9900653920', NULL);
INSERT INTO `tblstudent` VALUES (16, 'OMAR', 'AL-RASHIDI', '9900661543', '<p>This is a comment</p><p><em>This is an update.</em></p>');
INSERT INTO `tblstudent` VALUES (17, 'FATIMA', 'MALIK', '9900672816', NULL);
INSERT INTO `tblstudent` VALUES (18, 'YUSUF', 'AHMED', '9900683259', NULL);
INSERT INTO `tblstudent` VALUES (19, 'ZARA', 'KHAN', '9900694702', NULL);
INSERT INTO `tblstudent` VALUES (20, 'IBRAHIM', 'AL-FARSI', '9900701385', NULL);
INSERT INTO `tblstudent` VALUES (21, 'ANASTASIA', 'KOVALENKO', '9900712948', NULL);
INSERT INTO `tblstudent` VALUES (22, 'DMITRI', 'VOLKOV', '9900723461', NULL);
INSERT INTO `tblstudent` VALUES (23, 'NATALIA', 'PETRENKO', '9900734094', NULL);
INSERT INTO `tblstudent` VALUES (24, 'ALEKSEI', 'SOROKIN', '9900745637', NULL);
INSERT INTO `tblstudent` VALUES (25, 'OLENA', 'MARCHENKO', '9900756180', NULL);
INSERT INTO `tblstudent` VALUES (26, 'KWAME', 'ASANTE', '9900761823', NULL);
INSERT INTO `tblstudent` VALUES (27, 'AMARA', 'DIALLO', '9900772456', NULL);
INSERT INTO `tblstudent` VALUES (28, 'KOFI', 'MENSAH', '9900783099', NULL);
INSERT INTO `tblstudent` VALUES (29, 'ABENA', 'BOATENG', '9900794632', NULL);
INSERT INTO `tblstudent` VALUES (30, 'SEUN', 'ADEYEMI', '9900805175', NULL);
INSERT INTO `tblstudent` VALUES (31, 'LIANG', 'CHEN', '9900811708', NULL);
INSERT INTO `tblstudent` VALUES (32, 'MING', 'ZHANG', '9900822341', NULL);
INSERT INTO `tblstudent` VALUES (33, 'YUKI', 'TANAKA', '9900833884', NULL);
INSERT INTO `tblstudent` VALUES (34, 'HARUTO', 'WATANABE', '9900844427', NULL);
INSERT INTO `tblstudent` VALUES (35, 'JIYEON', 'PARK', '9900855960', NULL);
INSERT INTO `tblstudent` VALUES (36, 'MARCO', 'ESPOSITO', '9900861503', NULL);
INSERT INTO `tblstudent` VALUES (37, 'GIULIA', 'FERRETTI', '9900872046', NULL);
INSERT INTO `tblstudent` VALUES (38, 'PEDRO', 'ALMEIDA', '9900883589', NULL);
INSERT INTO `tblstudent` VALUES (39, 'SOFIA', 'RODRIGUES', '9900894132', NULL);
INSERT INTO `tblstudent` VALUES (40, 'ELENA', 'VASQUEZ', '9900905675', NULL);
INSERT INTO `tblstudent` VALUES (41, 'GEORGE', 'PAPADOPOULOS', '9900911208', NULL);
INSERT INTO `tblstudent` VALUES (42, 'MARIA', 'STAVRIDIS', '9900922751', NULL);
INSERT INTO `tblstudent` VALUES (43, 'CALLUM', 'MCDONALD', '9900933294', NULL);
INSERT INTO `tblstudent` VALUES (44, 'ISLA', 'MACGREGOR', '9900944837', NULL);
INSERT INTO `tblstudent` VALUES (45, 'NIAMH', 'GALLAGHER', '9900955380', NULL);
INSERT INTO `tblstudent` VALUES (46, 'CIAN', 'O\'BRIEN', '9900961923', NULL);
INSERT INTO `tblstudent` VALUES (47, 'SAOIRSE', 'MURPHY', '9900972466', NULL);
INSERT INTO `tblstudent` VALUES (48, 'DECLAN', 'FITZPATRICK', '9900983009', NULL);
INSERT INTO `tblstudent` VALUES (49, 'RYAN', 'BLACKWOOD', '9900994542', NULL);
INSERT INTO `tblstudent` VALUES (50, 'HANNAH', 'SUTHERLAND', '9901005085', NULL);
INSERT INTO `tblstudent` VALUES (51, 'LUCAS', 'BERGSTROM', '9901011628', NULL);
INSERT INTO `tblstudent` VALUES (52, 'ASTRID', 'LINDQVIST', '9901022171', NULL);
INSERT INTO `tblstudent` VALUES (53, 'LEON', 'HOFFMANN', '9901033714', NULL);
INSERT INTO `tblstudent` VALUES (54, 'ANNA', 'BECKER', '9901044257', NULL);
INSERT INTO `tblstudent` VALUES (55, 'FELIX', 'BRANDT', '9901055800', NULL);
INSERT INTO `tblstudent` VALUES (56, 'SUNITA', 'CHAUHAN', '9901061343', NULL);
INSERT INTO `tblstudent` VALUES (57, 'VIKRAM', 'MEHTA', '9901072886', NULL);
INSERT INTO `tblstudent` VALUES (58, 'LAYLA', 'HASSAN', '9901083429', NULL);
INSERT INTO `tblstudent` VALUES (59, 'TARIQ', 'MAHMOOD', '9901094972', NULL);
INSERT INTO `tblstudent` VALUES (60, 'AMIRA', 'BENALI', '9901105515', NULL);
INSERT INTO `tblstudent` VALUES (61, 'TOBIAS', 'ENGEL', '9901111058', NULL);
INSERT INTO `tblstudent` VALUES (62, 'CLAIRE', 'RENARD', '9901122601', NULL);
INSERT INTO `tblstudent` VALUES (63, 'BAPTISTE', 'MOREAU', '9901133144', NULL);
INSERT INTO `tblstudent` VALUES (64, 'ELEANOR', 'STIRLING', '9901144687', NULL);
INSERT INTO `tblstudent` VALUES (65, 'JACK', 'CAVENDISH', '9901155230', NULL);
INSERT INTO `tblstudent` VALUES (66, 'GRACE', 'WINTERBOTTOM', '9901161773', NULL);

-- ----------------------------
-- Table structure for tblstudent_group
-- ----------------------------
DROP TABLE IF EXISTS `tblstudent_group`;
CREATE TABLE `tblstudent_group`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` int UNSIGNED NOT NULL,
  `group_id` int UNSIGNED NOT NULL,
  `concern_id` int UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_enrollment`(`student_id` ASC, `group_id` ASC) USING BTREE,
  INDEX `group_id`(`group_id` ASC) USING BTREE,
  INDEX `concern_id`(`concern_id` ASC) USING BTREE,
  CONSTRAINT `tblstudent_group_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `tblstudent` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tblstudent_group_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `tblgroup` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tblstudent_group_ibfk_3` FOREIGN KEY (`concern_id`) REFERENCES `tblconcern` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 128 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Student-group enrollment; concern is per enrollment (per course)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tblstudent_group
-- ----------------------------
INSERT INTO `tblstudent_group` VALUES (1, 1, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (2, 2, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (3, 3, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (4, 4, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (5, 5, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (6, 6, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (7, 7, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (8, 8, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (9, 9, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (10, 10, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (11, 11, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (12, 12, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (13, 13, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (14, 14, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (15, 15, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (16, 16, 1, 2);
INSERT INTO `tblstudent_group` VALUES (17, 17, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (18, 18, 1, NULL);
INSERT INTO `tblstudent_group` VALUES (19, 19, 2, NULL);
INSERT INTO `tblstudent_group` VALUES (20, 20, 2, NULL);
INSERT INTO `tblstudent_group` VALUES (21, 21, 2, NULL);
INSERT INTO `tblstudent_group` VALUES (22, 22, 2, NULL);
INSERT INTO `tblstudent_group` VALUES (23, 23, 2, NULL);
INSERT INTO `tblstudent_group` VALUES (24, 24, 2, NULL);
INSERT INTO `tblstudent_group` VALUES (25, 25, 2, NULL);
INSERT INTO `tblstudent_group` VALUES (26, 26, 2, NULL);
INSERT INTO `tblstudent_group` VALUES (27, 27, 2, NULL);
INSERT INTO `tblstudent_group` VALUES (28, 28, 2, NULL);
INSERT INTO `tblstudent_group` VALUES (29, 29, 2, NULL);
INSERT INTO `tblstudent_group` VALUES (30, 30, 2, NULL);
INSERT INTO `tblstudent_group` VALUES (31, 31, 2, NULL);
INSERT INTO `tblstudent_group` VALUES (32, 32, 2, NULL);
INSERT INTO `tblstudent_group` VALUES (33, 33, 2, NULL);
INSERT INTO `tblstudent_group` VALUES (34, 34, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (35, 35, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (36, 36, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (37, 37, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (38, 38, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (39, 39, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (40, 40, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (41, 41, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (42, 42, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (43, 43, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (44, 44, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (45, 45, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (46, 46, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (47, 47, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (48, 48, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (49, 49, 3, NULL);
INSERT INTO `tblstudent_group` VALUES (50, 50, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (51, 51, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (52, 52, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (53, 53, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (54, 54, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (55, 55, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (56, 56, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (57, 57, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (58, 58, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (59, 59, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (60, 60, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (61, 61, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (62, 62, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (63, 63, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (64, 64, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (65, 65, 5, NULL);
INSERT INTO `tblstudent_group` VALUES (66, 66, 5, NULL);

-- ----------------------------
-- Table structure for tblunit
-- ----------------------------
DROP TABLE IF EXISTS `tblunit`;
CREATE TABLE `tblunit`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `unitcode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `unitname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `unitref` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `credits` int UNSIGNED NOT NULL DEFAULT 0,
  `glh` int UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Guided Learning Hours',
  `is_external` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = externally assessed unit',
  `year` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Year of study: 1, 2, 3 or 4',
  `section_type` enum('learning_objectives','grade_bands') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'NULL = no criteria configured; use direct grade entry',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblunit
-- ----------------------------
INSERT INTO `tblunit` VALUES (1, '1', 'NCFE Coding Unit 1', NULL, 0, 0, 0, 1, 'learning_objectives');
INSERT INTO `tblunit` VALUES (2, '2', 'NCFE Coding Unit 2', NULL, 0, 0, 0, 1, 'learning_objectives');
INSERT INTO `tblunit` VALUES (3, '3', 'NCFE Coding Unit 3', NULL, 0, 0, 0, 1, 'learning_objectives');
INSERT INTO `tblunit` VALUES (4, '4', 'NCFE Coding Unit 4', NULL, 0, 0, 0, 1, 'learning_objectives');
INSERT INTO `tblunit` VALUES (5, '5', 'NCFE Coding Unit 5', NULL, 0, 0, 0, 1, 'learning_objectives');
INSERT INTO `tblunit` VALUES (6, '6', 'Website Development', NULL, 60, 60, 0, 1, 'grade_bands');
INSERT INTO `tblunit` VALUES (7, '1', 'Information Technology Systems', NULL, 120, 120, 1, 1, 'grade_bands');
INSERT INTO `tblunit` VALUES (8, '2', 'Creating systems to manage Information', NULL, 90, 90, 1, 1, 'grade_bands');
INSERT INTO `tblunit` VALUES (9, '3', 'Social Media in Business', NULL, 90, 90, 0, 1, 'grade_bands');
INSERT INTO `tblunit` VALUES (10, '4', 'Programming', NULL, 90, 90, 0, 1, 'grade_bands');
INSERT INTO `tblunit` VALUES (11, '5', 'Data Modelling', NULL, 60, 60, 0, 1, 'grade_bands');
INSERT INTO `tblunit` VALUES (12, '7', 'Mobile Apps Development', NULL, 60, 60, 0, 1, 'grade_bands');
INSERT INTO `tblunit` VALUES (13, '9', 'IT Project Management', NULL, 90, 90, 0, 1, 'grade_bands');
INSERT INTO `tblunit` VALUES (14, '11', 'Cybersecurity and Incident Management', NULL, 120, 120, 1, 1, 'grade_bands');
INSERT INTO `tblunit` VALUES (15, '12', 'IT Technical Support and Management', NULL, 60, 60, 0, 1, 'grade_bands');
INSERT INTO `tblunit` VALUES (16, '16', 'Cloud Storage and Collaboration Tools', NULL, 60, 60, 0, 1, 'grade_bands');
INSERT INTO `tblunit` VALUES (17, '19', 'Internet of Things', NULL, 60, 60, 0, 1, 'grade_bands');
INSERT INTO `tblunit` VALUES (18, '14', 'IT Service Delivery', NULL, 120, 120, 1, 1, NULL);
INSERT INTO `tblunit` VALUES (19, '4', 'Relational Database Management', NULL, 60, 60, 0, 1, NULL);
INSERT INTO `tblunit` VALUES (20, '1', 'NCFE Cyber Unit 1', NULL, 0, 0, 0, 1, 'learning_objectives');
INSERT INTO `tblunit` VALUES (21, '2', 'NCFE Cyber Unit 2', NULL, 0, 0, 0, 1, 'learning_objectives');
INSERT INTO `tblunit` VALUES (22, '3', 'NCFE Cyber Unit 3', NULL, 0, 0, 0, 1, 'learning_objectives');
INSERT INTO `tblunit` VALUES (23, '4', 'NCFE Cyber Unit  4', NULL, 0, 0, 0, 1, 'learning_objectives');
INSERT INTO `tblunit` VALUES (24, '5', 'NCFE Cyber Unit 5', NULL, 0, 0, 0, 1, 'learning_objectives');
INSERT INTO `tblunit` VALUES (25, '6', 'NCFE Cyber Unit 6', NULL, 0, 0, 0, 1, 'learning_objectives');
INSERT INTO `tblunit` VALUES (26, '1', 'NCFE Data Analysis Unit 1', NULL, 0, 0, 0, 1, 'learning_objectives');
INSERT INTO `tblunit` VALUES (27, '2', 'NCFE Data Analysis Unit 2', NULL, 0, 0, 0, 1, 'learning_objectives');
INSERT INTO `tblunit` VALUES (28, '3', 'NCFE Data Analysis Unit 3', NULL, 0, 0, 0, 1, 'learning_objectives');
INSERT INTO `tblunit` VALUES (29, '4', 'NCFE Data Analysis Unit 4', NULL, 0, 0, 0, 1, 'learning_objectives');
INSERT INTO `tblunit` VALUES (30, '5', 'NCFE Data Analysis Unit 5', NULL, 0, 0, 0, 1, 'learning_objectives');

-- ----------------------------
-- Table structure for tblunitsection
-- ----------------------------
DROP TABLE IF EXISTS `tblunitsection`;
CREATE TABLE `tblunitsection`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `unit_id` int UNSIGNED NOT NULL,
  `label` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'e.g. LO1, LO2, P, M, D',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Optional descriptor',
  `sort_order` int UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_section`(`unit_id` ASC, `label` ASC) USING BTREE,
  CONSTRAINT `tblunitsection_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `tblunit` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Sections within a unit -- LOs or grade bands' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblunitsection
-- ----------------------------
INSERT INTO `tblunitsection` VALUES (2, 3, 'Unit 3', NULL, 0);
INSERT INTO `tblunitsection` VALUES (3, 1, 'Unit 1', NULL, 0);
INSERT INTO `tblunitsection` VALUES (4, 2, 'Unit 2', NULL, 0);
INSERT INTO `tblunitsection` VALUES (5, 4, 'Unit 4', NULL, 0);
INSERT INTO `tblunitsection` VALUES (6, 5, 'Unit 5', NULL, 0);

-- ----------------------------
-- Table structure for tbluser
-- ----------------------------
DROP TABLE IF EXISTS `tbluser`;
CREATE TABLE `tbluser`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Used as login username',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'bcrypt hashed, cost 12',
  `fullname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tbluser
-- ----------------------------
INSERT INTO `tbluser` VALUES (1, 'simonrundell@exe-coll.ac.uk', '$2y$12$zNJze/wF3IjtpHKkTh.OjOwfpfy2QC3K2MmgacUnj4NJqQ3dBiNZq', 'Simon Rundell', '2026-05-21 13:46:35');
INSERT INTO `tbluser` VALUES (2, 'christemple-murray2@exe-coll.ac.uk', '$2y$12$YEuAY.aKQDU/rc8nG87YwOo9gN01RGRqDjuliDmVvzQcrhBgASMvS', 'Chris Temple-Murray', '2026-06-30 15:38:16');

-- ----------------------------
-- View structure for vw_criteria_progress
-- ----------------------------
DROP VIEW IF EXISTS `vw_criteria_progress`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `vw_criteria_progress` AS select `cu`.`course_id` AS `course_id`,`u`.`id` AS `unit_id`,`u`.`unitcode` AS `unitcode`,`u`.`section_type` AS `section_type`,`s`.`label` AS `section_label`,`s`.`sort_order` AS `section_order`,`c`.`id` AS `criteria_id`,`c`.`code` AS `criterion_code`,`c`.`sort_order` AS `criterion_order`,`e`.`student_id` AS `student_id`,coalesce(`e`.`achieved`,0) AS `achieved`,`e`.`achieved_date` AS `achieved_date`,`e`.`portfolio_ref` AS `portfolio_ref`,`e`.`assessor` AS `assessor` from ((((`tblcriteria` `c` join `tblunitsection` `s` on((`c`.`section_id` = `s`.`id`))) join `tblunit` `u` on((`s`.`unit_id` = `u`.`id`))) join `tblcourseunit` `cu` on((`cu`.`unit_id` = `u`.`id`))) left join `tblevidence` `e` on((`e`.`criteria_id` = `c`.`id`))) order by `u`.`id`,`s`.`sort_order`,`c`.`sort_order`,`e`.`student_id`;

SET FOREIGN_KEY_CHECKS = 1;
