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

                            <ion-col size="auto" style="--ion-grid-column-padding: 0px; padding-right: 5px;">
                                <ion-spinner v-show="isLoading"></ion-spinner>
                            </ion-col>
                        </ion-row>
                    </ion-grid>
                </ion-toolbar>
            </ion-header>

            <ion-content class="ion-padding">
                <Running :presenting="presenting" />
                <Stress :presenting="presenting" />

                <Ping @@start="isLoading = true" @@end="isLoading = false" />
            </ion-content>
        </ion-content>

        <ion-footer class="ion-padding ion-text-center">
            <ion-text> DémoJ Connect version 1.0.0 </ion-text>
        </ion-footer>
    </ion-page>
</template>

<script setup lang="ts">
import { IonCol, IonContent, IonFooter, IonGrid, IonHeader, IonPage, IonRow, IonSpinner, IonText, IonTitle, IonToolbar } from "@ionic/vue";
import { onMounted, ref } from "vue";
import Ping from "./debug/Ping.vue";
import Running from "./debug/Running.vue";
import Stress from "./debug/Stress.vue";

const page = ref();
const presenting = ref();
const isLoading = ref(false);

onMounted(() => {
    presenting.value = page.value.$el;
});
</script>
