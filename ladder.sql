SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Table `ladder`.`users`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `ladder`.`users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `email` VARCHAR(255) NOT NULL ,
  `password` VARCHAR(255) NOT NULL ,
  `salt` CHAR(128) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) ,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ladder`.`game_types`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `ladder`.`game_types` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ladder`.`matches`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `ladder`.`matches` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `game_types_id` INT UNSIGNED NOT NULL ,
  `date` DATETIME NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) ,
  INDEX `fk_matches_game_types1_idx` (`game_types_id` ASC) ,
  CONSTRAINT `fk_matches_game_types1`
    FOREIGN KEY (`game_types_id` )
    REFERENCES `ladder`.`game_types` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ladder`.`sets`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `ladder`.`sets` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `matches_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) ,
  INDEX `fk_sets_matches_idx` (`matches_id` ASC) ,
  CONSTRAINT `fk_sets_matches`
    FOREIGN KEY (`matches_id` )
    REFERENCES `ladder`.`matches` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ladder`.`games`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `ladder`.`games` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `sets_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) ,
  INDEX `fk_games_sets1_idx` (`sets_id` ASC) ,
  CONSTRAINT `fk_games_sets1`
    FOREIGN KEY (`sets_id` )
    REFERENCES `ladder`.`sets` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ladder`.`game_scores`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `ladder`.`game_scores` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `games_id` INT UNSIGNED NOT NULL ,
  `users_id` INT UNSIGNED NOT NULL ,
  `score` INT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) ,
  INDEX `fk_game_scores_games1_idx` (`games_id` ASC) ,
  INDEX `fk_game_scores_users1_idx` (`users_id` ASC) ,
  CONSTRAINT `fk_game_scores_games1`
    FOREIGN KEY (`games_id` )
    REFERENCES `ladder`.`games` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_game_scores_users1`
    FOREIGN KEY (`users_id` )
    REFERENCES `ladder`.`users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ladder`.`user_ratings`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `ladder`.`user_ratings` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `game_types_id` INT UNSIGNED NOT NULL ,
  `users_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) ,
  INDEX `fk_user_ratings_game_types1_idx` (`game_types_id` ASC) ,
  INDEX `fk_user_ratings_users1_idx` (`users_id` ASC) ,
  CONSTRAINT `fk_user_ratings_game_types1`
    FOREIGN KEY (`game_types_id` )
    REFERENCES `ladder`.`game_types` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_ratings_users1`
    FOREIGN KEY (`users_id` )
    REFERENCES `ladder`.`users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
