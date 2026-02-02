<script setup lang="ts">
import { useRouter } from 'vue-router'
import { EnvironmentOutlined, PhoneOutlined, MailOutlined, ClockCircleOutlined } from '@ant-design/icons-vue'

const router = useRouter()
</script>

<template>
  <div class="static-page">
    <div class="page-container">
      <h1>联系方式</h1>
      
      <div class="contact-cards">
        <div class="contact-card">
          <PhoneOutlined class="icon" />
          <h3>客服热线</h3>
          <p class="main">400-888-9999</p>
          <p class="sub">7x24小时服务</p>
        </div>

        <div class="contact-card">
          <MailOutlined class="icon" />
          <h3>电子邮箱</h3>
          <p class="main">service@xingying.com</p>
          <p class="sub">工作日24小时内回复</p>
        </div>

        <div class="contact-card">
          <EnvironmentOutlined class="icon" />
          <h3>公司地址</h3>
          <p class="main">北京市朝阳区建国路88号</p>
          <p class="sub">SOHO现代城A座18层</p>
        </div>

        <div class="contact-card">
          <ClockCircleOutlined class="icon" />
          <h3>工作时间</h3>
          <p class="main">周一至周五 9:00-18:00</p>
          <p class="sub">法定节假日休息</p>
        </div>
      </div>

      <section class="section">
        <h2>常见问题</h2>
        <a-collapse>
          <a-collapse-panel key="1" header="如何购买电影票？">
            <p>选择您想观看的电影和场次，选择座位后完成支付即可。支付成功后会生成取票码，凭取票码到影院自助取票机取票。</p>
          </a-collapse-panel>
          <a-collapse-panel key="2" header="可以退票吗？">
            <p>电影开场前30分钟可申请退票，退票手续费为票价的10%。开场后不支持退票。</p>
          </a-collapse-panel>
          <a-collapse-panel key="3" header="取票码丢失怎么办？">
            <p>登录您的账户，在"我的订单"中可以查看取票码。如仍有问题，请联系客服。</p>
          </a-collapse-panel>
          <a-collapse-panel key="4" header="什么是陪伴观影？">
            <p>陪伴观影是我们的创新功能，单人购票时可选择玩偶陪伴或匹配同场次观众，让观影不再孤单。</p>
          </a-collapse-panel>
        </a-collapse>
      </section>

      <section class="section">
        <h2>在线留言</h2>
        <a-form layout="vertical">
          <a-row :gutter="16">
            <a-col :span="12">
              <a-form-item label="您的姓名">
                <a-input placeholder="请输入姓名" />
              </a-form-item>
            </a-col>
            <a-col :span="12">
              <a-form-item label="联系电话">
                <a-input placeholder="请输入手机号" />
              </a-form-item>
            </a-col>
          </a-row>
          <a-form-item label="留言内容">
            <a-textarea :rows="4" placeholder="请输入您的问题或建议" />
          </a-form-item>
          <a-form-item>
            <a-button type="primary">提交留言</a-button>
          </a-form-item>
        </a-form>
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

.contact-cards {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  margin-bottom: 40px;
}

.contact-card {
  text-align: center;
  padding: 24px;
  background: #f9f9f9;
  border-radius: 12px;
}

.contact-card .icon {
  font-size: 32px;
  color: var(--color-primary);
  margin-bottom: 12px;
}

.contact-card h3 {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 8px;
  color: #333;
}

.contact-card .main {
  font-size: 15px;
  color: #333;
  margin-bottom: 4px;
}

.contact-card .sub {
  font-size: 13px;
  color: #999;
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

.back-btn {
  text-align: center;
  margin-top: 32px;
}

@media (max-width: 576px) {
  .contact-cards {
    grid-template-columns: 1fr;
  }
}
</style>
