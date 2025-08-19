// script.js

function toggleDepartmentField() {
  const role = document.getElementById('role').value;
  const deptField = document.getElementById('departmentField');
  if (role === 'HOD') {
    deptField.style.display = 'block';
    document.getElementById('department').setAttribute('required', 'required');
  } else {
    deptField.style.display = 'none';
    document.getElementById('department').removeAttribute('required');
  }
}

function openForm() {
  document.getElementById('dashboardContent').style.display = 'none';
  document.getElementById('complaintFormSection').style.display = 'block';
  document.getElementById('chatSection').style.display = 'none';
}

function closeForm() {
  document.getElementById('complaintFormSection').style.display = 'none';
  document.getElementById('dashboardContent').style.display = 'block';
}

function filterTable(search, status, date) {
  console.log('Filtering with:', search, status, date);
}

function openChat() {
    // Hide other sections
    document.getElementById("dashboardContent").style.display = "none";
    document.getElementById("complaintFormSection").style.display = "none";

    // Show Chat Section
    document.getElementById("chatSection").style.display = "block";
}

function closeChat() {
    // Hide chat and return to dashboard
    document.getElementById("chatSection").style.display = "none";
    document.getElementById("dashboardContent").style.display = "block";
}



function sendMessage() {
    const input = document.getElementById("chatInput");
    const chatBox = document.getElementById("chatBox");

    if (input.value.trim() !== "") {
        const msgWrapper = document.createElement("div");
        msgWrapper.className = "chat-message right";

        const msgContent = document.createElement("div");
        msgContent.className = "message-content";
        msgContent.innerHTML = `
          <p>${input.value}</p>
          <span class="chat-timestamp">${new Date().toLocaleString()}</span>
        `;

        msgWrapper.appendChild(msgContent);
        chatBox.appendChild(msgWrapper);

        input.value = "";

        // Scroll to bottom automatically
        chatBox.scrollTop = chatBox.scrollHeight;
    }
}


document.getElementById("complaintForm").addEventListener("submit", function (e) {
  e.preventDefault(); // Prevent default form submission

  const formData = new FormData(this);

  fetch("SubmitComplaintServlet", {
    method: "POST",
    body: formData
  })
    .then(response => response.json())
    .then(data => {
      if (data.status === "success") {
        // ✅ Show success message
        alert("Complaint submitted successfully!");

        // ✅ Update Active Complaints count
        document.querySelector(".stats .card:nth-child(1) h2").textContent = data.activeComplaints;

        // ✅ Hide form, show dashboard
        closeForm();
      } else {
        alert("Failed to submit complaint.");
      }
    })
    .catch(err => {
      console.error("Error submitting complaint:", err);
      alert("Error occurred. Please try again.");
    });
});

