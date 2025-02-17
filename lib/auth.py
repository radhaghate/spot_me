from flask import Flask, request, jsonify, session
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

import jwt
import datetime
import bcrypt

# Initialize Flask and Database
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'  # SQLite database
app.config['SECRET_KEY'] = 'your_secret_key_here'
db = SQLAlchemy(app)
CORS(app)

# Create a User model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(100), unique=True, nullable=False)
    password = db.Column(db.String(100), nullable=False)

    #Additional info
    campus = db.Column(db.String(200))
    gender = db.Column(db.String(15))
    grade = db.Column(db.String(200))



# Create the database and the table (Run this once to create the database)
with app.app_context():
    db.create_all()

# User Registration Route
@app.route('/register', methods=['POST'])
def register():
    username = request.json.get('username')
    password = request.json.get('password')

    if not username or not password:
        return jsonify({"message": "Username and password are required"}), 400

    # Check if the user already exists
    user = User.query.filter_by(username=username).first()
    if user:
        return jsonify({"message": "User already exists"}), 400

    # Hash the password before saving
    hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

    # Create a new user and save to the database
    new_user = User(username=username, password=hashed_password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "User registered successfully"}), 201

# User Login Route (Authentication)
'''@app.route('/login', methods=['POST'])
def login():
    username = request.json.get('username')
    password = request.json.get('password')

    logging.debug(f"Received username: {username}")
    logging.debug(f"Received password: {password}")

    # Check if the user exists
    user = User.query.filter_by(username=username).first()
    if not user:
        return jsonify({"message": "Invalid credentials"}), 401

    # Check if the password is correct
    if not bcrypt.checkpw(password.encode('utf-8'), user.password):
        return jsonify({"message": "Invalid credentials"}), 401

    # Create JWT token
    payload = {
        'sub': username,
        'iat': datetime.datetime.utcnow(),
        'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1)
    }
    token = jwt.encode(payload, app.config['SECRET_KEY'], algorithm='HS256')


    session['username'] = username

    return jsonify({"token": token}), 200
'''
'''
doesn't work
@app.route('/login', methods=['POST'])
def login():
    username = request.json.get('username')
    password = request.json.get('password')


    # Hardcoded credentials
    if username != "kg904" or password != "happy":
        return jsonify({"message": "Invalid credentials"}), 401

    # Create JWT token
    payload = {
        'sub': username,
        'iat': datetime.datetime.utcnow(),
        'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1)
    }
    token = jwt.encode(payload, app.config['SECRET_KEY'], algorithm='HS256')

    session['username'] = username

    return jsonify({"token": token}), 200
'''

@app.route('/login', methods=['POST'])
def login():
    data = request.json  # Get JSON data from the request

    if not data or 'username' not in data or 'password' not in data:
        return jsonify({"message": "Missing credentials"}), 400

    # credentials
    if (data['username'] == "kg904" and data['password'] == "happy") or (data['username'] == "rsg169" and data['password'] == "12345"):
        return jsonify({"message": "Login successful"}), 200
    else:
        return jsonify({"message": "Invalid credentials"}), 401
    
    



@app.route('/update_questionnaire', methods=['POST'])
def update_questionnaire():
    # Get username from the session
    username = session.get('username')
    
    if not username:
        return jsonify({"message": "User not logged in"}), 401

    campus = request.json.get('campus')
    gender = request.json.get('gender')
    grade = request.json.get('grade')

    user = User.query.filter_by(username=username).first()
    if not user:
        return jsonify({"message": "User not found"}), 404

    # Update user details with questionnaire information
    user.campus = campus
    user.gender = gender
    user.grade = grade

    db.session.commit()

    return jsonify({"message": "Questionnaire updated successfully"}), 200



if __name__ == '__main__':
    app.run(debug=True, port = 50001)