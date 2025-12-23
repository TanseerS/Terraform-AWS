#!/bin/bash

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <website-bucket-name>"
    exit 1
fi

WEBSITE_BUCKET="$1"

cd "$(dirname "$0")/../www"

aws s3 cp index.html "s3://$WEBSITE_BUCKET/" --content-type "text/html"
aws s3 cp style.css "s3://$WEBSITE_BUCKET/" --content-type "text/css"
aws s3 cp script.js "s3://$WEBSITE_BUCKET/" --content-type "application/javascript"

echo "Website files uploaded successfully!"