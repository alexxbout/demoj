<template>
    <ion-page class="custom">
        <ion-grid>
            <ion-row class="ion-align-items-center ion-justify-content-center" style="height: 100%">
                <ion-col size="10">
                    <ion-img @click="handleClick" src="/assets/images/demoj.png" style="z-index: 1; position: relative"></ion-img>

                    <ConfettiExplosion v-if="visible" :colors="colors" :particleCount="250" :force="0.4" :duration="6000" :stageHeight="1500" :stageWidth="1200" style="z-index: 0; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%)" />
                </ion-col>
            </ion-row>
        </ion-grid>

        <ion-footer class="ion-padding">
            <ion-button @click="handleOperator" class="ion-margin-bottom" shape="round" size="default" expand="full" color="secondary">Accéder à l'application opérateur</ion-button>
            <ion-button @click="handleClient" shape="round" size="default" expand="full" color="primary">Accéder à l'application cliente</ion-button>
        </ion-footer>

        <ion-alert @didDismiss="isAlertOpen = false" :is-open="isAlertOpen" :header="alterText" :buttons="alertButtons" :inputs="alertInputs"></ion-alert>

        <ion-toast @didDismiss="toastOpen = false" @click="toastOpen = false" :is-open="toastOpen" swipe-gesture="vertical" position="top" :message="toastMessage" :duration="toastDuration" :color="toastColor"></ion-toast>
    </ion-page>
</template>

<script setup lang="ts">
import { IonAlert, IonButton, IonCol, IonFooter, IonGrid, IonImg, IonPage, IonRow, IonToast, useIonRouter } from "@ionic/vue";
import { nextTick, onMounted, ref } from "vue";
import ConfettiExplosion from "vue-confetti-explosion";

const router = useIonRouter();

const maxClickCount = 15;
const clickCount = ref(0);
const debug = ref(false);

const toastDuration = ref(2000);
const toastOpen = ref(false);
const toastMessage = ref("");
const toastColor = ref();

const isAlertOpen = ref(false);

const visible = ref(false);
const colors = ref(["#38b000", "#ccff33", "#ffff3f", "#affc41", "#29bf12"]);

const handleClick = async () => {
    clickCount.value++;

    if (clickCount.value === maxClickCount) {
        debug.value = !debug.value;
        clickCount.value = 0;

        localStorage.setItem("debugMode", debug.value.toString());

        toastMessage.value = debug.value ? "Mode développeur activé" : "Mode développeur désactivé";
        toastColor.value = debug.value ? "success" : "danger";
        toastOpen.value = true;

        if (debug.value) {
            visible.value = false;
            await nextTick();
            visible.value = true;
        }
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

const handleClient = () => {
    localStorage.setItem("mode", "client");
    router.push({ name: "scenarios" });
};

const handleOperator = () => {
    isAlertOpen.value = true;
};

onMounted(() => {
    // Set debug mode
    const storedDebugMode = localStorage.getItem("debugMode");
    if (storedDebugMode === "true") {
        debug.value = true;
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
