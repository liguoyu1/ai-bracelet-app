# AURA Vue → Flutter Parity Plan

## 状态
✅ 已完成 Phases 1-9 — 所有 12 个 Vue View 已实现，构建成功，已部署 Railway
🔴 阻塞: 后端 `/api/products/:id` 路由参数取不到 (chi.URLParam 未部署成功)
🔄 当前: 修复后端部署 + 验证产品详情 + 进入 Phase 10 测试

---

### Phase 1: Home 页 ✅
- [x] Hero: 双CTA按钮 (Shop Collection + Design Yours)
- [x] Bestsellers: 水平滚动列表
- [x] Categories: 水平滚动 (Crystal/Jade/Amber/Lava)
- [x] Energy CTA 卡片 (渐变金色背景 黑底文字)

### Phase 2: Products 列表页 ✅
- [x] 搜索输入框 (圆角24) + 清除按钮
- [x] 分类筛选 (All/Crystal/Jade/Amber/Lava)
- [x] 2列网格 + hover加购覆盖层
- [x] Load More

### Phase 3: ProductDetail ✅ (前端 workaround)
- [x] 图片轮播 (prev/next + dots)
- [x] 返回/分享/收藏按钮
- [x] 评价星级 + 评价卡片
- [x] 数量选择器 (+/-)
- [x] 设计师信息区
- [x] 相关产品水平滚动
- [!] 后端 `/api/products/:id` 有 bug → 前端改调 list 接口按 ID 查找

### Phase 4: Cart ✅
- [x] 数量 +/- 控制
- [x] 删除按钮
- [x] 合计栏 + 结算按钮

### Phase 5: 结算流程 ✅
- [x] OrderScreen (收货地址表单)
- [x] OrderStatusScreen (支付成功/取消)

### Phase 6: Designer (手串设计器) ✅
- [x] 设计画布 (珠子预览 38px 彩色圆圈)
- [x] 元素网格 (3列, beads/charms/pendants/spacers)
- [x] 串绳选择 (水平滚动)
- [x] 保存/发布

### Phase 7: Energy (能量测评) ✅
- [x] 表单 (出生/星座/五行/关注/生活方式)
- [x] 结果展示 (推荐颜色/材质/水晶卡片)

### Phase 8: Profile + Admin ✅
- [x] Profile: 头像(金边圆), 编辑资料, 设计师收益, 语言选择器
- [x] Admin: 产品/元素/订单管理 CRUD

### Phase 9: 导航栏 ✅
- [x] 5个标签: Shop/Design Studio/Energy/Cart/Profile
- [x] 移除Lang独立tab, Language放在页面内

### Phase 10: 测试 & 品质 ⏳ 待开始
- [ ] 单元测试 (Vitest)
- [ ] E2E (Playwright)
- [ ] 性能 (Lighthouse)
- [ ] 样式细化对齐 Flutter
- [ ] 安全审计

## 已知问题
1. **后端 ProductHandler 用 chi.URLParam**: handlers.go 9处 `r.PathValue("id")` 已改为 `chi.URLParam(r, "id")`，但 Railway deploy 多次后旧 binary 仍在运行
2. **DB is_active**: 所有产品 is_active=false，Get handler 过滤 WHERE is_active=true 导致"product not found"
3. **Frontend workaround**: getProduct() 改为调 list 接口 ?limit=247 再按 ID 查找
4. **Railway deploy**: `railway up --service backend` 上传成功但旧容器未重启
