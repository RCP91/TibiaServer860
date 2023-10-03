CREATE TABLE IF NOT EXISTS `bounty_hunter_system` (
     `id` int(11) NOT NULL auto_increment,
     `hunter_id` int(11) NOT NULL,
     `target_id` int(11) NOT NULL,
     `killer_id` int(11) NOT NULL,
     `prize` bigint(20) NOT NULL,
     `currencyType` varchar(32) NOT NULL,
     `dateAdded` int(15) NOT NULL,
     `killed` int(11) NOT NULL,
     `dateKilled` int(15) NOT NULL,
     PRIMARY KEY  (`id`)
    ) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;