<template>
    <ion-button @click="isOpen = true" expand="block" color="success">{{ header }}</ion-button>
    <ion-modal :is-open="isOpen" :presenting-element="props.presenting" @willDismiss="isOpen = false">
        <ion-header>
            <ion-toolbar>
                <ion-title>Scénarios en cours</ion-title>
                <ion-buttons slot="end">
                    <ion-button @click="isOpen = false">Retour</ion-button>
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

const header = ref("Voir les scénarios en cours");
</script>
