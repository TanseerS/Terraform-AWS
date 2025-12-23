#!/bin/bash

# Build Lambda layer with Pillow and piexif for image processing
# This script creates a Docker-based build environment for consistent dependencies

set -e

echo "🏗️  Building Lambda layer with Pillow and piexif..."

# Create temporary directory for layer
TEMP_DIR="/tmp/lambda-layer"
PYTHON_DIR="$TEMP_DIR/python"
ZIP_FILE="image_layer.zip"

rm -rf "$TEMP_DIR"
mkdir -p "$PYTHON_DIR/lib/python3.12/site-packages"

echo "📦 Installing dependencies..."

# Use Docker to build in consistent environment
docker run --rm -v "$TEMP_DIR":/layer python:3.12-slim bash -c "
    apt-get update && apt-get install -y build-essential libjpeg-dev zlib1g-dev && \
    pip install --no-cache-dir -t /layer/python/lib/python3.12/site-packages Pillow==10.4.0 piexif==1.1.3 boto3"

echo "📁 Creating layer ZIP file..."
cd "$TEMP_DIR"
zip -r "$ZIP_FILE" python/

echo "✅ Moving layer to terraform directory..."
mv "$ZIP_FILE" "../terraform/"

echo "🧹 Cleaning up..."
rm -rf "$TEMP_DIR"

echo "🎉 Layer build complete! File: ../terraform/$ZIP_FILE"