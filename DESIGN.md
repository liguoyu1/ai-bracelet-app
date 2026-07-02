# AURA 手串电商平台 — 功能模块设计

> 版本: 2026-07-02
> 目标: 海外用户手串 DIY 设计、发布、售卖、收益分成的全链路电商平台

---

## 一、系统架构总览

```
┌─────────────────────────────────────────────────────┐
│ 用户浏览器 (Vue 3 SPA)                               │
│  ┌───────────┬───────────┬───────────┬───────────┐  │
│  │ 5-tab 导航  │ router-view │ Pinia 状态 │ Axios API │  │
│  └───────────┴───────────┴───────────┴───────────┘  │
└──────────────────┬──────────────────────────────────┘
                   │ /api/*
                   ▼
┌──────────────────────────────────────────────────────┐
│ nginx (Railway frontend 服务)                         │
│  - /*            →  /usr/share/nginx/html (SPA 静态文件)│
│  - /api/*        →  proxy_pass backend.railway.internal│
└──────────────────┬───────────────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────────┐
│ Go/chi API (Railway backend 服务)                     │
│  ┌─────────┬──────────┬──────────┬────────────────┐  │
│  │ handlers │ services │ database │ middleware      │  │
│  │ 34 端点   │ Airwallex│ pgx 连接池│ JWT/CORS/Admin  │  │
│  │ i18n     │ DeepSeek │ 迁移引擎 │                 │  │
│  └─────────┴──────────┴──────────┴────────────────┘  │
└──────────────────┬───────────────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────────┐
│ PostgreSQL (Railway 托管)                             │
│ 8 表: users / products / design_elements /           │
│ user_designs / orders / order_items / favorites /    │
│ energy_assessments / designer_earnings / uploads     │
└──────────────────────────────────────────────────────┘
```

---

## 二、数据模型（10 表）

### 2.1 `users` — 用户
| 字段 | 类型 | 说明 |
|------|------|------|
| id | UUID PK | 自动生成 |
| email | VARCHAR UNIQUE | 登录邮箱 |
| password_hash | VARCHAR | bcrypt |
| display_name | VARCHAR | 显示名 |
| avatar_url | TEXT | 头像 |
| bio | TEXT | 个人简介 |
| role | VARCHAR | `user` / `designer` / `admin` |
| created_at / updated_at | TIMESTAMPTZ | |

### 2.2 `products` — 平台成品
| 字段 | 类型 | 说明 |
|------|------|------|
| id | UUID PK | |
| name / slug / description | VARCHAR/TEXT | slug 唯一 |
| price_cents | INT | 价格（分），>0 |
| images | TEXT[] | 图片 URL 数组 |
| category | VARCHAR | 分类 |
| tags | TEXT[] | 标签 |
| materials | JSONB | 材质结构 |
| stock | INT | 库存，>=0 |
| is_active | BOOL | 上下架 |
| sales_count | INT | 销量 |
| i18n | JSONB | 多语言覆盖 |

### 2.3 `design_elements` — 设计元素（珠子/挂件/串绳）
| 字段 | 类型 | 说明 |
|------|------|------|
| id | UUID PK | |
| name | VARCHAR | |
| type | VARCHAR(50) | `bead`/`charm`/`pendant`/`string`/`spacer`/`clasp` |
| color / material / shape | VARCHAR | 外观属性 |
| size_mm | DECIMAL(5,1) | 尺寸 |
| image_url | TEXT | 图片 |
| price_cents | INT | 单价 |
| stock | INT | 库存 |
| is_active | BOOL | 上下架 |
| i18n | JSONB | 多语言 |

### 2.4 `user_designs` — 用户设计
| 字段 | 类型 | 说明 |
|------|------|------|
| id | UUID PK | |
| user_id | UUID FK→users | 设计师 |
| name / description | VARCHAR/TEXT | |
| design_data | JSONB | 设计配置 `{elements:[], layout:{}}` |
| preview_images | TEXT[] | 预览图 |
| price_cents | INT | 售价 |
| is_published | BOOL | 发布状态 |
| sales_count | INT | 销量 |
| total_earnings_cents | INT | 累计收益 |

### 2.5 `orders` — 订单
| 字段 | 类型 | 说明 |
|------|------|------|
| id | UUID PK | |
| user_id | UUID FK | 买家 |
| total_cents | INT | 总价 |
| status | VARCHAR | `pending`→`paid`→`processing`→`shipped`→`delivered` |
| stripe_payment_intent_id | TEXT | Airwallex 支付 ID（命名未完整重命名） |
| shipping_address | TEXT | 收货地址 JSON |
| contact_email | TEXT | |
| notes | TEXT | 备注 |

### 2.6 `order_items` — 订单项
| 字段 | 类型 | 说明 |
|------|------|------|
| id | UUID PK | |
| order_id | UUID FK→orders | |
| item_type | VARCHAR | `product` / `user_design` |
| item_id | UUID | 产品或设计 ID |
| design_snapshot | TEXT | 设计快照（下单时的设计 json） |
| quantity / unit_price_cents / total_cents | INT | |
| designer_id | UUID FK nullable | 设计师 |
| designer_commission_cents | INT | 佣金（2%） |

### 2.7 `favorites` — 收藏
| 字段 | 类型 | 说明 |
|------|------|------|
| id | UUID PK | |
| user_id | UUID FK | |
| item_type | VARCHAR | `product` / `user_design` |
| item_id | UUID | |
| created_at | TIMESTAMPTZ | |

### 2.8 `energy_assessments` — 能量测评
| 字段 | 类型 | 说明 |
|------|------|------|
| id | UUID PK | |
| user_id | UUID FK | |
| birth_date / zodiac_sign / chinese_zodiac / five_elements / personality_traits / preferences | VARCHAR | 用户输入 |
| raw_input | TEXT | 原始问询 |
| ai_response | TEXT | DeepSeek 增强（异步） |
| recommendations | TEXT | 规则引擎结果 |

### 2.9 `designer_earnings` — 设计师收益
| 字段 | 类型 | 说明 |
|------|------|------|
| id | UUID PK | |
| designer_id | UUID FK | 设计师 |
| order_item_id | UUID FK | 来源订单项 |
| amount_cents | INT | 佣金金额 |
| status | VARCHAR | `pending`→`paid` |
| paid_at / created_at | TIMESTAMPTZ | |

### 2.10 `uploads` — 文件上传
| 字段 | 类型 | 说明 |
|------|------|------|
| id | UUID PK | |
| user_id | UUID FK | 上传者 |
| filename / url | TEXT | 文件名和访问路径 |
| size_bytes / mime_type | BIGINT/TEXT | |
| created_at | TIMESTAMPTZ | |

---

## 三、API 端点（34 条路由）

### 3.1 公开（无需认证）

| 方法 | 路径 | 用途 | 状态 |
|------|------|------|------|
| GET | `/api/health` | 健康检查 | ✅ |
| GET | `/api/config` | 前端配置 | ✅ |
| POST | `/api/auth/register` | 注册 | ✅ |
| POST | `/api/auth/login` | 登录 | ✅ |
| GET | `/api/products` | 产品列表（分页+筛选+i18n） | ✅ |
| GET | `/api/products/{id}` | 产品详情 | ✅ |
| GET | `/api/elements` | 设计元素列表 | ✅ |
| GET | `/api/designs` | 公开设计列表 | ✅ |
| GET | `/api/designs/{id}` | 公开设计详情 | ✅ |
| POST | `/api/webhook/airwallex` | Airwallex 支付回调 | ✅ |
| GET | `/uploads/{path}` | 静态文件访问 | ✅ |

### 3.2 需认证（JWT Bearer）

| 方法 | 路径 | 用途 | 状态 |
|------|------|------|------|
| GET | `/api/auth/me` | 个人信息 | ✅ |
| PUT | `/api/auth/me` | 更新资料 | ✅ |
| GET | `/api/designs/mine` | 我的设计 | ✅ |
| POST | `/api/designs` | 创建设计 | ✅ |
| PUT | `/api/designs/{id}` | 更新设计 | ✅ |
| POST | `/api/designs/{id}/publish` | 发布设计 | ✅ |
| POST | `/api/orders` | 创建订单 | ✅ |
| GET | `/api/orders` | 订单列表 | ✅ |
| GET | `/api/orders/{id}` | 订单详情 | ✅ |
| POST | `/api/orders/{id}/payment-intent` | 创建支付 | ✅ |
| GET | `/api/favorites` | 收藏列表 | ✅ |
| POST | `/api/favorites/toggle` | 切换收藏 | ✅ |
| POST | `/api/energy/assess` | 能量评估 | ✅ |
| GET | `/api/energy/history` | 评估历史 | ✅ |
| GET | `/api/energy/{id}` | 评估详情 | ✅ |
| GET | `/api/earnings` | 收益摘要 | ✅ |
| GET | `/api/earnings/history` | 收益明细 | ✅ |
| POST | `/api/upload` | 文件上传 | ✅ |

### 3.3 管理员（`role=admin`）

| 方法 | 路径 | 用途 | 状态 |
|------|------|------|------|
| GET | `/api/admin/products` | 管理产品列表 | ✅ 新加 |
| POST | `/api/admin/products` | 创建产品 | ✅ |
| PUT | `/api/admin/products/{id}` | 更新产品 | ✅ |
| GET | `/api/admin/elements` | 管理元素列表 | ✅ 新加 |
| POST | `/api/admin/elements` | 创建元素 | ✅ |
| PUT | `/api/admin/elements/{id}` | 更新元素 | ✅ 新加 |
| PUT | `/api/admin/orders/{id}/status` | 更新订单状态 | ✅ |

### 3.4 临时/调试路由
| 方法 | 路径 | 用途 | 状态 |
|------|------|------|------|
| POST | `/api/migrate-i18n` | i18n 数据迁移 | ⚠️ 应移除 |
| GET | `/api/debug-i18n` | 调试 i18n | ⚠️ 应移除 |

---

## 四、前端页面（13 个视图）

### 4.1 路由表

| 路径 | 视图 | 说明 | 状态 |
|------|------|------|------|
| `/` | Home.vue | 首页：Hero + 热销 + 分类 + 能量 CTA | ✅ |
| `/products` | Products.vue | 产品列表：搜索/筛选/分页 | ✅ |
| `/products/:id` | ProductDetail.vue | 产品详情：图片/描述/加购 | ✅ |
| `/login` | Login.vue | 登录/注册切换 | ✅ |
| `/cart` | Cart.vue | 购物车：数量/删除/结算 | ✅ |
| `/profile` | Profile.vue | 个人中心：订单/设计/收益/收藏/地址/语言/管理入口 | ✅ |
| `/designer` | Designer.vue | 设计工作室：DIY 手串 + 发布 | ✅[^1] |
| `/energy` | Energy.vue | 能量测评：表单/结果 | ✅ |
| `/order` | Order.vue | 下单：地址/确认/跳转支付 | ✅ |
| `/order-status` | OrderStatus.vue | 支付结果页 | ✅ |
| `/admin` | Admin.vue | 管理面板：产品CRUD/元素CRUD/订单管理 | ✅ |
| `/terms` | Terms.vue | 服务条款/版权协议 | ✅ 新加 |

[^1]: 发布时含版权确认弹窗 checkbox + Terms 链接

### 4.2 状态管理（3 个 Pinia Store）

| Store | 字段 | 说明 |
|-------|------|------|
| `auth` | token, user, isLoggedIn | 认证状态，localStorage 持久化 |
| `cart` | items, itemCount, total | 购物车，localStorage 持久化 |
| `favorites` | ids | 收藏，localStorage（不与后端同步） |

### 4.3 i18n

- 7 语言: en / zh / ja / ko / ru / fr / de
- ≈180 个 key 的静态字典
- `useI18n()` composable，`localStorage('lang')` 持久化
- 后端通过 `?lang=` 查询参数 + 产品 `i18n` JSONB 列做服务端本地化

---

## 五、核心业务流程

### 5.1 设计→发布→售卖→分成

```
用户 → Designer.vue → 选择元素（92 种珠子/挂件）→ 命名定价
     → 保存（POST /api/designs）→ 发布（POST /designs/{id}/publish）
     → 版权弹窗确认（checkbox + Terms 链接）
     → 设计上架公开列表（GET /api/designs）

其他用户浏览 → 下单（POST /api/orders）
     → 支付（Airwallex hosted checkout）
     → 回调 webhook（HMAC 验证）→ 订单状态 `paid`
     → 佣金计算（2%）→ INSERT designer_earnings
     → 设计师收益页面可查
```

### 5.2 普通下单

```
用户浏览 → 加购物车（前端 localStorage）
     → 填写地址 → 创建订单（POST /api/orders）
     → DB 事务：FOR UPDATE 锁 + 创建 order + order_items
     → 获取支付链接（POST /api/orders/{id}/payment-intent）
     → Airwallex CreateCheckoutSession → 跳转 hosted payment page
     → 用户完成支付 → 重定向到 /order-status
     → webhook 异步更新状态
```

### 5.3 能量测评

```
用户填写生辰/星座/偏好/关注点/生活方式
     → 规则引擎（energy_rules.go）→ 根据星座五行+关键字匹配晶体
     → 同步返回推荐结果
     → 异步 DeepSeek AI 增强（goroutine，best-effort）
     → 请求更新 ai_response JSONB 列
```

### 5.4 佣金分成

```
订单支付成功 webhook → distributeCommissions()
     → 查询 order_items 中 designer_id 非空的行
     → 每行 INSERT designer_earnings（amount_cents, status=pending）
     → 累加 user_designs.total_earnings_cents
     →（未实现：后台提现审核、批量付款）
```

---

## 六、已修复的问题（本会话）

| 分类 | 问题 | 修复 |
|------|------|------|
| 🔴 BLOCKER | WebhookKey 未传入 → HMAC 永不执行 | `main.go` line 42: `airwallexClient.WebhookKey = cfg.AirwallexWebhookKey` |
| 🔴 BLOCKER | Admin 路由缺 3 条 → 前端报错 | 加 `AdminList`(products/elements) + `AdminUpdate`(elements) |
| 🔴 BLOCKER | Upload 写磁盘不落 DB → 文件无法关联 | `UploadHandler{Pool}` + INSERT to `uploads` table |
| 🔴 BLOCKER | getProduct 拉取 247 条全量 | 前端改 `GET /api/products/{id}` 单条接口 |
| 🔴 BLOCKER | Home 页空白（`<SingleChildScrollView>` Vue 不认识） | 改为 `<div>` |
| 🟡 HIGH | nginx proxy 504（`proxy_pass host` 错误） | 改为 Railway 私有域名 `backend.railway.internal` |
| 🟡 HIGH | 设计发布无版权确认 | `Terms.vue` + 弹窗 checkbox + 7 语种 i18n |
| 🔧 环境 | Airwallex/DeepSeek 密钥挂在 frontend | 移到 backend，清掉 `sk_placeholder` |

---

## 七、已知未解决问题（TODO）

### P0 — 部署阻塞

| 问题 | 根因 | 解决 |
|------|------|------|
| frontend proxy 504 | online 镜像仍为旧构建（无 nginx 修复） | 触发从 `d7fce6a` 的新构建 |
| Railway auto-deploy 不稳定 | Git push 部分失败无日志 | Dashboard 手动 + nginx 修好后再观察 |
| backend 007/003 迁移报错 | 非幂等 SQL + 已有数据 | 已 `IF NOT EXISTS` 兜底，不影响运行 |

### P1 — 功能缺失

| 模块 | 缺失 | 影响 |
|------|------|------|
| 设计师收益 | 无提现/结算流程 | 收益入了 `designer_earnings` 但提不出去 |
| 文件上传 | 不与设计/产品实体关联 | 上传了但联不上 |
| 佣金比例 | 硬编码 2% | 无法按设计师/设计分级配置 |
| 后端分页 | Products 用 `limit/offset` 但前端省了 | 大数据量延迟 |

### P2 — 体验/代码

| 问题 | 说明 |
|------|------|
| `extractID()` 手拆 URL — 没走 chi `URLParam` | 一致性差 |
| `Favorites` store 只读 localStorage | 多设备登录不同步 |
| `StripePaymentIntentID` 命名与实际不符（Airwallex） | 混淆但无功能性影响 |
| `POST /api/migrate-i18n` + `GET /api/debug-i18n` | 临时路由应清理 |
| README.md 过时（仍描述 Flutter） | 误导新开发者 |
| 0 测试 | 订单→支付→佣金核心链路无回归保护 |

---

## 八、部署架构

### 8.1 Railway 两服务

```
frontend (railway.json builder=DOCKERFILE, root=frontend/)
  Dockerfile: node:20 build → nginx:alpine serve
  port: 8080
  nginx: /* → SPA, /api/* → proxy backend.railway.internal:8080

backend (railway.json builder=DOCKERFILE, root=backend/)
  Dockerfile: golang:1.22-alpine build → alpine:3.19 run
  port: 8080
  CMD: ./server (config → DB connect → migrations → routes)
```

### 8.2 环境变量

| 变量 | 属于 | 说明 |
|------|------|------|
| `DATABASE_URL` | backend | Railway Postgres 连接串 |
| `JWT_SECRET` | backend | HS256 签名密钥 |
| `AIRWALLEX_CLIENT_ID` | backend | Airwallex 商户 ID |
| `AIRWALLEX_API_KEY` | backend | Airwallex API 密钥 |
| `AIRWALLEX_WEBHOOK_KEY` | backend | Webhook HMAC 密钥 |
| `DEEPSEEK_KEY` | backend | DeepSeek API 密钥 |
| `FRONTEND_URL` | backend | CORS + 支付跳转回源 |
| `PORT` | backend | `8080` |
| `SKIP_MIGRATIONS` | backend | 跳过初始化迁移 |

---

## 九、技术债务清理路线

```
立即（部署前）
  ├─ 确保 frontend 从最新 d7fce6a 构建上线（nginx proxy fix）
  └─ backend 直连验证全 API 可用

本周
  ├─ 清理临时路由 migrate-i18n / debug-i18n
  ├─ 更新 README.md
  └─ 数据库迁移用版本表代替逐文件执行

本月
  ├─ 设计师提现流程
  ├─ 文件上传关联实体
  ├─ 佣金配置化
  ├─ 核心链路测试（payment→commission）
  └─ Favorites 后端同步
```
