document.addEventListener('DOMContentLoaded', () => {
  const fileInput = document.getElementById('file-upload');
  const form = document.getElementById('upload-form');
  const downloadBtn = document.getElementById('download-btn');
  const getLinkBtn = document.getElementById('get-link-btn');
  const pdfLinkInput = document.getElementById('pdf-link');
  const statusDiv = document.querySelector('.status');

  let recordId = null;

  const disableButtons = () => {
    downloadBtn.disabled = true;
    getLinkBtn.disabled = true;
    pdfLinkInput.value = '';
    pdfLinkInput.style.display = 'none';
  };

  disableButtons();

  fileInput.addEventListener('change', () => {
    if (fileInput.files.length === 0) return;

    disableButtons();
    statusDiv.textContent = '⏳ Uploading & Converting...';

    const formData = new FormData(form);

    fetch(form.action, {
      method: 'POST',
      body: formData,
      headers: { 'Accept': 'application/json' },
      credentials: 'same-origin'
    })
    .then(response => {
      if (!response.ok) {
        return response.json()
          .then(data => {
            const message = data.message || '❌ Upload failed';
            throw new Error(message);
          })
          .catch(() => {
            throw new Error('❌ Upload failed');
          });
      }
      return response.json();
    })
    .then(data => {
      recordId = data.id;

      const tryFetchPdf = (attemptsLeft = 10) => {
        fetch(`/conversion_records/${recordId}`)
          .then(resp => {
            if (!resp.ok) throw new Error('Not ready');
            return resp.json();
          })
          .then(data => {
            statusDiv.textContent = '✅ PDF ready!';
            downloadBtn.disabled = false;
            getLinkBtn.disabled = false;
            downloadBtn.setAttribute('data-record-id', recordId);
            getLinkBtn.setAttribute('data-url', data.pdf_url);
          })
          .catch(() => {
            if (attemptsLeft > 0) {
              setTimeout(() => tryFetchPdf(attemptsLeft - 1), 1000);
            } else {
              statusDiv.textContent = '❌ Conversion timeout';
            }
          });
      };

      tryFetchPdf();
    })
    .catch(error => {
      statusDiv.textContent = error.message;
      disableButtons();
    });
  });

  downloadBtn.addEventListener('click', e => {
    e.preventDefault();
    if (!recordId) return;
    window.location.href = `/conversion_records/${recordId}/download`;
  });

  getLinkBtn.addEventListener('click', e => {
    e.preventDefault();
    const url = getLinkBtn.getAttribute('data-url');
    if (url) {
      pdfLinkInput.value = url;
      pdfLinkInput.style.display = 'inline-block';
      pdfLinkInput.select();
    }
  });
});
