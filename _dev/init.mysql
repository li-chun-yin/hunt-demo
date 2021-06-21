CREATE TABLE `t_captcha` (
  `seq` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `to` varchar(255) NOT NULL DEFAULT '',
  `code` varchar(45) NOT NULL DEFAULT '',
  `update_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ux_to` (`type`,`to`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `t_user` (
  `seq` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` char(32) NOT NULL DEFAULT '',
  `nick` varchar(45) NOT NULL DEFAULT '',
  `login_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `login_ip` varchar(45) NOT NULL DEFAULT '',
  `create_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `update_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ux_uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `t_user_account` (
  `seq` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  `uid` char(32) NOT NULL DEFAULT '',
  `create_time` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ux_value` (`type`,`value`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `t_upload` (
  `seq` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `file_id` char(32) NOT NULL DEFAULT '',
  `original_name` varchar(255) NOT NULL DEFAULT '',
  `extension` varchar(255) NOT NULL DEFAULT '',
  `mime_type` varchar(255) NOT NULL DEFAULT '',
  `size` bigint(20) unsigned NOT NULL DEFAULT 0,
  `type` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `create_ip` varchar(45) NOT NULL DEFAULT '',
  `create_time` bigint(20) unsigned NOT NULL DEFAULT 0,
  `update_time` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ux_file_id` (`file_id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `t_article` (
  `seq` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(45) NOT NULL DEFAULT '',
  `desc` varchar(255) NOT NULL DEFAULT '',
  `image_id` char(32) NOT NULL DEFAULT '',
  `pv` bigint(20) unsigned NOT NULL DEFAULT 0,
  `create_time` bigint(20) unsigned NOT NULL DEFAULT 0,
  `create_user` char(32) NOT NULL DEFAULT '',
  `update_time` bigint(20) unsigned NOT NULL DEFAULT 0,
  `update_user` char(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `t_article_extend` (
  `seq` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `article_seq` int(10) unsigned NOT NULL DEFAULT 0,
  `content` longtext NOT NULL DEFAULT '',
  PRIMARY KEY (`seq`),
  UNIQUE KEY `ux_article` (`article_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;