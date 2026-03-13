<script setup>
import Lesson from './components/Lesson.vue'

const baseUrl = import.meta.env.BASE_URL
const jsonFile = 'de_es.json'
</script>

<template>
  <Lesson :jsonUrl="baseUrl + jsonFile" :maxCount="6" />
</template>

<style scoped>
.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>
