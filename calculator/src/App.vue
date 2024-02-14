<template>
  <div class="flex flex-col w-screen h-screen p-5 overflow-x-hidden gap-y-10">
    <div class="mt-auto"></div>

    <div ref="formulaField" class="w-screen pr-10 overflow-x-auto text-right scroll-smooth">
      <span class="w-full text-6xl font-bold">{{ formula }}</span>
    </div>

    <div class="grid grid-cols-4 gap-5">
      <Key @@click="clear" text="AC" type="delete" />
      <Key @@click="toggleSign" text="+/-" type="operator" />
      <Key @@click="percentage" text="%" type="operator" />
      <Key @@click="operator('/')" text="/" type="operator" />

      <Key @@click="append('(')" text="(" type="operator" />
      <Key @@click="append(')')" text=")" type="operator" />
      <Key @@click="append('^')" text="^" type="operator" />
      <Key @@click="append('Math.sqrt(')" text="√" type="operator" />

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

      <Key @@click="append('.')" text="." type="number" />
      <Key @@click="append('0')" text="0" type="number" />
      <Key @@click="equal" text="=" type="equal" :span="2" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import Key from "./components/Key.vue";

const formulaField = ref<HTMLElement | null>(null);
const formula = ref("");

const clear = () => {
  formula.value = "";
};

const append = (value: string) => {
  formula.value += value;
  scrollToRight();
};

const scrollToRight = () => {
  if (formulaField.value) {
    formulaField.value.scrollLeft = formulaField.value.scrollWidth;
  }
};

const toggleSign = () => {
  formula.value = eval("-1 * (" + formula.value + ")");
};

const percentage = () => {
  formula.value = eval("(" + formula.value + ") / 100");
};

const operator = (op: string) => {
  formula.value += op;
};

const equal = () => {
  try {
    formula.value = eval(formula.value);
  } catch (error) {
    formula.value = "Error";
  }
};
</script>