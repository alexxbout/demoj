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
                    <ion-grid style="padding: 0px">
                        <ion-row class="ion-align-items-end">
                            <ion-col>
                                <ion-title size="large">Debug</ion-title>
                            </ion-col>

                            <ion-col size="fullscreen">
                                <ion-spinner v-show="isLoading"></ion-spinner>
                            </ion-col>
                        </ion-row>
                    </ion-grid>
                </ion-toolbar>
            </ion-header>

            <ion-list class="ion-padding">
                <Ping @@start="isLoading = true" @@end="isLoading = false" />
                <ion-button class="ion-margin-vertical" @click="isOpen = true" expand="block">Test</ion-button>
            </ion-list>

            <ion-modal :is-open="isOpen" :presenting-element="presentingElement" @willDismiss="isOpen = false">
                <ion-header>
                    <ion-toolbar>
                        <ion-title>Modal</ion-title>
                        <ion-buttons slot="end">
                            <ion-button @click="isOpen = false">Close</ion-button>
                        </ion-buttons>
                    </ion-toolbar>
                </ion-header>
                <ion-content> </ion-content>
            </ion-modal>
        </ion-content>
    </ion-page>
</template>

<script setup lang="ts">
import { IonButton, IonButtons, IonCol, IonContent, IonGrid, IonHeader, IonList, IonModal, IonPage, IonRow, IonSpinner, IonTitle, IonToolbar } from "@ionic/vue";
import { onMounted, ref } from "vue";
import Ping from "./debug/Ping.vue";

const page = ref();
const isOpen = ref(false);
const presentingElement = ref();
const isLoading = ref(false);

onMounted(() => {
    presentingElement.value = page.value.$el;
});
</script>
