import json
import boto3
import os
import logging
from urllib.parse import unquote_plus
from io import BytesIO
from PIL import Image, ImageDraw, ImageFont
import uuid
import piexif
from datetime import datetime

# Configure logging
logger = logging.getLogger()
logger.setLevel(os.environ.get('LOG_LEVEL', 'INFO'))

s3_client = boto3.client('s3')

# Supported formats
SUPPORTED_FORMATS = ['JPEG', 'PNG', 'WEBP', 'BMP', 'TIFF']
DEFAULT_QUALITY = 85
MAX_DIMENSION = 4096

def lambda_handler(event, context):
    """
    Lambda function to process images uploaded to S3.
    Supports compression, format conversion, watermarking, and EXIF extraction.
    """
    try:
        logger.info(f"Received event: {json.dumps(event)}")

        # Check if this is an API Gateway call or S3 event
        if 'Records' in event:
            # S3 event trigger
            return handle_s3_event(event)
        else:
            # API Gateway direct upload
            return handle_api_upload(event)

    except Exception as e:
        logger.error(f"Error processing image: {str(e)}", exc_info=True)
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e)
            })
        }

def handle_s3_event(event):
    """Handle S3 event triggered uploads"""
    processed_count = 0

    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = unquote_plus(record['s3']['object']['key'])

        logger.info(f"Processing image: {key} from bucket: {bucket}")

        # Download the image from S3
        response = s3_client.get_object(Bucket=bucket, Key=key)
        image_data = response['Body'].read()

        # Process the image
        processed_images, metadata = process_image(image_data, key)

        # Upload processed images to the processed bucket
        processed_bucket = os.environ['PROCESSED_BUCKET']

        for processed_image in processed_images:
            output_key = processed_image['key']
            output_data = processed_image['data']
            content_type = processed_image['content_type']

            logger.info(f"Uploading processed image: {output_key}")

            s3_client.put_object(
                Bucket=processed_bucket,
                Key=output_key,
                Body=output_data,
                ContentType=content_type,
                Metadata={
                    'original-key': key,
                    'processed-by': 'lambda-image-processor',
                    'exif-data': json.dumps(metadata)
                }
            )

        processed_count += len(processed_images)
        logger.info(f"Successfully processed {len(processed_images)} variants of {key}")

    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Image processed successfully',
            'processed_images': processed_count
        })
    }

def handle_api_upload(event):
    """Handle direct API Gateway uploads"""
    try:
        # Parse the multipart form data
        if 'body' not in event:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'No image data provided'})
            }

        # For simplicity, assume base64 encoded image in body
        import base64
        image_data = base64.b64decode(event['body'])

        # Generate a unique key
        file_name = event.get('headers', {}).get('x-file-name', f'upload_{uuid.uuid4().hex}.jpg')
        key = f"api-uploads/{file_name}"

        # Process the image
        processed_images, metadata = process_image(image_data, key)

        # Upload to upload bucket first (to trigger S3 event processing)
        upload_bucket = os.environ.get('UPLOAD_BUCKET')
        s3_client.put_object(
            Bucket=upload_bucket,
            Key=key,
            Body=image_data,
            ContentType='image/jpeg'
        )

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Image uploaded and processed successfully',
                'key': key,
                'metadata': metadata,
                'processed_variants': len(processed_images)
            })
        }

    except Exception as e:
        logger.error(f"Error in API upload: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }

def extract_exif_metadata(image_data):
    """Extract EXIF metadata from image"""
    try:
        exif_dict = piexif.load(image_data)

        metadata = {}

        # Extract basic EXIF data
        if '0th' in exif_dict:
            zeroth = exif_dict['0th']
            metadata.update({
                'make': zeroth.get(piexif.ImageIFD.Make, b'').decode('utf-8', errors='ignore').strip('\x00'),
                'model': zeroth.get(piexif.ImageIFD.Model, b'').decode('utf-8', errors='ignore').strip('\x00'),
                'orientation': zeroth.get(piexif.ImageIFD.Orientation, 1),
            })

        if 'Exif' in exif_dict:
            exif = exif_dict['Exif']
            metadata.update({
                'datetime_original': exif.get(piexif.ExifIFD.DateTimeOriginal, b'').decode('utf-8', errors='ignore').strip('\x00'),
                'datetime_digitized': exif.get(piexif.ExifIFD.DateTimeDigitized, b'').decode('utf-8', errors='ignore').strip('\x00'),
                'exposure_time': exif.get(piexif.ExifIFD.ExposureTime, (0, 1)),
                'f_number': exif.get(piexif.ExifIFD.FNumber, (0, 1)),
                'iso_speed': exif.get(piexif.ExifIFD.ISOSpeedRatings, 0),
                'focal_length': exif.get(piexif.ExifIFD.FocalLength, (0, 1)),
            })

        return metadata

    except Exception as e:
        logger.warning(f"Could not extract EXIF data: {str(e)}")
        return {}

def add_watermark(image, text="Sample Watermark"):
    """Add watermark to image"""
    try:
        # Create a copy to avoid modifying original
        img = image.copy()

        # Create drawing context
        draw = ImageDraw.Draw(img)

        # Try to use a default font, fallback to basic if not available
        try:
            font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 36)
        except:
            try:
                font = ImageFont.truetype("arial.ttf", 36)
            except:
                font = ImageFont.load_default()

        # Calculate text size
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]

        # Position watermark (bottom right corner)
        width, height = img.size
        x = width - text_width - 20
        y = height - text_height - 20

        # Add semi-transparent background for text
        draw.rectangle([x-10, y-10, x+text_width+10, y+text_height+10],
                      fill=(255, 255, 255, 128))

        # Add text
        draw.text((x, y), text, fill=(0, 0, 0, 255), font=font)

        return img

    except Exception as e:
        logger.warning(f"Could not add watermark: {str(e)}")
        return image

def process_image(image_data, original_key):
    """
    Process the image: create compressed versions, convert formats, add watermark, extract EXIF.

    Args:
        image_data: Raw image data
        original_key: Original S3 key

    Returns:
        Tuple of (processed_images list, metadata dict)
    """
    processed_images = []
    metadata = {}

    try:
        # Extract EXIF metadata first
        metadata = extract_exif_metadata(image_data)

        # Open the image
        image = Image.open(BytesIO(image_data))

        # Convert RGBA to RGB for JPEG compatibility
        if image.mode in ('RGBA', 'LA', 'P'):
            background = Image.new('RGB', image.size, (255, 255, 255))
            if image.mode == 'P':
                image = image.convert('RGBA')
            background.paste(image, mask=image.split()[-1] if image.mode in ('RGBA', 'LA') else None)
            image = background
        elif image.mode != 'RGB':
            image = image.convert('RGB')

        # Get original format and dimensions
        original_format = image.format or 'JPEG'
        width, height = image.size

        logger.info(f"Original image: {width}x{height}, format: {original_format}")

        # Resize if image is too large
        if width > MAX_DIMENSION or height > MAX_DIMENSION:
            ratio = min(MAX_DIMENSION / width, MAX_DIMENSION / height)
            new_width = int(width * ratio)
            new_height = int(height * ratio)
            image = image.resize((new_width, new_height), Image.Resampling.LANCZOS)
            logger.info(f"Resized to: {new_width}x{new_height}")

        # Add watermark
        watermarked_image = add_watermark(image, "© Image Processor")

        # Generate base filename
        base_name = os.path.splitext(original_key)[0]
        unique_id = str(uuid.uuid4())[:8]

        # Create multiple variants
        variants = [
            {'format': 'JPEG', 'quality': 85, 'suffix': 'compressed'},
            {'format': 'JPEG', 'quality': 60, 'suffix': 'low'},
            {'format': 'WEBP', 'quality': 85, 'suffix': 'webp'},
            {'format': 'PNG', 'quality': None, 'suffix': 'png'}
        ]

        for variant in variants:
            output = BytesIO()
            save_format = variant['format']

            if variant['quality']:
                watermarked_image.save(output, format=save_format, quality=variant['quality'], optimize=True)
            else:
                watermarked_image.save(output, format=save_format, optimize=True)

            output.seek(0)

            # Generate output key
            extension = save_format.lower()
            if extension == 'jpeg':
                extension = 'jpg'

            output_key = f"{base_name}_{variant['suffix']}_{unique_id}.{extension}"

            # Determine content type
            content_type_map = {
                'JPEG': 'image/jpeg',
                'PNG': 'image/png',
                'WEBP': 'image/webp'
            }
            content_type = content_type_map.get(save_format, 'image/jpeg')

            processed_images.append({
                'key': output_key,
                'data': output.getvalue(),
                'content_type': content_type,
                'format': save_format,
                'quality': variant['quality']
            })

            logger.info(f"Created variant: {output_key} ({save_format}, quality: {variant['quality']})")

        # Create thumbnail
        thumbnail = watermarked_image.copy()
        thumbnail.thumbnail((300, 300), Image.Resampling.LANCZOS)
        thumb_output = BytesIO()
        thumbnail.save(thumb_output, format='JPEG', quality=80, optimize=True)
        thumb_output.seek(0)

        processed_images.append({
            'key': f"{base_name}_thumbnail_{unique_id}.jpg",
            'data': thumb_output.getvalue(),
            'content_type': 'image/jpeg',
            'format': 'JPEG',
            'quality': 80
        })

        logger.info(f"Created thumbnail: {base_name}_thumbnail_{unique_id}.jpg")

        return processed_images, metadata

    except Exception as e:
        logger.error(f"Error in process_image: {str(e)}", exc_info=True)
        raise