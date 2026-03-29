# 【PC端】门店账号管理模块迁移重构 - 技术方案

# 一、背景

## 1.1 相关文档

| | 文档链接 |
|---|---|
| Ones | {待填写} |
| PRD | 无新增功能，纯迁移重构 |

## 1.2 项目干系人

| | 负责人（R） | 参与人（S） | 备注 |
|---|---|---|---|
| PM | {待填写} | | |
| 后端 | {待填写} | | 接口不变，仅前端迁移 |
| 前端 | 张迪 (zhangyedi03) | | |
| QA | {待填写} | | 需全量回归 |

## 1.3 业务背景

门店账号管理模块（poiacct）当前维护在 `msfe-dailyops` 仓库中，存在三个问题：

1. **组织耦合** — dailyops 是其他团队维护的仓库，两个团队在一个仓库下开发，发版/CR/分支管理互相制约
2. **仓库分散** — 到餐商家账号管理相关页面散落在 dailyops（门店账号）和 bizaccount（商家账号/注销/审批）两个仓库，维护成本高
3. **技术债** — poiacct 模块技术栈老旧（Class Components + Redux + JS + Bootstrap 风格 CSS），与 bizaccount 仓库的现代栈（FC + MobX + TS + MTD + SCSS Modules）不一致，维护困难

目标：将 poiacct 的 4 个页面功能平移到 `msfe-bizaccount` 仓库，同时完成技术栈升级。**业务逻辑和后端接口保持不变。**

# 二、目标

## 2.1 业务目标

- 门店账号管理功能从 dailyops 迁出至 bizaccount 仓库，实现账号域页面归一
- 技术栈对齐 bizaccount 现有标准，降低后续维护成本
- 迁移后功能和交互与现有完全一致，用户无感知

# 三、研发关键信息

| 涉及端 | PC 端 |
|---|---|
| 涉及系统 | 门店账号管理（到餐商家运营） |
| 源仓库 | `msfe-dailyops` → `src/pages/poiacct/` |
| 目标仓库 | `msfe-bizaccount` → `packages/container/web/src/pages/poiacct-pc/`（新增） |
| 涉及页面 | 门店账号列表、新增账号、重设密码/修改手机号/修改商户名称、绑定IVR电话 |

# 四、方案选型

## 方案 A: 新增独立入口 `poiacct-pc`（推荐 ✅）

在 bizaccount 的 `pages/` 下新增独立的 `poiacct-pc` 模块，与现有 `bizacct-pc` 平级。拥有独立的 `main.tsx`、`app.tsx`、`routes/`、`views/`、`store/`。

**优点**：
- 与现有 bizacct-pc 模块完全隔离，不影响现有功能
- 独立入口，可以配置独立的登录体系（poiacct 使用 epassport 商家登录，bizacct-pc 使用 sso 登录，二者身份体系不同）
- Rome 多入口天然支持，部署路径独立
- 后续可独立迭代，不互相影响

**缺点**：
- 无法复用 bizacct-pc 的现有组件（但两者业务逻辑差异大，实际可复用的很少）

## 方案 B: 嵌入现有 `bizacct-pc` 模块

将门店账号页面作为 bizacct-pc 的子路由，共享同一个入口和容器。

**优点**：
- 共享布局和初始化逻辑

**缺点**：
- ⚠️ 登录体系冲突 — poiacct 使用 epassport（`login()` 获取商家 token），bizacct-pc 使用 sso（`sso().login()` 获取运营端 token），强行合并需要在入口做分支判断，增加复杂度
- 路由耦合，互相影响

## 选型结论

**选择方案 A**。核心理由：poiacct 和 bizacct-pc 的登录认证体系不同（epassport vs sso），强行合并入口会引入不必要的复杂度。独立入口是最干净的方案。

# 五、模块详细设计

## 5.1 整体架构

### 新增文件结构

```
packages/container/web/src/pages/poiacct-pc/     # 新增模块
├── main.tsx              # 入口：epassport 登录 + 渲染 App
├── app.tsx               # 路由容器
├── routes/
│   └── index.ts          # 路由配置（4 个页面）
├── views/
│   ├── container/        # 布局容器（导航栏 + 内容区）
│   │   ├── index.tsx
│   │   ├── nav.tsx
│   │   └── index.module.scss
│   ├── list/             # 门店账号列表
│   │   ├── index.tsx
│   │   ├── table.tsx
│   │   ├── tip.tsx
│   │   ├── head.tsx
│   │   └── index.module.scss
│   ├── add/              # 新增门店账号
│   │   ├── index.tsx
│   │   ├── form.tsx
│   │   ├── head.tsx
│   │   └── index.module.scss
│   ├── reset-pwd/        # 重设密码 / 修改手机号 / 修改商户名称
│   │   ├── index.tsx
│   │   ├── form.tsx
│   │   ├── head.tsx
│   │   ├── constants.ts
│   │   └── index.module.scss
│   └── bind-ivr/         # 绑定IVR电话
│       ├── index.tsx
│       ├── form.tsx
│       ├── head.tsx
│       ├── tip.tsx
│       └── index.module.scss
└── store/
    ├── index.ts           # store 聚合
    ├── poi-list.ts        # 门店列表 store
    ├── poi-add.ts         # 新增账号 store
    ├── poi-reset-pwd.ts   # 重设密码 store
    ├── poi-bind-ivr.ts    # 绑定IVR store
    └── poi-permission.ts  # 权限判断 store

packages/apis/poiacct/                            # 新增 API 层
├── list/
│   ├── index.ts
│   └── types.ts
├── add-acct/
│   ├── index.ts
│   └── types.ts
├── add-acct-save/
│   ├── index.ts
│   └── types.ts
├── reset-pwd/
│   ├── index.ts
│   └── types.ts
├── reset-pwd-save/
│   ├── index.ts
│   └── types.ts
├── bind-ivr/
│   ├── index.ts
│   └── types.ts
├── bind-ivr-save/
│   ├── index.ts
│   └── types.ts
└── modify-phone-and-name/
    ├── index.ts
    └── types.ts
```

### 技术栈映射

| 维度 | 迁出 (poiacct @ dailyops) | 迁入 (poiacct-pc @ bizaccount) |
|---|---|---|
| 组件风格 | Class Components + Redux connect | **FC + MobX observer** |
| 状态管理 | Redux action/reducer | **MobX makeAutoObservable** |
| 类型系统 | JavaScript (.js) | **TypeScript (.tsx/.ts)** |
| UI 组件库 | Bootstrap + 自封装 Form/Input | **MTD (@ss/mtd-react3)** |
| 样式方案 | 全局 CSS (.css) | **SCSS Modules (.module.scss)** |
| 请求 | dailyops 内部 request() | **axios + @nibfe/we-utils** |
| 构建 | Webpack (msfe-activity) | **Rome** |
| 登录 | epassport (商家登录) | **epassport (商家登录)** — 保持不变 |

## 5.2 路由配置

**文件**: `pages/poiacct-pc/routes/index.ts`

```typescript
import { IRouteProps } from '@rome/runtime'
import { lazy } from 'react'

const PREFIX = '/kdbaccount/poiacct-pc'

const routes: IRouteProps[] = [
  {
    path: PREFIX,
    component: lazy(() => import('../views/container')),
    routes: [
      {
        title: '门店账号管理',
        path: `${PREFIX}/manage/list`,
        component: lazy(() => import('../views/list')),
      },
      {
        title: '新增门店账号',
        path: `${PREFIX}/add`,
        component: lazy(() => import('../views/add')),
      },
      {
        title: '重设密码',
        path: `${PREFIX}/resetPwd`,
        component: lazy(() => import('../views/reset-pwd')),
      },
      {
        title: '绑定IVR电话',
        path: `${PREFIX}/bindIvr`,
        component: lazy(() => import('../views/bind-ivr')),
      },
    ],
  },
]

export default routes
```

同步在 `constants/page-path.ts` 中新增：

```typescript
export const POIACCT_PAGE_PATH = {
  POIACCT_PC_LIST: `${PREFIX_PATH}/poiacct-pc/manage/list`,
  POIACCT_PC_ADD: `${PREFIX_PATH}/poiacct-pc/add`,
  POIACCT_PC_RESET_PWD: `${PREFIX_PATH}/poiacct-pc/resetPwd`,
  POIACCT_PC_BIND_IVR: `${PREFIX_PATH}/poiacct-pc/bindIvr`,
}
```

## 5.3 入口与登录

**文件**: `pages/poiacct-pc/main.tsx`

poiacct 使用 epassport 商家登录体系（与 acctcancel-pc 相同），复用现有 KDB PC 初始化模块：

```typescript
import React from 'react'
import ReactDOM from 'react-dom'
import '@/lib/init/kdb-pc-moudle'    // 复用现有 KDB PC 初始化（we-request / showTip / showModal）
import { BssoInfo } from '@/store'
import { epassport, BizAcctInfo } from '@rome/runtime'
import '@/assets/styles/pc/index.pc.global.scss'
import '@ss/mtd-react3/lib/style/index.css'
import App from './app'
import { customReport, ErrCategory, ErrLevel } from 'acct-module/lib/owl/web'

epassport()
  ?.login()
  .then((user: BizAcctInfo) => {
    BssoInfo.setValue(user)
    ReactDOM.render(<App />, document.getElementById('root'))
  })
  .catch(err => {
    customReport({
      message: err?.status?.message || err?.message || '登录异常',
      category: ErrCategory.other,
      level: ErrLevel.info,
      note: '登录异常',
      opts: { error: err },
    })
  })
```

## 5.4 API 层设计

门店账号的后端接口保持不变，调用方式从 dailyops 的 `request()` 迁移为 bizaccount 的 axios 模式。

### 接口清单（均为原有接口，不新增不修改）

| 功能 | 方法 | URL | 说明 |
|---|---|---|---|
| 获取门店列表 | GET | `/acctpms/api/poiacct/-/m/permission/service/poiAcct/v2/list` | 返回门店及其子账号列表 |
| 获取新增账号页信息 | GET | `/acctpms/api/poiacct/-/m/permission/service/poiAcct/v2/addAcct` | 按 poiId 查询门店信息 |
| 新增账号保存 | POST | `/acctpms/api/poiacct/-/m/permission/service/poiAcct/v2/addAcct/save` | 创建门店子账号 |
| 获取重设密码页信息 | GET | `/acctpms/api/poiacct/-/m/permission/service/poiAcct/v2/resetPassword` | 按 poiId+acctId 查询 |
| 重设密码保存 | POST | `/acctpms/api/poiacct/-/m/permission/service/poiAcct/v2/resetPassword/save` | 重设密码 |
| 获取绑定IVR页信息 | GET | `/acctpms/api/poiacct/-/m/permission/service/poiAcct/v2/bindIVR` | 按 poiId 查询 |
| 绑定IVR保存 | POST | `/acctpms/api/poiacct/-/m/permission/service/poiAcct/v2/bindIVR/save` | 绑定电话 |
| 修改手机号/商户名称 | POST | `/acctpms/api/poiacct/-/m/permission/service/poiAcct/v2/modifyAccountPhoneAndName` | 修改手机号或商户名称 |
| 查询ACL权限 | GET | `/gateway-proxy/resource/pc/pageResource` | 判断免密登录权限 |

### API 封装示例

在 `packages/apis/poiacct/` 下用 axios 封装（与 we-utils createRequest 并存）：

```typescript
// packages/apis/poiacct/list/index.ts
import { axiosInstance } from '@web/lib/request'

export interface PoiAcctItem {
  acctId: number
  login: string
  name?: string
  phone?: string
}

export interface PoiAcctListItem {
  poiId: number
  name: string
  cityLocation?: string
  poiAccts: PoiAcctItem[]
}

const BASE = '/activity/gw/acctpms/api/poiacct/-/m/permission/service/poiAcct/v2'

export const requestPoiAcctList = () =>
  axiosInstance.get<{ data: PoiAcctListItem[] }>(`${BASE}/list`)

export const requestAddAcctInfo = (params: { poiId: string }) =>
  axiosInstance.get(`${BASE}/addAcct`, { params })

export const requestAddAcctSave = (data: {
  acctLogin?: string; acctPassword?: string; phone?: string;
  poiIdLong: number; feAclPermission?: boolean
}) => axiosInstance.post(`${BASE}/addAcct/save`, data)

export const requestResetPwdInfo = (params: { poiId: string; acctId: string }) =>
  axiosInstance.get(`${BASE}/resetPassword`, { params })

export const requestResetPwdSave = (data: {
  acctPassword?: string; reason: string;
  poiIdLong: number; acctId?: number
}) => axiosInstance.post(`${BASE}/resetPassword/save`, data)

export const requestBindIvrInfo = (params: { poiIdLong: string }) =>
  axiosInstance.get(`${BASE}/bindIVR`, { params })

export const requestBindIvrSave = (data: { phone: string; poiIdLong: number }) =>
  axiosInstance.post(`${BASE}/bindIVR/save`, data)

export const requestModifyPhoneAndName = (data: {
  acctId: string; poiIdLong: string;
  phone?: string; name?: string; reason?: string;
}) => axiosInstance.post(`${BASE}/modifyAccountPhoneAndName`, data)
```

> ⚠️ **前置依赖**：BASE URL 前缀需确认 bizaccount 部署域名下的网关转发配置。若 bizaccount 域名与 dailyops 域名不同，需运维在 nginx 配置 `/activity/gw/acctpms/...` 的代理转发。

## 5.5 Store 设计

按 bizaccount 现有模式，使用 MobX Store 替代 Redux action/reducer。

### poi-list.ts — 门店列表 Store

```typescript
import { makeAutoObservable } from 'mobx'
import { requestPoiAcctList, PoiAcctListItem } from 'acct-api/poiacct/list'
import showTip from 'acct-module/lib/show-tip'

class PoiListStore {
  items: PoiAcctListItem[] = []
  currentUrl: string = ''
  loading: boolean = false

  constructor() { makeAutoObservable(this) }

  fetchList = async () => {
    this.loading = true
    try {
      const response = await requestPoiAcctList()
      this.items = response.data?.data || []
    } catch (error: any) {
      showTip({ message: error?.message || '获取门店列表失败', level: 'error' })
    } finally {
      this.loading = false
    }
  }

  setCurrentUrl = (url: string) => { this.currentUrl = url }

  clear = () => { this.items = []; this.currentUrl = '' }
}

export default new PoiListStore()
```

### poi-permission.ts — ACL 权限 Store

```typescript
import { makeAutoObservable } from 'mobx'
import { axiosInstance } from '@web/lib/request'

class PoiPermissionStore {
  aclPermission: boolean = false

  constructor() { makeAutoObservable(this) }

  /** 获取 ACL 权限：有权限返回 false（可设密码），无权限返回 true（只能设手机号） */
  fetchAclPermission = async (): Promise<boolean> => {
    try {
      const response = await axiosInstance.get('/gateway-proxy/resource/pc/pageResource', {
        params: {
          groupCodeList: process.env.APP_ENV === 'production' ? '100129074' : '100049529',
          permissionSpace: 1, bizLine: 1,
          resourceType: 'kkdb:no_pwd_button',
          attributeKey: '/kdb/account/accountlist',
          resourceRoutes: '/kdb/account/accountlist',
        },
      })
      const data = response.data?.data?.data || {}
      if (data['/kdb/account/accountlist']?.length > 0) {
        this.aclPermission = false; return false
      }
      this.aclPermission = true; return true
    } catch {
      this.aclPermission = true; return true
    }
  }
}

export default new PoiPermissionStore()
```

### 其余 Store

`poi-add.ts`、`poi-reset-pwd.ts`、`poi-bind-ivr.ts` 模式相同：将原有 Redux reducer 中的 state 转为 MobX observable，action creator 中的异步请求转为 store async method，`dispatch(successInfo())` 替换为 `showTip({ level: 'success' })`，`history.goBack()` 保持使用 `react-router` 的 `useHistory` / `useNavigate`。

## 5.6 核心改动文件对照表

| 新增文件路径 | 对应源文件 | 改动说明 |
|---|---|---|
| `pages/poiacct-pc/main.tsx` | `poiacct/main.tsx` | epassport 登录，Redux Provider → 无（MobX 直接 import） |
| `pages/poiacct-pc/app.tsx` | `poiacct/app.tsx` | BrowserRouter + renderRoutes，去掉 Redux connect |
| `pages/poiacct-pc/routes/index.ts` | `poiacct/routes/index.js` | 路由路径更新，TS + IRouteProps |
| `pages/poiacct-pc/views/container/index.tsx` | `views/container/index.js` | FC 改写，MTD 替代 Bootstrap 布局 |
| `pages/poiacct-pc/views/container/nav.tsx` | `views/container/nav.js` | FC + observer，从 BssoInfo 取登录名 |
| `pages/poiacct-pc/views/list/index.tsx` | `views/list/index.js` | FC + observer + poiListStore |
| `pages/poiacct-pc/views/list/table.tsx` | `views/list/table.js` | MTD Table 替代 Bootstrap table |
| `pages/poiacct-pc/views/list/head.tsx` | `views/list/head.js` | FC + observer |
| `pages/poiacct-pc/views/list/tip.tsx` | `views/list/tip.js` | 纯 FC，内容不变 |
| `pages/poiacct-pc/views/add/index.tsx` | `views/add/index.js` | FC + observer + poiAddStore |
| `pages/poiacct-pc/views/add/form.tsx` | `views/add/form.js` | MTD Form/Input 替代自封装 Form |
| `pages/poiacct-pc/views/add/head.tsx` | `views/add/head.js` | FC |
| `pages/poiacct-pc/views/reset-pwd/index.tsx` | `views/reset-pwd/index.js` | FC + observer + poiResetPwdStore |
| `pages/poiacct-pc/views/reset-pwd/form.tsx` | `views/reset-pwd/form.js` | MTD Form，保留 formType 动态渲染 |
| `pages/poiacct-pc/views/reset-pwd/head.tsx` | `views/reset-pwd/head.js` | FC |
| `pages/poiacct-pc/views/reset-pwd/constants.ts` | `views/reset-pwd/constants.js` | TS 化，内容不变 |
| `pages/poiacct-pc/views/bind-ivr/index.tsx` | `views/bind-ivr/index.js` | FC + observer + poiBindIvrStore |
| `pages/poiacct-pc/views/bind-ivr/form.tsx` | `views/bind-ivr/form.js` | MTD Form/Input |
| `pages/poiacct-pc/views/bind-ivr/head.tsx` | `views/bind-ivr/head.js` | FC |
| `pages/poiacct-pc/views/bind-ivr/tip.tsx` | `views/bind-ivr/tip.js` | 纯 FC，内容不变 |
| `pages/poiacct-pc/store/*.ts` | `store/ + views/*/action.js + reducer.js` | MobX Store 替代 Redux |
| `packages/apis/poiacct/**` | 无（新增） | 接口 TS 封装层 |
| `constants/page-path.ts`（修改） | — | 新增 POIACCT_PAGE_PATH |

## 5.7 关键交互逻辑

### 列表页 → 子页面导航

原 poiacct 通过 React Router `<Link>` 传 query 参数跳转（`?poiId=X&acctId=Y&formType=Z`），新模块保持相同模式，仅更新路由前缀：

```typescript
// table.tsx 中
<Link to={`${PREFIX}/add?poiId=${poiId}`}>+新增账号</Link>
<Link to={`${PREFIX}/resetPwd?poiId=${poiId}&acctId=${acct.acctId}&formType=resetPwd`}>重设密码</Link>
<Link to={`${PREFIX}/resetPwd?poiId=${poiId}&acctId=${acct.acctId}&formType=modifyPhoneNum`}>修改手机号</Link>
<Link to={`${PREFIX}/resetPwd?poiId=${poiId}&acctId=${acct.acctId}&formType=modifyMerchantName`}>修改商户名称</Link>
```

### 重设密码页 formType 动态渲染

保持 `constants.ts` 中的 `formTypeMap` + `formConfig` 不变，通过 URL query 的 `formType` 字段决定渲染哪种表单：

| formType | 表单内容 | 提交接口 |
|---|---|---|
| `resetPwd` | 新密码 + 理由 | resetPassword/save |
| `modifyPhoneNum` | 手机号 + 理由 | modifyAccountPhoneAndName |
| `modifyMerchantName` | 商户名称 | modifyAccountPhoneAndName |

### 免密登录（ACL）权限判断

原逻辑：`user.aclUserID` 判断是否免密登录 → 调用 `getAclPermission()` → 决定表单字段差异。

迁移后：`BssoInfo` 中取 `aclUserId` → `poiPermissionStore.fetchAclPermission()` → 同样逻辑，状态从 Redux → MobX。

| 场景 | 新增账号表单 | 重设密码表单 |
|---|---|---|
| 正常登录（有权限） | 账号名 + 密码 | 新密码 + 理由 |
| 免密登录（无权限） | 账号名 + 手机号 | 手机号 + 理由（密码通过短信下发） |

### 灰度检查

原 `useGrayStatus` hook 调用 `/activity/gw/ICustomerGrayService/customerIsGray`，仅在列表页使用。迁移后保留此逻辑作为列表页前置判断。

## 5.8 边界条件 & 异常处理

| 场景 | 处理方式 |
|---|---|
| 接口网关不通（域名转发未配） | 页面加载后列表为空 + showTip 错误提示；**上线前必须确认网关转发** |
| epassport 登录失败 | 复用 acctcancel-pc 逻辑，catch 后上报 owl |
| 门店列表为空 | 正常展示空 table（原有行为） |
| 免密登录权限接口异常 | 兜底 `aclPermission = true`（无权限），保持与原逻辑一致 |
| 表单校验失败 | 密码不能和账号相同 / 手机号 11 位 / 密码 8-20 位大小写+数字，用 MTD Form rules 实现 |
| 已绑定电话重复绑定 | bind-ivr 校验 `poiInfo.phones` 包含输入号码时报错，逻辑不变 |
| 路由参数缺失（无 poiId） | 子页面获取不到 poiId 时接口报错，保持原有行为 |

# 六、项目执行

## 6.1 前置依赖（⚠️ 必须先完成）

1. **网关配置** — 确认 bizaccount 部署域名下能代理 `/activity/gw/acctpms/...` 到后端服务。需与运维/后端确认
2. **Rome 入口注册** — 在 bizaccount 的 Rome 配置中注册 `poiacct-pc` 为新的 page entry

## 6.2 任务拆分

| 序号 | 事项 | 估时 | 负责人 |
|---|---|---|---|
| p0 | 方案设计 + 评审 | 0.5pd | 张迪 |
| p1 | 网关转发配置确认 & Rome 入口注册 | 0.5pd | 张迪 |
| p2 | API 层搭建（`packages/apis/poiacct/`，8 个接口 TS 封装） | 0.5pd | 张迪 |
| p3 | Store 层搭建（5 个 MobX Store） | 1pd | 张迪 |
| p4 | 入口 + 容器 + 路由（main/app/container/nav） | 0.5pd | 张迪 |
| p5 | 列表页（list/table/head/tip）+ 样式 | 1pd | 张迪 |
| p6 | 新增账号页（add/form/head）+ 权限分支 | 0.5pd | 张迪 |
| p7 | 重设密码/修改手机号/修改商户名称页（reset-pwd，三种 formType） | 1pd | 张迪 |
| p8 | 绑定IVR页（bind-ivr/form/head/tip） | 0.5pd | 张迪 |
| p9 | 联调 & 自测 | 1pd | 张迪 |
| p10 | CR & 提测 | 0.5pd | 张迪 |
| | **合计** | **7pd** | |

# 七、影响面评估

- **bizaccount 现有功能**：零影响。poiacct-pc 是独立入口，不修改任何现有代码（仅 `page-path.ts` 新增常量）
- **dailyops 侧**：迁移完成 + 灰度验证后，dailyops 侧的 poiacct 模块可下线。下线前需保留，做灰度切流
- **回归测试建议**：
  - 新模块：4 个页面全量功能回归（列表、新增、重设密码、修改手机号、修改商户名称、绑定 IVR）
  - 免密登录 vs 正常登录两种场景
  - bizaccount 现有页面冒烟测试（确认无影响）

# 八、上线策略

- **灰度策略**：通过网关配置灰度切流，先导 1% 流量到新页面，观察后逐步放量
- **回滚方案**：网关将流量切回 dailyops 旧页面，秒级回滚
- **监控告警**：
  - Owl 错误率监控（新入口的 JS 异常率）
  - 接口成功率（poiacct 8 个接口的网关 QPS 和错误率）
  - 页面加载耗时（LCP / FCP）
- **旧模块下线**：灰度全量 + 稳定运行 1 周后，从 dailyops 删除 poiacct 模块代码
