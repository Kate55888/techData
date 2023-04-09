----Staging
CREATE TABLE import_csv (
	dept_code int4 NOT NULL,
	dept_name char(30) NULL,
	"location" varchar(33) NOT NULL,
	emp_code int4 NOT NULL,
	emp_first_name varchar(15) NULL,
	emp_last_name varchar(15) NULL,
	gender varchar(10) NULL,
	job varchar(45) NULL,
	hire_date date NULL,
	salary numeric(6, 2) NULL,
	commission int4 NULL
);

----department table
CREATE TABLE department (
	dept_code int4 NOT NULL,
	dept_name bpchar(30) NULL,
	"location" varchar(33) NOT NULL,
	CONSTRAINT departament_pkey PRIMARY KEY (dept_code),
	CONSTRAINT dept_unique UNIQUE (dept_name)
);

----employee table
CREATE TABLE employee (
	emp_code int4 NOT NULL,
	emp_name varchar(50) NULL,
    gender varchar(10) NULL,
	job varchar(45) NULL,
	hire_date date NULL,
	salary numeric(6, 2) NULL,
	commission int4 NULL,
	dept_code int4 NULL,
	CONSTRAINT employee_pkey PRIMARY KEY (emp_code)
);

----add FK
ALTER TABLE employee ADD CONSTRAINT employee_dept_code_fkey FOREIGN KEY (dept_code) REFERENCES department(dept_code);

INSERT INTO department (dept_code, dept_name, location)
SELECT DISTINCT dept_code, dept_name, location FROM import_csv;

INSERT INTO employee (emp_code, emp_name, gender, job, hire_date, salary, commission, dept_code)
SELECT DISTINCT emp_code, 
       CONCAT(emp_first_name, ' ', emp_last_name) as emp_name,
       CASE WHEN gender = 'M' THEN 'Male' ELSE 'Female' END as gender,
       job, hire_date, salary, commission, dept_code
FROM import_csv;

CREATE OR REPLACE FUNCTION audit_on_duplicate()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_table (table_name, pk_value, duplicate_timestamp)
    VALUES (TG_TABLE_NAME, NEW.emp_code, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_employee_duplicate
AFTER INSERT ON employee
FOR EACH ROW
WHEN EXISTS (SELECT 1 FROM employee WHERE emp_code = NEW.emp_code AND ROW(NEW.*) IS DISTINCT FROM ROW(employee.*))
EXECUTE FUNCTION audit_on_duplicate();

CREATE TRIGGER audit_department_duplicate
AFTER INSERT ON department
FOR EACH ROW
WHEN EXISTS (SELECT 1 FROM department WHERE dept_code = NEW.dept_code AND ROW(NEW.*) IS DISTINCT FROM ROW(department.*))
EXECUTE FUNCTION audit_on_duplicate();

