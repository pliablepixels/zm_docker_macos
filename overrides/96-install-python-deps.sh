#!/command/with-contenv bash
# ==============================================================================
# Install Python3, pip3, git, opencv-python and clone repos into /pp
# Runs once on container startup
# ==============================================================================

echo "Installing git, python3, pip3, vim..."
apt-get update -qq > /dev/null 2>&1
apt-get install -y git python3 python3-pip vim sudo > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "WARNING: Failed to install git/python3/pip3"
    exit 1
fi

echo "Installing opencv-python..."
pip3 install opencv-python --break-system-packages > /dev/null 2>&1 || \
    pip3 install opencv-python > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "WARNING: Failed to install opencv-python"
    exit 1
fi

# Clone repos only if not already present (they persist on the volume)
mkdir -p /pp

if [ ! -d "/pp/zmeventnotification/.git" ]; then
    echo "Cloning zmeventnotification into /pp..."
    git clone https://github.com/pliablepixels/zmeventnotification /pp/zmeventnotification
fi

if [ ! -d "/pp/pyzm/.git" ]; then
    echo "Cloning pyzm into /pp..."
    git clone https://github.com/pliablepixels/pyzm /pp/pyzm
fi

echo "Python deps and repos ready"
