# syntax=docker/dockerfile:1

# ---------- Stage 1: build image ----------
FROM python:3.10-slim AS builder

# Install rembg con supporto GPU (CUDA 11.8) + pillow
RUN pip install --no-cache-dir "rembg[gpu]" pillow

# ---------- Stage 2: runtime ----------
FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04

# Copia i binari Python da builder
COPY --from=builder /usr/local /usr/local

# Includi tini come init per correttezza dei signal
RUN apt-get update && apt-get install -y --no-install-recommends tini && \
    rm -rf /var/lib/apt/lists/*

ENV NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility

# 7000 è la porta che userai in RunPod
EXPOSE 7000

# Avvia rembg in modalità server GPU
ENTRYPOINT ["/usr/bin/tini","--"]
CMD ["rembg","s","-p","7000"]
