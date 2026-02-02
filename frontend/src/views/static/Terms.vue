<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()
</script>

<template>
  <div class="static-page">
    <div class="page-container">
      <h1>用户服务协议</h1>
      <p class="update-time">更新日期：2026年1月1日</p>
      
      <section class="section">
        <h2>一、服务条款的确认与接受</h2>
        <p>1.1 本协议是用户（以下简称"您"）与星影票务平台（以下简称"本平台"）之间关于使用本平台服务所订立的协议。</p>
        <p>1.2 您在使用本平台服务前，应仔细阅读本协议全部内容。如您对本协议有任何疑问，可向本平台客服咨询。</p>
        <p>1.3 当您按照注册页面提示填写信息、阅读并同意本协议且完成全部注册程序后，即表示您已充分阅读、理解并接受本协议的全部内容。</p>
      </section>

      <section class="section">
        <h2>二、账户注册与管理</h2>
        <p>2.1 您确认，在您完成注册程序或以其他本平台允许的方式实际使用本平台服务时，您应当是具备完全民事权利能力和完全民事行为能力的自然人。</p>
        <p>2.2 您有义务保证注册信息的真实性、准确性和完整性，并对因信息不真实或不准确而产生的任何后果承担相应责任。</p>
        <p>2.3 您有责任妥善保管账户信息及账户密码的安全，您需要对账户下的行为承担法律责任。</p>
        <p>2.4 如发现任何未经授权使用您账户的情况，您应立即通知本平台。</p>
      </section>

      <section class="section">
        <h2>三、服务内容</h2>
        <p>3.1 本平台为您提供电影票在线预订服务，包括但不限于影片信息查询、场次选择、座位预订、在线支付、取票码生成等。</p>
        <p>3.2 本平台有权根据业务发展需要，调整服务内容或终止部分服务。</p>
        <p>3.3 本平台所提供的影片信息、场次安排、票价等均以影院实际公布为准。</p>
      </section>

      <section class="section">
        <h2>四、购票与退票规则</h2>
        <p>4.1 用户在本平台成功支付后即完成购票，系统将生成取票码。</p>
        <p>4.2 退票规则：电影开场前30分钟可申请退票，退票将收取票价10%的手续费；开场后不支持退票。</p>
        <p>4.3 特殊情况（如影院临时取消场次）的退票，本平台将全额退款。</p>
        <p>4.4 退款将原路返回至您的支付账户，到账时间视支付渠道而定，一般为1-7个工作日。</p>
      </section>

      <section class="section">
        <h2>五、用户行为规范</h2>
        <p>5.1 您在使用本平台服务时，应遵守中华人民共和国相关法律法规。</p>
        <p>5.2 您不得利用本平台从事以下行为：</p>
        <ul>
          <li>发布、传送、传播违法违规内容</li>
          <li>侵犯他人知识产权或其他合法权益</li>
          <li>恶意注册账户、批量购票等扰乱平台正常运营的行为</li>
          <li>利用技术手段攻击、干扰平台系统</li>
        </ul>
      </section>

      <section class="section">
        <h2>六、知识产权</h2>
        <p>6.1 本平台的所有内容，包括但不限于文字、图片、软件、音频、视频等，均受著作权法等法律保护。</p>
        <p>6.2 未经本平台书面许可，任何人不得擅自使用、复制、修改、传播本平台的任何内容。</p>
      </section>

      <section class="section">
        <h2>七、免责声明</h2>
        <p>7.1 因不可抗力导致的服务中断或数据丢失，本平台不承担责任。</p>
        <p>7.2 本平台不对影院的服务质量承担责任。</p>
        <p>7.3 因用户自身原因（如密码泄露、设备丢失等）导致的损失，由用户自行承担。</p>
      </section>

      <section class="section">
        <h2>八、协议修改</h2>
        <p>8.1 本平台有权根据需要修改本协议，修改后的协议将在平台公布。</p>
        <p>8.2 如您不同意修改后的协议，有权停止使用本平台服务。</p>
        <p>8.3 如您继续使用本平台服务，则视为接受修改后的协议。</p>
      </section>

      <section class="section">
        <h2>九、法律适用与争议解决</h2>
        <p>9.1 本协议的订立、执行和解释及争议的解决均应适用中华人民共和国法律。</p>
        <p>9.2 因本协议引起的或与本协议有关的任何争议，双方应友好协商解决；协商不成的，任何一方均可向本平台所在地有管辖权的人民法院提起诉讼。</p>
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
  margin-bottom: 32px;
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
}

.back-btn {
  text-align: center;
  margin-top: 32px;
}
</style>
