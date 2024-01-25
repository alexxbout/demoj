<template>
    <ion-button @click="isOpen = true" expand="block" color="danger">{{ header }}</ion-button>
    <ion-modal :is-open="isOpen" :presenting-element="props.presenting" @willDismiss="isOpen = false">
        <ion-header>
            <ion-toolbar>
                <ion-title>Modal</ion-title>
                <ion-buttons slot="end">
                    <ion-button @click="isOpen = false">Close</ion-button>
                </ion-buttons>
            </ion-toolbar>
        </ion-header>
        <ion-content></ion-content>
    </ion-modal>
</template>

<script setup lang="ts">
import { IonButton, IonButtons, IonContent, IonHeader, IonModal, IonTitle, IonToolbar } from "@ionic/vue";
import { ref } from "vue";

const props = defineProps<{
    presenting: any;
}>();

const isOpen = ref(false);

const header = ref("Stresser un module");
</script>
