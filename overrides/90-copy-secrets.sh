#!/command/with-contenv bash
# ==============================================================================
# Copy Custom Secrets File
# Copies secrets.ini from overrides to /config on every container startup
# This ensures your custom secrets persist and overwrites container defaults
# ==============================================================================

OVERRIDE_SECRETS="/overrides/secrets.ini"
TARGET_SECRETS="/config/secrets.ini"

if [ -f "$OVERRIDE_SECRETS" ]; then
    echo "Copying custom secrets.ini from overrides..."
    cp -f "$OVERRIDE_SECRETS" "$TARGET_SECRETS"
    chmod 644 "$TARGET_SECRETS"
    echo "Custom secrets.ini copied successfully"
else
    echo "WARNING: Override secrets file not found at $OVERRIDE_SECRETS"
    exit 1
fi
