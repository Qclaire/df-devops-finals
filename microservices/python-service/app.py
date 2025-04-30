from flask import Flask
import requests
import os

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
        return f"Python → Go: {resp.text.strip()}", resp.status_code
    except Exception as e:
        return f"Error calling Go service: {e}", 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)