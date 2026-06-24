README - ai_bracelet_app 数据资产

== 商品数据 ==
位置: assets/bracelets_data.json
条目: 184条 (来自 Alibaba.com 1688国际站)
品类: 珍珠/水晶/玉石/木质各44-46条, 朱砂3条, 黑曜石1条
格式: 含 id, platform, category, title, price, image_url(alcdn), product_url

== 3D模型 ==
位置: assets/3d_models/thingiverse/
数量: 70个目录, 37+ 模型文件, ~76MB
格式: STL (zip压缩)
来源: Thingiverse beads/bracelet 3D打印模型

== 淘宝爬虫框架 ==
位置: assets/taobao_mtop.py
运行: /Users/guoyuli/miniconda3/bin/python3 taobao_mtop.py
说明: 使用 nodriver 绕过反爬, 获取 cookies + mtop 签名调用搜索 API
注意: SEARCH_API 常量可能需要逆向确认 (淘宝新UI mtop API 名)
依赖: nodriver (miniconda python3.13)
