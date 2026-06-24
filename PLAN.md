# AURA — 全面审计与上线计划

## 当前状态
✅ 代码已完成：12 Vue views + Go backend + 7语言 i18n + 规则引擎
🚫 部署受阻：Railway CLI 上传超时（本机网络问题）
✅ 代码已推 GitHub：commit `5c4c7bd`

## 审计范围

## 竞品对标结果
对标 Alex and Ani / Pura Vida / Stone and Strand / Catbird / Gorjana

### 主要差距（按优先级）
**CRITICAL — 不修不能上线：**
- 后端 `/api/products/:id` 路由 — extractID 已改代码在 git，需部署
- `energy_assessments` 表缺少 `preferred_element`、`concerns`、`lifestyle` 列 → INSERT 必崩
- `CreatePaymentIntent` 是个 stub，没调 Airwallex → 下单不能支付
- Airwallex webhook 无 HMAC 签名验证 → 伪造 webhook 可入侵
- `Upload` handler 生成文件名但不保存文件到磁盘
- Railway 部署上传超时（需换网络或 Dashboard 点 Redeploy）

**P1 高优：**
- 缺失 3 个 Admin API：`GET /api/admin/products`、`GET /api/admin/elements`、`PUT /api/admin/elements/{id}`
- 产品详情无评价/评分/收藏 → 影响转化
- DIY 设计器无保存草稿/分享 → 用户流失
- 能量测评无进度条/视觉效果/结果分享 → 完成率低

**P2 中优：**
- 首页无邮件订阅、社交证明（Instagram 流）
- 购物车无快递计算器、免密支付(Apple Pay)
- Profile 缺收藏列表/历史测评查看
- Admin 无数据分析/优惠券引擎

**P3 优化：**
- 移动端适配不完善（safe area / 触控优化）
- 无骨架加载/空状态美化
- 无图片懒加载
- 缺乏物流跟踪
- [ ] 产品浏览/搜索/筛选/分页
- [ ] 产品详情（图片轮播/描述/材质/价格/加购）
- [ ] 用户注册/登录/JWT
- [ ] 购物车（增删改/数量/合计）
- [ ] 下单/支付（地址表单 + 支付网关）
- [ ] 个人中心（订单/地址/收藏/设计）
- [ ] 收藏（心形按钮 + 收藏列表）
- [ ] 多语言 7 语种

### B 层：核心差异化功能
- [ ] 手串设计器（画布/元素/串绳/保存/发布）
- [ ] 能量测评（星座/五行/关注 → 推荐手串）
- [ ] 设计师收益 2% 分成
- [ ] 社区设计展示/购买

### C 层：电商标准体验（对标淘宝/京东/独立站）
- [ ] 空状态/加载骨架/错误重试
- [ ] 搜索防抖/自动补全
- [ ] 支付安全（HTTPS/PCI/沙箱模式）
- [ ] 响应式布局（mobile-first）
- [ ] 图片懒加载/占位
- [ ] 购物车徽标实时更新
- [ ] 优惠码/运费计算器
- [ ] 订单状态追踪
- [ ] 地址管理（最多10条）
- [ ] 评价系统（星级/图文）

### D 层：视觉与品牌
- [ ] 品牌一致性（AURA 黑金主题）
- [ ] 字体体系（衬线标题/无衬线正文）
- [ ] 动效过渡（页面切换/加购/收藏）
- [ ] 无障碍（ARIA/对比度/键盘导航）
- [ ] 移动端 Safe Area / 触摸优化

### E 层：测试与品质
- [ ] 单元测试（Vitest）
- [ ] E2E 测试（Playwright）
- [ ] 性能审计（Lighthouse > 85）
- [ ] 安全审计（XSS/CSRF/SQL注入）

## 部署方法
1. 你跑: `cd /path/to/project && railway service frontend && railway up`
2. 等部署成功再跑 `railway service backend && railway up`
3. 或者 Railway Dashboard 点 Redeploy