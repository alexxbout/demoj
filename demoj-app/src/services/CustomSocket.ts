import { IConfig } from "@/types/IConfig";
import { io, Socket } from "socket.io-client";
import { ref, Ref, watch } from "vue";
import API from "./API";

export class CustomSocket {
    private socket: Socket | null;
    private config: Ref<IConfig | null>;

    constructor() {
        this.socket = null;
        this.config = ref(null);

        watch(this.config, (newConfig) => {
            console.log("new config from Socket.ts");
            console.log(newConfig);
        });
    }

    public connect() {
        this.socket = io(`http://${import.meta.env.VITE_IP_NETWORK}:${import.meta.env.VITE_PORT}`);

        this.socket.on("connect", () => {
            console.log("Socket connected");
            this.socket?.emit("ready", { device: "client" });

            API.getConfig().then((config) => {
                this.config.value = config;
            });
        });

        this.socket.on("disconnect", () => {
            console.log("Socket closed");
            this.reconnect();
        });

        this.socket.on("error", (error: any) => {
            console.log(error);
        });

        this.socket.on("connect_error", (error: any) => {
            console.log(error);
            this.reconnect();
        });

        this.socket.on("connect_timeout", (error: any) => {
            console.log(error);
            this.reconnect();
        });
    }

    private reconnect() {
        setTimeout(() => {
            if (this.socket && !this.socket.connected) this.socket.connect();
        }, 1000);
    }

    public disconnect() {
        if (this.socket && this.socket.connected) this.socket.disconnect();
    }

    public isConnected() {
        return this.socket?.connected;
    }

    public getConfig() {
        return this.config;
    }
}

export default new CustomSocket();
