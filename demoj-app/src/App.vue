<template>
    <ion-app>
        <ion-router-outlet animated="false" />
    </ion-app>
</template>

<script setup lang="ts">
import { IonApp, IonRouterOutlet } from "@ionic/vue";
import { inject, onMounted } from "vue";
import { Zocket } from "./services/Zocket";

const socket = inject("socket") as Zocket;

onMounted(() => {
    console.log("Hello DémoJ Connect");

    // Connect to the server only if the app is not running on localhost
    if (window.location.hostname !== "localhost") socket.connect();

    if (!localStorage.getItem("mode")) localStorage.setItem("mode", "client");
});
</script>
./services/Zocket
