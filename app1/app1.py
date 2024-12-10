from flask import Flask
app = Flask(__name__)

@app.route("/app1")
def hello():
    return "Hello, app 1 here!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
