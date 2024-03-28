export type DeviceTypes = "terminal" | "network" | "server";
export type ParameterTypes = "number" | "percentage" | "boolean";

export interface IParameter {
    id: number;
    name: string;
    type: ParameterTypes;
    isActive: boolean;
    value?: number;
};

export interface IScenario {
    name: string;
    description: string;
    id: number;
};

export interface IConfig {
    modules: { [key in DeviceTypes]: { isConnected: boolean, parameters?: IParameter[] } };
    scenarios: IScenario[];
};

export enum DeviceStates {
    ON = "on",
    OFF = "off"
};

export enum DeviceActions {
    RESTART = "restart",
    STOP = "stop"
};