ALTER TABLE `sms_message` ADD `sender` VARCHAR( 100 ) NULL DEFAULT NULL;
ALTER TABLE `sms_autoresponder` ADD `sender` VARCHAR( 100 ) NULL DEFAULT NULL;
ALTER TABLE `sms_message` CHANGE `pubdate` `pubdate` DATETIME NULL DEFAULT NULL;
ALTER TABLE `sms_autolist` ADD `sender` VARCHAR( 100 ) NULL DEFAULT NULL;
ALTER TABLE `sms_phonebook` CHANGE `idgroup` `idgroup` VARCHAR( 300 ) NULL DEFAULT NULL;
ALTER TABLE `sms_poll_main` ADD `keyword` VARCHAR( 200 ) NOT NULL AFTER `id`; 
ALTER TABLE `sms_inbox` ADD `idfolder` int(10) NULL DEFAULT NULL;
ALTER TABLE `sms_inbox` ADD `idmodem` varchar(100) NULL DEFAULT NULL;
ALTER TABLE `sms_phonebook` ADD `datebirth` DATE NULL DEFAULT NULL;
ALTER TABLE `sms_group` CHANGE `idgroup` `idgroup` INT( 11 ) NOT NULL; 
ALTER TABLE `sms_folder` ADD `keywords` text NULL DEFAULT NULL;
ALTER TABLE `sms_folder` ADD `autoreplystatus` int(10) NULL DEFAULT NULL;
ALTER TABLE `sms_folder` ADD `reply` text NULL DEFAULT NULL;
ALTER TABLE `sms_temp` ADD `tanggal` DATE;

DROP TABLE `sms_user`;
DROP TABLE `sms_option`;
DROP TABLE `daemons`;
DROP TABLE `gammu`;
DROP TABLE `inbox`;
DROP TABLE `outbox`;
DROP TABLE `outbox_multipart`;
DROP TABLE `pbk`;
DROP TABLE `pbk_groups`;
DROP TABLE `sentitems`;
DROP TABLE `phones`;

CREATE TABLE `daemons` (
  `Start` text NOT NULL,
  `Info` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `gammu` (
  `Version` integer NOT NULL default '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `inbox` (
  `UpdatedInDB` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `ReceivingDateTime` timestamp NOT NULL default '0000-00-00 00:00:00',
  `Text` text NOT NULL,
  `SenderNumber` varchar(20) NOT NULL default '',
  `Coding` enum('Default_No_Compression','Unicode_No_Compression','8bit','Default_Compression','Unicode_Compression') NOT NULL default 'Default_No_Compression',
  `UDH` text NOT NULL,
  `SMSCNumber` varchar(20) NOT NULL default '',
  `Class` integer NOT NULL default '-1',
  `TextDecoded` text NOT NULL default '',
  `ID` integer unsigned NOT NULL auto_increment,
  `RecipientID` text NOT NULL,
  `Processed` enum('false','true') NOT NULL default 'false',
  PRIMARY KEY `ID` (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

CREATE TABLE `outbox` (
  `UpdatedInDB` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `InsertIntoDB` timestamp NOT NULL default '0000-00-00 00:00:00',
  `SendingDateTime` timestamp NOT NULL default '0000-00-00 00:00:00',
  `Text` text,
  `DestinationNumber` varchar(20) NOT NULL default '',
  `Coding` enum('Default_No_Compression','Unicode_No_Compression','8bit','Default_Compression','Unicode_Compression') NOT NULL default 'Default_No_Compression',
  `UDH` text,
  `Class` integer default '-1',
  `TextDecoded` text NOT NULL default '',
  `ID` integer unsigned NOT NULL auto_increment,
  `MultiPart` enum('false','true') default 'false',
  `RelativeValidity` integer default '-1',
  `SenderID` varchar(255),
  `SendingTimeOut` timestamp NULL default '0000-00-00 00:00:00',
  `DeliveryReport` enum('default','yes','no') default 'default',
  `CreatorID` text NOT NULL,
  PRIMARY KEY `ID` (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE INDEX outbox_date ON outbox(SendingDateTime, SendingTimeOut);
CREATE INDEX outbox_sender ON outbox(SenderID);

CREATE TABLE `outbox_multipart` (
  `Text` text,
  `Coding` enum('Default_No_Compression','Unicode_No_Compression','8bit','Default_Compression','Unicode_Compression') NOT NULL default 'Default_No_Compression',
  `UDH` text,
  `Class` integer default '-1',
  `TextDecoded` text default NULL,
  `ID` integer unsigned NOT NULL default '0',
  `SequencePosition` integer NOT NULL default '1',
  PRIMARY KEY (`ID`, `SequencePosition`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `pbk` (
  `ID` integer NOT NULL auto_increment,
  `GroupID` integer NOT NULL default '-1',
  `Name` text NOT NULL,
  `Number` text NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `pbk_groups` (
  `Name` text NOT NULL,
  `ID` integer NOT NULL auto_increment,
  PRIMARY KEY `ID` (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

CREATE TABLE `phones` (
  `ID` text NOT NULL,
  `UpdatedInDB` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `InsertIntoDB` timestamp NOT NULL default '0000-00-00 00:00:00',
  `TimeOut` timestamp NOT NULL default '0000-00-00 00:00:00',
  `Send` enum('yes','no') NOT NULL default 'no',
  `Receive` enum('yes','no') NOT NULL default 'no',
  `IMEI` varchar(35) NOT NULL,
  `Client` text NOT NULL,
  `Battery` integer NOT NULL DEFAULT 0,
  `Signal` integer NOT NULL DEFAULT 0,
  `Sent` int NOT NULL DEFAULT 0,
  `Received` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`IMEI`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `sentitems` (
  `UpdatedInDB` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `InsertIntoDB` timestamp NOT NULL default '0000-00-00 00:00:00',
  `SendingDateTime` timestamp NOT NULL default '0000-00-00 00:00:00',
  `DeliveryDateTime` timestamp NULL,
  `Text` text NOT NULL,
  `DestinationNumber` varchar(20) NOT NULL default '',
  `Coding` enum('Default_No_Compression','Unicode_No_Compression','8bit','Default_Compression','Unicode_Compression') NOT NULL default 'Default_No_Compression',
  `UDH` text NOT NULL,
  `SMSCNumber` varchar(20) NOT NULL default '',
  `Class` integer NOT NULL default '-1',
  `TextDecoded` text NOT NULL default '',
  `ID` integer unsigned NOT NULL default '0',
  `SenderID` varchar(255) NOT NULL,
  `SequencePosition` integer NOT NULL default '1',
  `Status` enum('SendingOK','SendingOKNoReport','SendingError','DeliveryOK','DeliveryFailed','DeliveryPending','DeliveryUnknown','Error') NOT NULL default 'SendingOK',
  `StatusError` integer NOT NULL default '-1',
  `TPMR` integer NOT NULL default '-1',
  `RelativeValidity` integer NOT NULL default '-1',
  `CreatorID` text NOT NULL,
  PRIMARY KEY (`ID`, `SequencePosition`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE INDEX sentitems_date ON sentitems(DeliveryDateTime);
CREATE INDEX sentitems_tpmr ON sentitems(TPMR);
CREATE INDEX sentitems_dest ON sentitems(DestinationNumber);
CREATE INDEX sentitems_sender ON sentitems(SenderID);

CREATE TABLE `sms_autolist` (
  `phoneNumber` varchar(15) NOT NULL default '',
  `id` int(11) NOT NULL default '0',
  `status` int(11) default NULL,
  `sender` varchar(100) default NULL,
  PRIMARY KEY  (`phoneNumber`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `sms_autoreply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keyword` varchar(300) DEFAULT NULL,
  `reply` text,
  PRIMARY KEY (`id`)
);

CREATE TABLE `sms_autoresponder` (
  `id` int(11) NOT NULL auto_increment,
  `msg` text,
  `interv` int(11) default NULL,
  `idgroup` int(11) default NULL,
  `sender` varchar(100) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `sms_group` (
  `idgroup` int(11) NOT NULL,
  `group` varchar(50) default NULL,
  PRIMARY KEY  (`idgroup`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `sms_inbox` (
  `id` int(11) NOT NULL auto_increment,
  `msg` text,
  `sender` varchar(20) default NULL,
  `time` datetime default NULL,
  `flagRead` int(11) default NULL,
  `flagReply` int(11) default NULL,
  `idfolder` int(10),
  `idmodem` varchar(100),
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `sms_message` (
  `id` int(11) NOT NULL auto_increment,
  `message` text,
  `pubdate` datetime default NULL,
  `status` int(11) NOT NULL,
  `idgroup` int(11) default NULL,
  `sender` varchar(100) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `sms_phonebook` (
  `noTelp` varchar(50) NOT NULL default '',
  `nama` varchar(50) default NULL,
  `alamat` varchar(100) default NULL,
  `idgroup` varchar(300) default NULL,
  `dateJoin` date default NULL,
  `datebirth` DATE,
  PRIMARY KEY  (`noTelp`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `sms_sentmsg` (
  `id` int(11) NOT NULL auto_increment,
  `msg` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `sms_user` (
  `username` varchar(50) NOT NULL default '',
  `password` varchar(32) default NULL,
  `ulevel` int(10), 
  PRIMARY KEY  (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `sms_data` (
  `keyword` varchar(20) NOT NULL default '',
  `key` varchar(100) NOT NULL default '',
  `field1` varchar(100) default NULL,
  `field2` varchar(100) default NULL,
  `field3` varchar(100) default NULL,
  `field4` varchar(100) default NULL,
  `field5` varchar(100) default NULL,
  PRIMARY KEY  (`keyword`,`key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `sms_keyword` (
  `keyword` varchar(100) NOT NULL default '',
  `template` varchar(500) default NULL,
  PRIMARY KEY  (`keyword`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `sms_spam` (
  `sender` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`sender`)
); 

CREATE TABLE `sms_poll_main` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` text,
  `status` int(11) DEFAULT NULL,
  `limited` int(11) DEFAULT NULL,
  `open` int(11) DEFAULT NULL,
  `keyword` VARCHAR( 200 ),
  PRIMARY KEY (`id`)
);

CREATE TABLE `sms_poll_option` (
  `id` int(11) NOT NULL DEFAULT '0',
  `option` int(11) NOT NULL DEFAULT '0',
  `desc` varchar(500) DEFAULT NULL,
  `timeinsert` datetime DEFAULT NULL,
  PRIMARY KEY (`id`,`option`)
);

CREATE TABLE `sms_poll_vote` (
  `id` int(11) DEFAULT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL,
  `vote` int(11) DEFAULT NULL
);

CREATE TABLE `sms_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `template` text,
  PRIMARY KEY (`id`)
);

CREATE TABLE `sms_option` (
  `option` varchar(100) DEFAULT NULL,
  `value` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`option`)
);

CREATE TABLE `sms_birthday` (
  `phoneNumber` varchar(30) NOT NULL DEFAULT '',
  `tglkirim` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`phoneNumber`,`tglkirim`)
);

CREATE TABLE `sms_folder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `folder` varchar(200) DEFAULT NULL,
  `keywords` text,
  `autoreplystatus` int(11) DEFAULT NULL,
  `reply` text,
  PRIMARY KEY (`id`)
);

CREATE TABLE `sms_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `textdecoded` text,
  `tanggal` DATE,
  PRIMARY KEY (`id`)
); 

INSERT INTO `sms_user` VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', '1');
INSERT INTO `gammu` (`Version`) VALUES (11);
INSERT INTO `sms_option` VALUES ('sms_on', '0');
INSERT INTO `sms_option` VALUES ('sms_header', '');
INSERT INTO `sms_option` VALUES ('sms_footer', '');
