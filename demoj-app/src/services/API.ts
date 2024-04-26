import { IConfig } from "@/types/IConfig";
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
}

export default new API();
