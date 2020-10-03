-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "titles" (
    "emp_title_id" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "emp_title_id"
     )
);

CREATE TABLE "departments" (
    "dept_no" varchar   NOT NULL,
    "dept_name" varchar   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "manager_dep" (
    "dept_no" varchar   NOT NULL,
    "emp_no" int   NOT NULL,
    CONSTRAINT "pk_manager_dep" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" varchar   NOT NULL,
    "birth_date" varchar   NOT NULL,
    "first_name" varchar   NOT NULL,
    "last_name" varchar   NOT NULL,
    "sex" varchar   NOT NULL,
    "hire_date" varchar   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" varchar   NOT NULL,
	--------------------------------------------created a compositkey---
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no",
		"dept_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_titles_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("emp_title_id");

ALTER TABLE "manager_dep" ADD CONSTRAINT "fk_departments_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");


ALTER TABLE "manager_dep" ADD CONSTRAINT "fk_employees_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");
------------------------------------------Importing CSV'-------------------
COPY departments FROM 'C:\Users\sharr\OneDrive\Desktop\Temporary\departments.csv' DELIMITER ',' CSV HEADER;
COPY dept_emp FROM 'C:\Users\sharr\OneDrive\Desktop\Temporary\dept_emp.csv' DELIMITER ',' CSV HEADER;
COPY employees FROM 'C:\Users\sharr\OneDrive\Desktop\Temporary\employees.csv' DELIMITER ',' CSV HEADER;
COPY manager_dep FROM 'C:\Users\sharr\OneDrive\Desktop\Temporary\manager_dep.csv' DELIMITER ',' CSV HEADER;
COPY salaries FROM 'C:\Users\sharr\OneDrive\Desktop\Temporary\salaries.csv' DELIMITER ',' CSV HEADER;
COPY titles FROM 'C:\Users\sharr\OneDrive\Desktop\Temporary\titles.csv' DELIMITER ',' CSV HEADER;
-------------------------------------------Checking all coloumn's and rows in tables-------------- 
select * from departments
select * from dept_emp
select * from employees
select * from manager_dep
select * from salaries
select * from titles
---------1)------List the following details of each employee: employee number, last name, first name, sex, and salary
select e.emp_no, e.last_name, e.first_name, e.sex ,s.salary 
	from employees e, salaries s
	where e.emp_no = s.emp_no;
-------1)using Joins----	
	select e.emp_no, e.last_name, e.first_name, e.sex ,s.salary 
	from employees e join salaries s
	on e.emp_no = s.emp_no;
	
	
---------2)------List first name, last name, and hire date for employees who were hired in 1986.
select first_name,last_name,hire_date 
	from employees 
	where hire_date like '%1986%';
	
	
---------3)------List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
select D.dept_no, D.dept_name,M_D.emp_no, e.last_name, e.first_name
	from departments D,manager_dep M_D,employees e
	where D.dept_no=M_D.dept_no and M_D.emp_no=e.emp_no;
--------3)--using joins------	
	select D.dept_no, D.dept_name,M_D.emp_no, e.last_name, e.first_name
	from departments D join manager_dep M_D
						on D.dept_no=M_D.dept_no 
						join employees e
						on M_D.emp_no=e.emp_no;
	
	
---------4)------List the department of each employee with the following information: employee number, last name, first name, and department name.
select e.emp_no, e.last_name, e.first_name, D.dept_name, D_E.dept_no
	from employees e,departments D,dept_emp D_E
	where e.emp_no=D_E.emp_no and D_E.dept_no=D.dept_no;
---------4)-------using joins---
select e.emp_no, e.last_name, e.first_name, D.dept_name, D_E.dept_no
	from employees e 
	Join dept_emp D_E  on e.emp_no=D_E.emp_no
	join departments D on D_E.dept_no=D.dept_no 
	;
	
	
---------5)------List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
select first_name, last_name, sex
	from employees
	where first_name = 'Hercules'
	and last_name like 'B%';
	
	
---------6)------List all employees in the Sales department, including their employee number, last name, first name, and department name
select e.emp_no, e.last_name, e.first_name, D.dept_name, D_E.dept_no
	from employees e,departments D,dept_emp D_E
	where E.emp_no=D_E.emp_no and D_E.dept_no=D.dept_no and D.dept_name ='Sales' ;
---------6)using joins------
select e.emp_no, e.last_name, e.first_name, D.dept_name, D_E.dept_no
	from departments D
	join dept_emp D_E on D_E.dept_no=D.dept_no
	join employees e on E.emp_no=D_E.emp_no 
	where D.dept_name ='Sales' ;
			
			
---------7)------List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
select e.emp_no, e.last_name, e.first_name, D.dept_name, D_E.dept_no
 from employees e,departments D,dept_emp D_E
 where e.emp_no=D_E.emp_no and D_E.dept_no=D.dept_no and (D.dept_name ='Sales' or D.dept_name ='Development');
 
---------8)------In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
select last_name, count(1)
from employees 
group by last_name 
ORDER BY
	last_name DESC;