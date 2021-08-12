CREATE TABLE `tbl_emp` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`name` varchar(20) DEFAULT NULL,
`deptId` int(11) DEFAULT NULL,
PRIMARY KEY (`id`) ,
KEY `fk_dept_id`(`deptId`)
)ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8;

CREATE TABLE `tbl_dept` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`deptName` varchar(30) DEFAULT NULL,
`locAdd` varchar(40) DEFAULT NULL,
PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8;


insert into tbl_dept(deptName,locAdd) values('RD','11');
insert into tbl_dept(deptName,locAdd) values('HR','12');
insert into tbl_dept(deptName,locAdd) values('MK','13');
insert into tbl_dept(deptName,locAdd) values('MIS','14');
insert into tbl_dept(deptName,locAdd) values('FD','15');

insert into tbl_emp(name,deptId) values('z3',1);
insert into tbl_emp(name,deptId) values('z4',1);
insert into tbl_emp(name,deptId) values('z5',1);
insert into tbl_emp(name,deptId) values('w5',2);
insert into tbl_emp(name,deptId) values('w6',2);
insert into tbl_emp(name,deptId) values('s7',3);
insert into tbl_emp(name,deptId) values('s8',4);
insert into tbl_emp(name,deptId) values('s9',51);