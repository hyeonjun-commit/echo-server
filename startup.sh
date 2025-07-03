#! /bin/bash
exec > /var/log/startup-script.log 2>&1

# 1) 환경 준비
apt-get update -y
apt-get install -y python3-venv git

# 2) 앱 코드 가져오기 (예: GCS public bucket)
mkdir -p /opt/echo
gsutil cp gs://YOUR_BUCKET/fastapi-echo.tar.gz /opt/echo/
tar -xzf /opt/echo/fastapi-echo.tar.gz -C /opt/echo/

# 3) Python venv + 의존성
python3 -m venv /opt/echo/venv
/opt/echo/venv/bin/pip install --upgrade pip
/opt/echo/venv/bin/pip install -r /opt/echo/requirements.txt

# 4) systemd 서비스
cat >/etc/systemd/system/echo.service <<'EOF'
[Unit]
Description=FastAPI Echo
After=network.target

[Service]
User=root
WorkingDirectory=/opt/echo
ExecStart=/opt/echo/venv/bin/uvicorn main:app --host 0.0.0.0 --port 80
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now echo.service
