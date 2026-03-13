<script setup>
import { ref, onMounted } from 'vue'
import { useDisplay } from 'vuetify'

const display = useDisplay()

const props = defineProps({
  jsonUrl: String,
  maxCount: Number,
})

class WordPair {
  constructor(source, target) {
    this.source = source;
    this.target = target;
  }
  getSource() { return this.source }
  getTarget()  { return this.target }
}

class Dictionary {
  constructor(sourceLang, targetLang, wordPairs) {
    if (new.target === Dictionary) {
      throw new Error("Dictionary is abstract and cannot be instantiated directly");
    }
    this.sourceLang = sourceLang
    this.targetLang = targetLang
    this.wordPairs = wordPairs
  }
  size() {
    return this.wordPairs.length
  }
  isEmpty() {
    return this.size() == 0
  }
  popRandomWordPair() {
    if (this.isEmpty()) {
      return null
    }
    const randomIndex = Math.floor(Math.random() * this.wordPairs.length)
    const wordPair = this.wordPairs[randomIndex]
    this.wordPairs.splice(randomIndex, 1)
    return wordPair
  }
}

class JsonDictionary extends Dictionary {
  static async create(url) {
    const response = await fetch(url);
    const json = await response.json();
    const wordPairs = json.words.map(w => new WordPair(w.source, w.target));
    return new JsonDictionary(json.sourceLang, json.targetLang, wordPairs);
  }
}

const dictionary = ref(null)
const count = ref(null)
const activeWords = ref([])
const activeSource = ref(null)
const activeTarget = ref(null)

const mapping = ref(new Map())

onMounted(async () => {
  dictionary.value = await JsonDictionary.create(props.jsonUrl)

  count.value = Math.min(props.maxCount, dictionary.value.size())
  initActiveWords(count.value)
  for (let i = 0; i < count.value; i++) {
    showNextWord()
  }
})

function initActiveWords(count) {
  for (let i = 0; i < count; i++) {
    mapping.value.set(i, (i + 2) % count)
    activeWords.value.push({
      index: i,
      sourceRef: null,
      sourceActive: false,
      targetRef: null,
      targetActive: false,
    })
  }
}

function showNextWord() {
  if (!dictionary.value.isEmpty()) {
    const wordPair = dictionary.value.popRandomWordPair();

    for (let i = 0; i < activeWords.value.length; i++) {
      if (activeWords.value[i].sourceRef == null) {
        activeWords.value[i].sourceRef = wordPair.source
        activeWords.value[mapping.value.get(i)].targetRef = wordPair.target
        break;
      }
    }
  }
}

function onSourceClick(activeWord) {
  activeWord.sourceActive = !activeWord.sourceActive
  for (let i = 0; i < count.value; i++) {
    if (i != activeWord.index) {
      activeWords.value[i].sourceActive = false
    }
  }
  if (activeWord.sourceActive) {
    activeSource.value = activeWord.index
  } else {
    activeSource.value = null
  }
  checkPair(activeWord, null)
}

function onTargetClick(activeWord) {
  activeWord.targetActive = !activeWord.targetActive
  for (let i = 0; i < count.value; i++) {
    if (i != activeWord.index) {
      activeWords.value[i].targetActive = false
    }
  }
  if (activeWord.targetActive) {
    activeTarget.value = activeWord.index
  } else {
    activeTarget.value = null
  }
  checkPair(null, activeWord)
}

function checkPair(activeSourceWord, activeTargetWord) {
  if (activeSourceWord == null && activeSource.value != null) {
    activeSourceWord = activeWords.value[activeSource.value]
  }
  if (activeTargetWord == null && activeTarget.value != null) {
    activeTargetWord = activeWords.value[activeTarget.value]
  }
  if (activeSource.value == null || activeTarget.value == null) {
    return
  }
  if (mapping.value.get(activeSource.value) == activeTarget.value) {
    onMatch(activeSourceWord, activeTargetWord)
  } else {
    onNoMatch(activeSourceWord, activeTargetWord)
  }
}

function onMatch(activeSourceWord, activeTargetWord) {
  activeSource.value = null
  activeSourceWord.sourceActive = false
  activeSourceWord.sourceRef = null
  activeTarget.value = null
  activeTargetWord.targetActive = false
  activeTargetWord.targetRef = null
  showNextWord()
}

function onNoMatch(activeSourceWord, activeTargetWord) {
  activeSource.value = null
  activeSourceWord.sourceActive = false
  activeTarget.value = null
  activeTargetWord.targetActive = false
}
</script>

<template>
  <v-container fluid>
    <v-row>
      <v-col cols="12" class="text-center">
        <h1>{{ dictionary.sourceLang }} - {{ dictionary.targetLang }}</h1>
      </v-col>
    </v-row>
    <v-row v-for="activeWord in activeWords">
      <v-col cols="6" offset-md="2" md="4" offset-lg="3" lg="3" class="d-flex justify-end">
        <v-btn block :color="activeWord.sourceActive ? 'green' : 'blue'" rounded="lg" :size="display.xs.value ? 'small' : 'x-large'" @click="onSourceClick(activeWord)">{{ activeWord.sourceRef }}</v-btn>
      </v-col>
      <v-col cols="6" md="4" lg="3" class="d-flex justify-end">
        <v-btn block rounded="lg" :color="activeWord.targetActive ? 'green' : 'blue'" :size="display.xs.value ? 'small' : 'x-large'" @click="onTargetClick(activeWord)">{{ activeWord.targetRef }}</v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<style scoped>
</style>
