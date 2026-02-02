<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { dollApi } from '@/api/companion'
import { CheckOutlined } from '@ant-design/icons-vue'

interface DollType {
  id: number
  name: string
  description: string
  imageUrl: string
  price: number
  stock: number
}

const props = defineProps<{
  visible: boolean
}>()

const emit = defineEmits<{
  (e: 'update:visible', val: boolean): void
  (e: 'select', doll: DollType): void
  (e: 'skip'): void
}>()

const loading = ref(false)
const dolls = ref<DollType[]>([])
const selectedDoll = ref<DollType | null>(null)

const fetchDolls = async () => {
  loading.value = true
  try {
    const res = await dollApi.getList()
    dolls.value = res.data || []
  } catch (error) {
    console.error('获取玩偶列表失败', error)
  } finally {
    loading.value = false
  }
}

const handleSelect = (doll: DollType) => {
  selectedDoll.value = doll
}

const handleConfirm = () => {
  if (selectedDoll.value) {
    emit('select', selectedDoll.value)
    emit('update:visible', false)
  }
}

const handleSkip = () => {
  emit('skip')
  emit('update:visible', false)
}

onMounted(() => {
  fetchDolls()
})
</script>

<template>
  <a-modal
    :open="visible"
    title="🧸 选择玩偶陪伴"
    width="700px"
    :footer="null"
    @cancel="emit('update:visible', false)"
  >
    <div class="doll-selector">
      <p class="tip">选择一只可爱的玩偶，它将在你旁边的座位陪你看电影~</p>
      
      <a-spin :spinning="loading">
        <div class="doll-grid">
          <div
            v-for="doll in dolls"
            :key="doll.id"
            class="doll-card"
            :class="{ selected: selectedDoll?.id === doll.id }"
            @click="handleSelect(doll)"
          >
            <div class="doll-image">
              <img :src="doll.imageUrl" :alt="doll.name" />
              <div class="selected-badge" v-if="selectedDoll?.id === doll.id">
                <CheckOutlined />
              </div>
            </div>
            <div class="doll-info">
              <h4>{{ doll.name }}</h4>
              <p class="desc">{{ doll.description }}</p>
              <div class="price">¥{{ doll.price }}</div>
            </div>
          </div>
        </div>
      </a-spin>

      <div class="actions">
        <a-button size="large" @click="handleSkip">
          跳过，不需要陪伴
        </a-button>
        <a-button
          type="primary"
          size="large"
          :disabled="!selectedDoll"
          @click="handleConfirm"
        >
          确认选择 {{ selectedDoll ? `(+¥${selectedDoll.price})` : '' }}
        </a-button>
      </div>
    </div>
  </a-modal>
</template>

<style scoped>
.doll-selector {
  padding: 16px 0;
}

.tip {
  text-align: center;
  color: #666;
  margin-bottom: 24px;
}

.doll-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 24px;
}

.doll-card {
  border: 2px solid #f0f0f0;
  border-radius: 12px;
  padding: 12px;
  cursor: pointer;
  transition: all 0.3s;
}

.doll-card:hover {
  border-color: var(--color-primary);
  box-shadow: 0 4px 12px rgba(214, 51, 132, 0.15);
}

.doll-card.selected {
  border-color: var(--color-primary);
  background: #fff0f6;
}

.doll-image {
  position: relative;
  aspect-ratio: 1;
  border-radius: 8px;
  overflow: hidden;
  margin-bottom: 12px;
}

.doll-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.selected-badge {
  position: absolute;
  top: 8px;
  right: 8px;
  width: 24px;
  height: 24px;
  background: var(--color-primary);
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.doll-info h4 {
  font-size: 14px;
  margin-bottom: 4px;
}

.doll-info .desc {
  font-size: 12px;
  color: #999;
  margin-bottom: 8px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.doll-info .price {
  font-size: 16px;
  font-weight: 700;
  color: var(--color-primary);
}

.actions {
  display: flex;
  justify-content: center;
  gap: 16px;
}

@media (max-width: 768px) {
  .doll-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style>
