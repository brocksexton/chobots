ALTER TABLE `kavalok`.`user` DROP INDEX `email`;
ADD INDEX `email` USING BTREE(`email`);
