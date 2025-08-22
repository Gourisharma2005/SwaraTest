let socket;
let reconnectAttempts = 0;
const maxReconnectAttempts = 5;
const reconnectDelay = 3000;

function initChat(userId) {
    if (!userId || userId === "Guest") {
        console.error("Invalid user ID:", userId);
        return;
    }
    socket = new WebSocket("ws://localhost:8080/SwaraTest/chat");

    socket.onopen = () => {
        console.log("Connected for user:", userId);
        reconnectAttempts = 0;
        // Delay or check readyState
        if (socket.readyState === WebSocket.OPEN) {
            socket.send(JSON.stringify({ type: "join", userId: userId }));
        } else {
            setTimeout(() => {
                if (socket.readyState === WebSocket.OPEN) {
                    socket.send(JSON.stringify({ type: "join", userId: userId }));
                }
            }, 100); // 100ms delay
        }
    };

    socket.onmessage = (e) => {
        const data = JSON.parse(e.data);
        appendMessage(data.sender, data.message, data.timestamp);
    };

    socket.onerror = (err) => {
        console.error("WebSocket error:", err);
        appendMessage("System", "Chat connection error. Check console.", new Date().toISOString());
    };

    socket.onclose = () => {
        console.log("Disconnected");
        appendMessage("System", "Chat disconnected. Attempting to reconnect...", new Date().toISOString());
        if (reconnectAttempts < maxReconnectAttempts) {
            setTimeout(() => {
                console.log(`Reconnect attempt ${reconnectAttempts + 1}`);
                reconnectAttempts++;
                initChat(userId);
            }, reconnectDelay);
        } else {
            appendMessage("System", "Max reconnect attempts reached. Please refresh.", new Date().toISOString());
        }
    };
}

function sendMessage() {
    const input = document.getElementById("chatInput");
    const msg = input.value.trim();
    const userId = window.userId || "Anonymous"; // Fallback to "Anonymous" if not set

    if (!msg) return;

    if (socket && socket.readyState === WebSocket.OPEN) {
        const timestamp = new Date().toISOString();
        const messageData = {
            type: "message",
            sender: userId,
            message: msg,
            timestamp: timestamp
        };
        socket.send(JSON.stringify(messageData));
        appendMessage(userId, msg, timestamp, true);
        input.value = "";
    } else {
        appendMessage("System", "Cannot send message: Chat is disconnected.", new Date().toISOString());
    }
}


function appendMessage(sender, message, timestamp, isSent = false) {
    const chatBox = document.getElementById("chatBox");
    if (!chatBox) {
        console.error("Chat box not found");
        return;
    }
    const messageDiv = document.createElement("div");
    messageDiv.className = `chat-message ${isSent ? "right" : "left"}`;
    const messageContent = document.createElement("div");
    messageContent.className = "message-content";
    const p = document.createElement("p");
    p.textContent = `${sender}: ${message}`;
    const timeSpan = document.createElement("span");
    timeSpan.className = "chat-timestamp";
    timeSpan.textContent = formatTimestamp(timestamp);
    messageContent.appendChild(p);
    messageContent.appendChild(timeSpan);
    messageDiv.appendChild(messageContent);
    chatBox.appendChild(messageDiv);
    chatBox.scrollTop = chatBox.scrollHeight;
}

function formatTimestamp(isoString) {
    const date = new Date(isoString);
    return date.toLocaleString("en-US", {
        year: "numeric", month: "short", day: "2-digit",
        hour: "2-digit", minute: "2-digit", hour12: true
    });
}

document.addEventListener("DOMContentLoaded", () => {
    window.userId = "<%= session.getAttribute('anonymous_id') != null ? session.getAttribute('anonymous_id') : (session.getAttribute('role') != null ? session.getAttribute('role') : 'Guest') %>";
    if (!window.userId || window.userId.includes("<%= ")) {
        window.userId = "Guest"; // Fallback if JSP fails
    }
    initChat(window.userId);
});