--Kystaubekov Mukhamejan
--24B032166

--Task 1.1 
create table employees (
    employees_id integer primary key,
    first_name text,
    last_name text,
    age integer check (age between 18 and 65),
    salary numeric check (salary > 0)
);

--Task 1.2
create table products_catalog (
    product_id integer primary key,
    product_name text,
    regular_price numeric,
    discount_price numeric,
    CONSTRAINT valid_discount check (
        regular_price > 0 and 
        discount_price > 0 and 
        discount_price < regular_price
    )
);

--Task 1.3
create table booking (
    booking_id integer primary key,
    check_in_date date not null,
    check_out_date date not null,
    num_guests integer check (num_guests between 1 and 10),
    check (check_out_date > check_in_date)
);

--Task 1.4
insert into employees values (1, 'Ivan', 'Petrov', '30, 45000');
insert into employees values (2, 'Aigul', 'Sarapova', '25, 52000');
--insert into employees values (3, 'John', 'Snow', '17', -1500); (age < 18 and salary < 0)

insert into products_catalog values (1, 'smartphone', '1000', '850');
insert into products_catalog values (2, 'headphone', '500', '400');
--insert into products_catalog values (3, 'laptop', '-700', '200'); (negative price and discount > regular)

insert into booking values (1, date '2025-01-01', date '2025-01-02', 3);
insert into booking values (2, date '2025-02-02', date '2025-02-03', 5);
--insert into booking values (3, date '2025-03-03', date '2025-03-02', 15); (in date > out date and guests > 10)

--Task 2.1
create table customers (
    customer_id integer not null primary key,
    email text not null,
    phone text,
    registration_date date not null,
);

--Task 2.2
create table inventory (
    item_id integer not null primary key,
    item_name text not null,
    quantity integer not null check (quantity >= 0),
    unit_price numeric not null check (unit_price > 0),
    last_updated  timestamp not null,
);

--Task 2.3
insert into customers values (1, 'ivan@mail.ru', '77711234567', date '2025-01-01');
insert into customers values (2, 'aigul@mail.ru', null, date '2025-02-02');
--insert into customers values (3, null, '77711234567', date '2025-01-01');

insert into inventory values (1, 'pen', 100, 0.5, now());
insert into inventory values (2, 'pencil', 50, 1.5, now());
--insert into inventory values (3, 'notebook', -5, 1.0, null);

--Task 3.1
create table users (
    user_id integer primary key,
    username text unique,
    email text unique,
    created_at timestamp,
);

--Task 3.2
create table course_enrollments (
    enrollment_id integer primary key,
    tudent_id integer not null,
    course_code text not null,
    semester text not null,
    unique (student_id, course_code, semester)
);

--Task 3.3
create table users2 (
    user_id integer primary key,
    username text,
    email text,
    created_at timestamp,
    constraint unique_username unique (username),
    constraint unique_email unique (email)
);

insert into users2 values (1, 'nurs', 'nurs@mail.ru', now());
insert into users2 values (2, 'tom', 'tom@mail.ru', now());
--insert into users2 values (3, 'nurs', 'another@mail.ru', now()); (duplicate username)
--insert into users2 values (4, 'alex', 'nurs@mail.ru', now()); (duplicate email)


--Task 4.1
create table departments (
    dept_id integer primary key,
    dept_name text not null,
    location text
);

insert into departments values (1, 'IT', 'Almaty');
insert into departments values (2, 'HR', 'Astana');
insert into departments values (3, 'Finance', 'Shymkent');
--insert into departments values (1, 'Duplicate', 'Nowhere'); (duplicate primary key)
--insert into departments values (null, 'NoID', 'Somewhere'); (null primary key)


--Task 4.2
create table student_courses (
    student_id integer,
    course_id integer,
    enrollment_date date,
    grade text,
    primary key (student_id, course_id)
);

insert into student_courses values (1001, 501, date '2025-01-01', 'A');
insert into student_courses values (1002, 501, date '2025-02-02', 'B');
--insert into student_courses values (1001, 501, date '2025-03-03', 'A+'); (duplicate composite key)


--Task 4.3
-- 1) PRIMARY KEY отличается от UNIQUE тем, что PRIMARY KEY не может содержать NULL.
-- 2) UNIQUE можно использовать несколько раз в таблице, а PRIMARY KEY — только один.
-- 3) Составной ключ (из двух и более колонок) используется, если одна колонка не уникальна, но их комбинация — уникальна.


--Task 5.1
create table employees_dept (
    emp_id integer primary key,
    emp_name text not null,
    dept_id integer references departments(dept_id),
    hire_date date
);

insert into employees_dept values (1, 'Serik', 1, date '2024-06-01');
--insert into employees_dept values (2, 'NoDept', 999, date '2025-01-10'); (foreign key error: no such dept_id)


--Task 5.2
create table authors (
    author_id integer primary key,
    author_name text not null,
    country text
);

create table publishers (
    publisher_id integer primary key,
    publisher_name text not null,
    city text
);

create table books (
    book_id integer primary key,
    title text not null,
    author_id integer references authors(author_id),
    publisher_id integer references publishers(publisher_id),
    publication_year integer,
    isbn text unique
);

insert into authors values (1, 'Leo Tolstoy', 'Russia');
insert into authors values (2, 'Albert Camus', 'France');

insert into publishers values (1, 'ClassicPub', 'Moscow');
insert into publishers values (2, 'WorldPress', 'Paris');

insert into books values (1, 'War and Peace', 1, 1, 1869, 'ISBN-0001');
insert into books values (2, 'The Stranger', 2, 2, 1942, 'ISBN-0002');


--Task 5.3
create table categories (
    category_id integer primary key,
    category_name text not null
);

create table products_fk (
    product_id integer primary key,
    product_name text not null,
    category_id integer references categories(category_id) on delete restrict
);

create table orders (
    order_id integer primary key,
    order_date date not null
);

create table order_items (
    item_id integer primary key,
    order_id integer references orders(order_id) on delete cascade,
    product_id integer references products_fk(product_id),
    quantity integer check (quantity > 0)
);

insert into categories values (1, 'Electronics');
insert into categories values (2, 'Stationery');

insert into products_fk values (1, 'Smartphone', 1);
insert into products_fk values (2, 'Pen', 2);

insert into orders values (1, date '2025-07-01');
insert into order_items values (1, 1, 1, 1);
insert into order_items values (2, 1, 2, 3);
--delete from categories where category_id = 1; (error: restrict)
--delete from orders where order_id = 1; (cascade: order_items also deleted)


--Task 6.1
create table ecommerce_customers (
    customer_id integer primary key,
    name text not null,
    email text not null unique,
    phone text,
    registration_date date not null
);

create table ecommerce_products (
    product_id integer primary key,
    name text not null,
    description text,
    price numeric not null check (price >= 0),
    stock_quantity integer not null check (stock_quantity >= 0)
);

create table ecommerce_orders (
    order_id integer primary key,
    customer_id integer references ecommerce_customers(customer_id) on delete set null,
    order_date date not null,
    total_amount numeric not null check (total_amount >= 0),
    status text not null check (status in ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

create table ecommerce_order_details (
    order_detail_id integer primary key,
    order_id integer references ecommerce_orders(order_id) on delete cascade,
    product_id integer references ecommerce_products(product_id),
    quantity integer not null check (quantity > 0),
    unit_price numeric not null check (unit_price >= 0)
);

--Task 6.2 Insert sample data
insert into ecommerce_customers values (1, 'Ivan Petrov', 'ivan@mail.ru', '77001234567', date '2025-01-10');
insert into ecommerce_customers values (2, 'Aigul S', 'aigul@mail.ru', '77009998877', date '2025-02-15');
insert into ecommerce_customers values (3, 'Serik N', 'serik@mail.ru', null, date '2025-03-20');
insert into ecommerce_customers values (4, 'Tom H', 'tom@mail.ru', '77005554433', date '2025-04-12');
insert into ecommerce_customers values (5, 'Nurs K', 'nurs@mail.ru', '77002223344', date '2025-05-01');

insert into ecommerce_products values (1, 'Phone X', 'Smartphone 64GB', 499.99, 25);
insert into ecommerce_products values (2, 'Laptop Pro', 'Ultrabook 13"', 1299.0, 10);
insert into ecommerce_products values (3, 'Headphones', 'Noise cancelling', 199.99, 40);
insert into ecommerce_products values (4, 'USB-C Cable', '1m cable', 9.99, 200);
insert into ecommerce_products values (5, 'Office Chair', 'Ergonomic model', 149.5, 15);

insert into ecommerce_orders values (1, 1, date '2025-07-01', 709.98, 'processing');
insert into ecommerce_orders values (2, 2, date '2025-07-02', 1299.00, 'shipped');
insert into ecommerce_orders values (3, 3, date '2025-07-03', 9.99, 'delivered');
insert into ecommerce_orders values (4, 4, date '2025-07-04', 199.99, 'pending');
insert into ecommerce_orders values (5, 5, date '2025-07-05', 649.99, 'cancelled');

insert into ecommerce_order_details values (1, 1, 1, 1, 499.99);
insert into ecommerce_order_details values (2, 1, 4, 2, 9.99);
insert into ecommerce_order_details values (3, 2, 2, 1, 1299.00);
insert into ecommerce_order_details values (4, 3, 4, 1, 9.99);
insert into ecommerce_order_details values (5, 4, 3, 1, 199.99);
insert into ecommerce_order_details values (6, 5, 1, 1, 499.99);
insert into ecommerce_order_details values (7, 5, 4, 15, 9.99);

--Task 6.3 Checks and delete behavior
--insert into ecommerce_products values (6, 'BadProduct', 'negative price', -10, 5); (price < 0)
--insert into ecommerce_products values (7, 'BadProduct2', 'negative stock', 10, -1); (stock < 0)
--insert into ecommerce_orders values (6, 1, date '2025-07-10', 100, 'unknown'); (invalid status)
--insert into ecommerce_order_details values (8, 1, 1, 0, 499.99); (quantity = 0)
--insert into ecommerce_customers values (6, 'Duplicate', 'ivan@mail.ru', null, date '2025-08-01'); (duplicate email)

--delete from ecommerce_orders where order_id = 1; (cascade deletes order_details)
--delete from ecommerce_customers where customer_id = 2; (sets null on related orders)