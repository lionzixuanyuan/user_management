# V1 版 API 说明文档

## 用户相关接口

### 用户注册接口
**描述：**
提交用户相关的信息，完成用户注册功能。

**需要登录:**
否

**方法:**
POST /api/v1/users

**参数:**
```json
{
  "sign":"c908f2613a6f0830091e0b2b9338d0f1d06b9f4e",
  "timestamp":1417681024,
  "user":{
    "name":"leo1",
    "e_mail":"123@qq.com",
    "password":"123123",
    "password_confirmation":"123123"
  }
}
```

**返回数据格式：**
```json
// 用户注册成功，返回部分用户信息以及对应 access_token
{
  "user": {
    "name": "leo1",
    "e_mail": "123@qq.com"
  },
  "access_token": "nsamAvvvAaNYk8SZGqVc"
}

// 签名校验失败
{
  "msg": "签名校验失败！"
}

// 用户注册失败，返回失败原因
{
  "msg": "用户注册失败！用户名：该用户名已存在！；邮箱：该邮箱已存在！"
}
```

### 获取用户信息接口
**描述：**
提交用户ID，返回用户对应的部分信息。

**需要登录:**
否

**方法:**
GET /api/v1/users/:id

**返回数据格式：**
```json
// 返回用户信息
{
  "user": {
    "name": "lion",
    "e_mail": "1232@qq.com"
  }
}
```

### 获取当前登录用户信息接口
**描述：**
提交 access_token，返回对应登录用户的部分信息。

**需要登录:**
是，需要有效的 access_token

**方法:**
GET /api/v1/profile/:access_token

**返回数据格式：**
```json
// 返回用户信息
{
  "user": {
    "name": "lion",
    "e_mail": "1232@qq.com"
  }
}

// access_token 无效
{
  "msg": "提供 access_token 无效！"
}
```


### 更新当前登录用户信息接口
**描述：**
提交 access_token 以及需要更新的相关用户信息，更新当前登录用户的信息。

**需要登录:**
是，需要有效的 access_token

**方法:**
PATCH /api/v1/profile/:access_token

**参数:**
```json
{
  "sign":"b49897af3039d059a78a908fc0af98f5c4b9bb5c",
  "user":{
    "password":"123123",
    "password_confirmation":"123123"
  }
}
```

**返回数据格式：**
```json
// 返回更新后的用户信息
{
  "user": {
    "name": "lion",
    "e_mail": "1232@qq.com"
  }
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
