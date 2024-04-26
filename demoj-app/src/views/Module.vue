<template>
    <ion-page ref="page">
        <ion-header>
            <ion-toolbar>
                <ion-title>{{ name }}</ion-title>
            </ion-toolbar>
        </ion-header>

        <ion-content :fullscreen="true">
            <ion-header collapse="condense">
                <ion-toolbar>
                    <ion-grid style="--ion-grid-padding: 0px">
                        <ion-row class="ion-align-items-center ion-justify-content-between">
                            <ion-col size="auto" style="--ion-grid-column-padding: 0px; padding-right: 5px">
                                <ion-title size="large">{{ name }}</ion-title>
                            </ion-col>
                            <ion-col size="auto" style="--ion-grid-column-padding: 0px; padding-right: 5px">
                                <connect-status :is-connected="isConnected" />
                            </ion-col>
                        </ion-row>
                    </ion-grid>
                </ion-toolbar>
            </ion-header>

            <ion-button @click="isOpen = true" expand="block" class="ion-padding" :disabled="!isConnected">Configurer les afficheurs</ion-button>
            <ion-modal :is-open="isOpen" :presenting-element="presenting" @willDismiss="handleDismiss">
                <ion-header>
                    <ion-toolbar>
                        <ion-title>Configuration des jauges</ion-title>
                        <ion-buttons slot="end">
                            <ion-button @click="isOpen = false">Retour</ion-button>
                        </ion-buttons>
                    </ion-toolbar>
                </ion-header>
                <ion-content class="ion-margin">
                    <Tower />
                </ion-content>
            </ion-modal>
        </ion-content>

        <ion-footer class="ion-padding">
            <ion-button :id="actionSheetRestartTrigger" expand="block" :color="isConnected ? 'primary' : 'medium'" :disabled="!isConnected">Redémarrer</ion-button>
            <ion-button :id="actionSheetStopTrigger" expand="block" :color="isConnected ? 'danger' : 'medium'" :disabled="!isConnected">Arrêter</ion-button>
        </ion-footer>

        <ion-action-sheet :trigger="actionSheetRestartTrigger" :header="actionSheetHeader" @didDismiss="handleRestart" :buttons="actionSheetButtonsRestart"></ion-action-sheet>
        <ion-action-sheet :trigger="actionSheetStopTrigger" :header="actionSheetHeader" @didDismiss="handleStop" :buttons="actionSheetButtonsStop"></ion-action-sheet>
    </ion-page>
</template>

<script setup lang="ts">
import ConnectStatus from "@/components/ConnectStatus.vue";
import Tower from "@/components/Tower.vue";
import { Zocket } from "@/services/Zocket";
import { DeviceActions, type DeviceType } from "@/types/IConfig";
import { ActionSheetButton, IonActionSheet, IonButton, IonButtons, IonCol, IonContent, IonFooter, IonGrid, IonHeader, IonModal, IonPage, IonRow, IonTitle, IonToolbar } from "@ionic/vue";
import { computed, inject, onMounted, ref } from "vue";

const props = defineProps<{
    device: DeviceType;
}>();

const socket = inject("socket") as Zocket;
const config = socket.getConfig();

const isConnected = computed<boolean>(() => config.value?.modules[props.device].isConnected ?? false);

const name = computed<string>(() => {
    switch (props.device) {
        case "network":
            return "Réseau";
        case "server":
            return "Serveur";
        case "terminal":
            return "Terminal";
    }
});

const actionSheetHeader = ref("Etes-vous sûr ?");
const actionSheetRestartTrigger = ref("restart-" + name.value);
const actionSheetStopTrigger = ref("stop-" + name.value);
const actionSheetButtonsRestart = ref<ActionSheetButton[]>([
    {
        text: "Redémarrer immédiatement",
        role: "destructive",
    },
    {
        text: "Annuler",
        role: "cancel",
    },
]);
const actionSheetButtonsStop = ref<ActionSheetButton[]>([
    {
        text: "Arrêter immédiatement",
        role: "destructive",
    },
    {
        text: "Annuler",
        role: "cancel",
    },
]);

const isOpen = ref(false);

const handleDismiss = () => {
    isOpen.value = false;
};

const page = ref();
const presenting = ref<any>();

const handleRestart = async (event: CustomEvent) => {
    if (event.detail.role == "destructive") {
        socket.sendAction(props.device, DeviceActions.RESTART);
    }
};

const handleStop = async (event: CustomEvent) => {
    if (event.detail.role == "destructive") {
        socket.sendAction(props.device, DeviceActions.STOP);
    }
};

onMounted(() => {
    presenting.value = page.value.$el;
});
</script>
@/services/Zocket
