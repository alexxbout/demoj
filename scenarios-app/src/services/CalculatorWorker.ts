import * as compute from "./Compute.ts";

onmessage = function (e) {
    const result = compute.parseAndEvaluate(e.data.expression);
    postMessage(result);
};

