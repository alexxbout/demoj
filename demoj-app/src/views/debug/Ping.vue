<template>
    <ion-button :id="trigger" expand="block">{{ header }}</ion-button>
    <ion-action-sheet @didDismiss="handleDismiss" :trigger="trigger" :header="header" :buttons="actionSheetButtons"></ion-action-sheet>
    <ion-toast @didDismiss="toastOpen = false" @click="toastOpen = false" :is-open="toastOpen" swipe-gesture="vertical" position="top" :message="toastMessage" :duration="toastDuration" :icon="toastIcon" :color="toastColor"></ion-toast>
</template>

<script setup lang="ts">
import API from "@/services/API";
import { IonActionSheet, IonButton, IonToast } from "@ionic/vue";
import { alertCircle, checkmarkCircle, radioButtonOff } from "ionicons/icons";
import { ref } from "vue";

const emits = defineEmits<{
    (e: "@start"): void;
    (e: "@end"): void;
}>();

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
const header = ref("Tester la connectivité (ping)");

const actionSheetButtons = ref([
    {
        text: "Tout",
        data: {
            type: "all",
        },
    },
    {
        text: "Terminal",
        data: {
            type: "terminal",
        },
    },
    {
        text: "Serveur",
        data: {
            type: "server",
        },
    },
    {
        text: "Annuler",
        role: "cancel",
    },
]);

const handleDismiss = async (event: CustomEvent) => {
    if (event.detail.data && event.detail.data.type) {
        emits("@start");
        switch (event.detail.data.type) {
            case "all":
                if ((await API.ping("terminal")) && (await API.ping("server"))) {
                    showToast("Ping réussi", true);
                } else {
                    showToast("Ping échoué", false);
                }
                break;
            case "terminal":
            case "server":
                if (await API.ping(event.detail.data.type)) {
                    showToast("Ping réussi", true);
                } else {
                    showToast("Ping échoué", false);
                }
                break;
        }
        emits("@end");
    }
};

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
