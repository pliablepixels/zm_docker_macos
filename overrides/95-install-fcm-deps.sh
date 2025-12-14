#!/command/with-contenv bash
# ==============================================================================
# Install FCM Direct Push Dependencies
# Runs once on container startup to install required Perl modules
# ==============================================================================

# Check if module is already installed
if perl -e 'use Crypt::OpenSSL::RSA;' 2>/dev/null; then
    echo "FCM dependencies already installed, skipping..."
    exit 0
fi

echo "Installing FCM dependencies for direct push with service account..."
apt-get update -qq > /dev/null 2>&1
apt-get install -y libcrypt-openssl-rsa-perl > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "FCM dependencies installed successfully"
else
    echo "WARNING: Failed to install FCM dependencies"
    exit 1
fi
