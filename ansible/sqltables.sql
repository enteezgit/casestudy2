
GRANT ALL PRIVILEGES ON *.* TO 'root2'@'%' IDENTIFIED BY 'pass123' WITH GRANT OPTION;


CREATE DATABASE devopsdb;

USE devopsdb;

CREATE TABLE `EMPLOYEE_LIST` (
  `emp_id` int(11) NOT NULL,
  `emp_passwd` varchar(45) DEFAULT NULL,
  `emp_name` varchar(45) NOT NULL,
  PRIMARY KEY (`emp_id`)
) ENGINE=NDBCLUSTER DEFAULT CHARSET=utf8;

CREATE TABLE `LATE_STAY_LIST` (
  `emp_id` int(11) NOT NULL,
  `emp_location` varchar(45) NOT NULL,
  PRIMARY KEY (`emp_id`),
  CONSTRAINT `LATE_STAY_LIST_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `EMPLOYEE_LIST` (`emp_id`) 
) ENGINE=NDBCLUSTER DEFAULT CHARSET=utf8;

INSERT INTO `devopsdb`.`EMPLOYEE_LIST`
(`emp_id`,
`emp_passwd`,
`emp_name`)
VALUES
(20000,
'Carol','Carol');

INSERT INTO `devopsdb`.`EMPLOYEE_LIST`
(`emp_id`,
`emp_passwd`,
`emp_name`)
VALUES
(19988,
'Valisha','Valisha');

INSERT INTO `devopsdb`.`LATE_STAY_LIST`
(`emp_id`,
`emp_location`)
VALUES
(20000,
'Margao');


 

