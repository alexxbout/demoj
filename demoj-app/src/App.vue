<template>
    <ion-app>
        <ion-router-outlet animated="false" />
    </ion-app>
</template>

<script setup lang="ts">
import { IonApp, IonRouterOutlet } from "@ionic/vue";
import { inject, onMounted } from "vue";
import { CustomSocket } from "./services/CustomSocket";

const socket = inject("socket") as CustomSocket;

onMounted(() => {
    console.log("Hello DémoJ Connect");
    socket.connect();

    if (!localStorage.getItem("mode")) localStorage.setItem("mode", "client");
});
</script>
