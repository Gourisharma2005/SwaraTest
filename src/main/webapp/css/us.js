const registerBtn = document.querySelector('.register-complaint-btn');
const dashboardContent = document.getElementById('dashboardContent');
const complaintFormSection = document.getElementById('complaintFormSection');

registerBtn.addEventListener('click', () => {
  dashboardContent.style.display = 'none';
  complaintFormSection.style.display = 'block';
});

function closeForm() {
  complaintFormSection.style.display = 'none';
  dashboardContent.style.display = 'block';
}
