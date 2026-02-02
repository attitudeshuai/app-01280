<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()
</script>

<template>
  <div class="static-page">
    <div class="page-container">
      <h1>关于我们</h1>
      
      <section class="section">
        <h2>公司简介</h2>
        <p>
          星影票务是国内领先的在线电影票务服务平台，致力于为广大影迷提供便捷、优质的购票体验。
          自2020年成立以来，我们已与全国超过5000家影院建立合作关系，服务用户超过3000万。
        </p>
      </section>

      <section class="section">
        <h2>我们的使命</h2>
        <p>
          让每一次观影都成为美好回忆。我们通过技术创新，不断优化选座体验、支付流程和取票服务，
          让用户能够轻松享受电影带来的乐趣。
        </p>
      </section>

      <section class="section">
        <h2>核心优势</h2>
        <ul>
          <li><strong>覆盖广泛</strong> - 合作影院遍布全国300+城市</li>
          <li><strong>实时座位</strong> - 座位信息实时同步，选座更精准</li>
          <li><strong>便捷取票</strong> - 电子取票码，到店即取即看</li>
          <li><strong>贴心服务</strong> - 7x24小时客服支持</li>
          <li><strong>创新体验</strong> - 独创陪伴观影功能，让观影不孤单</li>
        </ul>
      </section>

      <section class="section">
        <h2>发展历程</h2>
        <div class="timeline">
          <div class="timeline-item">
            <span class="year">2020</span>
            <span class="event">公司成立，上线首个版本</span>
          </div>
          <div class="timeline-item">
            <span class="year">2021</span>
            <span class="event">用户突破500万，合作影院超过1000家</span>
          </div>
          <div class="timeline-item">
            <span class="year">2022</span>
            <span class="event">推出陪伴观影功能，获得行业创新奖</span>
          </div>
          <div class="timeline-item">
            <span class="year">2023</span>
            <span class="event">完成B轮融资，估值超过10亿元</span>
          </div>
          <div class="timeline-item">
            <span class="year">2024</span>
            <span class="event">用户突破3000万，成为行业领军平台</span>
          </div>
        </div>
      </section>

      <div class="back-btn">
        <a-button type="link" @click="router.back()">← 返回</a-button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.static-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding: 40px 20px;
}

.page-container {
  max-width: 800px;
  margin: 0 auto;
  background: white;
  border-radius: 12px;
  padding: 40px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

h1 {
  font-size: 28px;
  font-weight: 600;
  margin-bottom: 32px;
  text-align: center;
  color: #333;
}

.section {
  margin-bottom: 32px;
}

.section h2 {
  font-size: 20px;
  font-weight: 600;
  margin-bottom: 16px;
  color: #333;
  border-left: 4px solid var(--color-primary);
  padding-left: 12px;
}

.section p {
  line-height: 1.8;
  color: #666;
}

.section ul {
  padding-left: 20px;
}

.section li {
  line-height: 2;
  color: #666;
}

.timeline {
  position: relative;
  padding-left: 30px;
}

.timeline::before {
  content: '';
  position: absolute;
  left: 8px;
  top: 0;
  bottom: 0;
  width: 2px;
  background: #e8e8e8;
}

.timeline-item {
  position: relative;
  padding-bottom: 20px;
}

.timeline-item::before {
  content: '';
  position: absolute;
  left: -26px;
  top: 6px;
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: var(--color-primary);
}

.timeline-item .year {
  font-weight: 600;
  color: var(--color-primary);
  margin-right: 12px;
}

.timeline-item .event {
  color: #666;
}

.back-btn {
  text-align: center;
  margin-top: 32px;
}
</style>
