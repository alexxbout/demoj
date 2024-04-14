import * as compute from "./compute.ts";

onmessage = function (e) {
    const result = compute.parseAndEvaluate(e.data.expression);
    postMessage(result);
};

