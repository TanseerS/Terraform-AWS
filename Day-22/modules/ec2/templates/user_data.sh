#!/bin/bash
apt-get update
apt-get install -y python3 python3-pip mysql-client

pip3 install flask pymysql

cat > /home/ubuntu/app.py << 'EOF'
from flask import Flask
import pymysql
import os

app = Flask(__name__)

def get_db_connection():
    return pymysql.connect(
        host='${rds_endpoint}'.split(':')[0],
        user='${db_username}',
        password='${db_password}',
        database='${db_name}',
        port=3306
    )

@app.route('/')
def home():
    return 'Hello from Flask on AWS!'

@app.route('/health')
def health():
    try:
        conn = get_db_connection()
        conn.close()
        return 'Database connection successful!'
    except Exception as e:
        return f'Database connection failed: {str(e)}'

@app.route('/db-info')
def db_info():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT VERSION()")
        version = cursor.fetchone()
        conn.close()
        return f'MySQL Version: {version[0]}'
    except Exception as e:
        return f'Error: {str(e)}'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
EOF

python3 /home/ubuntu/app.py