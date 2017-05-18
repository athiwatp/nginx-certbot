# Generate stronger, 4096 bit long DH parameters.
if [ ! -f /etc/ssl/dhparams.pem ]; then
    echo "Create dhparams..."
    # Create a directory for our SSL certificates
    sudo mkdir /etc/ssl

    # Generate stronger, 4096 bit long DH parameters.
    sudo openssl dhparam -out /etc/ssl/dhparams.pem 4096
fi

# Read only.
chmod 600 /etc/ssl/dhparams.pem