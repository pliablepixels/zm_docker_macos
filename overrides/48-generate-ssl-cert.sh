#!/command/with-contenv bash
# ==============================================================================
# Generate self-signed SSL cert with the container's actual IP address
# Runs before nginx starts so the cert is ready
# ==============================================================================

CERT_FILE="/config/ssl/cert.cer"
KEY_FILE="/config/ssl/key.pem"

# Use ZM_SSL_IP if set, otherwise fall back to container IP
# Note: The host LAN IP cannot be reliably detected from inside a container.
# Set ZM_SSL_IP in .env to your host/LAN IP for browser-trusted certs.
if [ -n "$ZM_SSL_IP" ]; then
  CERT_IP="$ZM_SSL_IP"
  echo "Using ZM_SSL_IP from environment: $CERT_IP"
else
  CERT_IP=$(hostname -I | awk '{print $1}')
  echo "WARNING: ZM_SSL_IP not set, using container IP $CERT_IP (set ZM_SSL_IP in .env to your LAN IP)"
fi

if [ -z "$CERT_IP" ]; then
  echo "WARNING: Could not determine IP, skipping cert generation"
  exit 0
fi

# Check if existing cert already matches the current IP
if [ -f "$CERT_FILE" ]; then
  EXISTING_IPS=$(openssl x509 -in "$CERT_FILE" -text -noout 2>/dev/null | grep 'IP Address:' | sed 's/IP Address://g; s/DNS:[^,]*//g; s/,/ /g; s/^ *//')
  if echo "$EXISTING_IPS" | grep -qF "$CERT_IP"; then
    echo "SSL cert already matches IP $CERT_IP, skipping regeneration"
    exit 0
  fi
fi

echo "Generating self-signed SSL cert for IP: $CERT_IP"
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout "$KEY_FILE" \
  -out "$CERT_FILE" \
  -subj "/CN=$CERT_IP" \
  -addext "subjectAltName=IP:$CERT_IP,DNS:localhost,IP:127.0.0.1" \
  2>/dev/null

if [ $? -eq 0 ]; then
  echo "SSL cert generated for IP: $CERT_IP (valid 10 years)"
else
  echo "WARNING: Failed to generate SSL cert"
  exit 1
fi
