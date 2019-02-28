SPOOL drop_tables.sql
SELECT 'DROP TABLE '||table_name||' cascade constraints;'
FROM user_tables;
SPOOL OFF
@drop_tables

CREATE TABLE Employee (id char(20) Primary Key,
	firstName varchar(20) NOT NULL,
	lastName varchar(20) NOT NULL,
	salary decimal(11, 2),
	jobTitle varchar(20) NOT NULL,
	officeNum int,
	rank int NOT NULL,
	supervisorId char(20));

CREATE TABLE GManager (id char(20) Primary Key,
	Constraint FK_genId Foreign Key (id) References Employee (id));

CREATE TABLE DManager (id char(20) Primary Key,
	genId char(20),
	CONSTRAINT FK_divId FOREIGN KEY (id) References Employee (id),
	CONSTRAINT FK_genId2 Foreign Key (genId) References GManager (id));

CREATE TABLE REmployee (id char(20) Primary Key,
	divId char(20),
	CONSTRAINT FK_empId Foreign Key (id) References Employee (id),
	Constraint FK_divId2 Foreign Key (divId) References DManager (id));


CREATE TABLE RManagedBy (empId char(20),
	managerId char(20),
	Constraint FK_empId1 Foreign Key (empId) References REmployee (id),
	Constraint FK_divId3 Foreign Key (managerId) References DManager (id));

CREATE TABLE DManagedBy (id char(20),
	managerId char(20),
	Constraint FK_divId4 Foreign Key (id) References DManager (id),
	Constraint FK_genId3 Foreign Key (managerId) References GManager (id));

CREATE TABLE EquipmentType (typeId char(20) Primary Key,
	description varchar(50),
	model varchar(20) NOT NULL,
	instructions varchar(50),
	numberOfUnits int Default 1);

CREATE TABLE Room (roomNum int Primary Key,
	occupiedFlag int Default 0,
	Constraint occupiedFlagVal check (occupiedFlag in (0, 1)));

CREATE TABLE Equipment (serialNum char(50) Primary Key,
	typeId char(20),
	purchaseYear int,
	lastInspection date NOT NULL,
	roomNum int,
	Constraint FK_typeId Foreign Key (typeId) References EquipmentType (typeId),
	Constraint FK_roomNum5 Foreign Key (roomNum) References Room (roomNum));

CREATE TABLE IsOf (typeId char(20),
	serialNum char(50),
	Constraint FK_typeId2 Foreign Key (typeId) References EquipmentType (typeId),
	Constraint FK_serialNum2 Foreign Key (serialNum) References Equipment (serialNum));

CREATE TABLE Contain (serialNum char(50),
	roomNum int,
	Constraint FK_serialNum Foreign Key (serialNum) References Equipment (serialNum),
	Constraint FK_roomNum Foreign Key (roomNum) References Room (roomNum));

CREATE TABLE CanAccess (id char(20),
	roomNum int,
	CONSTRAINT FK_empId2 FOREIGN KEY (id) REFERENCES Employee (id),
	CONSTRAINT FK_roomNum2 FOREIGN KEY (roomNum) REFERENCES Room (roomNum));

CREATE TABLE Service (sId varchar(10) Primary Key,
	service varchar(20),
	roomNum int,
	Constraint FK_roomNum3 FOREIGN KEY (roomNum) REFERENCES Room (roomNum));

CREATE TABLE Patient (patientSsn char(11) Primary Key,
	firstName varchar(20) NOT NULL,
	lastName varchar(20) NOT NULL,
	address varchar(30),
	telNum varchar(12));

CREATE TABLE Admission (admissionNum int Primary Key,
	admissionDate date NOT NULL,
	leaveDate date,
	totalPayment decimal(11,2) NOT NULL,
	insurancePayment decimal(11, 2) NOT NULL,
	patientSsn char(11),
	futureVisit date,
	CONSTRAINT FK_patientSsn FOREIGN KEY (patientSsn) REFERENCES Patient (patientSsn));

CREATE TABLE StayIn (roomNum int,
	admissionNum int,
	startDate date,
	endDate date,
	CONSTRAINT FK_roomNum4 FOREIGN KEY (roomNum) REFERENCES Room (roomNum),
	CONSTRAINT FK_admissionNum FOREIGN KEY (admissionNum) REFERENCES Admission (admissionNum));

CREATE TABLE Doctor (docId char(20) Primary Key,
	gender char(1),
	specialty varchar(20),
	firstName varchar(20) NOT NULL,
	lastName varchar(20) NOT NULL,
	Constraint genderVal check (gender in ('M', 'F')));

CREATE TABLE Examine (admissionNum int Unique,
	docId char(20),
	comm varchar(20),
	CONSTRAINT FK_admissionNum2 FOREIGN KEY (admissionNum) REFERENCES Admission (admissionNum),
	CONSTRAINT FK_docId FOREIGN KEY (docId) REFERENCES Doctor (docId));

CREATE TABLE Admit (admissionNum int Unique,
	patientSsn char(11) ,
	CONSTRAINT FK_admissionNum3 FOREIGN KEY (admissionNum) REFERENCES Admission (admissionNum),
	CONSTRAINT FK_patientSsn2 FOREIGN KEY (patientSsn) References Patient (patientSsn));

INSERT INTO Patient (patientSsn, firstName, lastName, address, telNum) VALUES ('123-45-6789', 'Patient1', 'PatientLast1', '1 Sever St', 1234567890);
INSERT INTO Patient (patientSsn, firstName, lastName, address, telNum) VALUES ('123-45-6790', 'Patient2', 'PatientLast2', '2 West St', 123456891);
INSERT INTO Patient (patientSsn, firstName, lastName, address, telNum) VALUES ('123-45-6791', 'Patient3', 'PatientLast3', '3 Trowbridge St', 123456892);
INSERT INTO Patient (patientSsn, firstName, lastName, address, telNum) VALUES ('123-45-6792', 'Patient4', 'PatientLast4', '4 Elm St', 1234567893);
INSERT INTO Patient (patientSsn, firstName, lastName, address, telNum) VALUES ('111-22-3333', 'Patient5', 'PatientLast5', '5 Cedar St', 1234567894);
INSERT INTO Patient (patientSsn, firstName, lastName, address, telNum) VALUES ('123-45-6794', 'Patient6', 'PatientLast6', '6 Main St', 1234567895);
INSERT INTO Patient (patientSsn, firstName, lastName, address, telNum) VALUES ('123-45-6795', 'Patient7', 'PatientLast7', '7 Highland St', 1234567896);
INSERT INTO Patient (patientSsn, firstName, lastName, address, telNum) VALUES ('123-45-6796', 'Patient8', 'PatientLast8', '8 Park Ave', 1234567897);
INSERT INTO Patient (patientSsn, firstName, lastName, address, telNum) VALUES ('123-45-6797', 'Patient9', 'PatientLast9', '9 Salisbury St', 1234567898);
INSERT INTO Patient (patientSsn, firstName, lastName, address, telNum) VALUES ('123-45-6798', 'Patient10', 'PatientLast10', '10 Boynston St', 1234567899);

INSERT INTO Doctor (docId, gender, specialty, firstName, lastName) VALUES ('hadm9loAM6vCsb8AgDY4', 'M', 'Specialty1', 'Doctor1', 'DoctorLast1');
INSERT INTO Doctor (docId, gender, specialty, firstName, lastName) VALUES ('wr8pNxC52IIpzARMe1T2', 'M', 'Specialty2', 'Doctor2', 'DoctorLast2');
INSERT INTO Doctor (docId, gender, specialty, firstName, lastName) VALUES ('aMBVCMYhQPOIMFlKCwDv', 'M', 'Specialty3', 'Doctor3', 'DoctorLast3');
INSERT INTO Doctor (docId, gender, specialty, firstName, lastName) VALUES ('qAXXvLqdb9goxTQHIDu4', 'M', 'Specialty4', 'Doctor4', 'DoctorLast4');
INSERT INTO Doctor (docId, gender, specialty, firstName, lastName) VALUES ('hA871LEA3KyUhd0yWeeX', 'M', 'Specialty5', 'Doctor5', 'DoctorLast5');
INSERT INTO Doctor (docId, gender, specialty, firstName, lastName) VALUES ('zgxugw8O4wksYaNQNT80', 'M', 'Specialty6', 'Doctor6', 'DoctorLast6');
INSERT INTO Doctor (docId, gender, specialty, firstName, lastName) VALUES ('EZyQ7KmuOtVOUcmIAy2G', 'M', 'Specialty7', 'Doctor7', 'DoctorLast7');
INSERT INTO Doctor (docId, gender, specialty, firstName, lastName) VALUES ('KgjdzeuJfG8zOrtviSIr', 'M', 'Specialty8', 'Doctor8', 'DoctorLast8');
INSERT INTO Doctor (docId, gender, specialty, firstName, lastName) VALUES ('i2O2BfMRciOGwW5ktbpQ', 'M', 'Specialty9', 'Doctor9', 'DoctorLast9');
INSERT INTO Doctor (docId, gender, specialty, firstName, lastName) VALUES ('KzqR3UVodeu9A7SRFtLu', 'M', 'Specialty10', 'Doctor10', 'DoctorLast10');

INSERT INTO Room (roomNum, occupiedFlag) VALUES (100, 1);
INSERT INTO Room (roomNum, occupiedFlag) VALUES (101, 0);
INSERT INTO Room (roomNum, occupiedFlag) VALUES (102, 0);
INSERT INTO Room (roomNum, occupiedFlag) VALUES (103, 0);
INSERT INTO Room (roomNum, occupiedFlag) VALUES (104, 1);
INSERT INTO Room (roomNum, occupiedFlag) VALUES (105, 0);
INSERT INTO Room (roomNum, occupiedFlag) VALUES (106, 1);
INSERT INTO Room (roomNum, occupiedFlag) VALUES (107, 0);
INSERT INTO Room (roomNum, occupiedFlag) VALUES (108, 0);
INSERT INTO Room (roomNum, occupiedFlag) VALUES (109, 1);

INSERT INTO Service (sId, roomNum, service) VALUES ('a', 100, 'Service1');
INSERT INTO Service (sId, roomNum, service) VALUES ('b', 101, 'Service2');
INSERT INTO Service (sId, roomNum, service) VALUES ('c', 102, 'Service3');
INSERT INTO Service (sId, roomNum, service) VALUES ('d', 103, 'Service4');
INSERT INTO Service (sId, roomNum, service) VALUES ('g', 104, 'Service5');
INSERT INTO Service (sId, roomNum, service) VALUES ('f', 105, 'Service6');
INSERT INTO Service (sId, roomNum, service) VALUES ('t', 106, 'Service7');
INSERT INTO Service (sId, roomNum, service) VALUES ('s', 107, 'Service8');
INSERT INTO Service (sId, roomNum, service) VALUES ('r', 108, 'Service9');
INSERT INTO Service (sId, roomNum, service) VALUES ('w', 109, 'Service10');
INSERT INTO Service (sId, roomNum, service) VALUES ('y', 100, 'Service10');
INSERT INTO Service (sId, roomNum, service) VALUES ('x', 101, 'Service10');
INSERT INTO Service (sId, roomNum, service) VALUES ('z', 102, 'Service10');

INSERT INTO EquipmentType (typeId, description, model, instructions, numberOfUnits) VALUES ('MkwCxAFocW2xuQ5KhUUw', 'Description1', 'Model1', 'Instructions1', 1);
INSERT INTO EquipmentType (typeId, description, model, instructions, numberOfUnits) VALUES ('tU4B1QlhS7b1LRmcg7nS', 'Description2', 'Model2', 'Instructions2', 1);
INSERT INTO EquipmentType (typeId, description, model, instructions, numberOfUnits) VALUES ('qJKsQpqBckJRfXkR5i71', 'Description3', 'Model3', 'Instructions3', 4);

INSERT INTO Equipment (serialNum, typeId, purchaseYear, lastInspection, roomNum) VALUES ('A01-02X', 'MkwCxAFocW2xuQ5KhUUw', 2010, TO_DATE('2019-02-05', 'YYYY-MM-DD'), 100);
INSERT INTO Equipment (serialNum, typeId, purchaseYear, lastInspection, roomNum) VALUES ('29vMOG1GQCqEcebg9aQ6Aombq0587fTyvgCuWqo3462yZ4TrJ3', 'tU4B1QlhS7b1LRmcg7nS', 2011, TO_DATE('2019-02-06', 'YYYY-MM-DD'), 101);
INSERT INTO Equipment (serialNum, typeId, purchaseYear, lastInspection, roomNum) VALUES ('FeRtx1BVSHtTxWMa2luVISixIJ1uwIO7Y5tkdapGuWGLcG2jFN', 'qJKsQpqBckJRfXkR5i71', 2019, TO_DATE('2019-02-07', 'YYYY-MM-DD'), 102);
INSERT INTO Equipment (serialNum, typeId, purchaseYear, lastInspection, roomNum) VALUES ('A01-03X', 'qJKsQpqBckJRfXkR5i71', 2010, TO_DATE('2019-02-05', 'YYYY-MM-DD'), 100);
INSERT INTO Equipment (serialNum, typeId, purchaseYear, lastInspection, roomNum) VALUES ('A01-04X', 'qJKsQpqBckJRfXkR5i71', 2011, TO_DATE('2019-02-06', 'YYYY-MM-DD'), 101);
INSERT INTO Equipment (serialNum, typeId, purchaseYear, lastInspection, roomNum) VALUES ('A01-05X', 'qJKsQpqBckJRfXkR5i71', 2019, TO_DATE('2019-02-07', 'YYYY-MM-DD'), 102);

INSERT INTO IsOf (typeId, serialNum) VALUES ('MkwCxAFocW2xuQ5KhUUw', 'A01-03X');
INSERT INTO IsOf (typeId, serialNum) VALUES ('tU4B1QlhS7b1LRmcg7nS', '29vMOG1GQCqEcebg9aQ6Aombq0587fTyvgCuWqo3462yZ4TrJ3');
INSERT INTO IsOf (typeId, serialNum) VALUES ('qJKsQpqBckJRfXkR5i71', 'FeRtx1BVSHtTxWMa2luVISixIJ1uwIO7Y5tkdapGuWGLcG2jFN');

INSERT INTO Contain (serialNum, roomNum) VALUES ('A01-03X', 100);
INSERT INTO Contain (serialNum, roomNum) VALUES ('29vMOG1GQCqEcebg9aQ6Aombq0587fTyvgCuWqo3462yZ4TrJ3', 101);
INSERT INTO Contain (serialNum, roomNum) VALUES ('FeRtx1BVSHtTxWMa2luVISixIJ1uwIO7Y5tkdapGuWGLcG2jFN', 102);

INSERT INTO Admission (admissionNum, admissionDate, leaveDate, totalPayment, insurancePayment, patientSsn, futureVisit) VALUES (1, TO_DATE('2019-02-04', 'YYYY-MM-DD'), TO_DATE('2019-02-04', 'YYYY-MM-DD'), 100.50, 75.50, '123-45-6789', null);
INSERT INTO Admission (admissionNum, admissionDate, leaveDate, totalPayment, insurancePayment, patientSsn, futureVisit) VALUES (7, TO_DATE('2019-02-05', 'YYYY-MM-DD'), null, 100.50, 75.50, '123-45-6789', null);
INSERT INTO Admission (admissionNum, admissionDate, leaveDate, totalPayment, insurancePayment, patientSsn, futureVisit) VALUES (2, TO_DATE('2019-02-04', 'YYYY-MM-DD'), TO_DATE('2019-02-04', 'YYYY-MM-DD'), 250.75, 200.50, '123-45-6790', null);
INSERT INTO Admission (admissionNum, admissionDate, leaveDate, totalPayment, insurancePayment, patientSsn, futureVisit) VALUES (8, TO_DATE('2019-02-05', 'YYYY-MM-DD'), null, 250.75, 200.50, '123-45-6790', null);
INSERT INTO Admission (admissionNum, admissionDate, leaveDate, totalPayment, insurancePayment, patientSsn, futureVisit) VALUES (3, TO_DATE('2019-02-04', 'YYYY-MM-DD'), TO_DATE('2019-02-04', 'YYYY-MM-DD'), 10000.00, 100.00, '123-45-6791', null);
INSERT INTO Admission (admissionNum, admissionDate, leaveDate, totalPayment, insurancePayment, patientSsn, futureVisit) VALUES (9, TO_DATE('2019-02-05', 'YYYY-MM-DD'), null, 10000.00, 100.00, '123-45-6791', null);
INSERT INTO Admission (admissionNum, admissionDate, leaveDate, totalPayment, insurancePayment, patientSsn, futureVisit) VALUES (10, TO_DATE('2019-02-04', 'YYYY-MM-DD'), TO_DATE('2019-02-04', 'YYYY-MM-DD'), 10000.00, 100.00, '123-45-6792', null);
INSERT INTO Admission (admissionNum, admissionDate, leaveDate, totalPayment, insurancePayment, patientSsn, futureVisit) VALUES (11, TO_DATE('2019-02-05', 'YYYY-MM-DD'), null, 10000.00, 100.00, '123-45-6792', null);
INSERT INTO Admission (admissionNum, admissionDate, leaveDate, totalPayment, insurancePayment, patientSsn, futureVisit) VALUES (4, TO_DATE('2019-02-06', 'YYYY-MM-DD'), null, 25000.00, 22500.25, '111-22-3333', null);
INSERT INTO Admission (admissionNum, admissionDate, leaveDate, totalPayment, insurancePayment, patientSsn, futureVisit) VALUES (5, TO_DATE('2019-02-03', 'YYYY-MM-DD'), TO_DATE('2019-02-04', 'YYYY-MM-DD'), 100000.00, 35000.00, '111-22-3333', null);
INSERT INTO Admission (admissionNum, admissionDate, leaveDate, totalPayment, insurancePayment, patientSsn, futureVisit) VALUES (6, TO_DATE('2019-02-05', 'YYYY-MM-DD'), TO_DATE('2019-02-05', 'YYYY-MM-DD'), 100000.00, 35000.00, '111-22-3333', TO_DATE('2019-02-07', 'YYYY-MM-DD'));

INSERT INTO StayIn (roomNum, admissionNum, startDate, endDate) VALUES (100, 1, TO_DATE('2019-02-04', 'YYYY-MM-DD'), TO_DATE('2019-02-04', 'YYYY-MM-DD'));
INSERT INTO StayIn (roomNum, admissionNum, startDate, endDate) VALUES (101, 2, TO_DATE('2019-02-04', 'YYYY-MM-DD'), TO_DATE('2019-02-04', 'YYYY-MM-DD'));
INSERT INTO StayIn (roomNum, admissionNum, startDate, endDate) VALUES (102, 3, TO_DATE('2019-02-04', 'YYYY-MM-DD'), TO_DATE('2019-02-04', 'YYYY-MM-DD'));
INSERT INTO StayIn (roomNum, admissionNum, startDate, endDate) VALUES (103, 4, TO_DATE('2019-02-04', 'YYYY-MM-DD'), null);
INSERT INTO StayIn (roomNum, admissionNum, startDate, endDate) VALUES (104, 5, TO_DATE('2019-02-03', 'YYYY-MM-DD'), TO_DATE('2019-02-04', 'YYYY-MM-DD'));
INSERT INTO StayIn (roomNum, admissionNum, startDate, endDate) VALUES (105, 6, TO_DATE('2019-02-05', 'YYYY-MM-DD'), TO_DATE('2019-02-05', 'YYYY-MM-DD'));
INSERT INTO StayIn (roomNum, admissionNum, startDate, endDate) VALUES (106, 7, TO_DATE('2019-02-05', 'YYYY-MM-DD'), null);
INSERT INTO StayIn (roomNum, admissionNum, startDate, endDate) VALUES (107, 8, TO_DATE('2019-02-05', 'YYYY-MM-DD'), null);
INSERT INTO StayIn (roomNum, admissionNum, startDate, endDate) VALUES (108, 9, TO_DATE('2019-02-05', 'YYYY-MM-DD'), null);
INSERT INTO StayIn (roomNum, admissionNum, startDate, endDate) VALUES (109, 10, TO_DATE('2019-02-05', 'YYYY-MM-DD'), null);
INSERT INTO StayIn (roomNum, admissionNum, startDate, endDate) VALUES (101, 11, TO_DATE('2019-02-05', 'YYYY-MM-DD'), null);

INSERT INTO Admit (admissionNum, patientSsn) VALUES (1, '123-45-6789');
INSERT INTO Admit (admissionNum, patientSsn) VALUES (2, '123-45-6790');
INSERT INTO Admit (admissionNum, patientSsn) VALUES (3, '123-45-6791');
INSERT INTO Admit (admissionNum, patientSsn) VALUES (4, '111-22-3333');
INSERT INTO Admit (admissionNum, patientSsn) VALUES (5, '111-22-3333');
INSERT INTO Admit (admissionNum, patientSsn) VALUES (6, '111-22-3333');
INSERT INTO Admit (admissionNum, patientSsn) VALUES (7, '123-45-6789');
INSERT INTO Admit (admissionNum, patientSsn) VALUES (8, '123-45-6790');
INSERT INTO Admit (admissionNum, patientSsn) VALUES (9, '123-45-6791');
INSERT INTO Admit (admissionNum, patientSsn) VALUES (10, '123-45-6792');
INSERT INTO Admit (admissionNum, patientSsn) VALUES (11, '123-45-6792');

INSERT INTO Examine (admissionNum, docId, comm) VALUES (1, 'hadm9loAM6vCsb8AgDY4', 'Comment1');
INSERT INTO Examine (admissionNum, docId, comm) VALUES (2, 'wr8pNxC52IIpzARMe1T2', 'Comment2');
INSERT INTO Examine (admissionNum, docId, comm) VALUES (3, 'aMBVCMYhQPOIMFlKCwDv', 'Comment3');
INSERT INTO Examine (admissionNum, docId, comm) VALUES (4, 'qAXXvLqdb9goxTQHIDu4', 'Comment4');
INSERT INTO Examine (admissionNum, docId, comm) VALUES (5, 'qAXXvLqdb9goxTQHIDu4', 'Comment5');
INSERT INTO Examine (admissionNum, docId, comm) VALUES (6, 'qAXXvLqdb9goxTQHIDu4', 'Comment6');
INSERT INTO Examine (admissionNum, docId, comm) VALUES (7, 'hA871LEA3KyUhd0yWeeX', 'Comment7');
INSERT INTO Examine (admissionNum, docId, comm) VALUES (8, 'i2O2BfMRciOGwW5ktbpQ', 'Comment8');
INSERT INTO Examine (admissionNum, docId, comm) VALUES (9, 'zgxugw8O4wksYaNQNT80', 'Comment9');
INSERT INTO Examine (admissionNum, docId, comm) VALUES (10, 'EZyQ7KmuOtVOUcmIAy2G', 'Comment10');
INSERT INTO Examine (admissionNum, docId, comm) VALUES (11, 'KzqR3UVodeu9A7SRFtLu', 'Comment11');

INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('Ag0IMRo5TqmvYYDkoOTU', 'Employee1', 'EmployeeLast1', 250000.00, 'GeneralManager1', 200, 2, null);
INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('Xrm71p1RWzWNrVCwwRnc', 'Employee2', 'EmployeeLast2', 300000.00, 'GeneralManager2', 201, 2, null);
INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('NLmDUNZIifd4pqYdsa33', 'Employee3', 'EmployeeLast3', 100000.00, 'DivisionManager1', 202, 1, 'Ag0IMRo5TqmvYYDkoOTU');
INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('WJA5LNLwdvwlCJ7yQSYy', 'Employee4', 'EmployeeLast4', 150000.00, 'DivisionManager2', 203, 1, 'Ag0IMRo5TqmvYYDkoOTU');
INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('K3ngRcojM3FEGNyayyN9', 'Employee5', 'EmployeeLast5', 150000.00, 'DivisionManager3', 204, 1, 'Xrm71p1RWzWNrVCwwRnc');
INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('7nZu0Q5ByfqroYJpxZAa', 'Employee6', 'EmployeeLast6', 160000.00, 'DivisionManager4', 205, 1, 'Xrm71p1RWzWNrVCwwRnc');
INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('tPp6euuOU8w2ScNMRyOR', 'Employee7', 'EmployeeLast7', 50000.00, 'Employee1', null, 0, 'NLmDUNZIifd4pqYdsa33');
INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('JS8k370tdwFM08TnbZAn', 'Employee8', 'EmployeeLast8', 50000.00, 'Employee2', null, 0, 'NLmDUNZIifd4pqYdsa33');
INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('9MfxI2M8lonXbVt25nA4', 'Employee9', 'EmployeeLast9', 55000.00, 'Employee3', null, 0, 'NLmDUNZIifd4pqYdsa33');
INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('qAwA3ODFDs6Wssb9xiNw', 'Employee10', 'EmployeeLast10', 55000.00, 'Employee4', null, 0, 'WJA5LNLwdvwlCJ7yQSYy');
INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('mmAkkr4VgkrqoXLKO0sb', 'Employee11', 'EmployeeLast11', 60000.00, 'Employee5', null, 0, 'WJA5LNLwdvwlCJ7yQSYy');
INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('WJoN3Tshzevq2orRS17R', 'Employee12', 'EmployeeLast12', 60000.00, 'Employee6', null, 0, 'WJA5LNLwdvwlCJ7yQSYy');
INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('OhckhGot1YGO8zGFD1bg', 'Employee13', 'EmployeeLast13', 65000.00, 'Employee7', null, 0, 'K3ngRcojM3FEGNyayyN9');
INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('m8SnRim5IWusfLGRfTgy', 'Employee14', 'EmployeeLast14', 65000.00, 'Employee8', null, 0, 'K3ngRcojM3FEGNyayyN9');
INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('2rnUzpS4OL5MoHhfjHGM', 'Employee15', 'EmployeeLast15', 70000.00, 'Employee9', null, 0, '7nZu0Q5ByfqroYJpxZAa');
INSERT INTO Employee (id, firstName, lastName, salary, jobTitle, officeNum, rank, supervisorId) VALUES ('dr2ufUNit4bZcfYNYecq', 'Employee16', 'EmployeeLast16', 70000.00, 'Employee10', null, 0, '7nZu0Q5ByfqroYJpxZAa');

INSERT INTO GManager (id) VALUES ('Ag0IMRo5TqmvYYDkoOTU');
INSERT INTO GManager (id) VALUES ('Xrm71p1RWzWNrVCwwRnc');

INSERT INTO DManager (id, genId) VALUES ('NLmDUNZIifd4pqYdsa33', 'Ag0IMRo5TqmvYYDkoOTU');
INSERT INTO DManager (id, genId) VALUES ('WJA5LNLwdvwlCJ7yQSYy', 'Ag0IMRo5TqmvYYDkoOTU');
INSERT INTO DManager (id, genId) VALUES ('K3ngRcojM3FEGNyayyN9', 'Xrm71p1RWzWNrVCwwRnc');
INSERT INTO DManager (id, genId) VALUES ('7nZu0Q5ByfqroYJpxZAa', 'Xrm71p1RWzWNrVCwwRnc');

INSERT INTO DManagedBy (id, managerId) VALUES ('NLmDUNZIifd4pqYdsa33', 'Ag0IMRo5TqmvYYDkoOTU');
INSERT INTO DManagedBy (id, managerId) VALUES ('WJA5LNLwdvwlCJ7yQSYy', 'Ag0IMRo5TqmvYYDkoOTU');
INSERT INTO DManagedBy (id, managerId) VALUES ('K3ngRcojM3FEGNyayyN9', 'Xrm71p1RWzWNrVCwwRnc');
INSERT INTO DManagedBy (id, managerId) VALUES ('7nZu0Q5ByfqroYJpxZAa', 'Xrm71p1RWzWNrVCwwRnc');

INSERT INTO REmployee (id, divId) VALUES ('tPp6euuOU8w2ScNMRyOR', 'NLmDUNZIifd4pqYdsa33');
INSERT INTO REmployee (id, divId) VALUES ('JS8k370tdwFM08TnbZAn', 'NLmDUNZIifd4pqYdsa33');
INSERT INTO REmployee (id, divId) VALUES ('9MfxI2M8lonXbVt25nA4', 'NLmDUNZIifd4pqYdsa33');
INSERT INTO REmployee (id, divId) VALUES ('qAwA3ODFDs6Wssb9xiNw', 'WJA5LNLwdvwlCJ7yQSYy');
INSERT INTO REmployee (id, divId) VALUES ('mmAkkr4VgkrqoXLKO0sb', 'WJA5LNLwdvwlCJ7yQSYy');
INSERT INTO REmployee (id, divId) VALUES ('WJoN3Tshzevq2orRS17R', 'WJA5LNLwdvwlCJ7yQSYy');
INSERT INTO REmployee (id, divId) VALUES ('OhckhGot1YGO8zGFD1bg', 'K3ngRcojM3FEGNyayyN9');
INSERT INTO REmployee (id, divId) VALUES ('m8SnRim5IWusfLGRfTgy', 'K3ngRcojM3FEGNyayyN9');
INSERT INTO REmployee (id, divId) VALUES ('2rnUzpS4OL5MoHhfjHGM', '7nZu0Q5ByfqroYJpxZAa');
INSERT INTO REmployee (id, divId) VALUES ('dr2ufUNit4bZcfYNYecq', '7nZu0Q5ByfqroYJpxZAa');

INSERT INTO RManagedBy (empId, managerId) VALUES ('tPp6euuOU8w2ScNMRyOR', 'NLmDUNZIifd4pqYdsa33');
INSERT INTO RManagedBy (empId, managerId) VALUES ('JS8k370tdwFM08TnbZAn', 'NLmDUNZIifd4pqYdsa33');
INSERT INTO RManagedBy (empId, managerId) VALUES ('9MfxI2M8lonXbVt25nA4', 'NLmDUNZIifd4pqYdsa33');
INSERT INTO RManagedBy (empId, managerId) VALUES ('qAwA3ODFDs6Wssb9xiNw', 'WJA5LNLwdvwlCJ7yQSYy');
INSERT INTO RManagedBy (empId, managerId) VALUES ('mmAkkr4VgkrqoXLKO0sb', 'WJA5LNLwdvwlCJ7yQSYy');
INSERT INTO RManagedBy (empId, managerId) VALUES ('WJoN3Tshzevq2orRS17R', 'WJA5LNLwdvwlCJ7yQSYy');
INSERT INTO RManagedBy (empId, managerId) VALUES ('OhckhGot1YGO8zGFD1bg', 'K3ngRcojM3FEGNyayyN9');
INSERT INTO RManagedBy (empId, managerId) VALUES ('m8SnRim5IWusfLGRfTgy', 'K3ngRcojM3FEGNyayyN9');
INSERT INTO RManagedBy (empId, managerId) VALUES ('2rnUzpS4OL5MoHhfjHGM', '7nZu0Q5ByfqroYJpxZAa');
INSERT INTO RManagedBy (empId, managerId) VALUES ('dr2ufUNit4bZcfYNYecq', '7nZu0Q5ByfqroYJpxZAa');

INSERT INTO CanAccess (id, roomNum) VALUES ('tPp6euuOU8w2ScNMRyOR', 100);
INSERT INTO CanAccess (id, roomNum) VALUES ('JS8k370tdwFM08TnbZAn', 101);
INSERT INTO CanAccess (id, roomNum) VALUES ('9MfxI2M8lonXbVt25nA4', 102);
INSERT INTO CanAccess (id, roomNum) VALUES ('qAwA3ODFDs6Wssb9xiNw', 103);
INSERT INTO CanAccess (id, roomNum) VALUES ('mmAkkr4VgkrqoXLKO0sb', 104);
INSERT INTO CanAccess (id, roomNum) VALUES ('WJoN3Tshzevq2orRS17R', 105);
INSERT INTO CanAccess (id, roomNum) VALUES ('OhckhGot1YGO8zGFD1bg', 106);
INSERT INTO CanAccess (id, roomNum) VALUES ('m8SnRim5IWusfLGRfTgy', 107);
INSERT INTO CanAccess (id, roomNum) VALUES ('2rnUzpS4OL5MoHhfjHGM', 108);
INSERT INTO CanAccess (id, roomNum) VALUES ('dr2ufUNit4bZcfYNYecq', 109);

/* PHASE 3 */

/*Part 1: Creating Views*/

/* CriticalCases selects patients admitted to ICU at least twice */
CREATE OR REPLACE VIEW CriticalCases AS
SELECT patientSsn AS Patient_SSN, firstName, lastName, totalAdmissions AS numberOfAdmissionsToICU
FROM Patient NATURAL JOIN (
	SELECT patientSsn, COUNT(*) AS totalAdmissions
	FROM Admission NATURAL JOIN (
		SELECT admissionNum
		FROM StayIn NATURAL JOIN (
			SELECT roomNum
			FROM Service
			WHERE sId = 'ICU'))
	GROUP BY patientSsn)
WHERE totalAdmissions > 2;

/* DoctorsLoad reports if doctor is underloaded (<= 10 patients) or overloaded (> 10 patients) */
CREATE OR REPLACE VIEW DoctorsLoad AS
SELECT docId AS DoctorID, gender, 'Underloaded' AS load
FROM Doctor NATURAL JOIN (
	SELECT docId, COUNT(admissionNum) AS admissionCount
	FROM Examine
	GROUP BY docId)
WHERE admissionCount <= 10
UNION
(SELECT docId AS DoctorID, gender, 'Overloaded' AS load
	FROM Doctor NATURAL JOIN (
		SELECT docId, COUNT(admissionNum) AS admissionCount
		FROM Examine
		GROUP BY docId)
	WHERE admissionCount > 10);

/* report of patients with > 4 ICU visits */
SELECT *
FROM CriticalCases
WHERE numberOfAdmissionsToICU > 4;

/* report female overloaded doctors */
SELECT Doctor.docId, Doctor.firstName, Doctor.lastName
FROM DoctorsLoad, Doctor
WHERE DoctorsLoad.DoctorId = Doctor.docId AND DoctorsLoad.gender = 'F' AND DoctorsLoad.load = 'Overloaded';

/* report comments from underloaded doctors of patients in the ICU */
SELECT DoctorsLoad.DoctorId, Admission.patientSsn, Examine.comm
FROM DoctorsLoad, CriticalCases, Admission, Examine
WHERE DoctorsLoad.DoctorId = Examine.docId AND Examine.admissionNum = Admission.admissionNum AND CriticalCases.Patient_SSN = Admission.patientSsn;

/* Problem 2: Creating Triggers */

/* LeaveComment ensures a comment is left for when a doctor examines a patient in the ICU */
CREATE OR REPLACE TRIGGER LeaveComment
BEFORE INSERT OR UPDATE ON Examine
FOR EACH ROW
DECLARE temp NUMBER := 0;
Begin
SELECT count(*) INTO temp
FROM Service, StayIn, Examine
WHERE :new.admissionNum = StayIn.admissionNum
AND StayIn.roomNum = Service.roomNum
AND Service.service = 'ICU';
IF(temp != 0 AND :new.comm = null) Then
RAISE_APPLICATION_ERROR(-20004, 'Comment cannot be null');
END IF;
END;
/

/* InsurancePercentage ensures that the insurance payment is always 65% of the total payment */
CREATE OR REPLACE TRIGGER InsurancePercentage
BEFORE INSERT OR UPDATE ON Admission
FOR EACH ROW
Begin
:new.insurancePayment := (:new.totalPayment * .65);
END;
/

/* RegularSupervisor ensures employees with rank 0 have supervisors as rank 1 */
CREATE OR REPLACE TRIGGER RegularSupervisor
BEFORE INSERT OR UPDATE ON Employee
FOR EACH ROW
WHEN (new.rank = 0)
DECLARE managerRank NUMBER := 1;
Begin
SELECT rank INTO managerRank FROM Employee WHERE id = :new.supervisorId;
IF(managerRank != 1) Then
RAISE_APPLICATION_ERROR(-20004, 'Employee with rank 0 must have supervisor with rank 1');
END IF;
END;
/

/* DivisionSupervisor ensures employees with rank 1 have supervisors as rank 2 */
CREATE OR REPLACE TRIGGER DivisionSupervisor
AFTER INSERT OR UPDATE ON Employee
FOR EACH ROW
WHEN (new.rank = 1)
DECLARE managerRank NUMBER := 2;
Begin
SELECT rank INTO managerRank FROM Employee WHERE id = :new.supervisorId;
IF(managerRank != 2) Then
RAISE_APPLICATION_ERROR(-20004, 'Employee with rank 1 must have supervisor with rank 2');
END IF;
END;
/

/* EmergencyAdmission ensures patients in rooms with emergency service have a future visit date of 2 months in advance */
CREATE OR REPLACE TRIGGER EmergencyAdmission
BEFORE INSERT ON StayIn
FOR EACH ROW
DECLARE roomType varchar(20);
aDate date;
Begin
SELECT Service.service, Admission.admissionDate INTO roomType, aDate
FROM Admission, Service, StayIn
WHERE :new.admissionNum = Admission.admissionNum
AND :new.roomNum = Service.roomNum
AND Service.service = 'Emergency';
IF(roomType != null) Then
UPDATE Admission SET futureVisit = ADD_MONTHS(aDate, 2) WHERE admissionNum = :new.admissionNum; 
END IF;
END;
/

/* EquipmentYearCheck ensures that the purchase year cannot be null or prior to 2007 for CT scanners and ultrasound equipment */
CREATE OR REPLACE TRIGGER EquipmentYearCheck
BEFORE INSERT OR UPDATE ON Equipment
FOR EACH ROW
Begin
IF(:new.typeId = 'CT Scanner' OR :new.typeId = 'Ultrasound') Then
IF(:new.purchaseYear = null OR :new.purchaseYear < 2007) Then
RAISE_APPLICATION_ERROR(-20004, 'Purchase year of CT Scanner or Ultrasound is either null or was not purchased after 2006');
END IF;
END IF;
END;
/

/* PrintPatientOnCheckout prints the patients information when checking out */
CREATE OR REPLACE TRIGGER PrintPatientOnCheckout
AFTER UPDATE ON Admission
FOR EACH ROW
DECLARE CURSOR doctorList IS SELECT Doctor.firstName, Doctor.lastName, Examine.comm FROM Doctor, Examine WHERE Doctor.docId = Examine.docId AND :new.admissionNum = Examine.admissionNum;

pfName varchar(20);
plName varchar(20);
pAddress varchar(40);
curDoctor doctorList%ROWTYPE;

BEGIN
SELECT Patient.firstName, Patient.lastName, Patient.address INTO pfName, plName, pAddress
FROM Patient
WHERE Patient.patientSsn = :new.patientSsn;

OPEN doctorList;
LOOP
FETCH doctorList INTO curDoctor;
EXIT WHEN doctorList%NOTFOUND;
dbms_output.put_line(pfName);
dbms_output.put_line(plName);
dbms_output.put_line(pAddress);
dbms_output.put_line(curDoctor.firstName);
dbms_output.put_line(curDoctor.lastName);
dbms_output.put_line(curDoctor.comm);
END LOOP;
CLOSE doctorList;
END;
/