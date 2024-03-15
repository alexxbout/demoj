<template>
    <div class="flex flex-col justify-end w-screen h-screen overflow-x-hidden">
        <div ref="field" class="w-screen p-5 overflow-x-auto scroll-smooth scrollbar-hide">
            <div class="flex items-center justify-end h-24 min-w-full p-5 ml-auto w-max">
                <span class="text-6xl font-medium text-slate-700">{{ formula }}</span>
            </div>
        </div>

        <div class="grid grid-cols-4 gap-4 p-5 pt-10">
            <Key @@click="clear" text="AC" type="action" />
            <Key @@click="invertSign" text="+/-" type="action" />
            <Key @@click="append('%')" text="%" type="action" />
            <Key @@click="append('/')" text="÷" type="operator" />

            <Key @@click="append('7')" text="7" type="number" />
            <Key @@click="append('8')" text="8" type="number" />
            <Key @@click="append('9')" text="9" type="number" />
            <Key @@click="operator('*')" text="x" type="operator" />

            <Key @@click="append('4')" text="4" type="number" />
            <Key @@click="append('5')" text="5" type="number" />
            <Key @@click="append('6')" text="6" type="number" />
            <Key @@click="operator('-')" text="-" type="operator" />

            <Key @@click="append('1')" text="1" type="number" />
            <Key @@click="append('2')" text="2" type="number" />
            <Key @@click="append('3')" text="3" type="number" />
            <Key @@click="operator('+')" text="+" type="operator" />

            <Key @@click="append('0')" text="0" type="number" :span="2" />
            <Key @@click="append('.')" text="." type="number" />
            <Key @@click="equal" text="=" type="operator" />
        </div>
    </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import Key from "./components/Key.vue";

const field = ref<HTMLElement | null>(null);
const formula = ref("");

const clear = () => {
    formula.value = "";
};

// const deleteChar = () => {
//     formula.value = formula.value.slice(0, -1);
// };

const invertSign = () => {
    formula.value = formula.value.startsWith("-") ? formula.value.slice(1) : `-${formula.value}`;
};

const append = (value: string) => {
    if (formula.value === "0" && value === "0") {
        return;
    }

    if (formula.value === "0" && value !== ".") {
        formula.value = value;
    } else {
        formula.value += value;
    }

    setTimeout(scrollToRight, 1);
};

const scrollToRight = () => {
    if (field.value) {
        field.value.scrollLeft = field.value.scrollWidth;
    }
};

const scrollToLeft = () => {
    if (field.value) {
        field.value.scrollLeft = 0;
    }
};

const operator = (op: string) => {
    formula.value += op;
};

const equal = () => {
    try {
        formula.value = eval(formula.value);
    } catch (e) {
        formula.value = ":(";
    }

    if (field.value) {
        setTimeout(scrollToLeft, 1);
    }
};

onMounted(() => {
    document.addEventListener("gesturestart", function (e) {
        e.preventDefault();
    });
});
</script>

<style scoped>
/* For Webkit-based browsers (Chrome, Safari and Opera) */
.scrollbar-hide::-webkit-scrollbar {
    display: none;
}

/* For IE, Edge and Firefox */
.scrollbar-hide {
    -ms-overflow-style: none; /* IE and Edge */
    scrollbar-width: none; /* Firefox */
}
</style>
