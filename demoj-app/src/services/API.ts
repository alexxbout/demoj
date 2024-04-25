import { DeviceType, IConfig } from "@/types/IConfig";
import axios from "axios";

class API {
    private timeout = 2000;
    private networkIP = "http://" + import.meta.env.VITE_IP_NETWORK + ":" + import.meta.env.VITE_PORT + "/api";

    async getConfig(): Promise<IConfig | null> {
        return await axios
            .get(this.networkIP + "/config", { timeout: this.timeout })
            .then((response) => {
                return response.data as IConfig;
            })
            .catch((error) => {
                console.error(error);
                return null;
            });
    }

    async setParameterState(device: DeviceType, id: number, isActive: boolean): Promise<boolean> {
        return await axios
            .post(this.networkIP + `/modules/${device}/params/${id}`, { isActive: isActive }, { timeout: this.timeout })
            .then(() => {
                return true;
            })
            .catch((error) => {
                console.error(error);
                return false;
            });
    }

    async setParameterValue(device: DeviceType, id: number, value: number): Promise<boolean> {
        return await axios
            .post(this.networkIP + `/modules/${device}/params/${id}`, { value: value }, { timeout: this.timeout })
            .then(() => {
                return true;
            })
            .catch((error) => {
                console.error(error);
                return false;
            });
    }

    async restartModule(device: DeviceType): Promise<boolean> {
        // TODO Add restart specific module
        return await axios
            .get(this.networkIP + `/restart/${device}`, { timeout: this.timeout })
            .then(() => {
                return true;
            })
            .catch((error) => {
                console.log(error);
                return false;
            });
    }

    async stopModule(device: DeviceType): Promise<boolean> {
        // TODO Add stop specific module
        return await axios
            .get(this.networkIP + `/stop/${device}`, { timeout: this.timeout })
            .then(() => {
                return true;
            })
            .catch((error) => {
                console.error(error);
                return false;
            });
    }
}

export default new API();
