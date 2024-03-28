<template>
    <ion-app>
        <ion-router-outlet animated="false" />
    </ion-app>
</template>

<script setup lang="ts">
import { IonApp, IonRouterOutlet } from "@ionic/vue";
import { inject, onMounted } from "vue";
import { Chaussette } from "./services/Chaussette";

const socket = inject("socket") as Chaussette;

onMounted(() => {
    console.log("Hello DémoJ Connect");
    socket.connect();

    if (!localStorage.getItem("mode")) localStorage.setItem("mode", "client");
});
</script>
./services/Chaussette