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
                    <ion-grid style="padding: 0px">
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

            <ion-list class="ion-padding">
                <ion-item v-for="param in parameters">
                    <ion-grid style="padding: 0px">
                        <ion-row>
                            <ion-toggle v-model="param.isActive" @click="onParameterToggle(param)" :disabled="!isConnected">{{ param.name }}</ion-toggle>
                            <ion-range v-if="param.type == 'percentage'" v-model="param.value" v-show="param.isActive" :pin="true" :pin-formatter="pinFormatter" :disabled="!isConnected" />
                        </ion-row>
                    </ion-grid>
                </ion-item>
            </ion-list>
        </ion-content>

        <ion-footer class="ion-padding">
            <ion-button class="ion-margin-vertical" expand="block" :color="isConnected ? 'primary' : 'medium'" :disabled="!isConnected">Redémarrer</ion-button>
            <ion-button expand="block" :color="isConnected ? 'danger' : 'medium'" :disabled="!isConnected">Arrêter</ion-button>
        </ion-footer>
    </ion-page>
</template>

<script setup lang="ts">
import ConnectStatus from "@/components/ConnectStatus.vue";
import router from "@/router";
import API from "@/services/API";
import type { DeviceTypes, IParameter } from "@/types/IConfig";
import { IonButton, IonCol, IonContent, IonFooter, IonGrid, IonHeader, IonItem, IonList, IonPage, IonRange, IonRefresher, IonRefresherContent, IonRow, IonTitle, IonToggle, IonToolbar } from "@ionic/vue";
import { computed, onMounted, ref, watch } from "vue";

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

const isConnected = ref(false);
const parameters = ref<IParameter[]>([]);

// const onPacketLossRangeUpdate = (event: any) => {
//     packetLossRange.value = event.detail.value;
// };

const onParameterToggle = async (parameter: IParameter) => {    
    await API.setParameterState(props.device, parameter.id, parameter.isActive);
};

const pinFormatter = (value: number) => `${value}%`;

const handleRefresh = async (event: any) => {
    await updateStatus();
    setTimeout(() => {
        event.target.complete();
    }, 500);
};

const updateStatus = async () => {
    await API.isConnected(props.device).then((response) => {
        isConnected.value = response;
    });
};

const getParameters = async () => {
    await API.getModuleParameters(props.device).then((response) => {
        parameters.value = response;
    });
};

onMounted(async () => {
    await updateStatus();
    if (isConnected.value) {
        getParameters();
    }
});

router.beforeEach(async (to, from, next) => {
    if (!to.path.includes(props.device || !from.path.includes(props.device))) {
        return next();
    }

    next();

    await updateStatus();
});

watch(parameters, (newValue) => {
    console.log(newValue);
}, { deep: true });
</script>
