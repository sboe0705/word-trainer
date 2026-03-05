<script setup>
import { ref, onMounted } from 'vue'

defineProps({
  msg: String,
})

const file = 'de_es.json'
const vocabulary = ref(null)

onMounted(async () => {
  const response = await fetch('/' + file)
  vocabulary.value = await response.json()
})
</script>

<template>
  <h1>{{ msg }}</h1>

  <div v-if="vocabulary">
    <h2>{{ vocabulary.sourceLang }} → {{ vocabulary.targetLang }}</h2>
  
    <div v-for="word in vocabulary.words" :key="word.source">
      <v-btn>{{ word.source }}</v-btn>
      <v-btn>{{ word.target }}</v-btn>
    </div>
  </div>

</template>

<style scoped>
</style>
