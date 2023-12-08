import { DeviceTypes, IConfig, IParameter } from "@/types/IConfig";
import axios from "axios";

class API {
    private timeout = 3000;
    private serverIP = "http://192.168.64.21:5000";

    private async getConfig(): Promise<IConfig | null> {
        return await axios
            .get(this.serverIP + "/config", { timeout: this.timeout })
            .then((response) => {
                return response.data as IConfig;
            })
            .catch((error) => {
                // console.error(error);
                return null;
            });
    }

    async refreshConfig(): Promise<void> {
        await this.getConfig();
    }

    async isConnected(device: DeviceTypes): Promise<boolean> {
        const config = await this.getConfig();

        if (config === null) {
            return false;
        }

        return config.modules[device].isConnected;
    }

    async getModuleParameters(device: DeviceTypes, shared: boolean = true): Promise<IParameter[]> {
        const config = await this.getConfig();

        if (config === null) {
            return [];
        }

        const parameters = config.modules[device].parameters;
        if (parameters === undefined) {
            return [];
        }

        return parameters;
    }

    async setParameterState(name: string, id: number, isActive: boolean): Promise<boolean> {
        console.log(name, id, isActive);
        
        await axios
            .post(this.serverIP + `/modules/${name}/params/${id}`, { isActive: isActive }, { timeout: this.timeout })
            .then((response) => {
                console.log(response);
                return true;
            })
            .catch((error) => {
                console.error(error);
                return false;
            });

        return false;
    }
}

export default new API();
