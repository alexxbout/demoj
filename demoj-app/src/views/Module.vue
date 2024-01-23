<template>
    <ion-page>
        <ion-header>
            <ion-toolbar>
                <ion-title>{{ name }}</ion-title>
            </ion-toolbar>
        </ion-header>

        <ion-content :fullscreen="true">
            <ion-refresher slot="fixed" :pull-factor="0.5" :pull-min="100" :pull-max="200" @ionRefresh="handleRefresh">
                <ion-refresher-content></ion-refresher-content>
            </ion-refresher>

            <ion-header collapse="condense">
                <ion-toolbar>
                    <ion-grid>
                        <ion-row class="ion-align-items-end">
                            <ion-col>
                                <ion-title size="large">{{ name }}</ion-title>
                            </ion-col>

                            <ion-col size="fullscreen">
                                <connect-status :is-connected="isConnected" />
                            </ion-col>
                        </ion-row>
                    </ion-grid>
                </ion-toolbar>
            </ion-header>

            <ion-list class="ion-margin" :inset="true">
                <ion-item v-for="param in parameters">
                    <ion-grid>
                        <ion-row>
                            <ion-toggle v-model="param.isActive" @ion-change="onParameterToggle(param)" :disabled="!isConnected">{{ param.name }}</ion-toggle>
                            <ion-range v-if="param.type == 'percentage'" v-model="param.value" @ion-change="onParameterUpdate(param)" v-show="param.isActive" :pin="true" :pin-formatter="pinFormatter" :disabled="!isConnected" />
                            <ion-input v-else-if="param.type == 'number'" v-model="param.value" @ion-change="onParameterUpdate(param)" v-show="param.isActive" label="Valeur" type="number"></ion-input>
                        </ion-row>
                    </ion-grid>
                </ion-item>
            </ion-list>
        </ion-content>

        <ion-footer class="ion-padding">
            <ion-button :id="actionSheetRestartTrigger" expand="block" :color="isConnected ? 'primary' : 'medium'" :disabled="!isConnected">Redémarrer</ion-button>
            <ion-button :id="actionSheetStopTrigger" expand="block" :color="isConnected ? 'danger' : 'medium'" :disabled="!isConnected">Arrêter</ion-button>
        </ion-footer>

        <ion-action-sheet :trigger="actionSheetRestartTrigger" :header="actionSheetHeader" @didDismiss="handleRestartSheet" :buttons="actionSheetButtonsRestart"></ion-action-sheet>
        <ion-action-sheet :trigger="actionSheetStopTrigger" :header="actionSheetHeader" @didDismiss="handleStopSheet" :buttons="actionSheetButtonsStop"></ion-action-sheet>

        <ion-toast @didDismiss="toastOpen = false" @click="toastOpen = false" :is-open="toastOpen" swipe-gesture="vertical" position="top" :message="toastMessage" :duration="toastDuration" :icon="checkmarkCircle" color="success"></ion-toast>
    </ion-page>
</template>

<script setup lang="ts">
import ConnectStatus from "@/components/ConnectStatus.vue";
import router from "@/router";
import API from "@/services/API";
import type { DeviceTypes, IParameter } from "@/types/IConfig";
import { ActionSheetButton, IonActionSheet, IonButton, IonCol, IonContent, IonFooter, IonGrid, IonHeader, IonInput, IonItem, IonList, IonPage, IonRange, IonRefresher, IonRefresherContent, IonRow, IonTitle, IonToast, IonToggle, IonToolbar } from "@ionic/vue";
import { checkmarkCircle } from "ionicons/icons";
import { computed, onMounted, ref } from "vue";

// TODO : Faire un check toutes les x secondes pour voir si le module est connecté ou non

const props = defineProps<{
    device: DeviceTypes;
}>();

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

const actionSheetRestartTrigger = ref("restart-" + name.value);
const actionSheetStopTrigger = ref("stop-" + name.value);

const isConnected = ref(false);
const parameters = ref<IParameter[]>([]);

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

const actionSheetHeader = ref("Etes-vous sûr ?");

const toastMessage = ref("Action effectuée avec succès");
const toastDuration = ref(5000);
const toastOpen = ref(false);

const handleRestartSheet = async (event: CustomEvent) => {
    if (event.detail.role == "destructive") {
        if (await API.restartModule(props.device)) {
            isConnected.value = false;
            toastOpen.value = true;

            // Automatically update the status of the module after 5 seconds
            setTimeout(async () => {
                await update();
            }, 5000);
        }
    }
};

const handleStopSheet = async (event: CustomEvent) => {
    if (event.detail.role == "destructive") {
        if (await API.stopModule(props.device)) {
            isConnected.value = false;
            toastOpen.value = true;
        }
    }
};

const onParameterToggle = async (parameter: IParameter) => {
    await API.setParameterState(props.device, parameter.id, parameter.isActive);
};

const onParameterUpdate = async (parameter: IParameter) => {
    await API.setParameterValue(props.device, parameter.id, parameter.value!);
};

const pinFormatter = (value: number) => `${value}%`;

const handleRefresh = async (event: any) => {
    await update();
    setTimeout(() => {
        event.target.complete();
    }, 500);
};

const updateStatus = async () => {
    isConnected.value = await API.checkStatus(props.device);
};

const getParameters = async () => {
    await API.getModuleParameters(props.device).then((response) => {
        parameters.value = response;
    });
};

const update = async () => {
    await updateStatus();
    if (isConnected.value) await getParameters();
};

onMounted(async () => {
    await update();
});

router.beforeEach(async (to, from, next) => {
    if (!to.path.includes(props.device || !from.path.includes(props.device))) {
        return next();
    }

    next();

    await update();
});
</script>
