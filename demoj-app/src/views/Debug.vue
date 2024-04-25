<template>
    <ion-page ref="page">
        <ion-header>
            <ion-toolbar>
                <ion-title>Debug</ion-title>
            </ion-toolbar>
        </ion-header>

        <ion-content :fullscreen="true">
            <ion-header collapse="condense">
                <ion-toolbar>
                    <ion-grid style="--ion-grid-padding: 0px">
                        <ion-row class="ion-align-items-end ion-justify-content-between">
                            <ion-col size="auto" style="--ion-grid-column-padding: 0px">
                                <ion-title size="large">Debug</ion-title>
                            </ion-col>

                            <ion-col size="auto" style="--ion-grid-column-padding: 0px; padding-right: 5px">
                                <ion-spinner v-show="isLoading"></ion-spinner>
                            </ion-col>
                        </ion-row>
                    </ion-grid>
                </ion-toolbar>
            </ion-header>

            <ion-content>
                <Stress @@stress="handleStress" :presenting="presenting" />
                <ion-list :inset="true">
                    <ProgressIndicator v-for="request in pendingRequests" :title="request.title" :time="request.time" />
                </ion-list>
            </ion-content>
        </ion-content>

        <ion-footer class="ion-padding ion-text-center">
            <ion-text>DémoJ Connect version {{ version }}</ion-text>
        </ion-footer>
    </ion-page>
</template>

<script setup lang="ts">
import ProgressIndicator from "@/components/ProgressIndicator.vue";
import { DeviceType } from "@/types/IConfig";
import { IonCol, IonContent, IonFooter, IonGrid, IonHeader, IonList, IonPage, IonRow, IonSpinner, IonText, IonTitle, IonToolbar } from "@ionic/vue";
import { onMounted, ref } from "vue";
import Stress from "./debug/Stress.vue";

const page = ref();
const presenting = ref();
const isLoading = ref(false);
const version = ref(import.meta.env.VITE_DEMOJCONNECT_VERSION);

const pendingRequests = ref<{ title: string; time: number }[]>([]);

const handleStress = (module: DeviceType, time: number) => {
    pendingRequests.value.push({ title: `Stress du module ${module}`, time });
};

onMounted(() => {
    presenting.value = page.value.$el;
});
</script>
