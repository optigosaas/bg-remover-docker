name: Build & Push BG Remover

on:
  push:
    branches: [ "main" ]
  workflow_dispatch:

env:
  IMAGE_NAME: bgremover
  IMAGE_TAG: 1.5

jobs:
  build-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
    - name: Checkout
      uses: actions/checkout@v4

    - name: Set up QEMU
      uses: docker/setup-qemu-action@v3

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3

    - name: Login to Docker Hub
      uses: docker/login-action@v3
      with:
        username: ${{ secrets.DOCKERHUB_USER }}
        password: ${{ secrets.DOCKERHUB_TOKEN }}

    - name: Build & Push
      uses: docker/build-push-action@v5
      with:
        context: .
        push: true
        tags: ${{ secrets.DOCKERHUB_USER }}/${{ env.IMAGE_NAME }}:${{ env.IMAGE_TAG }}
        cache-from: type=registry,ref=${{ secrets.DOCKERHUB_USER }}/${{ env.IMAGE_NAME }}:cache
        cache-to: type=registry,ref=${{ secrets.DOCKERHUB_USER }}/${{ env.IMAGE_NAME }}:cache,mode=max
