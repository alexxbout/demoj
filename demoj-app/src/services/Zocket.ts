import { DeviceActions, DeviceStates, DeviceType, IConfig } from "@/types/IConfig";
import { Socket, io } from "socket.io-client";
import { Ref, ref } from "vue";
import API from "./API";
import { SoundEnum, SoundManager } from "./SoundManager";

export class Zocket {
    private IP_NETWORK = import.meta.env.VITE_IP_NETWORK;
    private PORT = import.meta.env.VITE_PORT;
    private socket: Socket | null;
    private config: Ref<IConfig | null>;
    private soundManager: SoundManager;

    constructor() {
        this.socket = null;
        this.config = ref(null);

        this.soundManager = new SoundManager();
        this.soundManager.loadSounds([SoundEnum.NAVIGATION_FORWARD_SELECTION, SoundEnum.NAVIGATION_BACKWARD_SELECTION, SoundEnum.UI_LOADING]);
    }

    public connect() {
        console.info("Connecting to socket...");
        this.socket = io(`http://${this.IP_NETWORK}:${this.PORT}`);

        /**
         * Default events
         */

        this.socket.on("connect", () => {
            console.info("Socket connected");
            this.soundManager.playSound(SoundEnum.NAVIGATION_FORWARD_SELECTION);

            // Request the configuration
            API.getConfig().then((config) => {
                if (config) this.config.value = config;
            });
        });

        this.socket.on("disconnect", () => {
            console.info("Socket closed");
            if (this.config.value) {
                this.config.value.modules.terminal.isConnected = false;
                this.config.value.modules.server.isConnected = false;
                this.config.value.modules.network.isConnected = false;
            }
            this.reconnect();
        });

        this.socket.on("error", (error: any) => {
            console.info("Socket error");
            console.info(error);
        });

        this.socket.on("connect_error", () => {
            console.info("Socket connection error, reconnecting...");
            this.reconnect();
        });

        this.socket.on("connect_timeout", () => {
            console.info("Socket timeout, reconnecting...");
            this.reconnect();
        });

        /**
         * Custom events
         */

        this.socket.on("module_status", (data: { device: DeviceType; status: DeviceStates }) => {
            console.info(`Socket ${data.device} status: ${data.status}`);
            this.soundManager.playSound(data.status == DeviceStates.ON ? SoundEnum.NAVIGATION_FORWARD_SELECTION : SoundEnum.NAVIGATION_BACKWARD_SELECTION);

            // Update the status of the module
            if (this.config.value) this.config.value.modules[data.device].isConnected = data.status == DeviceStates.ON;
        });
    }

    public reconnect() {
        setTimeout(() => {
            this.soundManager.playSound(SoundEnum.UI_LOADING);

            if (this.socket && !this.socket.connected) this.socket.connect();
        }, 1000);
    }

    public disconnect() {
        if (this.socket && this.socket.connected) this.socket.disconnect();
    }

    public isConnected() {
        return this.socket?.connected;
    }

    public sendAction(module: DeviceType, action: DeviceActions) {
        if (this.socket) this.socket.emit("action", { device: module, action: action });
    }

    public sendStress(module: DeviceType, time: number) {
        if (this.socket) this.socket.emit("stress", { device: module, time: time });
    }

    public getConfig() {
        return this.config;
    }
}

export default new Zocket();
