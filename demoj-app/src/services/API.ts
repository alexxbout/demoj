import { DeviceTypes, IConfig, IParameter, IScenario } from "@/types/IConfig";
import axios from "axios";

class API {
    private timeout = 2000;
    private networkIP = "http://" + import.meta.env.VITE_IP_NETWORK + ":" + import.meta.env.VITE_PORT + "/api";

    // Getters from config file

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

    /**
     * @deprecated use socket instead
     */
    async getModuleParameters(device: DeviceTypes): Promise<IParameter[]> {
        const config = await this.getConfig();

        if (config == null) return [];

        try {
            const parameters = config.modules[device].parameters;
            if (parameters == null) return [];

            return parameters;
        } catch (error) {
            console.error("Unable to get parameters for device: " + device);
            console.error(error);
            return [];
        }
    }

    /**
     * @deprecated use socket instead
     */
    async getScenarios(): Promise<IScenario[]> {
        const config = await this.getConfig();

        if (config == null) return [];

        try {
            return config.scenarios;
        } catch (error) {
            console.error("Unable to get scenarios");
            console.error(error);
            return [];
        }
    }

    // Setters

    async setParameterState(device: DeviceTypes, id: number, isActive: boolean): Promise<boolean> {
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

    async setParameterValue(device: DeviceTypes, id: number, value: number): Promise<boolean> {
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

    // Actions

    async restartModule(device: DeviceTypes): Promise<boolean> {
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

    async stopModule(device: DeviceTypes): Promise<boolean> {
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

    async ping(device: DeviceTypes): Promise<boolean> {
        return await axios
            .get(this.networkIP + `/ping/${device}`, { timeout: this.timeout })
            .then(() => {
                return true;
            })
            .catch((error) => {
                console.error(error);
                return false;
            });
    }

    // Others

    async checkStatus(device: DeviceTypes): Promise<boolean> {
        return await axios
            .get(this.networkIP + `/check_status/${device}`, { timeout: this.timeout })
            .then((response) => {
                return response.data as boolean;
            })
            .catch((error) => {
                console.error(error);
                return false;
            });
    }
}

export default new API();
