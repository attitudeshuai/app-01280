<script setup lang="ts">
import { ConfigProvider, theme } from 'ant-design-vue'
import zhCN from 'ant-design-vue/es/locale/zh_CN'
import { useAppStore } from '@/stores/app'

const appStore = useAppStore()

// 主题配置 (参考 DesignSpec.md)
const themeConfig = {
  token: {
    colorPrimary: '#d63384',
    colorSuccess: '#198754',
    colorWarning: '#ffc107',
    colorError: '#dc3545',
    colorInfo: '#0dcaf0',
    borderRadius: 8,
    fontSize: 16,
  },
  algorithm: appStore.darkMode ? theme.darkAlgorithm : theme.defaultAlgorithm,
}
</script>

<template>
  <ConfigProvider :locale="zhCN" :theme="themeConfig">
    <RouterView />
  </ConfigProvider>
</template>

<style>
#app {
  min-height: 100vh;
}
</style>
