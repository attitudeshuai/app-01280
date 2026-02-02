<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()
</script>

<template>
  <div class="static-page">
    <div class="page-container">
      <h1>隐私政策</h1>
      <p class="update-time">更新日期：2026年1月1日</p>
      
      <div class="intro">
        <p>星影票务（以下简称"我们"）非常重视用户的隐私保护。本隐私政策说明了我们如何收集、使用、存储和保护您的个人信息。请您仔细阅读本政策，如您对本政策有任何疑问，可通过客服渠道与我们联系。</p>
      </div>

      <section class="section">
        <h2>一、我们收集的信息</h2>
        <h3>1.1 您主动提供的信息</h3>
        <ul>
          <li><strong>账户信息</strong>：手机号码、电子邮箱、昵称、头像等</li>
          <li><strong>订单信息</strong>：购票记录、支付信息等</li>
          <li><strong>反馈信息</strong>：您向我们提交的建议、投诉等</li>
        </ul>
        
        <h3>1.2 我们自动收集的信息</h3>
        <ul>
          <li><strong>设备信息</strong>：设备型号、操作系统版本、唯一设备标识符等</li>
          <li><strong>日志信息</strong>：访问时间、浏览记录、IP地址等</li>
          <li><strong>位置信息</strong>：用于为您推荐附近影院（需您授权）</li>
        </ul>
      </section>

      <section class="section">
        <h2>二、我们如何使用您的信息</h2>
        <p>我们收集的信息将用于以下目的：</p>
        <ul>
          <li>提供电影票预订服务，包括处理订单、生成取票码等</li>
          <li>验证您的身份，保障账户安全</li>
          <li>向您推送订单状态通知、优惠活动等信息</li>
          <li>改进和优化我们的产品和服务</li>
          <li>进行数据分析和研究，提升用户体验</li>
          <li>预防和打击欺诈行为</li>
          <li>遵守法律法规要求</li>
        </ul>
      </section>

      <section class="section">
        <h2>三、信息共享与披露</h2>
        <p>我们承诺不会将您的个人信息出售给任何第三方。但在以下情况下，我们可能会共享您的信息：</p>
        <ul>
          <li><strong>服务提供商</strong>：为完成订单，我们需要与影院、支付机构等合作伙伴共享必要信息</li>
          <li><strong>关联公司</strong>：为提供更好的服务，我们可能与关联公司共享信息</li>
          <li><strong>法律要求</strong>：应政府机关、司法机构的合法要求披露信息</li>
          <li><strong>保护权益</strong>：为保护用户或公众的人身财产安全</li>
        </ul>
      </section>

      <section class="section">
        <h2>四、信息存储与保护</h2>
        <p>4.1 <strong>存储地点</strong>：您的个人信息存储于中华人民共和国境内的服务器。</p>
        <p>4.2 <strong>存储期限</strong>：我们仅在为您提供服务所必需的期限内保留您的信息。账户注销后，我们将在合理期限内删除您的个人信息。</p>
        <p>4.3 <strong>安全措施</strong>：我们采用业界标准的安全技术保护您的信息，包括：</p>
        <ul>
          <li>数据传输加密（SSL/TLS）</li>
          <li>敏感信息加密存储</li>
          <li>访问权限控制</li>
          <li>安全审计与监控</li>
        </ul>
      </section>

      <section class="section">
        <h2>五、您的权利</h2>
        <p>根据相关法律法规，您对自己的个人信息享有以下权利：</p>
        <ul>
          <li><strong>访问权</strong>：您可以查看您的账户信息和订单记录</li>
          <li><strong>更正权</strong>：您可以修改您的账户信息</li>
          <li><strong>删除权</strong>：您可以申请删除您的账户和相关信息</li>
          <li><strong>撤回同意</strong>：您可以撤回此前给予的授权同意</li>
          <li><strong>注销账户</strong>：您可以申请注销账户</li>
        </ul>
        <p>如需行使上述权利，请联系我们的客服。</p>
      </section>

      <section class="section">
        <h2>六、Cookie 使用</h2>
        <p>我们使用 Cookie 和类似技术来改善您的使用体验，包括：</p>
        <ul>
          <li>记住您的登录状态</li>
          <li>分析网站访问数据</li>
          <li>提供个性化服务</li>
        </ul>
        <p>您可以通过浏览器设置管理 Cookie，但禁用 Cookie 可能影响部分功能的使用。</p>
      </section>

      <section class="section">
        <h2>七、未成年人保护</h2>
        <p>我们非常重视对未成年人个人信息的保护。如果您是未满18周岁的未成年人，请在监护人的陪同下阅读本政策，并在监护人明确同意后使用我们的服务。</p>
      </section>

      <section class="section">
        <h2>八、隐私政策的更新</h2>
        <p>我们可能会适时修订本隐私政策。当政策发生重大变更时，我们会在平台上发布通知。您继续使用我们的服务即表示接受更新后的政策。</p>
      </section>

      <section class="section">
        <h2>九、联系我们</h2>
        <p>如您对本隐私政策有任何疑问或建议，可通过以下方式联系我们：</p>
        <ul>
          <li>客服热线：400-888-9999</li>
          <li>电子邮箱：privacy@xingying.com</li>
          <li>公司地址：北京市朝阳区建国路88号 SOHO现代城A座18层</li>
        </ul>
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
  margin-bottom: 8px;
  text-align: center;
  color: #333;
}

.update-time {
  text-align: center;
  color: #999;
  margin-bottom: 24px;
}

.intro {
  background: #f9f9f9;
  padding: 16px;
  border-radius: 8px;
  margin-bottom: 28px;
}

.intro p {
  color: #666;
  line-height: 1.8;
  margin: 0;
}

.section {
  margin-bottom: 28px;
}

.section h2 {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 12px;
  color: #333;
}

.section h3 {
  font-size: 15px;
  font-weight: 600;
  margin: 12px 0 8px;
  color: #555;
}

.section p {
  line-height: 1.8;
  color: #666;
  margin-bottom: 8px;
}

.section ul {
  padding-left: 20px;
  margin-top: 8px;
}

.section li {
  line-height: 1.8;
  color: #666;
  margin-bottom: 4px;
}

.back-btn {
  text-align: center;
  margin-top: 32px;
}
</style>
