# AURA — 全面审计与上线清单

## 当前状态 (2026-06-24)
✅ 代码：12 Vue views + Go backend + 7语言 i18n + 能量规则引擎
🚫 部署：Railway CLI 本机上传超时（需换网络或 Dashboard）
✅ Git commit `5c4c7bd` + `6e57c28` — 代码已就绪

---

## CRITICAL — 不修不能上线

### 后端
- [ ] ~~`/api/products/:id` 路由~~ → **✅ extractID 已修，需部署生效**
- [ ] ~~Energy handler 写入不存在的DB列~~ → **✅ 改用已有列，编译通过**
- [ ] **Upload handler — 生成文件名但不保存文件** — 需修复（代码未改）
- [ ] **CreatePaymentIntent — stub，不调 Airwallex** — 需修复（代码未改）
- [ ] **Airwallex webhook — 无 HMAC 签名验证** — 需修复（代码未改）

### 前端
- [ ] ~~getProduct workaround bug~~ → **✅ res.data→res.data?.data 已修**
- [x] Designer 底部按钮被 tab 挡住 → **fixed**
- [x] Profile 缺少购物车/收藏/地址管理 → **fixed（已加收藏、地址管理）**
- [ ] **商品点击不进详情页** → 部署后生效（getProduct 修了 + extractID 修了）

---

## P1 高优 — 上线后尽快补

### 后端
- [ ] `GET /api/admin/products` — Admin 商品列表
- [ ] `GET /api/admin/elements` — Admin 元素列表
- [ ] `PUT /api/admin/elements/{id}` — Admin 元素编辑

### 前端（对比 Flutter）
- [ ] **产品详情评论未对接 API**（Flutter 硬编码，Vue 需要接）
- [ ] **产品详情相关产品未对接 API**（Flutter 硬编码）
- [ ] **Login 页无密码可见性切换**
- [ ] **Energy 字段名对齐**：energy_focus vs energyFocus
- [ ] **Products 页无 Snackbar 加购反馈**
- [ ] **Products 页无图片加载骨架屏**
- [ ] **Flutter 的社区设计版块在 Vue 缺失**

---

## P2 中优 — 体验提升

- [ ] 购物车标签页展示商品数量徽标
- [ ] Cart 页图片加载失败回退
- [ ] Order 更细粒度错误处理
- [ ] Home 分类 onTap 导航到 /products?cat=...
- [ ] 5-tab 导航图标改用 Material 图标
- [ ] 管理员元素/商品编辑完整 CRUD

---

## P3 低优 — 后续迭代

- [ ] 移动端 Safe Area / 触控优化
- [ ] 骨架加载/空状态美化
- [ ] 图片懒加载
- [ ] 邮件订阅（首页）
- [ ] 社交证明（Instagram 流）
- [ ] 快递计算器、免密支付（Apple Pay）
- [ ] Admin 数据分析
- [ ] 评价系统（星级+图文）

---

## 竞品对标差距

对标 Alex and Ani / Pura Vida / Stone and Strand:
- 关键缺失：社交证明（Instagram）、邮件订阅、快递计算、免密支付
- 功能超越：手串设计器（竞品没这个）、能量测评
- 持平：基础电商流程、购物车、订单

---

## 部署方法
1. 本机跑: `railway service backend && railway up` 或 `railway service frontend && railway up`
2. 或 Railway Dashboard → 项目 → Redeploy（选最新 commit）
