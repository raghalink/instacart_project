-- SCHEMA: instacart

-- DROP SCHEMA IF EXISTS "instacart" ;

CREATE SCHEMA  IF NOT EXISTS "instacart"
    AUTHORIZATION postgres;

COMMENT ON SCHEMA "instacart"
    IS 'instacart data schema.';
	
CREATE TABLE departments(
    department_id   INTEGER PRIMARY KEY,
	department      TEXT NOT NULL
	);
	
CREATE TABLE aisles(
    aisle_id   INTEGER PRIMARY KEY,
	aisle      TEXT NOT NULL
	);

CREATE TABLE products(
    product_id     INTEGER PRIMARY KEY,
	product_name   TEXT NOT NULL,
	aisle_id       INTEGER NOT NULL, 
	department_id  INTEGER NOT NULL,
	FOREIGN KEY (aisle_id) REFERENCES  aisles(aisle_id),
	FOREIGN KEY (department_id) REFERENCES departments(department_id)
	);

CREATE TABLE orders(
    order_id                  INTEGER PRIMARY KEY,
	user_id                   INTEGER NOT NULL,
	eval_set                  TEXT NOT NULL,
	order_number              INTEGER NOT NULL,
	order_dow                 SMALLINT NOT NULL,
	order_hour_of_day         SMALLINT NOT NULL,
	days_since_prior_order    SMALLINT,
	CHECK (order_hour_of_day BETWEEN 0 AND 23),
	CHECK (order_dow BETWEEN 1 AND 7)
	);
	
CREATE TABLE order_products(
    order_id               INTEGER NOT NULL,
	product_id             INTEGER NOT NULL,
	PRIMARY KEY (order_id,product_id),
	add_to_cart_order      SMALLINT,
	reordered              BOOLEAN,
	);

