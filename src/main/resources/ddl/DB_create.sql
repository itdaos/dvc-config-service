-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema open_gallery
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `open_gallery` ;

-- -----------------------------------------------------
-- Schema open_gallery
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `open_gallery` DEFAULT CHARACTER SET utf8 ;
USE `open_gallery` ;

-- -----------------------------------------------------
-- Table `artstyles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `artstyles` ;

CREATE TABLE IF NOT EXISTS `artstyles` (
                                           `ID` INT NOT NULL AUTO_INCREMENT,
                                           `title` VARCHAR(45) NOT NULL,
    `summary` TEXT NULL DEFAULT NULL,
    `age` DATE NULL DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE INDEX `ID_UNIQUE` (`ID` ASC) VISIBLE,
    UNIQUE INDEX `title_UNIQUE` (`title` ASC) VISIBLE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `authors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `authors` ;

CREATE TABLE IF NOT EXISTS `authors` (
                                         `ID` INT NOT NULL AUTO_INCREMENT,
                                         `full_name` VARCHAR(128) NOT NULL,
    `birthday` DATE NULL DEFAULT NULL,
    `deathday` DATE NULL DEFAULT NULL,
    `bio` TEXT NULL DEFAULT NULL,
    `portrait_pic` VARCHAR(2048) NULL DEFAULT NULL,
    `pseudoname` VARCHAR(128) NULL DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE INDEX `ID_UNIQUE` (`ID` ASC) VISIBLE,
    UNIQUE INDEX `full_name_UNIQUE` (`full_name` ASC) VISIBLE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `users` ;

CREATE TABLE IF NOT EXISTS `users` (
    `ID` INT NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(45) NOT NULL,
    `email` VARCHAR(50) NOT NULL,
    `bio` TEXT NULL DEFAULT NULL,
    `profile_pic` VARCHAR(2048) NULL DEFAULT NULL,
    `first_name` VARCHAR(45) NULL DEFAULT NULL,
    `last_name` VARCHAR(45) NULL DEFAULT NULL,
    `pass_hash` BINARY(60) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE INDEX `ID_UNIQUE` (`ID` ASC) VISIBLE,
    UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
    UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb3;
-- -----------------------------------------------------
-- Table `roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `roles`;

CREATE TABLE IF NOT EXISTS `roles` (
    `ID` INT NOT NULL AUTO_INCREMENT,
    `name` ENUM('ROLE_USER','ROLE_MODERATOR','ROLE_ADMIN')
) ENGINE = InnoDB DEFAULT  CHARACTER SET = utf8mb3;
-- -----------------------------------------------------
-- Table `user_roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user_roles`;

CREATE TABLE IF NOT EXISTS `user_roles` (
    `ID` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `role_id` INT NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE INDEX `ID_UNIQUE` (`ID` ASC) VISIBLE,
    INDEX `user_to_role_idx` (`user_id` ASC) VISIBLE,
    INDEX `role_to_user_idx` (`role_id` ASC) VISIBLE,
    CONSTRAINT `user_to_role_id`
        FOREIGN KEY (`user_id`)
            REFERENCES `users` (`ID`),
    CONSTRAINT `role_to_user_id`
        FOREIGN KEY (`role_id`)
            REFERENCES `roles` (`ID`)

) ENGINE = InnoDB DEFAULT  CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `art_objects`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `art_objects` ;

CREATE TABLE IF NOT EXISTS `art_objects` (
                                             `ID` INT NOT NULL AUTO_INCREMENT,
                                             `title` VARCHAR(65) NOT NULL,
    `category` ENUM('NA', 'painting', 'sculpture', 'digital', 'literature', 'architecture', 'film', 'music') NOT NULL DEFAULT 'NA',
    `type` ENUM('NA', 'physical', 'digital', 'NFT') NOT NULL DEFAULT 'NA',
    `status` ENUM('NA', 'in_private', 'in_public', 'on_auction', 'on_sale') NOT NULL DEFAULT 'NA',
    `description` TEXT NULL DEFAULT NULL,
    `author_id` INT NULL DEFAULT NULL,
    `owner_id` INT NOT NULL,
    `artstyle_id` INT NULL DEFAULT NULL,
    `time_created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `time_modified` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`ID`),
    UNIQUE INDEX `ID_UNIQUE` (`ID` ASC) VISIBLE,
    UNIQUE INDEX `title_UNIQUE` (`title` ASC) VISIBLE,
    INDEX `owner_id_idx` (`owner_id` ASC) VISIBLE,
    INDEX `artstyle_id` (`artstyle_id` ASC) VISIBLE,
    INDEX `author_id` (`author_id` ASC) VISIBLE,
    CONSTRAINT `artstyle_id`
    FOREIGN KEY (`artstyle_id`)
    REFERENCES `artstyles` (`ID`),
    CONSTRAINT `author_id`
    FOREIGN KEY (`author_id`)
    REFERENCES `authors` (`ID`),
    CONSTRAINT `owner_id`
    FOREIGN KEY (`owner_id`)
    REFERENCES `users` (`ID`))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `claims`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `claims` ;

CREATE TABLE IF NOT EXISTS `claims` (
                                        `ID` INT NOT NULL AUTO_INCREMENT,
                                        `issued_by` INT NOT NULL,
                                        `body` TEXT NOT NULL,
                                        `type` ENUM('other', 'create', 'update', 'delete') NOT NULL DEFAULT 'other',
    `decision` ENUM('delivered', 'on_review', 'accepted', 'rejected') NOT NULL DEFAULT 'delivered',
    `response` TEXT NULL DEFAULT NULL,
    `date_created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `date_reviewed` DATETIME NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE INDEX `ID_UNIQUE` (`ID` ASC) VISIBLE,
    INDEX `issued_by_idx` (`issued_by` ASC) VISIBLE,
    CONSTRAINT `issued_by`
    FOREIGN KEY (`issued_by`)
    REFERENCES `users` (`ID`))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `maintainances`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `maintainances` ;

CREATE TABLE IF NOT EXISTS `maintainances` (
                                               `ID` INT NOT NULL AUTO_INCREMENT,
                                               `maintainer_id` INT NOT NULL,
                                               `creator_id` INT NOT NULL,
                                               PRIMARY KEY (`ID`),
    UNIQUE INDEX `ID_UNIQUE` (`ID` ASC) VISIBLE,
    INDEX `maintainer_id_idx` (`maintainer_id` ASC) VISIBLE,
    INDEX `creator_id_idx` (`creator_id` ASC) VISIBLE,
    CONSTRAINT `creator_id`
    FOREIGN KEY (`creator_id`)
    REFERENCES `authors` (`ID`),
    CONSTRAINT `maintainer_id`
    FOREIGN KEY (`maintainer_id`)
    REFERENCES `users` (`ID`))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `subscribtions_id`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `subscribtions_id` ;

CREATE TABLE IF NOT EXISTS `subscribtions_id` (
                                                  `ID` INT NOT NULL AUTO_INCREMENT,
                                                  `user_id` INT NOT NULL,
                                                  `author_id` INT NOT NULL,
                                                  PRIMARY KEY (`ID`),
    UNIQUE INDEX `ID_UNIQUE` (`ID` ASC) VISIBLE,
    INDEX `follower_id_idx` (`user_id` ASC) VISIBLE,
    INDEX `leader_id_idx` (`author_id` ASC) VISIBLE,
    CONSTRAINT `follower_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`ID`),
    CONSTRAINT `leader_id`
    FOREIGN KEY (`author_id`)
    REFERENCES `authors` (`ID`))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb3;

USE `open_gallery` ;

-- -----------------------------------------------------
-- procedure add_art_object
-- -----------------------------------------------------

USE `open_gallery`;
DROP procedure IF EXISTS `add_art_object`;

DELIMITER $$
USE `open_gallery`$$
CREATE DEFINER=`root`@`%` PROCEDURE `add_art_object`(
	IN TITLE VARCHAR(65),
    IN CATEGORY VARCHAR(45),
    IN varTYPE VARCHAR(45),
    IN varSTATUS VARCHAR(45),
    IN varDESCRIPTION VARCHAR(45),
    IN AUTHOR_ID INT,
    IN OWNER_ID INT,
    IN ARTSTYLE_ID INT
)
BEGIN
INSERT INTO `art_objects`
(`title`, `category`, `type`, `status`, `description`, `author_id`, `owner_id`, `artstyle_id`, `time_created`, `time_modified`)
VALUES
    (TRIM(TITLE), TRIM(CATEGORY), TRIM(varTYPE), TRIM(varStatus), TRIM(varDescription), AUTHOR_ID, OWNER_ID, ARTSTYLE_ID, NOW(), NOW());
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure add_author
-- -----------------------------------------------------

USE `open_gallery`;
DROP procedure IF EXISTS `add_author`;

DELIMITER $$
USE `open_gallery`$$
CREATE DEFINER=`root`@`%` PROCEDURE `add_author`(
	IN FULL_NAME VARCHAR(128),
    IN BIO TEXT,
    IN BIRTHDAY DATE,
    IN DEATHDAY DATE,
    IN PORTRAIT_PIC VARCHAR(2048)
)
BEGIN
INSERT INTO `authors`
(`full_name`, `bio`, `birthday`, `deathday`, `portrait_pic`)
VALUES
    (TRIM(FULL_NAME), TRIM(BIO), BIRTHDAY, DEATHDAY, PORTRAIT_PIC);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function count_by_category
-- -----------------------------------------------------

USE `open_gallery`;
DROP function IF EXISTS `count_by_category`;

DELIMITER $$
USE `open_gallery`$$
CREATE DEFINER=`root`@`%` FUNCTION `count_by_category`(
	CATEGORY VARCHAR(45)
) RETURNS int
    READS SQL DATA
BEGIN
	DECLARE counter INT;
SELECT COUNT(*) FROM `art_objects` WHERE category = CATEGORY INTO counter;
RETURN counter;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_author_by_id
-- -----------------------------------------------------

USE `open_gallery`;
DROP procedure IF EXISTS `delete_author_by_id`;

DELIMITER $$
USE `open_gallery`$$
CREATE DEFINER=`root`@`%` PROCEDURE `delete_author_by_id`(
	IN id INT
)
BEGIN
DELETE FROM `authors` WHERE ID = id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_title
-- -----------------------------------------------------

USE `open_gallery`;
DROP procedure IF EXISTS `update_title`;

DELIMITER $$
USE `open_gallery`$$
CREATE DEFINER=`root`@`%` PROCEDURE `update_title`(
	IN OLD_TITLE VARCHAR(65),
    IN NEW_TITLE VARCHAR(65)
)
BEGIN
UPDATE `art_objects` SET `title` = NEW_TITLE WHERE title = OLD_TITLE;
END$$

DELIMITER ;
USE `open_gallery`;

DELIMITER $$

USE `open_gallery`$$
DROP TRIGGER IF EXISTS `authors_BEFORE_INSERT` $$
USE `open_gallery`$$
CREATE
DEFINER=`root`@`%`
TRIGGER `open_gallery`.`authors_BEFORE_INSERT`
BEFORE INSERT ON `open_gallery`.`authors`
FOR EACH ROW
BEGIN
	IF NEW.birthday > NEW.deathday THEN
		SET NEW.deathday = NULL;
END IF;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
