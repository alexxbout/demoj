<template>
    <ion-page>
        <div class="content ion-padding">
            <ion-img src="/demoj-app/demoj.png"></ion-img>
            <ion-button @click="router.push({ name: 'scenarios' })" shape="round" size="default">Accéder à l'application</ion-button>
        </div>
    </ion-page>
</template>

<script setup lang="ts">
import { IonButton, IonImg, IonPage, useIonRouter } from "@ionic/vue";

const router = useIonRouter();
</script>

<style scoped>
.content {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    justify-items: center;
    align-content: center;
    height: 100vh;
    gap: 1rem;
}
</style>
