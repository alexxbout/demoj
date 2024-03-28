<template>
    <ion-button @click="isOpen = true" expand="block" color="danger">{{ header }}</ion-button>
    <ion-modal :is-open="isOpen" :presenting-element="props.presenting" @willDismiss="handleDismiss">
        <ion-header>
            <ion-toolbar>
                <ion-title>Stresser un module</ion-title>
                <ion-buttons slot="end">
                    <ion-button @click="isOpen = false">Annuler</ion-button>
                </ion-buttons>
            </ion-toolbar>
        </ion-header>
        <ion-content class="ion-margin">
            <ion-list :inset="true">
                <ion-item>
                    <ion-select :value="moduleSelect" :label="moduleLabel" :placeholder="modulePlaceholder">
                        <ion-select-option value="terminal">Terminal</ion-select-option>
                        <ion-select-option value="network">Réseau</ion-select-option>
                        <ion-select-option value="server">Serveur</ion-select-option>
                    </ion-select>
                </ion-item>

                <ion-item>
                    <ion-select :value="levelSelect" :label="levelLabel" :placeholder="levelPlaceholder">
                        <ion-select-option :value="1">Faible stress</ion-select-option>
                        <ion-select-option :value="2">Stress modéré</ion-select-option>
                        <ion-select-option :value="3">Stress élevé</ion-select-option>
                    </ion-select>
                </ion-item>

                <ion-item>
                    <ion-input @ionInput="handleTimeInput" :value="timeInput" :label="timeLabel" type="number" :min="timeMin" :max="timeMax" class="ion-text-right"></ion-input>
                </ion-item>
            </ion-list>
        </ion-content>

        <ion-footer>
            <ion-button expand="block" class="ion-padding" color="danger" :disabled="isButtonDisabled">{{ buttonText }}</ion-button>
        </ion-footer>
    </ion-modal>
</template>

<script setup lang="ts">
import { Chaussette } from "@/services/Chaussette";
import { DeviceTypes } from "@/types/IConfig";
import { IonButton, IonButtons, IonContent, IonFooter, IonHeader, IonInput, IonItem, IonList, IonModal, IonSelect, IonSelectOption, IonTitle, IonToolbar } from "@ionic/vue";
import { computed, inject, ref } from "vue";

const props = defineProps<{
    presenting: any;
}>();

const socket = inject("socket") as Chaussette;

const isOpen = ref(false);
const header = ref("Stresser un module");

const moduleLabel = ref("Module");
const modulePlaceholder = ref("Choisir un module");
const moduleSelect = ref<DeviceTypes>("terminal");

const levelLabel = ref("Niveau");
const levelPlaceholder = ref("Choisir un niveau");
const levelSelect = ref<1 | 2 | 3>(1);

const timeLabel = ref("Durée (en secondes)");
const timeInput = ref(10);
const timeMin = ref(1);
const timeMax = ref(60*5);

const buttonText = ref("Stresser le module");
const isButtonDisabled = computed(() => timeInput.value < timeMin.value || timeInput.value > timeMax.value);

const handleTimeInput = (event: CustomEvent) => {
    const input = event.target as HTMLIonInputElement;
    timeInput.value = input.value as number;
};

const stressModule = () => {
    socket.stressModule(moduleSelect.value, levelSelect.value, timeInput.value);
    isOpen.value = false;
};

const handleDismiss = () => {
    moduleSelect.value = "terminal";
    levelSelect.value = 1;
    timeInput.value = 10;

    isOpen.value = false;
};
</script>
@/services/Chaussette