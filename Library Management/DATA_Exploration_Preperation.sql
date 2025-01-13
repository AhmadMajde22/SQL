SELECT * FROM book;
SELECT * FROM branch;
SELECT * FROM employee;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM member;

---------------------------------------------

--T1 Add new book record 

INSERT INTO Book(
	isbn,book_title,category,rental_price,status,author,publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM book;

--T2 Updating an Existing Member Address

UPDATE member
SET member_address = '125 Main St'
WHERE member_id = 'C101';
SELECT * FROM member;

--T3 Delete a Record From Issued_status

DELETE FROM issued_status
WHERE issued_id = 'IS121';
SELECT * FROM issued_status;

--T4 Retrive all books with certain employee
SELECT * FROM Issued_status
WHERE issued_emp_id = 'E101'

--T5 List Members Who have Issued More Than One Book
SELECT issued_emp_id,
COUNT(issued_id) as NO_Book
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1


--T6 CREATE TABLE As Select
CREATE TABLE book_counts
AS
SELECT b.isbn,
	   b.book_title,
	   COUNT(ist.issued_id) as no_issued
FROM Book As b
JOIN issued_status as ist
on  ist.issued_book_isbn = b.isbn 
GROUP BY b.isbn;

SELECT * FROM book_counts;


--T7 Retrieve all books in same category
SELECT * FROM Book
WHERE category = 'History';

--T8 Find Total Rental income by category
SELECT category,SUM(rental_price) as Total_Income
FROM BOOK
GROUP BY category
ORDER BY 2 DESC;

--T9 list Members Who Registerd in the last 1200 Days
SELECT * 
FROM Member
WHERE reg_date >= CURRENT_DATE - INTERVAL '1200 days';

--T10 List Employees with their Branch Manager's Name and their branch details
SELECT 
	e1.*,
	e2.emp_name as Manager,
	Branch.manager_id
FROM Employee e1
JOIN Branch 
ON Branch.branch_id = e1.branch_id
JOIN Employee e2
on e2.emp_id = Branch.manager_id

--T11 CREATE Table of books with rental price above a certain threshold
CREATE TABLE expensive_books AS
SELECT * FROM Book
WHERE rental_price > 7

SELECT * FROM expensive_books


--T12 Retrieve the List of Books Not Yet Returned
SELECT 
	iss.issued_book_name
FROM issued_status iss
LEFT JOIN return_status re
on iss.issued_id = re.issued_id
WHERE re.return_id IS  NULL

--T13 Identify Members with overdue Books
SELECT 
	M.member_id,
	M.member_name,
	iss.issued_book_name,
	iss.issued_date,
	--re.return_date,
	CURRENT_DATE - iss.issued_date as Overdue_days
	FROM Member M
JOIN issued_status iss
ON M.member_id = iss.issued_member_id
LEFT JOIN return_status re
ON re.issued_id = iss.issued_id
WHERE re.return_date IS NULL AND (CURRENT_DATE - iss.issued_date) > 280
ORDER BY 1;

--T14 Update Book status On Return
--Manually
SELECT * FROM issued_status iss
where iss.issued_book_isbn = '978-0-451-52994-2'
;

SELECT * From Book
WHERE isbn = '978-0-451-52994-2'

UPDATE book
SET status = 'no'
WHERE isbn = '978-0-451-52994-2'

SELECT * FROM return_status
WHere issued_id = 'IS130'

INSERT INTO return_status(return_id, issued_id,return_date)
VALUES ('RS125','IS130',CURRENT_DATE);

UPDATE book
SET status = 'yes'
WHERE isbn = '978-0-451-52994-2';

SELECT * From Book
WHERE isbn = '978-0-451-52994-2'

--SQL Store Procedures

CREATE OR REPLACE PROCEDURE add_return_records(
    p_return_id VARCHAR,
    p_issued_id VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
BEGIN
    -- Insert into return_status
    INSERT INTO return_status (return_id, issued_id, return_date)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE);

    -- Retrieve book details from issued_status
    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- Update book status
    UPDATE book
    SET status = 'yes'
    WHERE isbn = v_isbn;

    -- Display a notice
    RAISE NOTICE 'Thank You for Returning the book: %', v_book_name;
END;
$$;


--Testing the PLSQL
SELECT * FROM return_status;
SELECT * FROM issued_status;
SELECT * FROM book WHERE isbn ='978-0-307-58837-1';

CALL add_return_records('RS138','IS135');

SELECT * FROM return_status;
SELECT * FROM issued_status;
SELECT * FROM book WHERE isbn ='978-0-307-58837-1';

--T15 Branch Performance Report
CREATE TABLE branch_report 
AS 
SELECT 
	branch.branch_id,
	branch.manager_id,
	COUNT(iss.issued_id) as number_book_issued,
	COUNT(Re.return_id) as number_book_returned,
	SUM(Bo.rental_price) as Total_revenue
	
FROM 
	issued_status iss
JOIN 
	employee
ON 
	employee.emp_id = iss.issued_emp_id
JOIN 
	branch 
ON 
	branch.branch_id = employee.branch_id
JOIN 
	Book Bo
ON 
	Bo.isbn = iss.issued_book_isbn
LEFT JOIN 
	return_status Re
ON Re.issued_id = iss.issued_id

GROUP BY branch.branch_id,branch.manager_id;

SELECT * FROM branch_report;

--T16 Retreive active members
SELECT * FROM member
WHERE 
	member_id IN(

			SELECT  
			DISTINCT 
				issued_member_id
			FROM 
				issued_status
			WHERE 
				issued_date > CURRENT_DATE -  INTERVAL '10 MONTHS'
				);

--T17 Find Employee with Most Book Issued
SELECT Emp.emp_id,
		Emp.emp_name,
		Emp.branch_id,
		COUNT(iss.issued_id) No_Book_issued
FROM employee Emp
JOIN issued_status iss
ON iss.issued_emp_id = Emp.emp_id
GROUP BY 1,2,3
ORDER BY 4 DESC
LIMIT 3;

--T18
SELECT * FROM Book;
SELECT * FROM issued_status;

CREATE OR REPLACE PROCEDURE issue_book(
    p_issued_id VARCHAR,
    p_member_id VARCHAR,
    p_issued_book_isbn VARCHAR,
    p_emp_id VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_status VARCHAR(10);
BEGIN
    -- Fetch the status of the book
    SELECT status
    INTO v_status
    FROM book
    WHERE isbn = p_issued_book_isbn;

    -- Check if the book is available
    IF v_status = 'yes' THEN
        -- Insert the issue record
        INSERT INTO issued_status (issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES (p_issued_id, p_member_id, CURRENT_DATE, p_issued_book_isbn, p_emp_id);

        -- Update the book status to unavailable
        UPDATE book
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        -- Notify successful operation
        RAISE NOTICE 'Book records added successfully for book ISBN: %', p_issued_book_isbn;

    ELSE
        -- Notify the book is unavailable
        RAISE NOTICE 'Sorry to inform you, the book you requested is unavailable. ISBN: %', p_issued_book_isbn;
    END IF;
END;
$$;


SELECT * FROM Book
WHERE status = 'no';
SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-553-29698-2';
CALL issue_book('IS155','C108','978-0-553-29698-2','E103');
CALL issue_book('IS156','C109','978-0-375-41398-8','E104');






