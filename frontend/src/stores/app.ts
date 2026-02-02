import { defineStore } from 'pinia'
import { ref } from 'vue'

/**
 * 应用全局状态
 */
export const useAppStore = defineStore('app', () => {
  // 深色模式
  const darkMode = ref(false)
  
  // 当前城市
  const currentCity = ref('北京')
  
  // 全局加载状态
  const loading = ref(false)

  // 切换深色模式
  const toggleDarkMode = () => {
    darkMode.value = !darkMode.value
    document.documentElement.setAttribute(
      'data-theme',
      darkMode.value ? 'dark' : 'light'
    )
  }

  // 设置当前城市
  const setCity = (city: string) => {
    currentCity.value = city
  }

  // 设置加载状态
  const setLoading = (status: boolean) => {
    loading.value = status
  }

  return {
    darkMode,
    currentCity,
    loading,
    toggleDarkMode,
    setCity,
    setLoading
  }
})
