from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({"message": "Auth Service is running"})

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    return jsonify({"message": f"Welcome {username}!"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)

