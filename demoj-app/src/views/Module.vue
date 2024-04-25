<template>
    <ion-page>
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

            <Tower />

            <!-- <ion-list v-if="config" class="ion-margin" :inset="true">
                <ion-item v-for="param in config.modules[props.device].parameters">
                    <ion-grid>
                        <ion-row>
                            <ion-toggle v-model="param.isActive" @ion-change="onParameterToggle(param)" :disabled="!isConnected">{{ param.name }}</ion-toggle>
                            <ion-range v-if="param.type == 'percentage'" v-model="param.value" @ion-change="onParameterUpdate(param)" v-show="param.isActive" :pin="true" :pin-formatter="pinFormatter" :disabled="!isConnected" />
                            <ion-input v-else-if="param.type == 'number'" v-model="param.value" @ion-change="onParameterUpdate(param)" v-show="param.isActive" label="Valeur" type="number"></ion-input>
                        </ion-row>
                    </ion-grid>
                </ion-item>
            </ion-list> -->
        </ion-content>

        <ion-footer class="ion-padding">
            <ion-button :id="actionSheetRestartTrigger" expand="block" :color="isConnected ? 'primary' : 'medium'" :disabled="!isConnected">Redémarrer</ion-button>
            <ion-button :id="actionSheetStopTrigger" expand="block" :color="isConnected ? 'danger' : 'medium'" :disabled="!isConnected">Arrêter</ion-button>
        </ion-footer>

        <ion-action-sheet :trigger="actionSheetRestartTrigger" :header="actionSheetHeader" @didDismiss="handleRestart" :buttons="actionSheetButtonsRestart"></ion-action-sheet>
        <ion-action-sheet :trigger="actionSheetStopTrigger" :header="actionSheetHeader" @didDismiss="handleStop" :buttons="actionSheetButtonsStop"></ion-action-sheet>

        <ion-toast @didDismiss="toastOpen = false" @click="toastOpen = false" :is-open="toastOpen" swipe-gesture="vertical" position="top" :message="toastMessage" :duration="toastDuration" :icon="checkmarkCircle" color="success"></ion-toast>
    </ion-page>
</template>

<script setup lang="ts">
import ConnectStatus from "@/components/ConnectStatus.vue";
import Tower from "@/components/Tower.vue";
import { SoundEnum, SoundManager } from "@/services/SoundManager";
import { Zocket } from "@/services/Zocket";
import { DeviceActions, type DeviceType } from "@/types/IConfig";
import { ActionSheetButton, IonActionSheet, IonButton, IonCol, IonContent, IonFooter, IonGrid, IonHeader, IonPage, IonRow, IonTitle, IonToast, IonToolbar } from "@ionic/vue";
import { checkmarkCircle } from "ionicons/icons";
import { computed, inject, onMounted, ref } from "vue";

const props = defineProps<{
    device: DeviceType;
}>();

const soundManager = new SoundManager();

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

const toastMessage = ref("Action effectuée avec succès");
const toastDuration = ref(5000);
const toastOpen = ref(false);

// const pinFormatter = (value: number) => `${value}%`;

const handleRestart = async (event: CustomEvent) => {
    if (event.detail.role == "destructive") {
        socket.sendAction(props.device, DeviceActions.RESTART);
        soundManager.playSound(SoundEnum.NAVIGATION_SELECTION_COMPLETE_CELEBRATION);
        toastOpen.value = true;
    }
};

const handleStop = async (event: CustomEvent) => {
    if (event.detail.role == "destructive") {
        socket.sendAction(props.device, DeviceActions.STOP);
        soundManager.playSound(SoundEnum.NAVIGATION_SELECTION_COMPLETE_CELEBRATION);
        toastOpen.value = true;
    }
};

// const onParameterToggle = async (parameter: IParameter) => {
//     await API.setParameterState(props.device, parameter.id, parameter.isActive);
// };

// const onParameterUpdate = async (parameter: IParameter) => {
//     await API.setParameterValue(props.device, parameter.id, parameter.value!);
// };

onMounted(() => {
    soundManager.loadSounds([SoundEnum.NAVIGATION_SELECTION_COMPLETE_CELEBRATION]);
});
</script>
@/services/Zocket
