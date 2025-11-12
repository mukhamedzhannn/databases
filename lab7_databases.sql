--Part 2:

--Ex 2.1:
create view employee_details as
select e.emp_name, e.salary, d.dept_name, d.location
from employees e
inner join departments d on e.dept_id = d.dept_id;

--Ex 2.2:
create view dept_statistics as
select 
    d.dept_name,
    count(e.emp_id) as employee_count,
    avg(e.salary) as avg_salary,
    max(e.salary) as max_salary,
    min(e.salary) as min_salary
from departments d
left join employees e on d.dept_id = e.dept_id
group by d.dept_name;

--Ex 2.3:
create view project_overview as
select 
    p.project_name,
    p.budget,
    d.dept_name,
    d.location,
    count(e.emp_id) as team_size
from projects p
left join departments d on p.dept_id = d.dept_id
left join employees e on d.dept_id = e.dept_id
group by p.project_name, p.budget, d.dept_name, d.location;

--Ex 2.4:
create view high_earners as
select e.emp_name, e.salary, d.dept_name
from employees e
inner join departments d on e.dept_id = d.dept_id
where e.salary > 55000;

--Part 3:

--Ex 3.1:
create or replace view employee_details as
select 
    e.emp_name,
    e.salary,
    d.dept_name,
    d.location,
    case 
        when e.salary > 60000 then 'High'
        when e.salary > 50000 then 'Medium'
        else 'Standard'
    end as salary_grade
from employees e
inner join departments d on e.dept_id = d.dept_id;

--Ex 3.2:
alter view high_earners rename to top_performers;

--Ex 3.3:
create view temp_view as
select * from employees
where salary < 50000;

drop view temp_view;

--Part 4:

--Ex 4.1:
create view employee_salaries as
select emp_id, emp_name, dept_id, salary
from employees;

--Ex 4.2:
update employee_salaries
set salary = 52000
where emp_name = 'John Smith';

--Ex 4.3:
insert into employee_salaries (emp_id, emp_name, dept_id, salary)
values (6, 'Alice Johnson', 102, 58000);

--Ex 4.4:
create view it_employees as
select emp_id, emp_name, dept_id, salary
from employees
where dept_id = 101
with local check option;

-- This should fail
insert into it_employees (emp_id, emp_name, dept_id, salary)
values (7, 'Bob Wilson', 103, 60000);

--Part 5:

--Ex 5.1:
create materialized view dept_summary_mv as
select 
    d.dept_id,
    d.dept_name,
    count(e.emp_id) as total_employees,
    coalesce(sum(e.salary), 0) as total_salaries,
    count(p.project_id) as total_projects,
    coalesce(sum(p.budget), 0) as total_budget
from departments d
left join employees e on d.dept_id = e.dept_id
left join projects p on d.dept_id = p.dept_id
group by d.dept_id, d.dept_name
with data;

--Ex 5.2:
insert into employees (emp_id, emp_name, dept_id, salary)
values (8, 'Charlie Brown', 101, 54000);

refresh materialized view dept_summary_mv;

--Ex 5.3:
create unique index idx_dept_summary_mv_id on dept_summary_mv (dept_id);
refresh materialized view concurrently dept_summary_mv;

--Ex 5.4:
create materialized view project_stats_mv as
select 
    p.project_name,
    p.budget,
    d.dept_name,
    count(e.emp_id) as employee_count
from projects p
left join departments d on p.dept_id = d.dept_id
left join employees e on d.dept_id = e.dept_id
group by p.project_name, p.budget, d.dept_name
with no data;

-- fix: refresh materialized view project_stats_mv;

--Part 6:

--Ex 6.1:
create role analyst;
create role data_viewer login password 'viewer123';
create user report_user with password 'report456';
select rolname from pg_roles where rolname not like 'pg_%';

--Ex 6.2:
create role db_creator login createdb password 'creator789';
create role user_manager login createrole password 'manager101';
create role admin_user superuser login password 'admin999';

--Ex 6.3:
grant select on employees, departments, projects to analyst;
grant all privileges on employee_details to data_viewer;
grant select, insert on employees to report_user;

--Ex 6.4:
create role hr_team;
create role finance_team;
create role it_team;

create user hr_user1 with password 'hr001';
create user hr_user2 with password 'hr002';
create user finance_user1 with password 'fin001';

grant hr_team to hr_user1, hr_user2;
grant finance_team to finance_user1;

grant select, update on employees to hr_team;
grant select on dept_statistics to finance_team;

--Ex 6.5:
revoke update on employees from hr_team;
revoke hr_team from hr_user2;
revoke all privileges on employee_details from data_viewer;

--Ex 6.6:
alter role analyst with login password 'analyst123';
alter role user_manager superuser;
alter role analyst password null;
alter role data_viewer connection limit 5;

--Part 7:

--Ex 7.1:
create role read_only;
grant select on all tables in schema public to read_only;

create role junior_analyst login password 'junior123';
create role senior_analyst login password 'senior123';

grant read_only to junior_analyst, senior_analyst;
grant insert, update on employees to senior_analyst;

--Ex 7.2:
create role project_manager login password 'pm123';
alter view dept_statistics owner to project_manager;
alter table projects owner to project_manager;

--Ex 7.3:
create role temp_owner login;
create table temp_table (id int);
alter table temp_table owner to temp_owner;
reassign owned by temp_owner to postgres;
drop owned by temp_owner;
drop role temp_owner;

--Ex 7.4:
create view hr_employee_view as
select * from employees where dept_id = 102;
grant select on hr_employee_view to hr_team;

create view finance_employee_view as
select emp_id, emp_name, salary from employees;
grant select on finance_employee_view to finance_team;

--Part 8:

--Ex 8.1:
create view dept_dashboard as
select 
    d.dept_name,
    d.location,
    count(e.emp_id) as employee_count,
    round(avg(e.salary), 2) as avg_salary,
    count(distinct p.project_id) as active_projects,
    coalesce(sum(p.budget), 0) as total_project_budget,
    round(
        case when count(e.emp_id) = 0 then 0
             else coalesce(sum(p.budget), 0)::decimal / count(e.emp_id)
        end, 2
    ) as budget_per_employee
from departments d
left join employees e on d.dept_id = e.dept_id
left join projects p on d.dept_id = p.dept_id
group by d.dept_name, d.location;

--Ex 8.2:
alter table projects add column created_date timestamp default current_timestamp;

create view high_budget_projects as
select 
    p.project_name,
    p.budget,
    d.dept_name,
    p.created_date,
    case 
        when p.budget > 150000 then 'Critical Review Required'
        when p.budget > 100000 then 'Management Approval Needed'
        else 'Standard Process'
    end as approval_status
from projects p
left join departments d on p.dept_id = d.dept_id
where p.budget > 75000;

--Ex 8.3:
create role viewer_role;
grant select on all tables in schema public to viewer_role;
grant select on all views in schema public to viewer_role;

create role entry_role;
grant viewer_role to entry_role;
grant insert on employees, projects to entry_role;

create role analyst_role;
grant entry_role to analyst_role;
grant update on employees, projects to analyst_role;

create role manager_role;
grant analyst_role to manager_role;
grant delete on employees, projects to manager_role;

create user alice with password 'alice123';
create user bob with password 'bob123';
create user charlie with password 'charlie123';

grant viewer_role to alice;
grant analyst_role to bob;
grant manager_role to charlie;