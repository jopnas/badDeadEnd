CREATE TABLE `tents` (
  `id` bigint(255) NOT NULL AUTO_INCREMENT,
  `tentid` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL DEFAULT '0',
  `pos` varchar(255) NOT NULL DEFAULT '[0,0,0]',
  `rot` float NOT NULL DEFAULT '0',
  `type` varchar(45) NOT NULL DEFAULT '""',
  `items` varchar(1000) NOT NULL DEFAULT '[[],[]]',
  `weapons` varchar(1000) NOT NULL DEFAULT '[[],[]]',
  `magazines` varchar(1000) NOT NULL DEFAULT '[[],[]]',
  `backpacks` varchar(1000) NOT NULL DEFAULT '[[],[]]',
  PRIMARY KEY (`tentid`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `tentid_UNIQUE` (`tentid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
