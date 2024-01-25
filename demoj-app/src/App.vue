<template>
    <ion-app>
        <ion-router-outlet animated="false" />
    </ion-app>
</template>

<script setup lang="ts">
import { IonApp, IonRouterOutlet } from "@ionic/vue";
import { onMounted } from "vue";

onMounted(() => {
    if (!localStorage.getItem("mode")) {
        localStorage.setItem("mode", "client");
    }
});
</script>
