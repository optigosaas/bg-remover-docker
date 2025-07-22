FROM python:3.11-slim
WORKDIR /app

# librerie: rembg GPU + server
RUN apt-get update \
    && apt-get install -y git \
    && pip install --no-cache-dir "rembg[gpu]==2.0.52" fastapi uvicorn \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY server.py ./server.py
EXPOSE 7000
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "7000"]
