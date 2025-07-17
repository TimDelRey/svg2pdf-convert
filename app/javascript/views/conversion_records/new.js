document.addEventListener('DOMContentLoaded', function () {
  const fileInput = document.getElementById('file-upload');
  const form = document.getElementById('upload-form');
  const exportBtn = document.getElementById('export-btn');
  const statusDiv = document.querySelector('.status');

  fileInput.addEventListener('change', function () {
    if (fileInput.files.length > 0) {
      const formData = new FormData(form);
      fetch(form.action, {
        method: 'POST',
        body: formData,
        headers: {
          'Accept': 'application/json'
        },
        credentials: 'same-origin'
      })
      .then(response => {
        if (!response.ok) throw new Error('Upload failed');
        return response.json();
      })
      .then(data => {
        statusDiv.textContent = '✅ Ready to convertation';

        exportBtn.disabled = false;
        exportBtn.setAttribute('data-record-id', data.id);
      })
      .catch(() => {
        statusDiv.textContent = '❌ Upload failed';
        exportBtn.disabled = true;
      });
    }
  });

  exportBtn.addEventListener('click', function(e) {
    e.preventDefault();
    if (!exportBtn.disabled) {
      const recordId = exportBtn.getAttribute('data-record-id');
      if (recordId) {
        window.location.href = `/conversion_records/${recordId}/export`;
      }
    }
  });
});
