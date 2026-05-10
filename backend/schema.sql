-- Seller Reliability Analysis System - Database Schema
CREATE DATABASE IF NOT EXISTS seller_trust_db;
USE seller_trust_db;

-- Products Table
CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    description TEXT,
    image_url VARCHAR(500),
    base_price DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sellers Table
CREATE TABLE IF NOT EXISTS sellers (
    seller_id INT AUTO_INCREMENT PRIMARY KEY,
    seller_name VARCHAR(255) NOT NULL,
    seller_email VARCHAR(255),
    location VARCHAR(100),
    joined_date DATE,
    profile_image VARCHAR(500),
    total_sales INT DEFAULT 0
);

-- Listings Table (links sellers to products)
CREATE TABLE IF NOT EXISTS listings (
    listing_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    seller_id INT,
    price DECIMAL(10,2),
    rating DECIMAL(3,2),
    return_rate DECIMAL(4,3),
    listed_date DATE,
    stock INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

-- Complaints Table
CREATE TABLE IF NOT EXISTS complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    seller_id INT,
    product_id INT,
    complaint_text TEXT,
    complaint_date DATE,
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Orders Table
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    seller_id INT,
    customer_name VARCHAR(255),
    quantity INT DEFAULT 1,
    total_price DECIMAL(10,2),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

-- ===================== SEED DATA =====================

INSERT INTO products (name, category, description, image_url, base_price) VALUES
-- Original 8 products
('Sony WH-1000XM5 Headphones', 'Electronics', 'Industry-leading noise canceling headphones with Auto NC Optimizer, crystal clear hands-free calling, and up to 30-hour battery life.', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400', 24999.00),
('Apple iPhone 15 Pro', 'Electronics', 'iPhone 15 Pro. Forged in titanium and featuring the groundbreaking A17 Pro chip, a customizable Action button, and the most powerful iPhone camera system ever.', 'https://images.unsplash.com/photo-1678911820864-e5c567c655d0?w=400', 134900.00),
('Nike Air Max 270', 'Footwear', 'The Nike Air Max 270 delivers a large Air unit in the heel and a sleek, modern design for all-day comfort and style.', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400', 10995.00),
('Samsung 4K Smart TV 55"', 'Electronics', 'Crystal UHD 4K Smart TV with PurColor, HDR, and Alexa built-in for an immersive viewing experience.', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=400', 54990.00),
('Dyson V15 Detect Vacuum', 'Home Appliances', 'Dyson''s most powerful cordless vacuum with laser dust detection, HEPA filtration, and LCD screen showing real-time performance.', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400', 52900.00),
('Canon EOS R50 Camera', 'Electronics', 'Compact mirrorless camera with 24.2MP APS-C sensor, DIGIC X processor, and 4K video for creators on the go.', 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=400', 74995.00),
('Logitech MX Master 3S', 'Accessories', 'Advanced wireless mouse with ultra-fast MagSpeed scrolling, ergonomic design, and multi-device connectivity.', 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400', 8995.00),
('Kindle Paperwhite 2023', 'Electronics', 'Waterproof e-reader with a 6.8" display, adjustable warm light, and weeks of battery life for avid readers.', 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400', 13999.00),

-- NEW PRODUCTS
-- Books
('Atomic Habits by James Clear', 'Books', 'The #1 New York Times bestseller. A revolutionary system for building good habits and breaking bad ones — tiny changes, remarkable results.', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400', 399.00),
('The Psychology of Money', 'Books', 'Morgan Housel explores the strange ways people think about money and teaches you how to make better sense of one of life''s most important topics.', 'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=400', 349.00),
('Sapiens: A Brief History of Humankind', 'Books', 'Yuval Noah Harari takes us on a breathtaking journey through the entire history of the human race — a landmark work of narrative nonfiction.', 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400', 499.00),

-- Sports
('Yonex Arcsaber 11 Badminton Racket', 'Sports', 'Professional-grade badminton racket with carbon nanotube reinforcement for superior repulsion and accuracy. Favoured by competitive players.', 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=400', 6499.00),
('Boldfit Yoga Mat', 'Sports', 'Premium 6mm anti-skid yoga mat with carrying strap, ideal for yoga, pilates, and home workouts. Extra-thick for joint support.', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400', 899.00),
('Nivia Storm Football', 'Sports', 'FIFA-approved match ball with 32-panel synthetic leather construction, air retention bladder, and all-weather waterproof coating.', 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?w=400', 1299.00),

-- Beauty
('Minimalist 10% Niacinamide Serum', 'Beauty', 'Lightweight serum that visibly reduces enlarged pores, controls sebum, and evens skin tone. Suitable for all skin types, dermatologically tested.', 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400', 649.00),
('Forest Essentials Sandalwood Cream', 'Beauty', 'Luxurious Ayurvedic moisturiser with pure Mysore sandalwood extract. Deeply nourishes, reduces dark spots, and imparts a natural glow.', 'https://images.unsplash.com/photo-1601049676869-702ea24cfd58?w=400', 1695.00),

-- Kitchen
('Prestige Svachh Deep Kadai', 'Kitchen', 'Hard-anodised deep kadai with unique bowl-shaped glass lid that collects steam for healthier cooking. Compatible with all cooktops.', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400', 1299.00),
('Philips HL7756 Mixer Grinder', 'Kitchen', '750W mixer grinder with 3 stainless steel jars, ProBlend technology, and overheat protection for effortless grinding and blending.', 'https://images.unsplash.com/photo-1570222094114-d054a817e56b?w=400', 3999.00),
('Milton Thermosteel Flask 1L', 'Kitchen', 'Double-wall vacuum insulated flask keeps beverages hot for 24 hours or cold for 48 hours. Leak-proof, BPA-free, food-grade stainless steel.', 'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=400', 799.00),

-- More Electronics & Accessories
('boAt Airdopes 141', 'Electronics', 'True wireless earbuds with 42H total playback, IWP technology for instant pairing, IPX4 water resistance, and BEAST Mode for ultra-low latency gaming.', 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400', 1299.00);

INSERT INTO sellers (seller_name, seller_email, location, joined_date, total_sales) VALUES
('TechZone Official', 'techzone@store.com', 'Mumbai', '2019-03-15', 15420),
('QuickShip Electronics', 'quickship@store.com', 'Delhi', '2021-07-20', 8320),
('BudgetBazaar', 'budget@store.com', 'Bangalore', '2022-11-05', 3210),
('PremiumGadgets', 'premium@store.com', 'Chennai', '2020-01-10', 12800),
('FlashDeal Store', 'flashdeal@store.com', 'Hyderabad', '2023-02-28', 1540),
('MegaMart India', 'megamart@store.com', 'Kolkata', '2018-06-12', 25600),
('ValueKart', 'valuekart@store.com', 'Pune', '2022-08-17', 4320),
('EliteShop', 'eliteshop@store.com', 'Ahmedabad', '2021-03-05', 9870);

-- ─── Original Listings (Products 1–8) ───

INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(1, 1, 24999.00, 4.7, 0.03, '2022-01-10', 45),
(1, 2, 23499.00, 3.8, 0.12, '2022-06-15', 20),
(1, 3, 22000.00, 2.9, 0.22, '2023-01-20', 8),
(1, 4, 25500.00, 4.5, 0.05, '2022-03-05', 30);

INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(2, 6, 134900.00, 4.8, 0.02, '2023-09-20', 60),
(2, 2, 132000.00, 3.5, 0.15, '2023-10-01', 15),
(2, 5, 128000.00, 2.5, 0.28, '2023-10-15', 5),
(2, 8, 135500.00, 4.6, 0.04, '2023-09-22', 40);

INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(3, 7, 10995.00, 4.2, 0.08, '2021-05-10', 80),
(3, 3, 9500.00, 3.1, 0.19, '2022-02-20', 12),
(3, 5, 8999.00, 2.2, 0.31, '2023-03-15', 3),
(3, 1, 11200.00, 4.6, 0.03, '2021-07-05', 55);

INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(4, 6, 54990.00, 4.9, 0.01, '2020-11-01', 25),
(4, 4, 53000.00, 4.3, 0.06, '2021-01-15', 18),
(4, 2, 51000.00, 3.3, 0.17, '2021-08-20', 10),
(4, 7, 49999.00, 2.8, 0.24, '2022-04-10', 4);

INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(5, 4, 52900.00, 4.6, 0.04, '2021-02-14', 20),
(5, 8, 51500.00, 4.1, 0.09, '2021-06-30', 15),
(5, 3, 49000.00, 3.0, 0.20, '2022-09-05', 6),
(5, 5, 47000.00, 2.3, 0.29, '2023-05-12', 2);

INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(6, 1, 74995.00, 4.8, 0.02, '2022-04-01', 35),
(6, 6, 73000.00, 4.5, 0.05, '2022-04-10', 28),
(6, 7, 71000.00, 3.6, 0.14, '2022-09-20', 10),
(6, 3, 68000.00, 2.7, 0.25, '2023-02-14', 3);

INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(7, 8, 8995.00, 4.7, 0.03, '2021-11-05', 70),
(7, 2, 8500.00, 3.9, 0.11, '2022-03-20', 25),
(7, 5, 7999.00, 2.6, 0.26, '2023-01-10', 8),
(7, 1, 9200.00, 4.4, 0.06, '2021-12-01', 50);

INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(8, 4, 13999.00, 4.8, 0.02, '2023-07-01', 90),
(8, 6, 13500.00, 4.4, 0.06, '2023-07-15', 45),
(8, 3, 12999.00, 3.2, 0.18, '2023-08-20', 10),
(8, 7, 12500.00, 2.4, 0.27, '2023-09-01', 4);

-- ─── New Listings (Products 9–20) ───

-- Product 9: Atomic Habits (Books)
INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(9, 6, 399.00, 4.9, 0.01, '2022-03-01', 200),
(9, 7, 379.00, 4.5, 0.04, '2022-04-10', 120),
(9, 3, 349.00, 3.1, 0.16, '2023-01-05', 30),
(9, 5, 329.00, 2.4, 0.27, '2023-06-01', 10);

-- Product 10: The Psychology of Money (Books)
INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(10, 6, 349.00, 4.8, 0.02, '2022-05-10', 180),
(10, 4, 339.00, 4.4, 0.05, '2022-06-20', 90),
(10, 2, 319.00, 3.6, 0.13, '2023-02-01', 40),
(10, 5, 299.00, 2.2, 0.30, '2023-07-15', 5);

-- Product 11: Sapiens (Books)
INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(11, 8, 499.00, 4.7, 0.03, '2021-08-01', 150),
(11, 6, 479.00, 4.5, 0.05, '2021-09-15', 80),
(11, 3, 449.00, 3.0, 0.19, '2022-11-01', 20),
(11, 5, 420.00, 2.3, 0.28, '2023-04-10', 6);

-- Product 12: Yonex Badminton Racket (Sports)
INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(12, 1, 6499.00, 4.8, 0.02, '2021-01-15', 60),
(12, 7, 6199.00, 4.2, 0.07, '2021-05-20', 35),
(12, 3, 5799.00, 3.0, 0.21, '2022-08-01', 10),
(12, 5, 5499.00, 2.1, 0.33, '2023-02-20', 3);

-- Product 13: Boldfit Yoga Mat (Sports)
INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(13, 4, 899.00, 4.6, 0.04, '2022-01-10', 120),
(13, 8, 849.00, 4.2, 0.08, '2022-03-01', 80),
(13, 2, 799.00, 3.4, 0.15, '2022-09-01', 25),
(13, 5, 749.00, 2.5, 0.26, '2023-05-01', 8);

-- Product 14: Nivia Storm Football (Sports)
INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(14, 7, 1299.00, 4.5, 0.05, '2021-06-01', 100),
(14, 1, 1249.00, 4.7, 0.03, '2021-07-15', 75),
(14, 3, 1149.00, 3.1, 0.17, '2022-10-10', 15),
(14, 5, 1099.00, 2.3, 0.29, '2023-03-01', 4);

-- Product 15: Minimalist Niacinamide Serum (Beauty)
INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(15, 8, 649.00, 4.7, 0.03, '2022-02-01', 200),
(15, 4, 629.00, 4.4, 0.06, '2022-04-15', 130),
(15, 2, 599.00, 3.5, 0.14, '2022-11-01', 45),
(15, 5, 569.00, 2.4, 0.28, '2023-05-20', 10);

-- Product 16: Forest Essentials Sandalwood Cream (Beauty)
INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(16, 6, 1695.00, 4.8, 0.02, '2021-03-10', 80),
(16, 8, 1650.00, 4.5, 0.04, '2021-05-01', 50),
(16, 3, 1599.00, 3.2, 0.18, '2022-09-01', 12),
(16, 5, 1499.00, 2.2, 0.31, '2023-04-01', 3);

-- Product 17: Prestige Kadai (Kitchen)
INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(17, 4, 1299.00, 4.7, 0.03, '2021-04-01', 90),
(17, 6, 1249.00, 4.5, 0.05, '2021-06-15', 60),
(17, 7, 1199.00, 3.8, 0.11, '2022-07-01', 20),
(17, 3, 1099.00, 2.9, 0.22, '2023-01-10', 7);

-- Product 18: Philips Mixer Grinder (Kitchen)
INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(18, 1, 3999.00, 4.8, 0.02, '2020-08-01', 70),
(18, 4, 3849.00, 4.4, 0.06, '2020-10-15', 45),
(18, 2, 3699.00, 3.3, 0.16, '2021-09-01', 18),
(18, 5, 3499.00, 2.4, 0.27, '2023-02-01', 5);

-- Product 19: Milton Flask (Kitchen)
INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(19, 7, 799.00, 4.6, 0.04, '2021-10-01', 150),
(19, 8, 769.00, 4.3, 0.07, '2022-01-15', 100),
(19, 3, 729.00, 3.0, 0.20, '2022-08-01', 30),
(19, 5, 699.00, 2.2, 0.30, '2023-04-15', 8);

-- Product 20: boAt Airdopes 141 (Electronics)
INSERT INTO listings (product_id, seller_id, price, rating, return_rate, listed_date, stock) VALUES
(20, 1, 1299.00, 4.6, 0.04, '2022-07-01', 200),
(20, 2, 1249.00, 3.8, 0.12, '2022-09-10', 80),
(20, 3, 1199.00, 3.0, 0.21, '2023-01-01', 20),
(20, 5, 1099.00, 2.3, 0.30, '2023-06-15', 6);

-- ─── Complaints (original + new) ───

INSERT INTO complaints (seller_id, product_id, complaint_text, complaint_date) VALUES
-- Original complaints
(2, 1, 'Product arrived damaged', '2023-01-10'),
(2, 1, 'Wrong item sent', '2023-03-15'),
(3, 1, 'Fake product suspected', '2023-02-20'),
(3, 1, 'No response from seller', '2023-04-10'),
(3, 1, 'Missing accessories', '2023-05-01'),
(5, 2, 'Counterfeit suspected', '2023-11-05'),
(5, 2, 'Seal was broken', '2023-11-20'),
(5, 2, 'Wrong color delivered', '2023-12-01'),
(5, 2, 'Refused return request', '2024-01-10'),
(3, 3, 'Size mismatch', '2023-04-05'),
(5, 3, 'Fake Nike tag', '2023-05-15'),
(5, 3, 'Very poor quality', '2023-06-20'),
(7, 4, 'Dead pixels on screen', '2022-05-10'),
(2, 4, 'Remote not working', '2021-09-25'),
(5, 5, 'Motor noise issue', '2023-06-01'),
(3, 6, 'Camera body scratched', '2023-03-10'),
(5, 7, 'Scroll wheel broken', '2023-02-15'),
(3, 8, 'Different edition sent', '2023-09-15'),
-- New product complaints
(3, 9, 'Torn pages on arrival', '2023-07-10'),
(5, 9, 'Second-hand book sent as new', '2023-08-20'),
(5, 10, 'Different edition than listed', '2023-09-01'),
(5, 11, 'Sticker residue on cover', '2023-05-12'),
(3, 11, 'Cover damaged in shipping', '2023-06-20'),
(5, 12, 'Grip tape peeling', '2023-03-10'),
(3, 12, 'Racket snapped at joint', '2023-04-15'),
(5, 13, 'Strong chemical smell', '2023-06-01'),
(5, 14, 'Ball not properly inflated', '2023-05-20'),
(3, 14, 'Seam stitching unravelling', '2023-07-10'),
(5, 15, 'Expired product delivered', '2023-10-05'),
(5, 16, 'Counterfeit packaging suspected', '2023-11-01'),
(3, 16, 'Cream had different consistency', '2023-09-20'),
(3, 17, 'Handle detached on first use', '2023-02-10'),
(5, 18, 'Motor stopped working in 2 weeks', '2023-05-15'),
(5, 19, 'Flask leaking from lid', '2023-04-01'),
(3, 20, 'Left earbud not pairing', '2023-07-20'),
(5, 20, 'Charging case broken on arrival', '2023-08-10');
