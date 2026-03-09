#!/command/with-contenv bash
# Copy custom nginx config into place before 50-nginx-config.sh runs
cp /overrides/nginx.conf /etc/nginx/nginx.conf
echo "Custom nginx.conf installed (HTTP -> HTTPS redirect)"
