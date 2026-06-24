#!/Users/guoyuli/miniconda3/bin/python3
"""nodriver 淘宝爬虫 - 纯脚本，直接跑"""
import nodriver as uc
import asyncio, json, re, hashlib, os
from datetime import datetime, timezone

TARGET = "/Users/guoyuli/Document/code_s/ai_bracelet_app/assets"
OUTPUT = os.path.join(TARGET, "bracelets_data.json")
CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
NOW = datetime.now(timezone.utc).isoformat()

def make_id(title, platform):
    return hashlib.md5(f"{title}|{platform}".encode()).hexdigest()[:16]

CATEGORIES = ["珍珠手串", "水晶手串", "玉石手串", "木质手串", "香珠手串", "朱砂手串", "黑曜石手串"]

# Load existing
all_products = []
seen = set()
if os.path.exists(OUTPUT):
    with open(OUTPUT) as f:
        for p in json.load(f).get("products", []):
            if p["title"] not in seen:
                seen.add(p["title"])
                all_products.append(p)
print(f"已有: {len(all_products)} 条")

async def search_taobao(browser, keyword, category):
    """搜索淘宝 + 提取商品"""
    tab = await browser.get(f"https://s.taobao.com/search?q={keyword}&s=0")
    await asyncio.sleep(8)
    
    # 移除弹窗
    await tab.evaluate("""
        document.querySelectorAll('iframe,div.J_MIDDLEWARE_FRAME_WIDGET').forEach(e=>e.remove());
        document.body.style.overflow='auto';
    """)
    await asyncio.sleep(2)
    
    # 滚动
    for _ in range(3):
        await tab.evaluate("window.scrollBy(0,600)")
        await asyncio.sleep(1)
    
    # 提取商品 - 纯字符串方式避免序列化问题
    raw = await tab.evaluate("""
        Array.from(document.querySelectorAll('[class*="item"], [class*="card"], [class*="Card"]'))
            .filter(el => el.querySelector('[class*="title"], [class*="Title"], a[href*="item.taobao"]'))
            .map(el => {
                const t = el.querySelector('[class*="title"], [class*="Title"], a[href*="item.taobao"]');
                const p = el.querySelector('[class*="price"], [class*="Price"]');
                const i = el.querySelector('img[src*="alicdn"]');
                const s = el.querySelector('[class*="shop"], [class*="Shop"], [class*="nick"]');
                return JSON.stringify({
                    title: (t ? (t.textContent||t.getAttribute('title')||'') : '').trim().substring(0,100),
                    price: p ? p.textContent.trim() : '',
                    img: i ? i.src : '',
                    shop: s ? s.textContent.trim() : '',
                    url: t ? (t.href||'') : ''
                });
            })
            .filter(s => JSON.parse(s).title.length > 3)
            .join('\\n')
    """)
    
    products = []
    if raw:
        for line in raw.strip().split("\n"):
            try:
                products.append(json.loads(line))
            except:
                pass
    
    print(f"  {keyword}: {len(products)} 个商品")
    
    count = 0
    for item in products:
        title = item.get("title", "")
        if not title or title in seen:
            continue
        seen.add(title)
        
        all_products.append({
            "id": make_id(title, "淘宝"),
            "platform": "淘宝",
            "category": category,
            "title": title,
            "price": item.get("price", ""),
            "price_range": "",
            "image_url": item.get("img", ""),
            "description": "",
            "shop": item.get("shop", ""),
            "sales": "",
            "product_url": item.get("url", ""),
            "search_keyword": category,
            "crawl_time": NOW,
        })
        count += 1
    
    # 保存中间
    with open(os.path.join(TARGET, "bracelets_data_temp.json"), "w", encoding="utf-8") as f:
        json.dump({"products": all_products}, f, ensure_ascii=False, indent=2)
    print(f"  → 新增 {count} 条 (累计 {len(all_products)})")
    return len(products)

async def main():
    browser = await uc.start(
        browser_executable_path=CHROME,
        no_sandbox=True,
    )
    
    print("\n=== 淘宝商品采集开始 ===\n")
    
    for kw in CATEGORIES:
        try:
            await search_taobao(browser, kw, kw)
        except Exception as e:
            print(f"  {kw} 失败: {e}")
        await asyncio.sleep(2)
    
    # 关闭
    try:
        browser.stop()
    except:
        pass
    
    # 最终输出
    cats, plats = {}, {}
    for p in all_products:
        cats[p["category"]] = cats.get(p["category"], 0) + 1
        plats[p["platform"]] = plats.get(p["platform"], 0) + 1
    
    output = {
        "metadata": {
            "crawl_time": NOW,
            "total_count": len(all_products),
            "platforms": plats,
            "categories": cats,
        },
        "products": all_products,
    }
    
    with open(OUTPUT, "w", encoding="utf-8") as f:
        json.dump(output, f, ensure_ascii=False, indent=2)
    
    print(f"\n{'='*60}")
    print(f"完成! {len(all_products)} 条")
    print(f"平台: {plats}")
    print(f"品类: {cats}")

asyncio.run(main())
