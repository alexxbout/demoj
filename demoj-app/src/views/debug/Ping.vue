<template>
    <ion-button :id="trigger" expand="block">Ping...</ion-button>
    <ion-alert :trigger="trigger" :header="title" :buttons="alertButtons" :inputs="alertInputs"></ion-alert>
    <ion-toast @didDismiss="toastOpen = false" @click="toastOpen = false" :is-open="toastOpen" swipe-gesture="vertical" position="top" :message="toastMessage" :duration="toastDuration" :icon="toastIcon" :color="toastColor"></ion-toast>
</template>

<script setup lang="ts">
import API from "@/services/API";
import { IonAlert, IonButton, IonToast } from "@ionic/vue";
import { alertCircle, checkmarkCircle, radioButtonOff } from "ionicons/icons";
import { ref } from "vue";

const toastOpen = ref(false);
const toastMessage = ref("");
const toastDuration = ref(5000);
const toastTheme = ref({
    default: {
        icon: radioButtonOff,
        color: "light",
    },
    success: {
        icon: checkmarkCircle,
        color: "success",
    },
    error: {
        icon: alertCircle,
        color: "danger",
    },
});
const toastIcon = ref(toastTheme.value.default.icon);
const toastColor = ref(toastTheme.value.default.color);

const trigger = ref("ping");
const title = ref("Ping");
const alertButtons = ref([
    {
        text: "Annuler",
        role: "cancel",
    },
    {
        text: "Valider",
        handler: async (value: any) => {
            switch (value) {
                case "all":
                    if ((await API.ping("terminal")) && (await API.ping("network"))) {
                        console.log(value + " - Ping success");
                        showToast("Ping réussi", true);
                    } else {
                        console.log(value + " - Ping failed");
                        showToast("Ping échoué", false);
                    }
                    break;
                case "terminal":
                case "network":
                    if (await API.ping(value)) {
                        console.log(value + " - Ping success");
                        showToast("Ping réussi", true);
                    } else {
                        console.log(value + " - Ping failed");
                        showToast("Ping échoué", false);
                    }
                    break;
            }
        },
    },
]);
const alertInputs = ref([
    {
        label: "Tous",
        type: "radio",
        value: "all",
        checked: true,
    },
    {
        label: "Terminal",
        type: "radio",
        value: "terminal",
    },
    {
        label: "Serveur",
        type: "radio",
        value: "network",
    },
]);

const showToast = (message: string, isSuccess: boolean) => {
    toastMessage.value = message;
    if (isSuccess) {
        toastIcon.value = toastTheme.value.success.icon;
        toastColor.value = toastTheme.value.success.color;
    } else {
        toastIcon.value = toastTheme.value.error.icon;
        toastColor.value = toastTheme.value.error.color;
    }
    toastOpen.value = true;
};
</script>
