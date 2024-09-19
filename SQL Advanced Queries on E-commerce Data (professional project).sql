-- Commenting everything now because of saving it and building database--

-- Create the Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    email VARCHAR(255)
);

-- Create the Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(100),
    price DECIMAL(10, 2)
);

-- Create the Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Create the Order_Items table
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Create the Cart table (to track abandoned carts)
CREATE TABLE Cart (
    cart_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    status VARCHAR(50), -- 'active' or 'abandoned'
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
-- Insert sample customers
INSERT INTO Customers (customer_id, customer_name, email) 
VALUES 
(1, 'Alice Johnson', 'alice@example.com'),
(2, 'Bob Smith', 'bob@example.com');

-- Insert sample products
INSERT INTO Products (product_id, product_name, category, price) 
VALUES 
(1, 'Laptop', 'Electronics', 1000.00),
(2, 'Headphones', 'Electronics', 200.00);

-- Insert sample orders
INSERT INTO Orders (order_id, customer_id, order_date) 
VALUES 
(1, 1, '2024-09-10'),
(2, 2, '2024-09-11');

-- Insert sample order items
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, price) 
VALUES 
(1, 1, 1, 1, 1000.00),
(2, 2, 2, 2, 400.00);

-- Insert sample cart items
INSERT INTO Cart (cart_id, customer_id, product_id, quantity, status) 
VALUES 
(1, 1, 1, 1, 'abandoned'),
(2, 2, 2, 1, 'active');

-- SQL queries Identify top products--
SELECT 
    p.product_name, 
    SUM(oi.quantity * oi.price) AS total_sales
FROM 
    Order_Items oi
JOIN 
    Products p ON oi.product_id = p.product_id
GROUP BY 
    p.product_name
ORDER BY 
    total_sales DESC;

--Analyse purchase parterns--
/*SELECT 
    DAYNAME(order_date) AS day_of_week, 
    HOUR(order_date) AS hour_of_day, 
    COUNT(*) AS num_orders
FROM 
    Orders
GROUP BY 
    day_of_week, hour_of_day
ORDER BY 
    num_orders DESC;
*/
SELECT 
    DATENAME(WEEKDAY, order_date) AS day_of_week, 
    COUNT(*) AS num_orders
FROM 
    Orders
GROUP BY 
    DATENAME(WEEKDAY, order_date)
ORDER BY 
    num_orders DESC;
-- Find Customers with abandoned carts--
SELECT 
    c.customer_name, 
    p.product_name, 
    ct.quantity
FROM 
    Cart ct
JOIN 
    Customers c ON ct.customer_id = c.customer_id
JOIN 
    Products p ON ct.product_id = p.product_id
WHERE 
    ct.status = 'abandoned';
--Customer lifetime value--
SELECT 
    c.customer_name, 
    SUM(oi.quantity * oi.price) AS total_spent
FROM 
    Customers c
JOIN 
    Orders o ON c.customer_id = o.customer_id
JOIN 
    Order_Items oi ON o.order_id = oi.order_id
GROUP BY 
    c.customer_name
ORDER BY 
    total_spent DESC;

--Product cross-selling opportunities--
SELECT 
    oi1.product_id AS product_1, 
    oi2.product_id AS product_2, 
    COUNT(*) AS frequency
FROM 
    Order_Items oi1
JOIN 
    Order_Items oi2 ON oi1.order_id = oi2.order_id
WHERE 
    oi1.product_id != oi2.product_id
GROUP BY 
    oi1.product_id, oi2.product_id
ORDER BY 
    frequency DESC;
