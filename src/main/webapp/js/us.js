const registerBtn = document.querySelector('.register-complaint-btn');
const dashboardContent = document.getElementById('dashboardContent');
const complaintFormSection = document.getElementById('complaintFormSection');

function openForm() {
  dashboardContent.style.display = 'none';
  complaintFormSection.style.display = 'block';
}

function closeForm() {
  complaintFormSection.style.display = 'none';
  dashboardContent.style.display = 'block';
}

function viewComplaint(complaintId) {
  // Placeholder: Implement logic to view complaint details (e.g., fetch via AJAX or redirect)
  alert('View complaint with ID: ' + complaintId);
}

function filterTable(search, status, date) {
  // Placeholder: Implement table filtering logic
  console.log('Filtering with:', search, status, date);
}

registerBtn.addEventListener('click', openForm);