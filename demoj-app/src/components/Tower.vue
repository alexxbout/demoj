<template>
    <div style="width: 100%; margin-top: 60px; display: flex; flex-direction: column; align-items: center; justify-content: center; justify-items: center">
        <div style="display: flex; background-color: rgb(0 0 0); width: 180px; height: 45svh; border-radius: 5px; border: solid; border-width: 1px; border-color: lightgray">
            <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; justify-items: center; padding-top: 30px; padding-bottom: 30px">
                <div @click="setOpen(true, 'left')" style="height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center; justify-items: center; margin-right: 30px">
                    <div style="background-color: #686868; width: 27px; height: 100%; margin-bottom: 20px; border-radius: 5px"></div>
                    <ion-icon :icon="iconLeft" style="width: 27px; height: 27px; color: white; background-color: #007aff; padding: 8px; border-radius: 999px"></ion-icon>
                </div>
                <div @click="setOpen(true, 'right')" style="height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center; justify-items: center">
                    <div style="background-color: #686868; width: 27px; height: 100%; margin-bottom: 20px; border-radius: 5px"></div>
                    <ion-icon :icon="iconRight" style="width: 27px; height: 27px; color: white; background-color: #007aff; padding: 8px; border-radius: 999px"></ion-icon>
                </div>
            </div>
        </div>
    </div>

    <ion-alert
        @didDismiss="
            (e) => {
                handleInput('left', e);
            }
        "
        :is-open="isLeftOpen"
        :header="alterText + 'gauche'"
        :buttons="alertButtons"
        :inputs="alertInputs"></ion-alert>
    <ion-alert
        @didDismiss="
            (e) => {
                handleInput('right', e);
            }
        "
        :is-open="isRightOpen"
        :header="alterText + 'droite'"
        :buttons="alertButtons"
        :inputs="alertInputs"></ion-alert>
</template>

<script setup lang="ts">
import { AlertInput, IonAlert, IonIcon } from "@ionic/vue";
import { flashOutline, speedometerOutline, thermometerOutline } from "ionicons/icons";
import { ref } from "vue";

const isLeftOpen = ref(false);
const isRightOpen = ref(false);

const iconLeft = ref(flashOutline);
const iconRight = ref(thermometerOutline);

const alterText = ref("Séléctionnez le mode de la jauge ");
const alertButtons = ["OK"];
const alertInputs: AlertInput[] = [
    {
        label: "Température",
        type: "radio",
        value: "temperature",
        // checked: true,
    },
    {
        label: "Enérgie",
        type: "radio",
        value: "energy",
        // disabled: true,
    },
    {
        label: "Mémoire",
        type: "radio",
        value: "memory",
    },
];

const setOpen = (value: boolean, side: "left" | "right") => {
    if (side === "left") {
        isLeftOpen.value = value;
    } else {
        isRightOpen.value = value;
    }
};

const handleInput = (side: "left" | "right", e: CustomEvent) => {
    const data = e.detail.data;

    if (data) {
        const value = data.values;

        if (side === "left") {
            iconLeft.value = value === "energy" ? flashOutline : value === "temperature" ? thermometerOutline : speedometerOutline;
        } else {
            iconRight.value = value === "energy" ? flashOutline : value === "temperature" ? thermometerOutline : speedometerOutline;
        }
    }

    setOpen(false, side);
};
</script>
