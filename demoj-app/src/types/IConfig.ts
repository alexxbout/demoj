export type DeviceType = "terminal" | "network" | "server";
export type ParameterType = "number" | "percentage" | "boolean";

export interface IParameter {
    id: number;
    name: string;
    type: ParameterType;
    isActive: boolean;
    value?: number;
};

export interface IScenario {
    name: string;
    title: string;
    description: string;
    icon?: string;
};

export interface IConfig {
    modules: { [key in DeviceType]: { isConnected: boolean, parameters?: IParameter[] } };
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