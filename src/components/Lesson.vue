<script setup>
import { ref, onMounted } from 'vue'
import { useDisplay } from 'vuetify'

const display = useDisplay()

defineProps({
  msg: String,
})

const baseUrl = import.meta.env.BASE_URL
const file = 'de_es.json'
const vocabulary = ref(null)

onMounted(async () => {
  const response = await fetch(baseUrl + file)
  vocabulary.value = await response.json()
})
</script>

<template>
  <h1>{{ msg }}</h1>
  <v-container fluid v-if="vocabulary">
    <v-row>
      <v-col cols="12" class="text-center">
        <h2>{{ vocabulary.sourceLang }} - {{ vocabulary.targetLang }}</h2>
      </v-col>
    </v-row>
    <v-row v-for="word in vocabulary.words" :key="word.source">
      <v-col cols="6" offset-md="2" md="4" offset-lg="3" lg="3" class="d-flex justify-end">
        <v-btn block color="green" rounded="lg" :size="display.xs.value ? 'small' : 'x-large'">{{ word.source }}</v-btn>
      </v-col>
      <v-col cols="6" md="4" lg="3" class="d-flex justify-end">
        <v-btn block rounded="lg" color="green" :size="display.xs.value ? 'small' : 'x-large'">{{ word.target }}</v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<style scoped>
</style>
