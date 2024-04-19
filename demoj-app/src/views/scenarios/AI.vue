<template>
    <ion-page>
        <ion-header>
            <ion-toolbar>
                <ion-buttons slot="start">
                    <ion-back-button defaultHref="/tabs/scenarios" text="Retour"></ion-back-button>
                </ion-buttons>
                <ion-title>Détails</ion-title>
            </ion-toolbar>
        </ion-header>
        <ion-content class="ion-padding">
            <ion-text><p>Cette fonctionnalité permet aux utilisateurs de communiquer avec une IA conversationnelle similaire à ChatGPT.</p></ion-text>
            <ion-button @click="handleClick" expand="block">Accéder à l'application</ion-button>
        </ion-content>
    </ion-page>
</template>

<script setup lang="ts">
import { IonBackButton, IonButton, IonButtons, IonContent, IonHeader, IonPage, IonText, IonTitle, IonToolbar } from "@ionic/vue";

const handleClick = () => {
    console.log("Click");

    location.href = `http://${import.meta.env.VITE_IP_SERVER}:5000/app/ai`;
};
</script>
