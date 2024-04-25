<template>
    <ion-button @click="isOpen = true" expand="block" color="danger" class="ion-padding">{{ header }}</ion-button>
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
                    <ion-select v-model="moduleSelect" :label="moduleLabel" :placeholder="modulePlaceholder">
                        <ion-select-option v-for="value in values" :value="value.value" :disabled="value.disabled">{{ value.text }}</ion-select-option>
                    </ion-select>
                </ion-item>

                <ion-item>
                    <ion-input @ionInput="handleTimeInput" :value="timeInput" :label="timeLabel" type="number" :min="timeMin" :max="timeMax" class="ion-text-right"></ion-input>
                </ion-item>
            </ion-list>
        </ion-content>

        <ion-footer>
            <ion-button @click="sendStress" expand="block" class="ion-padding" color="danger" :disabled="isButtonDisabled">{{ buttonText }}</ion-button>
        </ion-footer>
    </ion-modal>
</template>

<script setup lang="ts">
import { Zocket } from "@/services/Zocket";
import { DeviceType } from "@/types/IConfig";
import { IonButton, IonButtons, IonContent, IonFooter, IonHeader, IonInput, IonItem, IonList, IonModal, IonSelect, IonSelectOption, IonTitle, IonToolbar } from "@ionic/vue";
import { computed, inject, ref } from "vue";

const props = defineProps<{
    presenting: any;
}>();

const emits = defineEmits<{
    (e: "@stress", module: DeviceType, time: number): void;
}>();

const socket = inject("socket") as Zocket;
const config = socket.getConfig();

const isOpen = ref(false);
const header = ref("Stresser un module");

const moduleLabel = ref("Module");
const modulePlaceholder = ref("Choisir un module");
const moduleSelect = ref<DeviceType | null>(null);

const timeLabel = ref("Durée (en secondes)");
const timeInput = ref(10);
const timeMin = 1;
const timeMax = 60 * 5;

const buttonText = ref("Stresser le module");
const isButtonDisabled = computed(() => timeInput.value < timeMin || timeInput.value > timeMax || !moduleSelect.value);

const values = computed<{ value: string; text: string; disabled: boolean }[]>(() => [
    { value: "terminal", text: "Terminal", disabled: config.value ? !config.value.modules.terminal.isConnected : true },
    { value: "network", text: "Réseau", disabled: config.value ? !config.value.modules.network.isConnected : true },
    { value: "server", text: "Serveur", disabled: config.value ? !config.value.modules.server.isConnected : false },
]);

const handleTimeInput = (event: CustomEvent) => {
    const input = event.target as HTMLIonInputElement;
    timeInput.value = input.value as number;
};

const sendStress = () => {
    console.log("Sending stress to module %s for %d seconds", moduleSelect.value, timeInput.value);

    if (moduleSelect.value) {
        isOpen.value = false;

        socket.sendStress(moduleSelect.value, timeInput.value);

        emits("@stress", moduleSelect.value, timeInput.value);
    }
};

const handleDismiss = () => {
    timeInput.value = 10;

    isOpen.value = false;
};
</script>
