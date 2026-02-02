FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install build deps AND dos2unix (Critical for Windows devs)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# --- FIXED: Lowercase 'config' ---
COPY config/entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh && chmod +x /entrypoint.sh

# --- FIXED: Lowercase 'volguard' ---
COPY volguard/volguard.py /app/

# Create user but DO NOT switch to it yet. 
# We need root in the entrypoint to fix volume permissions first.
RUN groupadd -g 1000 volguard && useradd -u 1000 -g 1000 volguard

ENTRYPOINT ["/entrypoint.sh"]