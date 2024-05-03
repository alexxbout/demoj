export type DeviceType = "terminal" | "network" | "server";
export type ParameterType = "number" | "percentage" | "boolean";

export interface IConfig {
    modules: { [key in DeviceType]: { isConnected: boolean } };
    isBackendCalculator: boolean;
};

export enum DeviceStates {
    ON = "on",
    OFF = "off"
};

export enum DeviceActions {
    RESTART = "restart",
    STOP = "stop"
};