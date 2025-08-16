// Function to toggle the department field visibility based on the selected role
function toggleDepartmentField() {
  const role = document.getElementById('role').value;
  const departmentField = document.getElementById('departmentField');
  if (role === 'HOD') {
    departmentField.style.display = 'block';
    document.getElementById('department').setAttribute('required', 'required');
  } else {
    departmentField.style.display = 'none';
    document.getElementById('department').removeAttribute('required');
  }
}

// Function to open the complaint form section
function openForm() {
  document.getElementById('dashboardContent').style.display = 'none';
  document.getElementById('complaintFormSection').style.display = 'block';
}

// Function to close the complaint form section
function closeForm() {
  document.getElementById('complaintFormSection').style.display = 'none';
  document.getElementById('dashboardContent').style.display = 'block';
  toggleDepartmentField(); // Reset department field visibility
}

// Function to display a placeholder alert for viewing a complaint
function viewComplaint(complaintId) {
  alert('View complaint with ID: ' + complaintId);
}

// Function to filter the complaint table based on search, status, and date
function filterTable(search, status, date) {
  const table = document.querySelector('.complaint-history table tbody');
  const rows = table.getElementsByTagName('tr');
  for (let i = 0; i < rows.length; i++) {
    let match = true;
    const cells = rows[i].getElementsByTagName('td');
    if (search && cells[0].textContent.toLowerCase().indexOf(search.toLowerCase()) === -1 &&
        cells[1].textContent.toLowerCase().indexOf(search.toLowerCase()) === -1) {
      match = false;
    }
    if (status && cells[2].textContent !== status) {
      match = false;
    }
    // Note: Date filtering assumes an incident_date column; adjust if not present
    if (date && cells.length > 3 && cells[3].textContent !== date) {
      match = false;
    }
    rows[i].style.display = match ? '' : 'none';
  }
}