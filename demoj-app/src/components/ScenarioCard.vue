<template>
    <ion-card>
        <ion-card-header>
            <ion-grid style="width: 100%;">
                <ion-row class="ion-align-items-center ion-justify-content-start">
                    <ion-col size="auto">
                        <ion-icon :icon="data.icon" size="large" style="color: black;" />
                    </ion-col>

                    <ion-col size="auto">
                        <ion-card-title>{{ props.data.title }}</ion-card-title>
                    </ion-col>
                </ion-row>
            </ion-grid>
        </ion-card-header>

        <ion-card-content>{{ props.data.description }}</ion-card-content>

        <ion-button @click="go" class="ion-padding" expand="block">Voir le scénario</ion-button>
    </ion-card>
</template>

<script setup lang="ts">
import { IScenario } from "@/types/IConfig";
import { IonButton, IonCard, IonCardContent, IonCardHeader, IonCardTitle, IonCol, IonGrid, IonIcon, IonRow } from "@ionic/vue";
import { useRouter } from "vue-router";

const props = defineProps<{
    data: IScenario;
}>();

const router = useRouter();

const go = () => {
    router.push({ name: props.data.name });
};
</script>
