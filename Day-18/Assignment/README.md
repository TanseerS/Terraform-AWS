# Image Processor with Watermarking and EXIF Extraction

A complete serverless image processing application with web frontend, API Gateway, and advanced features.

## 🎯 Features

- **Watermarking**: Automatic watermark added to all processed images
- **EXIF Metadata Extraction**: Extract and display image metadata (camera info, timestamps, etc.)
- **Multiple Output Formats**: JPEG, PNG, WebP with different quality levels
- **API Gateway Integration**: Direct API uploads via HTTP POST
- **Web Frontend**: Drag-and-drop interface for easy uploads
- **Thumbnail Generation**: Automatic thumbnail creation
- **Smart Resizing**: Handle large images automatically

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Web Frontend  │    │   API Gateway   │    │   Lambda Func   │
│   (S3 Static)   │───▶│   (REST API)    │───▶│   (Processor)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Upload S3     │    │   Processed S3  │    │   Website S3    │
│   (Source)      │    │   (Output)      │    │   (Frontend)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Deployment

### Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform v1.0+
- Docker (for building Lambda layers)

### Quick Deploy

```bash
# Navigate to the assignment directory
cd Day-18/Assignment

# Deploy everything
./scripts/deploy.sh
```

The script will:
1. Build the Lambda layer with Pillow and piexif
2. Initialize Terraform
3. Plan and apply the infrastructure
4. Display all endpoints and bucket names

### Manual Deployment

```bash
# Build Lambda layer
./scripts/build_layer_docker.sh

# Initialize Terraform
cd terraform
terraform init

# Plan deployment
terraform plan -out=tfplan

# Apply
terraform apply tfplan
```

## 📸 Usage

### Web Interface

After deployment, access the web interface at the provided website URL. The interface allows:
- Drag & drop image uploads
- Real-time metadata display
- Processed image previews

### API Usage

Upload images directly via API:

```bash
curl -X POST https://your-api-gateway-url/upload \
  -H "Content-Type: application/json" \
  -H "x-file-name: my-image.jpg" \
  -d @image_data.json
```

### S3 Upload

Traditional S3 upload still works:

```bash
aws s3 cp image.jpg s3://your-upload-bucket/
```

## 🎨 Processing Features

### Watermarking
- Text: "© Image Processor"
- Position: Bottom-right corner
- Semi-transparent background

### EXIF Extraction
- Camera make/model
- Date/time information
- Exposure settings
- GPS data (if available)

### Output Variants
1. **Compressed JPEG** (85% quality)
2. **Low Quality JPEG** (60% quality)
3. **WebP** (85% quality)
4. **PNG** (lossless)
5. **Thumbnail** (300x300px)

## 🔧 Configuration

### Environment Variables (Lambda)
- `PROCESSED_BUCKET`: Destination S3 bucket
- `UPLOAD_BUCKET`: Source S3 bucket
- `LOG_LEVEL`: Logging level (INFO/DEBUG)

### Customization

Edit `lambda/lambda_function.py` to modify:
- Watermark text and position
- Output quality settings
- Thumbnail dimensions
- Supported formats

## 📊 Monitoring

```bash
# View Lambda logs
aws logs tail /aws/lambda/YOUR-FUNCTION-NAME --follow

# Check API Gateway metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/ApiGateway \
  --metric-name Count \
  --dimensions Name=ApiName,Value=YOUR-API-NAME \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Sum
```

## 🧹 Cleanup

```bash
# Destroy all resources
./scripts/destroy.sh
```

## 💰 Cost Estimation

**Monthly costs** (approximate):

- **S3 Storage**: $0.023/GB
- **Lambda**: $0.20 per 1M requests
- **API Gateway**: $3.50 per million requests
- **CloudFront** (optional): $0.085/GB

**Example**: 1,000 images/month ≈ $1-3

## 🔐 Security

- All buckets are private
- Server-side encryption (AES256)
- IAM least privilege
- No public access to processed images
- CORS configured for web interface

## 📝 Notes

- Lambda timeout: 60 seconds
- Max image size: Limited by Lambda memory (1024MB)
- Supported input formats: JPEG, PNG, WebP, BMP, TIFF
- Processing time: ~2-10 seconds per image