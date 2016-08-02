CREATE TABLE `dogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(45) NOT NULL DEFAULT '""',
  `alive` int(11) NOT NULL DEFAULT '1',
  `items` varchar(2000) NOT NULL DEFAULT '[]',
  `soundBark` varchar(255) NOT NULL DEFAULT '""',
  `position` varchar(45) NOT NULL DEFAULT '[]',
  `bestFriend` varchar(45) NOT NULL DEFAULT '""',
  PRIMARY KEY (`type`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `type_UNIQUE` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
