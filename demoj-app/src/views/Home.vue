<template>
    <ion-page class="custom">
        <ion-grid>
            <ion-row class="ion-align-items-center ion-justify-content-center" style="height: 100%">
                <ion-col size="10">
                    <ion-img @click="handleClick" src="assets/images/demoj.png"></ion-img>
                </ion-col>
            </ion-row>
        </ion-grid>

        <ion-footer class="ion-padding" style="">
            <ion-button @click="router.push({ name: 'scenarios' })" shape="round" size="default" expand="full"> Accéder à l'application </ion-button>
        </ion-footer>

        <ion-toast @didDismiss="toastOpen = false" @click="toastOpen = false" :is-open="toastOpen" swipe-gesture="vertical" position="top" :message="toastMessage" :duration="toastDuration" :icon="checkmarkCircle" color="success"></ion-toast>
    </ion-page>
</template>

<script setup lang="ts">
import { IonButton, IonCol, IonFooter, IonGrid, IonImg, IonPage, IonRow, IonToast, useIonRouter } from "@ionic/vue";
import { checkmarkCircle } from "ionicons/icons";
import { computed, ref } from "vue";

const router = useIonRouter();
const clickCount = ref(0);
const debugMode = ref(false);
const toastDuration = ref(2000);
const toastOpen = ref(false);
const toastMessage = computed<string>(() => {
    if (debugMode.value) {
        return "Mode développeur activé !";
    } else {
        return "Mode développeur désactivé !";
    }
});

// Vérifier si le mode développeur est déjà activé au chargement de la page
const storedDebugMode = localStorage.getItem("debugMode");
if (storedDebugMode === "true") {
    debugMode.value = true; // Activer le mode développeur
}

const handleClick = () => {
    clickCount.value++;

    if (clickCount.value === 10) {
        toastOpen.value = true; // Ouvrir le toast
        debugMode.value = !debugMode.value; // Inverser l'état du mode développeur
        localStorage.setItem("debugMode", debugMode.value.toString()); // Enregistrer le mode développeur dans le local storage
        clickCount.value = 0; // Réinitialiser le compteur
    }
};
</script>

<style scoped>
.custom {
    background: white;
}

@media (prefers-color-scheme: dark) {
    .custom {
        background: black;
    }
}
</style>
