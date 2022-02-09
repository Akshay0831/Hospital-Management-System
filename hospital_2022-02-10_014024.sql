/*!40101 SET NAMES utf8 */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ hospital /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE hospital;

DROP TABLE IF EXISTS admin;
CREATE TABLE `admin` (
  `mailId` varchar(30) NOT NULL,
  `passwd` varchar(30) DEFAULT NULL,
  `adminName` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`mailId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS appointment;
CREATE TABLE `appointment` (
  `mailId` varchar(30) NOT NULL,
  `appointmentDate` date NOT NULL,
  `docMailId` varchar(30) NOT NULL,
  PRIMARY KEY (`mailId`,`appointmentDate`,`docMailId`),
  KEY `docMailId` (`docMailId`),
  CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`mailId`) REFERENCES `patient` (`mailId`) ON DELETE CASCADE,
  CONSTRAINT `appointment_ibfk_2` FOREIGN KEY (`docMailId`) REFERENCES `doctor` (`docMailId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS diagnosis;
CREATE TABLE `diagnosis` (
  `mailId` varchar(30) NOT NULL,
  `testId` int NOT NULL,
  `testDate` date NOT NULL,
  `analysis` text,
  PRIMARY KEY (`mailId`,`testId`,`testDate`),
  KEY `testId` (`testId`),
  CONSTRAINT `diagnosis_ibfk_1` FOREIGN KEY (`testId`) REFERENCES `test` (`testId`) ON DELETE CASCADE,
  CONSTRAINT `diagnosis_ibfk_2` FOREIGN KEY (`mailId`) REFERENCES `patient` (`mailId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS doctor;
CREATE TABLE `doctor` (
  `docMailId` varchar(30) NOT NULL,
  `passwd` varchar(30) NOT NULL,
  `docName` varchar(30) NOT NULL,
  `sex` char(1) NOT NULL,
  PRIMARY KEY (`docMailId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS dosage;
CREATE TABLE `dosage` (
  `mailId` varchar(30) NOT NULL,
  `medicineId` int NOT NULL,
  `quantity` decimal(4,0) NOT NULL,
  `doseDate` date NOT NULL,
  PRIMARY KEY (`mailId`,`medicineId`,`doseDate`),
  KEY `medicineId` (`medicineId`),
  CONSTRAINT `dosage_ibfk_1` FOREIGN KEY (`medicineId`) REFERENCES `medicine` (`medicineId`) ON DELETE CASCADE,
  CONSTRAINT `dosage_ibfk_2` FOREIGN KEY (`mailId`) REFERENCES `patient` (`mailId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS medicine;
CREATE TABLE `medicine` (
  `medicineId` int NOT NULL AUTO_INCREMENT,
  `medicineName` varchar(30) NOT NULL,
  PRIMARY KEY (`medicineId`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS nurse;
CREATE TABLE `nurse` (
  `nurseId` varchar(30) NOT NULL,
  `nurseName` varchar(30) NOT NULL,
  `phoneNumber` decimal(10,0) NOT NULL,
  PRIMARY KEY (`nurseId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS nursealloc;
CREATE TABLE `nursealloc` (
  `nurseId` varchar(30) NOT NULL,
  `mailId` varchar(30) NOT NULL,
  `dateIn` date NOT NULL,
  `dateOut` date DEFAULT NULL,
  PRIMARY KEY (`mailId`,`dateIn`),
  KEY `nurseId` (`nurseId`),
  CONSTRAINT `nursealloc_ibfk_1` FOREIGN KEY (`mailId`) REFERENCES `patient` (`mailId`) ON DELETE CASCADE,
  CONSTRAINT `nursealloc_ibfk_2` FOREIGN KEY (`nurseId`) REFERENCES `nurse` (`nurseId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS patient;
CREATE TABLE `patient` (
  `mailId` varchar(30) NOT NULL,
  `passwd` varchar(30) NOT NULL,
  `Pname` varchar(30) NOT NULL,
  `dob` date NOT NULL,
  `bloodGroup` varchar(3) NOT NULL,
  `sex` char(1) NOT NULL,
  PRIMARY KEY (`mailId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS record;
CREATE TABLE `record` (
  `recordId` int NOT NULL AUTO_INCREMENT,
  `mailId` varchar(30) NOT NULL,
  `Analysis` text,
  `docMailId` varchar(30) NOT NULL,
  PRIMARY KEY (`recordId`),
  KEY `mailId` (`mailId`),
  KEY `docMailId` (`docMailId`),
  CONSTRAINT `record_ibfk_1` FOREIGN KEY (`mailId`) REFERENCES `patient` (`mailId`) ON DELETE CASCADE,
  CONSTRAINT `record_ibfk_2` FOREIGN KEY (`docMailId`) REFERENCES `doctor` (`docMailId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS test;
CREATE TABLE `test` (
  `testId` int NOT NULL AUTO_INCREMENT,
  `testName` varchar(30) NOT NULL,
  `testCategory` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`testId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE OR REPLACE VIEW `v_detailedrecords` AS select `r`.`recordId` AS `recordId`,`p`.`Pname` AS `Pname`,`r`.`mailId` AS `mailId`,`d`.`docName` AS `docName`,`r`.`docMailId` AS `docMailId`,`r`.`Analysis` AS `Analysis` from ((`record` `r` join `doctor` `d`) join `patient` `p`) where ((`r`.`docMailId` = `d`.`docMailId`) and (`r`.`mailId` = `p`.`mailId`));

CREATE OR REPLACE VIEW `v_detailedappointments` AS select `a`.`mailId` AS `mailId`,`p`.`Pname` AS `Pname`,`a`.`docMailId` AS `docMailId`,`d`.`docName` AS `docName`,`a`.`appointmentDate` AS `appointmentDate` from ((`appointment` `a` join `patient` `p`) join `doctor` `d`) where ((`a`.`mailId` = `p`.`mailId`) and (`d`.`docMailId` = `a`.`docMailId`));

INSERT INTO admin(mailId,passwd,adminName) VALUES('a1@hsptl.com','0000','Pushpa'),('a2@hsp.com','0000','Rocky'),('a3@hsptl.com','0000','Ram');

INSERT INTO appointment(mailId,appointmentDate,docMailId) VALUES('1@hsptl.com','2022-03-12','dr1@hsptl.com'),('2@hsptl.com','2022-03-12','dr1@hsptl.com'),('1@hsptl.com','2022-04-01','dr2@hsptl.com');

INSERT INTO diagnosis(mailId,testId,testDate,analysis) VALUES('0@hsptl.com',1,'2022-02-04',X'50617469656e74206d617920657870657269656e63652074697265646e6573732c206661696e74696e6720616e64206d617920676574206672657175656e74206d79677261696e65732064756520746f206c6f776572207175616e746974696573206f66206861656d6f676c6f62696e2e205265636f6d6d656e6420746f2074616b652069726f6e20737570706c656d656e7473'),('1@hsptl.com',3,'2022-02-06',X'412053747265737320467261637475726520697320666f756e64206174206d6964646c65206f66207468652066656d75722e2053696e636520746865206672616374757265206973206e6f74207365766572652063617374206d6179206e6f7420626520726571756972656420627574207468652070617469656e74206d7573742072656d61696e2063617574696f75732e');

INSERT INTO doctor(docMailId,passwd,docName,sex) VALUES('dr1@hsptl.com','0000','Preethi','F'),('dr2@hsptl.com','0000','Shreesha','M'),('dr3@hsptl.com','0000','Varun','M'),('dr4@hsptl.com','0000','Suhas','M'),('dr5@hsptl.com','0000','Jessie','F'),('dr6@hsptl.com','0000','James','M'),('dr7@hsptl.com','0000','Norn','F'),('dr8@hsptl.com','0000','Naveen','M'),('pk@hsptl.com','0000','Prajwal Kulkarni','M');

INSERT INTO dosage(mailId,medicineId,quantity,doseDate) VALUES('0@hsptl.com',4,50,'2022-02-04'),('1@hsptl.com',8,100,'2022-02-06');

INSERT INTO medicine(medicineId,medicineName) VALUES(1,'Phenolphatline'),(2,'Paracetomal'),(3,'Lysonamic'),(4,'Aquathacin'),(5,'Amioramine'),(6,'Caffeicor'),(7,'Fragnuma'),(8,'Vitrarabine');

INSERT INTO nurse(nurseId,nurseName,phoneNumber) VALUES('n0@hp.com','Manasa',9247775899),('n1@hp.com','Anagha',9246665899),('n2@hp.com','Jothi',9245555899),('n3@hp.com','Emily',9244445899),('n4@hp.com','Shivani',9241115899),('n5@hp.com','Dia',9274775899),('n6@hp.com','Demetria',9249975899),('n7@hp.com','Sabina',9247775999);

INSERT INTO nursealloc(nurseId,mailId,dateIn,dateOut) VALUES('n0@hp.com','0@hsptl.com','2022-02-06','2022-02-18'),('n1@hp.com','1@hsptl.com','2022-02-09','2022-02-19');

INSERT INTO patient(mailId,passwd,Pname,dob,bloodGroup,sex) VALUES('0@hsptl.com','0000','Abhay','1988-09-05','O+','M'),('1@hsptl.com','0000','John','1995-11-14','O+','M'),('2@hsptl.com','0000','Dubravka','1998-06-26','B+','M'),('3@hsptl.com','0000','Fabio','2007-05-22','O+','F'),('4@hsptl.com','0000','Freddy','2007-05-22','O+','M'),('5@hsptl.com','0000','Roxy','1972-11-04','AB+','F'),('6@hsptl.com','0000','Rohan','1977-10-18','B+','M'),('7@hsptl.com','0000','Arjun','1975-10-15','A+','M'),('8@hsptl.com','0000','Ajay','1976-11-27','O+','M'),('9@hsptl.com','0000','Sankalp','1983-11-08','O+','F');

INSERT INTO record(recordId,mailId,Analysis,docMailId) VALUES(1,'0@hsptl.com',X'5468652050617469656e742069732066696e65','dr1@hsptl.com'),(2,'1@hsptl.com',X'5468652050617469656e7420506879736963616c6c792066696e652c206275742072657175697265732070737963686f6c6f676963616c2074686572617079','dr2@hsptl.com');

INSERT INTO test(testId,testName,testCategory) VALUES(1,'Haemoglobin','Blood'),(2,'Cranium','CT'),(3,'Femur','X-Ray'),(4,'Brain Scan','MRI'),(5,'Sugar','Blood');DROP PROCEDURE IF EXISTS checkAppointment;

DELIMITER $$
CREATE PROCEDURE `checkAppointment`(IN doctor_mail varchar(30), IN mail_id VARCHAR(30), IN appointment_date DATE)
BEGIN
IF NOT EXISTS
((SELECT docMailId FROM appointment WHERE docMailId=doctor_mail AND appointmentDate=appointment_date HAVING COUNT(docMailId)>=15)
UNION
(SELECT docMailId FROM appointment WHERE appointmentDate=appointment_date AND mailId=mail_id)) THEN
INSERT INTO appointment(mailId, appointmentDate, docMailId) VALUES(mail_id, appointment_date, doctor_mail);
ELSE
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'ERROR: Appointment Not Possible!';
END IF;
END; $$

CREATE TRIGGER CheckNurseAllocAdd BEFORE INSERT ON nursealloc
FOR EACH ROW
BEGIN
IF EXISTS(SELECT * FROM nursealloc WHERE mailId = NEW.mailId OR nurseId=NEW.nurseId AND dateIn<=NEW.dateIn AND dateOut>=NEW.dateOut) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'ERROR: Nurse Already Allocatied!';
END IF;
END; $$
DELIMITER ;