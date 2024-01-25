<template>
    <ion-page class="custom">
        <ion-grid>
            <ion-row class="ion-align-items-center ion-justify-content-center" style="height: 100%">
                <ion-col size="10">
                    <ion-img @click="handleClick" src="assets/images/demoj.png"></ion-img>
                </ion-col>
            </ion-row>
        </ion-grid>

        <ion-footer class="ion-padding">
            <ion-button id="present-alert" class="ion-margin-bottom" shape="round" size="default" expand="full" color="secondary">Accéder à l'application opérateur</ion-button>
            <ion-button @click="handleClientAcces" shape="round" size="default" expand="full" color="primary">Accéder à l'application cliente</ion-button>
        </ion-footer>

        <ion-alert trigger="present-alert" :header="alterText" :buttons="alertButtons" :inputs="alertInputs"></ion-alert>

        <ion-toast @didDismiss="toastOpen = false" @click="toastOpen = false" :is-open="toastOpen" swipe-gesture="vertical" position="top" :message="toastMessage" :duration="toastDuration" :color="toastColor"></ion-toast>
    </ion-page>
</template>

<script setup lang="ts">
import { IonAlert, IonButton, IonCol, IonFooter, IonGrid, IonImg, IonPage, IonRow, IonToast, useIonRouter } from "@ionic/vue";
import { onMounted, ref } from "vue";

const router = useIonRouter();

const maxClickCount = 15;
const clickCount = ref(0);
const debugMode = ref(false);

const toastDuration = ref(2000);
const toastOpen = ref(false);
const toastMessage = ref("");
const toastColor = ref();

const handleClick = () => {
    clickCount.value++;

    if (clickCount.value === maxClickCount) {
        debugMode.value = !debugMode.value;
        clickCount.value = 0;

        localStorage.setItem("debugMode", debugMode.value.toString());

        toastMessage.value = debugMode.value ? "Mode développeur activé !" : "Mode développeur désactivé !";
        toastColor.value = debugMode.value ? "success" : "danger";
        toastOpen.value = true;
    }
};

const alterText = ref("Saisir le code d'accès");
const alertButtons = ref([
    {
        text: "Annuler",
        role: "cancel",
    },
    {
        text: "Valider",
        handler: (value: any) => {
            if (value[0] == import.meta.env.VITE_OPERATOR_CODE) {
                localStorage.setItem("mode", "operator");
                router.push({ name: "scenarios" });
            } else {
                toastMessage.value = "Code invalide !";
                toastColor.value = "danger";
                toastOpen.value = true;
            }
        },
    },
]);
const alertInputs = ref([
    {
        placeholder: "Code",
        type: "number",
        min: 1,
    },
]);

const handleClientAcces = () => {
    localStorage.setItem("mode", "client");
    router.push({ name: "scenarios" });
};

onMounted(() => {
    // Set debug mode
    const storedDebugMode = localStorage.getItem("debugMode");
    if (storedDebugMode === "true") {
        debugMode.value = true;
    }
});
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
