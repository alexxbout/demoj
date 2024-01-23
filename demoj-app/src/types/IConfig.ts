export type DeviceTypes = "terminal" | "network" | "server";
export type ParameterTypes = "number" | "percentage" | "boolean";

export interface IParameter {
    id: number;
    name: string;
    type: ParameterTypes;
    isActive: boolean;
    value?: number;
}

export interface IScenario {
    name: string;
    description: string;
    id: number;
    to: keyof DeviceTypes;
    multipleInstance: boolean;
    parameters: {
        name: string;
        value: number;
    }[];
    instances: {}[];
    icon?: string;
}

export interface IConfig {
    modules: { [key in DeviceTypes]: { parameters?: IParameter[] } };
    scenarios: IScenario[];
}
