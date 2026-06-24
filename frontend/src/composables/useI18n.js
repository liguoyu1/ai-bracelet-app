import { ref, onMounted, onUnmounted } from 'vue'
import { tr, getLang, setLang, onLangChange, locales, flags, names } from '../i18n'

const lang = ref(getLang())

export function useI18n() {
  let unsub
  onMounted(() => { unsub = onLangChange(() => { lang.value = getLang() }) })
  onUnmounted(() => { unsub?.() })

  function t(key) { return tr(key, lang.value) }
  function setLanguage(l) { setLang(l) }

  return { t, lang, setLanguage, locales, flags, names }
}
