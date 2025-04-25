member 테이블 생성

CREATE TABLE `t_member` (
  `userid` varchar(100) NOT NULL,
  `passwd` varchar(255) DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `loginTime` datetime DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `detailAddress` varchar(255) DEFAULT NULL,
  `fullAddress` varchar(500) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `regDate` datetime DEFAULT current_timestamp(),
  `updateDate` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `role` varchar(20) DEFAULT 'USER',
  `login_fail_count` int(11) DEFAULT 0,
  `account_locked` tinyint(1) DEFAULT 0,
  `social_type` varchar(20) DEFAULT 'normal',
  `naver_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`userid`)
)

board 테이블 생성

CREATE TABLE `t_board` (
  `bno` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `writer` varchar(100) DEFAULT NULL,
  `passwd` varchar(100) NOT NULL,
  `regDate` datetime DEFAULT current_timestamp(),
  `viewCount` int(11) DEFAULT 0,
  `nickName` varchar(50) DEFAULT NULL,
  `isPrivate` varchar(1) NOT NULL,
  PRIMARY KEY (`bno`),
  KEY `fk_writer` (`writer`),
  CONSTRAINT `fk_writer` FOREIGN KEY (`writer`) REFERENCES `t_member` (`userid`)
)