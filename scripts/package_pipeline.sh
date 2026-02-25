#!/bin/bash
# MIA-DoD Packaging Script

PROJECT_NAME="mia-dod-nervous-system"
S3_BUCKET="s3://mia-dod-artifacts-$(aws sts get-caller-identity --query Account --output text)"

echo "🚀 Packaging transforms and dependencies..."

# Create a temporary build directory
mkdir -p build
cp -r pipeline/src/transforms build/

# Zip the transforms for Glue --extra-py-files
cd build
zip -r ../transforms.zip transforms/
cd ..

# Upload to S3
echo "📤 Uploading artifacts to $S3_BUCKET..."
aws s3 cp transforms.zip $S3_BUCKET/glue/libs/
aws s3 cp pipeline/src/main_pipeline.py $S3_BUCKET/glue/jobs/

echo "✅ Deployment artifacts ready for AWS Glue."