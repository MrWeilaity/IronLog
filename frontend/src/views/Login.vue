<template>
  <div class="login-container">
    <h1>Login</h1>
    <div v-if="statusMessage">
        <p>Status: {{ statusMessage }}</p>
    </div>
    <div class="test-controls">
        <button @click="testBackend">Test Backend Connectivity</button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const statusMessage = ref('');

const testBackend = async () => {
    statusMessage.value = "Pinging backend...";
    try {
        // We assume /api is proxied by Nginx to the backend
        // We hit a known endpoint, e.g., /api/users/1 or similar.
        // Since we don't know if user 1 exists, we expect either 200 or 404, but a response nonetheless.
        // Or we can try the login endpoint with dummy data.
        const response = await fetch('/api/users/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ username: 'test', password: 'test' })
        });

        if (response.ok) {
             statusMessage.value = "Backend connected! (Login Success)";
        } else {
             const text = await response.text();
             statusMessage.value = `Backend reachable, but returned: ${response.status} - ${text}`;
        }
    } catch (error) {
        statusMessage.value = `Error connecting to backend: ${error.message}`;
        console.error(error);
    }
};
</script>

<style scoped>
.login-container {
    padding: 20px;
    text-align: center;
}
button {
    margin-top: 10px;
    padding: 8px 16px;
    cursor: pointer;
}
</style>
