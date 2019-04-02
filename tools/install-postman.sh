echo "Installing Postman"

# Remove previous version
sudo rm -rf /opt/Postman

# Download latest Postman
wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz

# Unzip in /opt/Postman
sudo tar -xzf postman.tar.gz -C /opt

# Delete donwloaded installation file
rm postman.tar.gz

# Link to /usr/bin
sudo ln -s /opt/Postman/Postman /usr/bin/postman

echo "Completed Postman installation"
