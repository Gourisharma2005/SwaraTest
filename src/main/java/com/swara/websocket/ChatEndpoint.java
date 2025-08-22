package com.swara.websocket;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.io.IOException;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

@ServerEndpoint("/chat")
public class ChatEndpoint {
    private static final Set<Session> sessions = new CopyOnWriteArraySet<>();
    private static final Gson gson = new Gson();

    @OnOpen
    public void onOpen(Session session) {
        sessions.add(session);
        try {
            JsonObject joinMessage = new JsonObject();
            joinMessage.addProperty("sender", "System");
            joinMessage.addProperty("message", "User connected to chat.");
            joinMessage.addProperty("timestamp", new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(new java.util.Date()));
            broadcast(gson.toJson(joinMessage));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnMessage
    public void onMessage(String message, Session sender) {
        try {
            // Parse incoming JSON message
            JsonObject jsonMessage = gson.fromJson(message, JsonObject.class);
            String type = jsonMessage.get("type").getAsString();

            if ("message".equals(type)) {
                // Broadcast the message to all connected clients
                broadcast(message);
            } else if ("join".equals(type)) {
                // Handle join message (optional, for logging or notifications)
                System.out.println("User joined: " + jsonMessage.get("userId").getAsString());
            }
        } catch (Exception e) {
            e.printStackTrace();
            JsonObject errorMessage = new JsonObject();
            errorMessage.addProperty("sender", "System");
            errorMessage.addProperty("message", "Error processing message.");
            errorMessage.addProperty("timestamp", new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(new java.util.Date()));
            broadcast(gson.toJson(errorMessage));
        }
    }

    @OnClose
    public void onClose(Session session) {
        sessions.remove(session);
        try {
            JsonObject leaveMessage = new JsonObject();
            leaveMessage.addProperty("sender", "System");
            leaveMessage.addProperty("message", "User disconnected from chat.");
            leaveMessage.addProperty("timestamp", new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(new java.util.Date()));
            broadcast(gson.toJson(leaveMessage));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("WebSocket error: " + throwable.getMessage());
        sessions.remove(session);
    }

    private void broadcast(String message) {
        for (Session session : sessions) {
            if (session.isOpen()) {
                session.getAsyncRemote().sendText(message);
            }
        }
    }
}