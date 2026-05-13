from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector
from datetime import datetime, date
import json
import os


app = Flask(__name__)
CORS(app)

# ─────────────────────────────────────────────
#  DB CONFIG  – update credentials as needed
# ─────────────────────────────────────────────
db = mysql.connector.connect(
    host=os.getenv("DB_HOST", "localhost"),
    user=os.getenv("DB_USER", "root12"),
    password=os.getenv("DB_PASSWORD", "ayaan@1228#$"),
    database=os.getenv("DB_NAME", "trust_system")
}

def get_db():
    return mysql.connector.connect(**db)

# ──────────────────────────────────────────────
#  TRUST SCORE ENGINE
# ──────────────────────────────────────────────
def compute_trust(rating, return_rate, complaint_count, is_earliest):
    rating_component    = rating / 5.0
    return_performance  = 1.0 - return_rate
    complaint_component = 1.0 / (1.0 + complaint_count)
    base_score = (rating_component * 0.4) + (return_performance * 0.4) + (complaint_component * 0.2)

    # Small bonus for being earliest lister
    if is_earliest:
        base_score = min(1.0, base_score + 0.03)

    trust_score = round(base_score, 4)

    if trust_score > 0.70:
        risk_level      = "Low Risk"
        risk_class      = "low"
        recommended     = True
        recommendation  = "Recommended"
    elif trust_score > 0.40:
        risk_level      = "Medium Risk"
        risk_class      = "medium"
        recommended     = False
        recommendation  = "Not Recommended"
    else:
        risk_level      = "High Risk"
        risk_class      = "high"
        recommended     = False
        recommendation  = "Not Recommended"

    # Build explainable reason
    reasons = []
    if rating >= 4.5:
        reasons.append("excellent customer ratings")
    elif rating >= 3.5:
        reasons.append("decent customer ratings")
    else:
        reasons.append("poor customer ratings")

    if return_rate <= 0.05:
        reasons.append("very low return rate")
    elif return_rate <= 0.15:
        reasons.append("moderate return rate")
    else:
        reasons.append("high return rate — caution advised")

    if complaint_count == 0:
        reasons.append("zero complaints on record")
    elif complaint_count <= 2:
        reasons.append(f"{complaint_count} complaint(s) on record")
    else:
        reasons.append(f"{complaint_count} complaints — high risk")

    if is_earliest:
        reasons.append("earliest listing (original seller)")

    explanation = "This seller has " + ", ".join(reasons) + "."

    return {
        "trust_score":    trust_score,
        "risk_level":     risk_level,
        "risk_class":     risk_class,
        "recommended":    recommended,
        "recommendation": recommendation,
        "explanation":    explanation
    }


# ──────────────────────────────────────────────
#  ROUTES
# ──────────────────────────────────────────────

@app.route("/")
def index():
    return jsonify({"message": "Seller Reliability Analysis API", "version": "1.0"})


@app.route("/products", methods=["GET"])
def get_products():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT p.*,
               COUNT(DISTINCT l.seller_id) AS seller_count,
               MIN(l.price)               AS min_price,
               MAX(l.price)               AS max_price,
               AVG(l.rating)              AS avg_rating
        FROM products p
        LEFT JOIN listings l ON p.product_id = l.product_id
        GROUP BY p.product_id
        ORDER BY p.product_id
    """)
    products = cursor.fetchall()
    cursor.close()
    db.close()

    for p in products:
        for k, v in p.items():
            if isinstance(v, (datetime, date)):
                p[k] = str(v)
            elif hasattr(v, '__float__'):
                p[k] = float(v) if v is not None else None

    return jsonify(products)


@app.route("/product/<int:product_id>", methods=["GET"])
def get_product(product_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM products WHERE product_id = %s", (product_id,))
    product = cursor.fetchone()
    cursor.close()
    db.close()

    if not product:
        return jsonify({"error": "Product not found"}), 404

    for k, v in product.items():
        if isinstance(v, (datetime, date)):
            product[k] = str(v)

    return jsonify(product)


@app.route("/trust-data/<int:product_id>", methods=["GET"])
def get_trust_data(product_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    # Get all listings for this product
    cursor.execute("""
        SELECT l.*, s.seller_name, s.location, s.joined_date, s.total_sales, s.profile_image
        FROM listings l
        JOIN sellers s ON l.seller_id = s.seller_id
        WHERE l.product_id = %s
        ORDER BY l.listed_date ASC
    """, (product_id,))
    listings = cursor.fetchall()

    if not listings:
        cursor.close()
        db.close()
        return jsonify({"error": "No listings found for this product"}), 404

    # Count complaints per seller for this product
    cursor.execute("""
        SELECT seller_id, COUNT(*) AS complaint_count
        FROM complaints
        WHERE product_id = %s
        GROUP BY seller_id
    """, (product_id,))
    complaint_map = {row["seller_id"]: row["complaint_count"] for row in cursor.fetchall()}

    cursor.close()
    db.close()

    # Find earliest lister
    earliest_seller_id = listings[0]["seller_id"]  # already sorted by listed_date ASC

    results = []
    for l in listings:
        sid             = l["seller_id"]
        rating          = float(l["rating"])
        return_rate     = float(l["return_rate"])
        complaint_count = complaint_map.get(sid, 0)
        is_earliest     = (sid == earliest_seller_id)

        trust_info = compute_trust(rating, return_rate, complaint_count, is_earliest)

        results.append({
            "listing_id":      l["listing_id"],
            "seller_id":       sid,
            "seller_name":     l["seller_name"],
            "location":        l["location"],
            "joined_date":     str(l["joined_date"]) if l["joined_date"] else None,
            "total_sales":     l["total_sales"],
            "price":           float(l["price"]),
            "rating":          rating,
            "return_rate":     return_rate,
            "listed_date":     str(l["listed_date"]) if l["listed_date"] else None,
            "stock":           l["stock"],
            "complaint_count": complaint_count,
            "is_earliest":     is_earliest,
            **trust_info
        })

    # Sort: recommended first, then by trust score descending
    results.sort(key=lambda x: (-int(x["recommended"]), -x["trust_score"]))

    # Mark best seller
    if results:
        results[0]["is_best"] = True
        for r in results[1:]:
            r["is_best"] = False

    return jsonify({
        "product_id": product_id,
        "sellers":    results,
        "total":      len(results)
    })


@app.route("/place-order", methods=["POST"])
def place_order():
    data = request.get_json()
    db = get_db()
    cursor = db.cursor()

    cursor.execute("""
        INSERT INTO orders (product_id, seller_id, customer_name, quantity, total_price)
        VALUES (%s, %s, %s, %s, %s)
    """, (
        data.get("product_id"),
        data.get("seller_id"),
        data.get("customer_name", "Guest"),
        data.get("quantity", 1),
        data.get("total_price")
    ))
    db.commit()
    order_id = cursor.lastrowid
    cursor.close()
    db.close()

    return jsonify({"success": True, "order_id": order_id, "message": "Order placed successfully!"})


@app.route("/sellers", methods=["GET"])
def get_sellers():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM sellers ORDER BY total_sales DESC")
    sellers = cursor.fetchall()
    cursor.close()
    db.close()
    for s in sellers:
        for k, v in s.items():
            if isinstance(v, (datetime, date)):
                s[k] = str(v)
    return jsonify(sellers)


if __name__ == "__main__":
    app.run(debug=True, port=5000)
