#API Base

## API综述

API Base 中归纳的主要为一些基础功能接口。

最主要的是与 access_token 相关的接口，access_token 是全局用于换取对应用户信息的票据。

access_token 默认的有效期为 1 周，可以在失效前换取新的票据，或者在实效后重新获取。

## 签名（sign）生成方法

为了校验请求是否合法，避免频繁的恶意请求，需要对请求做签名校验。

默认情况下，所有的 API 请求都需要签名校验，特殊情况会在具体的接口文档中说明。

### 与签名相关的两个参数：

1. timestamp（Unix时间戳）：

  时间戳用于确保请求的实效性，避免同样的 API 地址被重复多次的恶意请求。默认情况下，每一个 API 地址的有效时间为5秒。

  这里的所说的同样的 API 地址是指加上 timestamp 和 sign 参数后的 API 请求的实际地址。

2. SECRET_TOKEN（摘要密钥）

  为了提高签名的可靠性，引入了摘要密钥。这个密钥将参与签名的计算过程，但不暴露于任何 API 请求的参数中。

  当前系统约定的密钥为：**bc257fb298be8462129331e1d7b949acd9b4ffb4**，建议正式投入使用前更改此密钥

### 签名的计算方法

1. 假设现有请求所需参数为

  ```
  {
    "user_account": "lion",
    "user_password": "123456"
  }
  ```

2. 添加时间戳
  ```
  {
    "user_account": "lion",
    "user_password": "123456",
    "timestamp": "1417588357"
  }
  ```

3. 对参数按 key 进行字典排序
  ```
  {
    "timestamp": "1417588357",
    "user_account": "lion",
    "user_password": "123456"
  }
  ```

4. 每对参数之间用 “&” 间隔，参数的 key 与 value 之间用 “=”间隔，拼接成字符串
  ```
timestamp=1417588357&user_account=lion&user_password=123456
  ```

5. 在第4步获得的字符串结尾混入 SECRET_TOKEN，得到字符串
  ```
timestamp=1417588357&user_account=lion&user_password=123456bc257fb298be8462129331e1d7b949acd9b4ffb4
  ```

6. 对第5步得到的字符串做 SHA1 校验，得到 sign
  ```
  e8997a05e634665cacb8c12b834e866d5c979014
  ```

7. 得到最终传递参数集合为
  ```
  {
    "user_account": "lion",
    "user_password": "123456",
    "timestamp": "1417588357",
    "sign": "e8997a05e634665cacb8c12b834e866d5c979014"
  }
  ```

最终参数传递时，无需关注参数的排序问题；不用传递 SECRET_TOKEN 参数。

## API 版本继承说明

此次 API 开发将版本迭代抽象为继承关系，因此，新版本的接口总是能够兼容原版本接口，并在此基础上扩展新功能接口。

目前分为两个版本：**初版** 和 **v1** 版。通过这两个版本来说明接口的继承关系:

1. 初版中为 API 中最基本的功能：access_token 的获取、更换和销毁，其中 access_token 的获取和销毁对应 app 中用户的登录与登出。

2. v1版中相较与初版增加了用户注册、用户信息获取、当前用户信息获取以及当前用户信息变更接口。

以用户登录功能（获取 access_token）为例:

  - 初版中定义如下：
  ```
  POST   /api/token
  ```

  - v1版中仍保留该功能：
  ```
  POST   /api/v1/token
  ```

  - 后续版本中，该接口定义也将保持：
  ```
  POST   /api/vn/token
  ```

在 app 开发过程中，可根据不同的版本设置不同的 base_url 常量，即可以保证原版本接口功能不变的情况下，应用新功能接口。

注：当某接口在新版中作废时，这个接口仅在新版本接口中不可用，在原版接口中仍然有效。

## 获取全局的 access_token

**描述：**
提交用户的账户和密码，换取与该用户对应的 access_token。

**需要登录:**
否

**方法:**
POST /api/token

**参数:**
```json
{
  "user_account":"lion",
  "user_password":"123123",
  "timestamp":"1417588357",
  "sign":"54d3827df37458eb7b8d2c04d98cb2dc245f8f37"
}
```

**返回数据格式：**

```json
// 获取 access_token 成功
{
  "access_token": "WfRMYGoUl356sRZbLdmC"
}

// 签名校验失败
{
  "msg": "签名校验失败！"
}

// 请求已过期
{
  "msg": "请求已过期，无法响应！"
}

// 错误的用户或者密码
{
  "msg": "错误的用户或者密码！"
}
```


## 通过已有的 access_token 换取新的 access_token

**描述：**
通过接口获取的 access_token 是有失效时间的，当 access_token 实效，则需要用户重新登录。为了保证 access_token 的有效性的同时，尽力避免用户频繁的登录，这里提供了更换 access_token 的接口。

** 判断是否需要更新 access_token 的方法： **
假设一个接口请求需要验证 access_token ，且这个 access_token 仍然有效，但是即将过期，那么，在返回正常所需的业务信息的同时，会在头部添加一个自定义的消息

```
X-Dying-Token → exchange_access_token
```
当检测到这个头部信息时就可以进行回调，调用换取 access_token 的接口。这个可以做成一个全局的回调方法，所有需要验证 access_token 的接口（除换取 access_token 接口以外）都会在 access_token 即将过期时返回这个头部信息。目前预置的提醒时间持续1小时。

**需要登录:**
是，需要有效的 access_token

**方法:**
PATCH /api/token

**参数:**
```json
{
  "access_token":"AyFj7mHM6tdUucdLkGVL",
  "timestamp":"1417588357",
  "sign":"3ea6ff8ae2f22da81469d42330058c537f2fa8c1"
}
```
**返回数据格式：**

```json
// 换取 access_token 成功
{
  "access_token": "H3h3YoH1dyPJnxALfjai"
}

// 签名校验失败
{
  "msg": "签名校验失败！"
}

// access_token 无效
{
  "msg": "提供 access_token 无效！"
}
```

## 销毁 access_token

**描述：**
提交已有的有效的 access_token 将其销毁，使其不能继续作为凭证获取用户信息使用。

**需要登录:**
是，需要有效的 access_token

**方法:**
DELETE /api/token

**参数:**
```json
{
  "access_token":"o55ecAiDGfkqNGwbWKPM",
  "timestamp":"1417588357",
  "sign":"8c90c295975287b75c9ab52a53cd87a7f4be8a48"
}
```
**返回数据格式：**

```json
// 销毁 access_token 成功
{
  "msg": "access_token 删除成功！"
}

// 签名校验失败
{
  "msg": "签名校验失败！"
}

// access_token 无效
{
  "msg": "提供 access_token 无效！"
}
```
