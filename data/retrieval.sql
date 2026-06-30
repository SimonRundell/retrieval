/*
 Navicat Premium Dump SQL

 Source Server         : LOCALHOST
 Source Server Type    : MySQL
 Source Server Version : 120302 (12.3.2-MariaDB)
 Source Host           : localhost:3306
 Source Schema         : retrieval

 Target Server Type    : MySQL
 Target Server Version : 120302 (12.3.2-MariaDB)
 File Encoding         : 65001

 Date: 30/06/2026 06:24:05
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tblquiz
-- ----------------------------
DROP TABLE IF EXISTS `tblquiz`;
CREATE TABLE `tblquiz`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `quizCode` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quizType` tinyint NOT NULL DEFAULT 1 COMMENT '1=Match, 2=MC',
  `quizName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quizSetBy` int NOT NULL COMMENT 'tbluser.id',
  `quizSubject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `quizDescription` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `quizTopic` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `quizYear` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `quizUnit` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `quizData` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'JSON quiz content',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_quizCode`(`quizCode` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblquiz
-- ----------------------------
INSERT INTO `tblquiz` VALUES (1, 'doql7c', 2, 'Level 2 Coding Lesson 2 Retrieval', 1, 'Coding', 'This is the first retrieval at lesson 2 to see what we have learnt from lesson 1', 'Introduction to Coding', '2026', '1', '[{\"question\":\"What is the capital of Outer Mongolia?\",\"answers\":[\"Paris\",\"Ulanbaator\",\"Bejing\",\"Dar-es-Salaam\"],\"correctAnswer\":1}]');
INSERT INTO `tblquiz` VALUES (2, 'e8gsa2', 1, 'Match Definitions Test', 1, 'Level 2 Coding', 'This is a test of drag and drop questions', 'Cosing', '2026', '1', '{\"QuestionSets\":[{\"Header\":\"Set 1\",\"QuestionAnswerPairs\":[{\"Question\":\"What does all the calculations in a computer?\",\"Answer\":\"CPU\"},{\"Question\":\"Where does data get stored for fast retrieval?\",\"Answer\":\"RAM\"},{\"Question\":\"Where are all the low-level pieces of information stored before startup?\",\"Answer\":\"BIOS\"},{\"Question\":\"What is the name of the standard peripheral connection?\",\"Answer\":\"USB\"}]}]}');
INSERT INTO `tblquiz` VALUES (3, 'g55688', 2, 'Unit 2 Lesson 2 Retrieval', 1, 'Level 2 Coding', '', 'How computers understand code', '2026', '2', '[{\"question\":\"What is the main difference between a high-level and a low-level language?\",\"answers\":[\"High-level languages are closer to human language; low-level languages are closer to machine code\",\"High-level languages only run on phones\",\"Low-level languages cannot be translated\",\"I don\'t know\"],\"correctAnswer\":0},{\"question\":\"In the kitchen analogy used in the lesson, who does the Waiter represent?\",\"answers\":[\"The Programmer\",\"The Translator (compiler or interpreter)\",\"The Computer hardware\",\"I don\'t know\"],\"correctAnswer\":1},{\"question\":\"Which of these is something that is NOT one of the three types of translator covered in the lesson?\",\"answers\":[\"Debugger\",\"Compiler\",\"Assembler\",\"I don\'t know\"],\"correctAnswer\":0},{\"question\":\"What does a compiler do?\",\"answers\":[\"Translates the entire program at once before it runs\",\"Translates the program one line at a time while it runs\",\"Deletes unused code from the program\",\"I don\'t know\"],\"correctAnswer\":0},{\"question\":\"What does an interpreter do?\",\"answers\":[\"Translates the whole program in advance\",\"Translates and executes the code line by line in real time\",\"Converts low-level code into machine code only\",\"I don\'t know\"],\"correctAnswer\":1},{\"question\":\"Why can a compiler detect syntax errors but not run-time errors?\",\"answers\":[\"Syntax errors only happen when the code actually runs\",\"Syntax errors are found when the code is translated, before the program runs, but run-time errors only appear once it is running\",\"Compilers cannot detect any errors at all\",\"I don\'t know\"],\"correctAnswer\":1},{\"question\":\"Why does an interpreted language generally run more slowly than a compiled one?\",\"answers\":[\"Because interpreted languages have no syntax\",\"Because translation happens at run-time, repeating the read, check, translate and execute cycle for every instruction\",\"Because interpreters only work on older computers\",\"I don\'t know\"],\"correctAnswer\":1},{\"question\":\"Which of these is an example of a compiled language mentioned in the lesson?\",\"answers\":[\"Python\",\"JavaScript\",\"C++\",\"I don\'t know\"],\"correctAnswer\":2},{\"question\":\"In the five-stage compilation process, what does the Linking stage do?\",\"answers\":[\"Gathers the ingredients by handling #include directives\",\"Combines the object file with libraries to form a complete executable program\",\"Loads the executable into memory and runs it\",\"I don\'t know\"],\"correctAnswer\":1},{\"question\":\"What is produced at the end of the Execution stage when a compiled program runs?\",\"answers\":[\"A .obj file\",\"A .asm file\",\"The program runs and produces output\",\"I don\'t know\"],\"correctAnswer\":2}]');

-- ----------------------------
-- Table structure for tblsession
-- ----------------------------
DROP TABLE IF EXISTS `tblsession`;
CREATE TABLE `tblsession`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `quizCode` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `startTime` datetime NOT NULL,
  `durationSecs` int NOT NULL DEFAULT 600 COMMENT 'Session length in seconds',
  `createdBy` int NOT NULL COMMENT 'tbluser.id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_quizCode`(`quizCode` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblsession
-- ----------------------------
INSERT INTO `tblsession` VALUES (1, 'doql7c', '2026-06-29 19:57:23', 600, 1);
INSERT INTO `tblsession` VALUES (2, 'doql7c', '2026-06-29 20:05:07', 600, 1);
INSERT INTO `tblsession` VALUES (3, 'e8gsa2', '2026-06-29 20:30:23', 600, 1);
INSERT INTO `tblsession` VALUES (4, 'g55688', '2026-06-30 05:08:54', 600, 1);
INSERT INTO `tblsession` VALUES (5, 'g55688', '2026-06-30 05:14:33', 600, 1);
INSERT INTO `tblsession` VALUES (6, 'g55688', '2026-06-30 05:17:30', 600, 1);
INSERT INTO `tblsession` VALUES (7, 'g55688', '2026-06-30 05:17:51', 600, 1);
INSERT INTO `tblsession` VALUES (8, 'g55688', '2026-06-30 05:18:51', 600, 1);
INSERT INTO `tblsession` VALUES (9, 'doql7c', '2026-06-30 05:22:03', 600, 1);

-- ----------------------------
-- Table structure for tblstatus
-- ----------------------------
DROP TABLE IF EXISTS `tblstatus`;
CREATE TABLE `tblstatus`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `studentName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quizCode` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `score` int NOT NULL DEFAULT 0,
  `quizComplete` tinyint NOT NULL DEFAULT 0 COMMENT '1 = finished',
  `lastUpdate` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_quizCode`(`quizCode` ASC) USING BTREE,
  INDEX `idx_studentQuiz`(`studentName` ASC, `quizCode` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tblstatus
-- ----------------------------
INSERT INTO `tblstatus` VALUES (6, 'Simon', 'e8gsa2', 1, 0, '2026-06-29 20:30:46');
INSERT INTO `tblstatus` VALUES (7, 'Simon', 'e8gsa2', 2, 0, '2026-06-29 20:30:49');
INSERT INTO `tblstatus` VALUES (8, 'Simon', 'e8gsa2', 3, 0, '2026-06-29 20:30:53');
INSERT INTO `tblstatus` VALUES (9, 'Simon', 'e8gsa2', 4, 0, '2026-06-29 20:30:56');
INSERT INTO `tblstatus` VALUES (10, 'Simon', 'e8gsa2', 4, 1, '2026-06-29 20:30:56');
INSERT INTO `tblstatus` VALUES (12, 'Simon', 'doql7c', 0, 1, '2026-06-30 05:22:25');

-- ----------------------------
-- Table structure for tbluser
-- ----------------------------
DROP TABLE IF EXISTS `tbluser`;
CREATE TABLE `tbluser`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `passwordHash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `studentName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `schoolName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `classNamen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `admin` tinyint NOT NULL DEFAULT 0 COMMENT '1 = admin',
  `teacher` tinyint NOT NULL DEFAULT 0 COMMENT '1 = teacher',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tbluser
-- ----------------------------
INSERT INTO `tbluser` VALUES (1, 'simonrundell@exe-coll.ac.uk', '81dc9bdb52d04dc20036dbd8313ed055', 'Administrator', 'Exeter College', NULL, 1, 1);

SET FOREIGN_KEY_CHECKS = 1;
