-- Lab3

-- Part A: Database and Table Setup

CREATE TABLE IF NOT EXISTS employees (
    emp_id     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name  TEXT NOT NULL,
    department TEXT,
    salary     NUMERIC(12,2) DEFAULT 30000.00, -- default salary
    hire_date  DATE,
    status     TEXT DEFAULT 'Active'
);

-- departments
CREATE TABLE IF NOT EXISTS departments (
    dept_id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dept_name TEXT NOT NULL UNIQUE,
    budget    NUMERIC(14,2) DEFAULT 0,
    manager_id BIGINT REFERENCES employees(emp_id) ON DELETE SET NULL
);

-- projects
CREATE TABLE IF NOT EXISTS projects (
    project_id  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_name TEXT NOT NULL,
    dept_id      BIGINT REFERENCES departments(dept_id) ON DELETE SET NULL,
    start_date   DATE,
    end_date     DATE,
    budget       NUMERIC(14,2) DEFAULT 0
);

-- Part B: Advanced INSERT Operations

-- 2. INSERT с указанием колонок (только emp_id, first_name, last_name, department)
INSERT INTO employees (first_name, last_name, department)
VALUES
('Alice', 'Ivanova', 'IT'),
('Bob', 'Petrov', 'Sales');

-- 3. INSERT с DEFAULT значениями (salary и status по умолчанию)
INSERT INTO employees (first_name, last_name, hire_date)
VALUES ('Charlie', 'Sidorov', CURRENT_DATE);

-- 4. INSERT нескольких строк в departments одним запросом
INSERT INTO departments (dept_name, budget)
VALUES
('IT', 200000),
('Sales', 150000),
('HR', 50000);

-- 5. INSERT с выражениями (hire_date = current_date, salary = 50000 * 1.1)
INSERT INTO employees (first_name, last_name, department, hire_date, salary)
VALUES ('Diana', 'Kuznetsova', 'IT', CURRENT_DATE, 50000 * 1.1);

-- 6. INSERT FROM SELECT (создать временную таблицу temp_employees и вставить сотрудников из отдела IT)
CREATE TEMP TABLE temp_employees AS
SELECT * FROM employees WHERE department = 'IT';

-- Part C: Complex UPDATE Operations

-- 7. Увеличить все зарплаты на 10%
UPDATE employees
SET salary = salary * 1.10;

-- 8. UPDATE с WHERE и несколькими условиями
UPDATE employees
SET status = 'Senior'
WHERE salary > 60000
  AND hire_date IS NOT NULL
  AND hire_date < DATE '2020-01-01';

-- 9. UPDATE с CASE выражением (переразнесение по department на основе salary)
UPDATE employees
SET department = CASE
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior'
END;

-- 10. UPDATE с DEFAULT (установить department в default для 'Inactive' сотрудников)

ALTER TABLE employees ALTER COLUMN department SET DEFAULT 'Unassigned';

UPDATE employees
SET department = DEFAULT
WHERE status = 'Inactive';

-- 11. UPDATE с подзапросом: увеличить бюджет отдела на 20% от среднего salary сотрудников этого отдела

UPDATE departments d
SET budget = (SELECT COALESCE(d.budget,0) + AVG(e.salary) * 0.20
              FROM employees e
              WHERE e.department = d.dept_name)
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.department = d.dept_name);

-- 12. UPDATE нескольких колонок в одном statement

UPDATE employees
SET salary = salary * 1.15,
    status = 'Promoted'
WHERE department = 'Sales';

-- Part D: Advanced DELETE Operations

-- 13. DELETE с простым WHERE (удалить сотрудников со статусом 'Terminated')
DELETE FROM employees
WHERE status = 'Terminated';

-- 14. DELETE со сложным WHERE
DELETE FROM employees
WHERE salary < 40000
  AND hire_date > DATE '2023-01-01'
  AND department IS NULL;

-- 15. DELETE с подзапросом: удалить departments, у которых нет сотрудников
DELETE FROM departments
WHERE dept_id NOT IN (
    SELECT DISTINCT d.dept_id
    FROM departments d
    JOIN employees e ON e.department = d.dept_name
)


-- 16. DELETE с RETURNING (удалить проекты с end_date < '2023-01-01' и вернуть данные)
DELETE FROM projects
WHERE end_date < DATE '2023-01-01'
RETURNING *;

-- Part E: Operations with NULL Values

-- 17. INSERT с NULL для salary и department
INSERT INTO employees (first_name, last_name, salary, department, hire_date)
VALUES ('Egor', 'Smirnov', NULL, NULL, CURRENT_DATE);

-- 18. UPDATE: заполнить department значением 'Unassigned' где NULL
UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;

-- 19. DELETE где salary IS NULL OR department IS NULL
DELETE FROM employees
WHERE salary IS NULL OR department IS NULL;

-- Part F: RETURNING Clause Operations

-- 20. INSERT с RETURNING (вставить нового сотрудника и вернуть emp_id и полное имя)
INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Fedor', 'Orlov', 'Marketing', 42000, CURRENT_DATE)
RETURNING emp_id, (first_name || ' ' || last_name) AS full_name;

-- 21. UPDATE с RETURNING (увеличить зарплаты в IT на 5000 и вернуть emp_id, old и new salary)
WITH updated AS (
  UPDATE employees
  SET salary = salary + 5000
  WHERE department = 'IT'
  RETURNING emp_id, (salary - 5000) AS old_salary, salary AS new_salary
)
SELECT * FROM updated;

-- 22. DELETE с RETURNING всех колонок для сотрудников с hire_date < '2020-01-01'
DELETE FROM employees
WHERE hire_date < DATE '2020-01-01'
RETURNING *;

-- Part G: Advanced DML Patterns

-- 23. Conditional INSERT: вставлять сотрудника только если нет такого же имени+фамилии
INSERT INTO employees (first_name, last_name, department, salary, hire_date)
SELECT 'George', 'Nazarov', 'R&D', 55000, CURRENT_DATE
WHERE NOT EXISTS (
  SELECT 1 FROM employees WHERE first_name = 'George' AND last_name = 'Nazarov'
);

-- 24. UPDATE с логикой JOIN (повышение зарплат в зависимости от бюджета департамента)
UPDATE employees e
SET salary = salary * CASE
    WHEN (SELECT COALESCE(budget,0) FROM departments d WHERE d.dept_name = e.department) > 100000 THEN 1.10
    ELSE 1.05
END
WHERE e.department IS NOT NULL;

-- 25. Bulk operations: Insert 5 employees в одном выражении, затем одно UPDATE для увеличения их зарплат на 10%
INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES
('Hanna','A','Support', 32000, CURRENT_DATE),
('Ilya','B','Support', 33000, CURRENT_DATE),
('Julia','C','Support', 31000, CURRENT_DATE),
('Kirill','D','Support', 30000, CURRENT_DATE),
('Lena','E','Support', 34000, CURRENT_DATE);

-- Обновить зарплаты всех только что вставленных (по примеру: department = 'Support' и hire_date = today)
UPDATE employees
SET salary = salary * 1.10
WHERE department = 'Support' AND hire_date = CURRENT_DATE;

-- 26. Data migration simulation: создать employee_archive, переместить Inactive и удалить из employees
CREATE TABLE IF NOT EXISTS employee_archive AS
SELECT * FROM employees WHERE FALSE; -- создаёт таблицу с той же структурой, без строк

-- Вставить в архив inactive
INSERT INTO employee_archive
SELECT * FROM employees WHERE status = 'Inactive';

-- Удалить их из исходной таблицы
DELETE FROM employees WHERE status = 'Inactive';

-- 27. Complex business logic:
UPDATE projects p
SET end_date = p.end_date + INTERVAL '30 days'
WHERE p.budget > 50000
  AND EXISTS (
    SELECT 1
    FROM departments d
    JOIN (
      SELECT department, COUNT(*) AS emp_count
      FROM employees
      GROUP BY department
    ) ec ON ec.department = d.dept_name
    WHERE d.dept_id = p.dept_id AND ec.emp_count > 3
  );

-----------------------
-- Дополнительно: тестовые выборки/проверки (полезно для отладки)
-----------------------

-- Просмотреть часть сотрудников
SELECT * FROM employees LIMIT 20;

-- Просмотреть departments
SELECT * FROM departments;

-- Просмотреть проекты
SELECT * FROM projects;


