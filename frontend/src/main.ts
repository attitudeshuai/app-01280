import { createApp } from 'vue'
import { createPinia } from 'pinia'
import Antd from 'ant-design-vue'
import App from './App.vue'
import router from './router'

// 样式
import 'ant-design-vue/dist/reset.css'
import './styles/global.css'

const app = createApp(App)

// 使用 Pinia 状态管理
app.use(createPinia())

// 使用 Vue Router
app.use(router)

// 使用 Ant Design Vue
app.use(Antd)

// 挂载应用
app.mount('#app')
