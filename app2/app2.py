from flask import Flask
app = Flask(__name__)

@app.route("/app2")
def hello():
    return "Hello, app 2 here!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
