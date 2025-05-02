from flask import Flask
import requests
import os
from flask import jsonify

app = Flask(__name__)

GO_SERVICE_HOST = os.environ.get("GO_SERVICE_HOST", "go-service")
GO_SERVICE_PORT = os.environ.get("GO_SERVICE_PORT", "8080")


@app.route("/health")
def health():
    return "OK", 200


@app.route("/chain")
def chain():
    try:
        url = f"http://{GO_SERVICE_HOST}:{GO_SERVICE_PORT}/health"
        resp = requests.get(url, timeout=2)
        resp.raise_for_status()

        go_data = resp.json()
        return jsonify({
            "service_name": "python-gateway",
            "status": "ok",
            "role": "API Gateway",
            "go_service_response": go_data
        }), 200
    except Exception as e:
        return jsonify({
            "service_name": "python-gateway",
            "status": "error",
            "role": "API Gateway",
            "error": str(e)
        }), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)