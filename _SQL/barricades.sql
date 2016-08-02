CREATE TABLE `barricades` (
  `id` bigint(255) NOT NULL AUTO_INCREMENT,
  `barricadeid` varchar(255) NOT NULL,
  `pos` varchar(255) NOT NULL DEFAULT '[0,0,0]',
  `rot` float NOT NULL DEFAULT '0',
  `type` varchar(45) NOT NULL DEFAULT '""',
  `health` float NOT NULL DEFAULT '1000',
  PRIMARY KEY (`barricadeid`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `barricadeid_UNIQUE` (`barricadeid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;