#!/bin/bash

set -e

TEMP_DIR="/tmp/lambda-layer"
PYTHON_DIR="$TEMP_DIR/python"
ZIP_FILE="image_layer.zip"

rm -rf "$TEMP_DIR"
mkdir -p "$PYTHON_DIR/lib/python3.12/site-packages"

docker run --rm -v "$TEMP_DIR":/layer python:3.12-slim bash -c "
    apt-get update && apt-get install -y build-essential libjpeg-dev zlib1g-dev && \
    pip install --no-cache-dir -t /layer/python/lib/python3.12/site-packages Pillow==10.4.0 piexif==1.1.3 boto3"

cd "$TEMP_DIR"
zip -r "$ZIP_FILE" python/

mv "$ZIP_FILE" "../terraform/"

rm -rf "$TEMP_DIR"