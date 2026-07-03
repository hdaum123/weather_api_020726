# Flask Weather API – AWS Cloud Deployment & Infrastructure Documentation

This project demonstrates the deployment of a Python Flask Weather API application onto an AWS EC2 Ubuntu virtual machine using an automated Bash deployment script. The application accepts a UK postcode and returns live weather information by consuming the OpenWeather API.

The deployment process was designed to demonstrate the differences between deploying a Python Flask applications compared to Node.js applications, including dependency management, Python virtual environments, repository retrieval using Git, and reverse proxy configuration using Nginx.

---

# ☁️ Cloud Infrastructure Overview

The application was deployed using the following cloud infrastructure:

| Component | Configuration |
|----------|--------------|
| Cloud Provider | Amazon Web Services (AWS) |
| Compute Service | EC2 |
| Instance Type | t3.micro |
| Operating System | Ubuntu Server 24.04 LTS |
| Web Server | Nginx |
| Application Framework | Flask |
| Programming Language | Python 3 |
| Repository Management | Git/GitHub |
| Process Execution | Python Virtual Environment |

---

# 🏗 System Architecture

The deployment architecture separates responsibilities into multiple layers.

## Web Server Layer (Nginx)

Nginx acts as a reverse proxy server. Instead of exposing the Flask development server directly to the internet, Nginx listens on port 80 and forwards incoming requests internally to the Flask application running on port 5000.

## Application Layer (Flask)

The Flask application processes incoming postcode requests, validates location data, communicates with the OpenWeather API, and returns formatted weather information.

## Python Virtual Environment Layer

The Python virtual environment (`venv`) isolates application dependencies from Ubuntu's global Python installation. This prevents dependency conflicts and improves portability.

## API Integration Layer

The application communicates with the OpenWeather API to retrieve weather data after converting UK postcodes into geographic coordinates.

---

# 📋 AWS Infrastructure Requirements

Before deployment, the AWS EC2 Security Group was configured with the following inbound rules:

| Type | Port | Source | Purpose |
|------|------|---------|---------|
| SSH | 22 | My IP | Secure remote administration |
| HTTP | 80 | Anywhere | Public access to the application |

---

# 🖥 Deployment Script Creation

The deployment automation script was created locally using Visual Studio Code.

The purpose of the deployment script was to automate:

- System updates
- Dependency installation
- Repository cloning
- Python virtual environment creation
- Flask dependency installation
- Nginx reverse proxy configuration

The deployment script was saved as:

```text
setupflask.sh
```

---

# 🚀 Cloud Deployment Procedure

## Step 1 – Transfer Deployment Script

The deployment script was transferred from the local machine to the EC2 instance using Secure Copy Protocol (SCP):

```bash
scp -i ~/.ssh/homaira-tech610-key.pem ./setupflask.sh ubuntu@3.253.49.214:/home/ubuntu/
```

---

## Step 2 – Establish SSH Connection

The EC2 instance was accessed securely using SSH:

```bash
ssh -i ~/.ssh/homaira-tech610-key.pem ubuntu@3.253.49.214
```

---

## Step 3 – Authorise Script Execution

The deployment script was given executable permissions:

```bash
chmod +x setupflask.sh
```

---

## Step 4 – Execute Deployment Script

The automated deployment script was executed:

```bash
./setupflask.sh
```

The script performed the following operations.

### System Updates

```bash
sudo apt update
sudo apt upgrade -y
```

### Package Installation

```bash
sudo apt install nginx -y
sudo apt install python3 -y
sudo apt install python3-pip -y
sudo apt install python3-venv -y
sudo apt install git -y
```

### Repository Retrieval

Rather than manually transferring the Flask application files, the source code was retrieved directly from GitHub using Git.

```bash
git clone https://github.com/hdaum123/spartaglobal.git
```

The project directory was then accessed:

```bash
cd spartaglobal
```

This ensured that the EC2 instance was running the exact same version of the application stored within the GitHub repository.

### Python Virtual Environment Creation

```bash
python3 -m venv venv
source venv/bin/activate
```

### Python Dependency Installation

```bash
pip install flask requests
```

### Nginx Reverse Proxy Configuration

```bash
sudo sed -i 's|try_files \$uri \$uri/ =404;|proxy_pass http://localhost:5000;|' /etc/nginx/sites-available/default

sudo nginx -t
sudo systemctl restart nginx
```

---
# 🔑 API Authentication Configuration

The Flask Weather API application requires an OpenWeather API key in order to retrieve live weather information.

After the deployment script completed, the API key file was created manually on the EC2 instance.

The project directory was accessed:

```bash
cd ~/spartaglobal
```

The API key file was then opened using Nano:

```bash
nano api_key.py
```

The OpenWeather API key was pasted into the file as plain text:

```text
YOUR_OPENWEATHER_API_KEY
```

The file was then saved using:

```text
CTRL + O
ENTER
CTRL + X
```

The API key was verified using:

```bash
cat api_key.py
```

This step was necessary because the Flask application reads the API key directly from the `api_key.py` file when making requests to the OpenWeather API service.

> **Security Note:** API keys should not be committed to public GitHub repositories. In a production environment, environment variables or secret management services should be used instead of plain text files.
---

# 🐍 Running the Flask Application

After deployment, the Python virtual environment was activated:

```bash
source venv/bin/activate
```

The Flask application was started using:

```bash
python main.py
```

The application successfully started on:

```text
http://127.0.0.1:5000
```

---

# 🌐 Reverse Proxy Configuration

Nginx was configured as a reverse proxy.

The request flow is:

```text
Internet
    ↓
Port 80
    ↓
Nginx
    ↓
localhost:5000
    ↓
Flask Application
```

This configuration allows the Flask application to be accessed publicly without exposing the Flask development server directly.

---

# 🔄 Dependency Changes Compared to Node.js Deployment

Compared to the previous Node.js deployment, several dependencies changed.

## Node.js Deployment

- nodejs
- npm
- pm2

## Flask Deployment

- python3
- python3-pip
- python3-venv
- flask
- requests

Additionally, Python virtual environments were required to isolate project dependencies.

---

# ✅ Application Testing

The deployed API was tested using the EC2 public IP address.

Example request:

```text
http://3.253.49.214/weather_api?postcode=se28+8dq
```

Example response:

```json
{
    "condition": "overcast clouds",
    "feels_like": 24.26,
    "humidity": 44,
    "location": "Abbey Wood",
    "postcode": "se28 8dq",
    "temperature": 24.6,
    "wind_speed": 1.79
}
```

The application was also successfully tested through the browser interface.

---

# 🎯 Conclusion

This project successfully demonstrated the deployment of a Flask Weather API application to AWS EC2 using an Ubuntu 24 t3.micro instance and an automated Bash deployment script.

The deployment required a different software stack compared to previous Node.js deployments, including Python-specific package management, Python virtual environments, and Flask dependencies.

The application source code was retrieved directly from GitHub using Git, ensuring deployment consistency and maintainability.

Nginx was successfully configured as a reverse proxy, allowing external HTTP requests to be securely forwarded to the Flask application running on port 5000.

The use of an automated deployment script (`setupflask.sh`) reduced manual configuration and provided a repeatable deployment workflow for future Flask applications.
