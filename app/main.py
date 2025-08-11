from flask import Flask, jsonify, render_template

app = Flask(__name__)


@app.get("/")
def dashboard():
    return render_template(
        "index.html",
        app_name="VPN-Protected Dashboard",
        status="ok",
        vpn_subnet="10.8.0.0/24",
    )


@app.get("/api/health")
def health():
    return jsonify(
        {
            "app": "VPN-Protected Dashboard",
            "status": "ok",
            "message": "Accessible only over the VPN subnet (10.8.0.0/24).",
        }
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
