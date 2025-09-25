
-- lab2_advanced_ddl.sql
-- Laboratory Work #2: Advanced DDL Operations
-- Generated to follow the uploaded LabWork2.pdf instructions.

-- PART 1: Multiple Database Management
-- Create tablespaces (requires superuser and existing filesystem paths)
--CREATE TABLESPACE student_data LOCATION '/data/students';
--CREATE TABLESPACE course_data OWNER CURRENT_USER LOCATION '/data/courses';

-- Databases creation
-- Note: use \c in psql to connect between databases in one .sql file
CREATE DATABASE university_main
    OWNER = postgres
    TEMPLATE template0
    ENCODING 'UTF8';

CREATE DATABASE university_archive
    CONNECTION LIMIT 50
    TEMPLATE template0;

CREATE DATABASE university_test
    IS_TEMPLATE true
    CONNECTION LIMIT 10;

CREATE DATABASE university_distributed
    ENCODING 'UTF8';

-- PART 2: Complex Table Creation
-- Switch to university_main for table creation
\c university_main

-- students table
CREATE TABLE students (
    student_id serial PRIMARY KEY,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    phone char(15),
    date_of_birth date,
    enrollment_date date,
    gpa numeric(5,2),
    is_active boolean,
    graduation_year smallint
);

-- professors table
CREATE TABLE professors (
    professor_id serial PRIMARY KEY,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    office_number varchar(20),
    hire_date date,
    salary numeric(12,2),
    is_tenured boolean,
    years_experience integer
);

-- courses table
CREATE TABLE courses (
    course_id serial PRIMARY KEY,
    course_code char(8),
    course_title varchar(100),
    description text,
    credits smallint,
    max_enrollment integer,
    course_fee numeric(10,2),
    is_online boolean,
    created_at timestamp without time zone
);

-- class_schedule table
CREATE TABLE class_schedule (
    schedule_id serial PRIMARY KEY,
    course_id integer,
    professor_id integer,
    classroom varchar(20),
    class_date date,
    start_time time without time zone,
    end_time time without time zone,
    duration interval
);

-- student_records table
CREATE TABLE student_records (
    record_id serial PRIMARY KEY,
    student_id integer,
    course_id integer,
    semester varchar(20),
    year integer,
    grade char(2),
    attendance_percentage numeric(4,1),
    submission_timestamp timestamp with time zone,
    last_updated timestamp with time zone
);

-- PART 4: Additional supporting tables (placed in university_main)
-- departments
CREATE TABLE departments (
    department_id serial PRIMARY KEY,
    department_name varchar(100),
    department_code char(5),
    building varchar(50),
    phone varchar(15),
    budget numeric(15,2),
    established_year integer
);

-- library_books
CREATE TABLE library_books (
    book_id serial PRIMARY KEY,
    isbn char(13),
    title varchar(200),
    author varchar(100),
    publisher varchar(100),
    publication_date date,
    price numeric(10,2),
    is_available boolean,
    acquisition_timestamp timestamp without time zone
);

-- student_book_loans
CREATE TABLE student_book_loans (
    loan_id serial PRIMARY KEY,
    student_id integer,
    book_id integer,
    loan_date date,
    due_date date,
    return_date date,
    fine_amount numeric(10,2),
    loan_status varchar(20)
);

-- Lookup tables
CREATE TABLE grade_scale (
    grade_id serial PRIMARY KEY,
    letter_grade char(2),
    min_percentage numeric(4,1),
    max_percentage numeric(4,1),
    gpa_points numeric(3,2)
);

CREATE TABLE semester_calendar (
    semester_id serial PRIMARY KEY,
    semester_name varchar(20),
    academic_year integer,
    start_date date,
    end_date date,
    registration_deadline timestamp with time zone,
    is_current boolean
);

-- PART 4.2: Add foreign key columns (only columns, no FK constraints yet)
ALTER TABLE professors ADD COLUMN department_id integer;
ALTER TABLE students ADD COLUMN advisor_id integer;
ALTER TABLE courses ADD COLUMN department_id integer;

-- PART 3: Advanced ALTER TABLE Operations
-- Switch to university_main (already connected), perform modifications

-- Modify students table
ALTER TABLE students ADD COLUMN middle_name varchar(30);
ALTER TABLE students ADD COLUMN student_status varchar(20);
ALTER TABLE students ALTER COLUMN phone TYPE varchar(20) USING trim(phone)::varchar;
ALTER TABLE students ALTER COLUMN student_status SET DEFAULT 'ACTIVE';
ALTER TABLE students ALTER COLUMN gpa SET DEFAULT 0.00;

-- Modify professors table
ALTER TABLE professors ADD COLUMN department_code char(5);
ALTER TABLE professors ADD COLUMN research_area text;
ALTER TABLE professors ALTER COLUMN years_experience TYPE smallint USING years_experience::smallint;
ALTER TABLE professors ALTER COLUMN is_tenured SET DEFAULT false;
ALTER TABLE professors ADD COLUMN last_promotion_date date;

-- Modify courses table
ALTER TABLE courses ADD COLUMN prerequisite_course_id integer;
ALTER TABLE courses ADD COLUMN difficulty_level smallint;
ALTER TABLE courses ALTER COLUMN course_code TYPE varchar(10) USING trim(course_code)::varchar;
ALTER TABLE courses ALTER COLUMN credits SET DEFAULT 3;
ALTER TABLE courses ADD COLUMN lab_required boolean DEFAULT false;

-- PART 3.2: class_schedule modifications
ALTER TABLE class_schedule ADD COLUMN room_capacity integer;
ALTER TABLE class_schedule DROP COLUMN duration;
ALTER TABLE class_schedule ADD COLUMN session_type varchar(15);
ALTER TABLE class_schedule ALTER COLUMN classroom TYPE varchar(30) USING classroom::varchar;
ALTER TABLE class_schedule ADD COLUMN equipment_needed text;

-- student_records modifications
ALTER TABLE student_records ADD COLUMN extra_credit_points numeric(4,1);
ALTER TABLE student_records ALTER COLUMN grade TYPE varchar(5) USING grade::varchar;
ALTER TABLE student_records ALTER COLUMN extra_credit_points SET DEFAULT 0.0;
ALTER TABLE student_records ADD COLUMN final_exam_date date;
ALTER TABLE student_records DROP COLUMN last_updated;

-- PART 5: Table Deletion and Cleanup
-- Drop tables if they exist
DROP TABLE IF EXISTS student_book_loans;
DROP TABLE IF EXISTS library_books;
DROP TABLE IF EXISTS grade_scale;

-- Recreate grade_scale with additional description column
CREATE TABLE grade_scale (
    grade_id serial PRIMARY KEY,
    letter_grade char(2),
    min_percentage numeric(4,1),
    max_percentage numeric(4,1),
    gpa_points numeric(3,2),
    description text
);

-- Drop semester_calendar with CASCADE and recreate
DROP TABLE IF EXISTS semester_calendar CASCADE;

CREATE TABLE semester_calendar (
    semester_id serial PRIMARY KEY,
    semester_name varchar(20),
    academic_year integer,
    start_date date,
    end_date date,
    registration_deadline timestamp with time zone,
    is_current boolean
);

-- PART 5.2 Database cleanup (may require superuser)
-- Drop test/distributed DBs if they exist
-- To run these, you must be connected to a different DB (e.g., postgres)
\c postgres
DROP DATABASE IF EXISTS university_test;
DROP DATABASE IF EXISTS university_distributed;

-- Create university_backup using university_main as template
CREATE DATABASE university_backup TEMPLATE university_main;

-- End of script
