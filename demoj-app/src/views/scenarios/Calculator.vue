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
            <ion-text><p>Cette fonctionnalité permet aux utilisateurs d'effectuer une gamme étendue de calculs, depuis des opérations basiques jusqu'à des fonctions mathématiques avancées comme Fibonacci, factorielle et recherche de nombres premiers. Le tout peut être réalisé côté client ou côté serveur.</p></ion-text>
            <ion-button expand="block">Accéder à l'application</ion-button>
        </ion-content>
    </ion-page>
</template>

<script setup lang="ts">
import { IonBackButton, IonButton, IonButtons, IonContent, IonHeader, IonPage, IonText, IonTitle, IonToolbar } from "@ionic/vue";
</script>
