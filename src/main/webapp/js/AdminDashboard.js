// Handle sending chat messages
function sendMessage() {
    const input = document.getElementById('chatInput');
    const chatBox = document.getElementById('chatBox');
    if (input.value.trim()) {
        const p = document.createElement('p');
        p.innerHTML = `<strong>admin:</strong> ${input.value} ${new Date().toLocaleString('en-IN', { timeZone: 'Asia/Kolkata' })}`;
        chatBox.appendChild(p);
        input.value = '';
        chatBox.scrollTop = chatBox.scrollHeight;
    }
}

// Allow sending with Enter key
document.getElementById('chatInput').addEventListener('keypress', function (e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        sendMessage();
    }
});

// Filter complaints by status and department
function filterComplaints() {
    const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
    const deptFilter = document.getElementById('deptFilter').value.toLowerCase();
    const rows = document.getElementById('complaintTableBody').getElementsByTagName('tr');

    for (let i = 0; i < rows.length; i++) {
        const status = rows[i].getElementsByTagName('td')[4].textContent.toLowerCase(); // Status is column 5
        const department = rows[i].getElementsByTagName('td')[3].textContent.toLowerCase(); // Department is column 4

        const matchStatus = statusFilter === "" || status === statusFilter;
        const matchDept = deptFilter === "" || department === deptFilter;

        rows[i].style.display = matchStatus && matchDept ? '' : 'none';
    }
}

// Modal popup logic for viewing complaint details
function openModal(id, title, description, status) {
    document.getElementById('modalId').textContent = id;
    document.getElementById('modalTitle').textContent = title;
    document.getElementById('modalDescription').textContent = description;
    document.getElementById('modalStatus').textContent = status;
    document.getElementById('complaintModal').style.display = 'flex';
}

function closeModal() {
    document.getElementById('complaintModal').style.display = 'none';
}

// Sidebar toggle for mobile responsiveness
document.querySelector('.menu-toggle').addEventListener('click', function () {
    document.querySelector('.sidebar').classList.toggle('active');
});
