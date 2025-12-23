// Image Processor Web Interface JavaScript

document.addEventListener('DOMContentLoaded', function() {
    const uploadArea = document.getElementById('uploadArea');
    const fileInput = document.getElementById('fileInput');
    const browseBtn = document.getElementById('browseBtn');
    const uploadBtn = document.getElementById('uploadBtn');
    const fileInfo = document.getElementById('fileInfo');
    const fileName = document.getElementById('fileName');
    const fileSize = document.getElementById('fileSize');
    const resultsSection = document.getElementById('resultsSection');
    const metadataContent = document.getElementById('metadataContent');
    const imagesGrid = document.getElementById('imagesGrid');

    let selectedFile = null;

    // API Gateway URL - This should be replaced with the actual API URL after deployment
    const API_URL = 'YOUR_API_GATEWAY_URL/upload'; // Replace with actual URL

    // Drag and drop functionality
    uploadArea.addEventListener('dragover', (e) => {
        e.preventDefault();
        uploadArea.classList.add('dragover');
    });

    uploadArea.addEventListener('dragleave', () => {
        uploadArea.classList.remove('dragover');
    });

    uploadArea.addEventListener('drop', (e) => {
        e.preventDefault();
        uploadArea.classList.remove('dragover');

        const files = e.dataTransfer.files;
        if (files.length > 0) {
            handleFileSelect(files[0]);
        }
    });

    uploadArea.addEventListener('click', () => {
        fileInput.click();
    });

    browseBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        fileInput.click();
    });

    fileInput.addEventListener('change', (e) => {
        if (e.target.files.length > 0) {
            handleFileSelect(e.target.files[0]);
        }
    });

    uploadBtn.addEventListener('click', uploadFile);

    function handleFileSelect(file) {
        if (!file.type.startsWith('image/')) {
            alert('Please select an image file.');
            return;
        }

        selectedFile = file;
        fileName.textContent = file.name;
        fileSize.textContent = formatFileSize(file.size);
        fileInfo.style.display = 'block';
        uploadBtn.disabled = false;
    }

    function formatFileSize(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    }

    async function uploadFile() {
        if (!selectedFile) return;

        uploadBtn.disabled = true;
        uploadBtn.innerHTML = '<span class="loading"></span> Processing...';

        try {
            // Convert file to base64
            const base64 = await fileToBase64(selectedFile);

            // Prepare request
            const response = await fetch(API_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'x-file-name': selectedFile.name
                },
                body: JSON.stringify({
                    body: base64,
                    headers: {
                        'x-file-name': selectedFile.name
                    }
                })
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const result = await response.json();
            displayResults(result);

        } catch (error) {
            console.error('Upload failed:', error);
            alert('Upload failed. Please check the console for details.');
        } finally {
            uploadBtn.disabled = false;
            uploadBtn.innerHTML = 'Upload & Process';
        }
    }

    function fileToBase64(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.readAsData64(file);
            reader.onload = () => resolve(reader.result.split(',')[1]);
            reader.onerror = error => reject(error);
        });
    }

    function displayResults(result) {
        resultsSection.style.display = 'block';

        // Display metadata
        if (result.metadata) {
            let metadataHtml = '';
            for (const [key, value] of Object.entries(result.metadata)) {
                if (value && value !== '' && value !== 0) {
                    metadataHtml += `<p><strong>${key}:</strong> ${value}</p>`;
                }
            }
            metadataContent.innerHTML = metadataHtml || '<p>No EXIF metadata found.</p>';
        } else {
            metadataContent.innerHTML = '<p>No metadata available.</p>';
        }

        // Display processed images
        // Note: In a real implementation, you'd need to get the processed image URLs
        // For now, we'll show a placeholder
        imagesGrid.innerHTML = `
            <div class="image-card">
                <div style="height: 200px; background: #f8f9fa; display: flex; align-items: center; justify-content: center; color: #7f8c8d;">
                    Processed images will appear here after upload
                </div>
                <div class="image-info">
                    <h4>Processing Complete</h4>
                    <p>Images have been processed and stored in S3</p>
                    <p><strong>Key:</strong> ${result.key || 'N/A'}</p>
                    <p><strong>Variants:</strong> ${result.processed_variants || 0}</p>
                </div>
            </div>
        `;

        // Scroll to results
        resultsSection.scrollIntoView({ behavior: 'smooth' });
    }

    // Initialize - check if API URL is configured
    if (API_URL.includes('YOUR_API_GATEWAY_URL')) {
        console.warn('Please replace YOUR_API_GATEWAY_URL with the actual API Gateway URL from your Terraform outputs.');
    }
});