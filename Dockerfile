FROM python:3.10-slim

# Install basic tools
RUN apt-get update && apt-get install -y wget gcc g++ ca-certificates && rm -rf /var/lib/apt/lists/*

# Install CloudWatch Agent
RUN wget -q https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -O /tmp/cw-agent.deb && \
    dpkg -i /tmp/cw-agent.deb || true && \
    apt-get -f install -y && \
    rm /tmp/cw-agent.deb

# Copy CloudWatch config
COPY cloudwatch-agent-config.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# Install Python deps
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY src /opt/src
WORKDIR /opt/src

# Run startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
