<template>
    <ion-button @click="handleConnect" expand="block">Se connecter à la socket serveur</ion-button>
    <ion-button @click="handleMsg" expand="block">Envoyer un message</ion-button>
    <ion-button @click="handleClose" expand="block">Fermer la socket</ion-button>
</template>

<script setup lang="ts">
import { IonButton } from "@ionic/vue";
import { Socket, io } from "socket.io-client";

let socket: Socket | null = null;

const handleConnect = () => {
    socket = io("http://192.168.64.101:5000");

    socket.on("connect", () => {
        console.log("socket connected");
        // socket?.emit("message", "hellloooooooo");
    });

    socket.on("message", (data: any) => {
        console.log(data);
    });

    socket.on("disconnect", () => {
        console.log("socket closed");
    });

    socket.on("error", (error: any) => {
        console.log(error);
    });

    socket.on("connect_error", (error: any) => {
        console.log(error);
    });

    socket.on("connect_timeout", (error: any) => {
        console.log(error);
    });
};

const handleClose = () => {
    // On Chrome, this will cause an Invalid frame header error, but it's fine
    
    if (socket && socket.connected) socket.disconnect();
};

const handleMsg = () => {
    socket?.emit("message", "hellloooooooo");
};
</script>
