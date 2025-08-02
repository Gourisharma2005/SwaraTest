function filterTable(search, status, date) {
  let table = document.getElementById("complaintTable");
  let tr = table.getElementsByTagName("tr");

  for (let i = 1; i < tr.length; i++) {
    let tdId = tr[i].getElementsByTagName("td")[0];
    let tdSubject = tr[i].getElementsByTagName("td")[1];
    let tdStatus = tr[i].getElementsByTagName("td")[2];
    let tdDate = tr[i].getElementsByTagName("td")[3]; // Optional if you add a date column

    let txtValueId = tdId ? tdId.textContent || tdId.innerText : "";
    let txtValueSubject = tdSubject ? tdSubject.textContent || tdSubject.innerText : "";
    let txtValueStatus = tdStatus ? tdStatus.textContent || tdStatus.innerText : "";
    let txtValueDate = tdDate ? tdDate.textContent || tdDate.innerText : "";

    let shouldShow = true;

    if (search && !txtValueId.toLowerCase().includes(search.toLowerCase()) &&
        !txtValueSubject.toLowerCase().includes(search.toLowerCase())) {
      shouldShow = false;
    }

    if (status && txtValueStatus.toLowerCase() !== status.toLowerCase()) {
      shouldShow = false;
    }

    if (date && txtValueDate !== date) {
      shouldShow = false;
    }

    tr[i].style.display = shouldShow ? "" : "none";
  }
}

function viewComplaint(complaintId) {
  alert("Viewing complaint: " + complaintId);

}
