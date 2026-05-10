# 🛡 TrustMart — Seller Reliability Analysis System

A full-stack e-commerce trust analysis platform. Every seller is scored, classified, and explained before you buy.

---

## 📁 Project Structure

```
seller-trust-app/
├── backend/
│   ├── app.py              ← Flask REST API
│   ├── schema.sql          ← MySQL database + seed data
│   └── requirements.txt    ← Python dependencies
└── frontend/
    ├── index.html          ← Login page
    ├── marketplace.html    ← Product listing
    ├── product.html        ← Product detail + seller comparison + charts
    ├── cart.html           ← Shopping cart + checkout
    └── seller.html         ← Seller profile page
```

---

## 🚀 Setup Instructions

### Step 1 — MySQL Database

1. Open **MySQL Workbench** (or any MySQL client)
2. Run the file: `backend/schema.sql`
   - This creates the `seller_trust_db` database
   - Creates all 5 tables: products, sellers, listings, complaints, orders
   - Inserts 8 products, 8 sellers, and 32+ listings with realistic data

### Step 2 — Backend (Flask API)

```bash
cd backend

# Install dependencies
pip install -r requirements.txt

# Edit app.py — update your MySQL password on line 17:
# "password": "your_password"

# Start the API server
python app.py
```

The API runs on: `http://localhost:5000`

### Step 3 — Frontend

Simply open `frontend/index.html` in your browser.

> **Tip:** Use VS Code Live Server extension for the best experience, or run:
> ```bash
> cd frontend
> python -m http.server 8080
> ```
> Then visit `http://localhost:8080`

---

## 🔐 Demo Login

| Field    | Value    |
|----------|----------|
| Username | `demo`   |
| Password | `demo123`|

Or click **Browse as Guest** to skip login.

---

## 🌐 API Endpoints

| Method | Endpoint                    | Description                        |
|--------|-----------------------------|------------------------------------|
| GET    | `/products`                 | All products with seller count     |
| GET    | `/product/<id>`             | Single product details             |
| GET    | `/trust-data/<product_id>`  | Sellers + trust scores for product |
| GET    | `/sellers`                  | All sellers                        |
| POST   | `/place-order`              | Place an order                     |

---

## 🧮 Trust Score Formula

```
Trust Score = (Rating/5 × 0.40) + ((1 - return_rate) × 0.40) + (1/(1+complaints) × 0.20)
```

| Score Range | Risk Level  | Recommendation     |
|-------------|-------------|-------------------|
| > 0.70      | Low Risk    | ✅ Recommended     |
| 0.40–0.70   | Medium Risk | ⚠️ Not Recommended |
| < 0.40      | High Risk   | ❌ Not Recommended |

---

## 🎯 Features

- ✅ Login / Guest mode
- ✅ Product marketplace with search & category filter
- ✅ Trust score computation per seller
- ✅ Risk classification (Low / Medium / High)
- ✅ Explainable AI reasoning per seller
- ✅ 4 interactive charts (trust, scatter, complaints, price)
- ✅ Safe seller toggle filter
- ✅ Shopping cart with trust warnings
- ✅ Order placement (connected to MySQL)
- ✅ Seller profile pages with radar chart
- ✅ "Best Seller" and "Original Lister" badges
- ✅ Responsive design

---

## 🛠 Tech Stack

| Layer    | Technology                    |
|----------|-------------------------------|
| Frontend | HTML5, CSS3, JavaScript, Chart.js |
| Backend  | Python 3.10+, Flask, Flask-CORS   |
| Database | MySQL                             |
| Fonts    | Syne (display), DM Sans (body)    |
