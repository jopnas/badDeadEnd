CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `classname` varchar(255) NOT NULL DEFAULT '""',
  `position` varchar(255) NOT NULL DEFAULT '[0,0,0]',
  `rotation` float NOT NULL DEFAULT '0',
  `fuel` float NOT NULL DEFAULT '0',
  `damage` varchar(10000) NOT NULL DEFAULT '[[],[]]',
  `destroyed` tinyint(2) NOT NULL DEFAULT '0',
  `items` text NOT NULL,
  `weapons` text NOT NULL,
  `magazines` text NOT NULL,
  `backpacks` text NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT '""',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8;
