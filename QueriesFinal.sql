-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/SPruCE
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- Modify this code to update the DB schema diagram.
-- To reset the sample schema, replace everything with
-- two dots ('..' - without quotes).

CREATE TABLE "Department" (
    "dept_no" VARCHAR(10)   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Department" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "Dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR(10)   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

-- PK is the start-end date
CREATE TABLE "Dept_manager" (
    "dept_no" VARCHAR(10)   NOT NULL,
    "emp_no" INT   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "Employees" (
    "emp_no" INT   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "gender" CHAR(1)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "emp_no"
     )
);

-- PK woild be the composite of the 4 items
CREATE TABLE "Salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

-- dont know exactly what the PK is
CREATE TABLE "Titles" (
    "emp_no" INT   NOT NULL,
    "title" VARCHAR   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

ALTER TABLE "Dept_emp" ADD CONSTRAINT "fk_Dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Dept_emp" ADD CONSTRAINT "fk_Dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Department" ("dept_no");

ALTER TABLE "Dept_manager" ADD CONSTRAINT "fk_Dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Department" ("dept_no");

ALTER TABLE "Dept_manager" ADD CONSTRAINT "fk_Dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Salaries" ADD CONSTRAINT "fk_Salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Titles" ADD CONSTRAINT "fk_Titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

--SELECT salary FROM "Salaries";
--1.List the following details of each employee: employee number, last name, first name, gender, and salary. OK
SELECT e.emp_no,
  e.last_name,
  e.first_name,
  e.gender,
  s.salary
FROM "Employees" as e
INNER JOIN "Salaries" as s ON
e.emp_no = s.emp_no;

--2.List employees who were hired in 1986. OK
SELECT emp_no, last_name, first_name, hire_date
FROM "Employees"
WHERE hire_date > '12/31/1985' and hire_date < '1/1/1987';

--3.List the manager of each department with the following information: department number, department name, 
--the manager's employee number, last name, first name, and start and end employment dates. OK
SELECT dm.dept_no, d.dept_name, dm.emp_no, 
	e.first_name, e.last_name, 
	dm.from_date, dm.to_date
FROM "Dept_manager" as dm
JOIN "Department" as d ON dm.dept_no = d.dept_no 
JOIN "Employees" as e ON dm.emp_no = e.emp_no;

--4.List the department of each employee with the following information: employee number, last name, first name, and department name -OK
SELECT e.emp_no,
  e.last_name,
  e.first_name,
  d.dept_name
FROM "Employees" as e
JOIN "Dept_emp" as dm ON dm.emp_no = e.emp_no
JOIN "Department" as d ON d.dept_no=dm.dept_no
;

--5.List all employees whose first name is "Hercules" and last names begin with "B." OK
SELECT emp_no, first_name, last_name
FROM "Employees"
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--6.List all employees in the Sales department, including their employee number, last name, first name, and department name. MISSING "SALES"
-- instead of d007, join with RIGHT department table? but where... SECOND OK, FIRST ONLY CHECK HOW TO FINISH IT WITH NAME INSTEAD OF DEPT#
SELECT "Employees".emp_no,
  "Employees".last_name,
  "Employees".first_name,
  "Department".dept_name
FROM "Dept_emp"
JOIN "Employees" ON "Employees".emp_no = "Dept_emp".emp_no
JOIN "Department" ON "Dept_emp".dept_no = "Department".dept_no
WHERE dept_name = 'Sales';

--7.List all employees in the Sales and Development departments, including their employee number, last name, 
--first name, and department name -OK
SELECT "Employees".emp_no,
  "Employees".last_name,
  "Employees".first_name,
  "Department".dept_name
FROM "Dept_emp"
JOIN "Employees" ON "Employees".emp_no = "Dept_emp".emp_no
JOIN "Department" ON "Dept_emp".dept_no = "Department".dept_no
WHERE dept_name = 'Sales' OR dept_name ='Development';

--8.In descending order, list the frequency count of employee last names, i.e., how many employees share each last name - OK

SELECT last_name as "Last Name", COUNT(last_name) AS "Last Name Count"
FROM "Employees"
GROUP BY last_name 
ORDER BY "Last Name Count" DESC;


