<template>
    <ion-app>
        <ion-router-outlet animated="false" />
    </ion-app>
</template>

<script setup lang="ts">
import { IonApp, IonRouterOutlet } from "@ionic/vue";
import { inject, onMounted } from "vue";
import { CustomSocket } from "./services/CustomSocket";

const socket: CustomSocket | undefined = inject("socket");

onMounted(() => {
    console.log("Hello DémoJ Connect");
    console.log("Starting socket connection");
    if (socket) socket.connect();

    if (!localStorage.getItem("mode")) localStorage.setItem("mode", "client");
});
</script>
