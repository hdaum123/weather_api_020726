sudo apt update
sudo apt upgrade -y

sudo apt install nginx -y

sudo apt install python3-pip -y
sudo apt install python3 -y
sudo apt install python3-venv -y
sudo apt install git -y

git clone https://github.com/hdaum123/spartaglobal.git

cd spartaglobal

python3 -m venv venv
source venv/bin/activate

pip install flask requests


sudo sed -i 's|try_files \$uri \$uri/ =404;|proxy_pass http://localhost:5000;|' /etc/nginx/sites-available/default

# Restart Nginx
sudo nginx -t
sudo systemctl restart nginx
