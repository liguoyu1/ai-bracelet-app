#!/Users/guoyuli/miniconda3/bin/python3
"""
淘宝 mtop 签名 API 爬虫框架
用法: /Users/guoyuli/miniconda3/bin/python3 taobao_mtop.py
"""
import nodriver as uc
import asyncio, json, hashlib, time, os
from datetime import datetime

OUT = os.path.dirname(os.path.abspath(__file__))
CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# mtop 配置
APP_KEY = "12574478"  # 淘宝 web 端 appKey
SEARCH_API = "mtop.taobao.search.search"  # 搜索 API (可能需要逆向确认)

def mtop_sign(token, t, app_key, data):
    """淘宝 mtop 签名算法"""
    pattern = f"{token}&{t}&{app_key}&{data}"
    return hashlib.md5(pattern.encode()).hexdigest()

async def get_session():
    """获取 nodriver 会话 + cookies"""
    browser = await uc.start(browser_executable_path=CHROME, no_sandbox=True)
    tab = await browser.get("https://www.taobao.com/")
    await asyncio.sleep(5)
    
    # 提取 _m_h5_tk
    cookies = {}
    for c in await browser.cookies.get_all():
        if c.name == "_m_h5_tk" or c.name == "_m_h5_tk_enc" or c.name == "cookie2" or c.name == "t" or c.name == "cna":
            cookies[c.name] = c.value
    
    m_h5_tk = cookies.get("_m_h5_tk", "")
    token = m_h5_tk.split("_")[0] if "_" in m_h5_tk else m_h5_tk
    
    print(f"Token: {token[:10]}...  ({'有' if token else '无'})")
    return browser, tab, cookies, token

async def call_mtop(browser, tab, cookies, token, api_name, params):
    """调用淘宝 mtop API"""
    t = str(int(time.time() * 1000))
    data_str = json.dumps(params, separators=(",", ":"))
    sign = mtop_sign(token, t, APP_KEY, data_str)
    
    # 构造 URL
    url = (
        f"https://h5api.m.taobao.com/h5/{api_name}/1.0/"
        f"?jsv=2.6.1&appKey={APP_KEY}&t={t}&sign={sign}"
        f"&data={data_str}"
        f"&api={api_name}&v=1.0"
        f"&type=jsonp&dataType=jsonp"
        f"&callback=mtopjsonp{int(time.time())}"
    )
    
    # 用 nodriver 的 tab 发请求 (保持同会话)
    result = await tab.evaluate(f"""
        fetch('{url}', {{
            credentials: 'include',
            headers: {{ 'Accept': 'application/json' }}
        }}).then(r => r.text())
    """)
    
    return result

async def search_products(browser, tab, cookies, token, keyword, page=1):
    """搜索淘宝商品"""
    params = {
        "q": keyword,
        "s": (page - 1) * 44,
        "pSize": 44,
        "sort": "sale-desc",
    }
    
    result = await call_mtop(browser, tab, cookies, token, SEARCH_API, params)
    
    if result:
        # 可能被 JSONP 包裹: mtopjsonp123({...})
        if result.startswith("mtopjsonp"):
            result = result[result.index("{"):result.rindex("}")+1]
        
        try:
            data = json.loads(result)
            ret = data.get("ret", [])
            if ret and "SUCCESS" in str(ret):
                auctions = data.get("data", {}).get("auctions", [])
                return auctions
            else:
                print(f"  API 错误: {ret}")
                return []
        except json.JSONDecodeError as e:
            print(f"  JSON 解析失败: {e}")
            print(f"  响应: {result[:200]}")
    
    return []

async def main():
    print("=== 淘宝 mtop API 爬虫 ===\n")
    
    # 获取会话
    print("[1/3] 获取 nodriver 会话...")
    browser, tab, cookies, token = await get_session()
    
    if not token:
        print("! 获取 token 失败，退出")
        await browser.stop()
        return
    
    # 搜索品类
    categories = ["珍珠手串", "水晶手串", "玉石手串", "木质手串", "香珠手串", "朱砂手串", "黑曜石手串"]
    all_products = []
    
    print(f"\n[2/3] 搜索 {len(categories)} 个品类...")
    for kw in categories:
        print(f"\n--- {kw} ---")
        auctions = await search_products(browser, tab, cookies, token, kw)
        
        if auctions:
            print(f"  → {len(auctions)} 个商品")
            all_products.extend(auctions)
        else:
            print(f"  → 无数据，可能是 mtop API 名称不对")
            print(f"  需逆向确认 SEARCH_API 的值")
        
        await asyncio.sleep(2)
    
    await browser.stop()
    
    print(f"\n[3/3] 共获取 {len(all_products)} 个商品")
    
    if input("\n保存到 bracelets_data.json? (y/N): ").lower() == "y":
        output = os.path.join(OUT, "bracelets_data.json")
        # 合并已有数据
        if os.path.exists(output):
            with open(output) as f:
                existing = json.load(f).get("products", [])
            all_products = existing + all_products
        
        with open(output, "w", encoding="utf-8") as f:
            json.dump({"products": all_products}, f, ensure_ascii=False, indent=2)
        print(f"已保存到 {output}")

if __name__ == "__main__":
    asyncio.run(main())
