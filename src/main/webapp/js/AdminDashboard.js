document.addEventListener('DOMContentLoaded', () => {
    const menuToggle = document.querySelector('.menu-toggle');
    const sidebar = document.querySelector('.sidebar');
    const statusFilter = document.getElementById('statusFilter');
    const deptFilter = document.getElementById('deptFilter');
    const tableBody = document.getElementById('complaintTableBody');

    // Sidebar Toggle
    menuToggle.addEventListener('click', () => {
        sidebar.classList.toggle('active');
    });

    // Handle sending chat messages
    function sendMessage() {
        const input = document.getElementById('chatInput');
        const chatBox = document.getElementById('chatBox');
        if (input.value.trim()) {
            const p = document.createElement('p');
            const now = new Date().toLocaleString('en-IN', { timeZone: 'Asia/Kolkata' });
            p.innerHTML = `<strong>admin:</strong> ${input.value} <span class="chat-timestamp">${now}</span>`;
            chatBox.appendChild(p);
            input.value = '';
            chatBox.scrollTop = chatBox.scrollHeight;
        }
    }

    // Allow sending with Enter key
    document.getElementById('chatInput').addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            e.preventDefault();
            sendMessage();
        }
    });

    // Filter complaints by status and department
    function filterComplaints() {
        const statusValue = statusFilter.value;
        const deptValue = deptFilter.value;
        const rows = tableBody.getElementsByTagName('tr');

        for (let row of rows) {
            const cells = row.getElementsByTagName('td');
            const status = cells[4].getElementsByTagName('span')[0].className.split(' ')[1].replace('-', ' ');
            const department = cells[3].textContent.toLowerCase();
            const matchStatus = !statusValue || status === statusValue;
            const matchDept = !deptValue || department === deptValue.toLowerCase();
            row.style.display = matchStatus && matchDept ? '' : 'none';
        }
    }

    // Modal popup logic for viewing complaint details
    function openModal(id, title, description, status) {
        const sanitize = (str) => str.replace(/</g, '&lt;').replace(/>/g, '&gt;');
        document.getElementById('modalId').textContent = sanitize(id);
        document.getElementById('modalTitle').textContent = sanitize(title);
        document.getElementById('modalDescription').textContent = sanitize(description || 'No description');
        document.getElementById('modalStatus').textContent = sanitize(status);
        document.getElementById('complaintModal').style.display = 'flex';

        // Close modal with Escape key
        document.addEventListener('keydown', closeOnEscape);
    }

    function closeModal() {
        document.getElementById('complaintModal').style.display = 'none';
        document.removeEventListener('keydown', closeOnEscape);
    }

    function closeOnEscape(e) {
        if (e.key === 'Escape') closeModal();
    }

    // Function to generate report (with confirmation)
    function generateReport(period) {
        if (confirm(`Are you sure you want to generate the ${period} report?`)) {
            const now = new Date().toLocaleString('en-IN', { timeZone: 'Asia/Kolkata' });
            alert(`Generating ${period} report at ${now}`);
            // Placeholder: Replace with actual report generation logic
            // e.g., window.location.href = `GenerateReportServlet?type=${period}`;
        }
    }

    // Auto-refresh complaints table to reflect user changes
    function refreshComplaints() {
        fetch('AdminDashboard.jsp') // Adjust URL if needed
            .then(response => response.text())
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                const newTableBody = doc.getElementById('complaintTableBody');
                if (newTableBody) {
                    tableBody.innerHTML = newTableBody.innerHTML;
                    filterComplaints(); // Reapply filters
                }
            })
            .catch(error => console.error('Refresh error:', error));
    }

    // Initialize event listeners and auto-refresh
    statusFilter.addEventListener('change', filterComplaints);
    deptFilter.addEventListener('change', filterComplaints);
    filterComplaints(); // Apply initial filter
    setInterval(refreshComplaints, 30000); // Refresh every 30 seconds
});