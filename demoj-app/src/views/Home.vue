<template>
    <ion-page>
        <div class="content ion-padding">
            <ion-img @click="handleClick" src="/demoj-app/demoj.png"></ion-img>
            <ion-button @click="router.push({ name: 'scenarios' })" shape="round" size="default"> Accéder à l'application </ion-button>
        </div>
        <ion-toast @didDismiss="toastOpen = false" @click="toastOpen = false" :is-open="toastOpen" swipe-gesture="vertical" position="top" :message="toastMessage" :duration="toastDuration" :icon="checkmarkCircle"></ion-toast>
    </ion-page>
</template>

<script setup lang="ts">
import { IonButton, IonImg, IonPage, IonToast, useIonRouter } from "@ionic/vue";
import { checkmarkCircle } from "ionicons/icons";
import { computed, ref } from "vue";

const router = useIonRouter();
const clickCount = ref(0);
const debugModeEnabled = ref(false);
const toastDuration = ref(2000);
const toastOpen = ref(false);
const toastMessage = computed<string>(() => {
    if (debugModeEnabled.value) {
        return "Mode développeur activé !";
    } else {
        return "Mode développeur désactivé !";
    }
});

// Vérifier si le mode développeur est déjà activé au chargement de la page
const storedDebugMode = localStorage.getItem("debugMode");
if (storedDebugMode === "true") {
    debugModeEnabled.value = true; // Activer le mode développeur
}

const handleClick = () => {
    clickCount.value++;

    if (clickCount.value === 10) {
        toastOpen.value = true; // Ouvrir le toast
        debugModeEnabled.value = !debugModeEnabled.value; // Inverser l'état du mode développeur
        localStorage.setItem("debugMode", debugModeEnabled.value.toString()); // Enregistrer le mode développeur dans le local storage
        clickCount.value = 0; // Réinitialiser le compteur
    }
};
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
    padding-left: 30px;
    padding-right: 30px;
    background: white;
}
</style>
