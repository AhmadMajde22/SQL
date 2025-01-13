-- Library Managment System

-- create branch table
DROP TABLE IF EXISTS branch;
CREATE Table Branch(
	branch_id VARCHAR(10) PRIMARY KEY,
	manager_id VARCHAR(10),
	branch_address VARCHAR(55),
	contact_no VARCHAR(50)
);
-- create Employee table
DROP TABLE IF EXISTS employee;
CREATE TABLE Employee(
	emp_id VARCHAR(10) PRIMARY KEY,
	emp_name VARCHAR(25),
	position VARCHAR(25),
	salary INT,
	branch_id VARCHAR(10)
);
-- create Book table
DROP TABLE IF EXISTS book;
CREATE TABLE Book(
	isbn VARCHAR(20) PRIMARY KEY,
	book_title VARCHAR(75),
	category VARCHAR(30),
	rental_price FLOAT,
	status VARCHAR(15),
	author VARCHAR(35),
	publisher VARCHAR(55)
);
-- create Member table
DROP TABLE IF EXISTS member;
CREATE TABLE Member(
	member_id VARCHAR(10) PRIMARY KEY,
	member_name VARCHAR(25),
	member_address VARCHAR(75),
	reg_date DATE	
);
-- create issued_status table
DROP TABLE IF EXISTS issued_status;
CREATE TABLE Issued_Status(
	issued_id VARCHAR(10) PRIMARY KEY,
	issued_member_id VARCHAR(10),
	issued_book_name VARCHAR(75),
	issued_date DATE,
	issued_book_isbn VARCHAR(25),
	issued_emp_id VARCHAR(10)
);
-- create return_status table
DROP TABLE IF EXISTS Return_Status;
CREATE TABLE Return_Status(
	return_id VARCHAR(10) PRIMARY KEY,
	issued_id VARCHAR(10),
	return_book_name VARCHAR(75),
	return_date DATE,
	return_book_isbn VARCHAR(20)
);



-- DATA Modeling
ALTER TABLE issued_status
ADD CONSTRAINT FK_Member
FOREIGN KEY (issued_member_id)
REFERENCES Member(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT FK_Book
FOREIGN KEY (issued_book_isbn)
REFERENCES Book(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT FK_Employee
FOREIGN KEY (issued_emp_id)
REFERENCES Employee(emp_id);

ALTER TABLE employee
ADD CONSTRAINT FK_Branch
FOREIGN KEY (branch_id)
REFERENCES Branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT FK_Issued_Status
FOREIGN KEY (issued_id)
REFERENCES Issued_Status(issued_id)















