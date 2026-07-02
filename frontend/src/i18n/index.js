const locales = ['en', 'zh', 'ja', 'ko', 'ru', 'fr', 'de']

const flags = { en: '🇺🇸', zh: '🇨🇳', ja: '🇯🇵', ko: '🇰🇷', ru: '🇷🇺', fr: '🇫🇷', de: '🇩🇪' }
const names = { en: 'English', zh: '中文', ja: '日本語', ko: '한국어', ru: 'Русский', fr: 'Français', de: 'Deutsch' }

let currentLang = localStorage.getItem('lang') || 'en'
const listeners = new Set()

export function getLang() { return currentLang }
export function setLang(l) {
  currentLang = l
  localStorage.setItem('lang', l)
  listeners.forEach(fn => fn())
}
export function onLangChange(fn) {
  listeners.add(fn)
  return () => listeners.delete(fn)
}

const t = {
  'home.title': { en: 'AURA', zh: 'AURA', ja: 'AURA', ko: 'AURA', ru: 'AURA', fr: 'AURA', de: 'AURA' },
  'home.tagline': { en: 'Handcrafted Energy Bracelets', zh: '手工能量手串', ja: '手作りエナジーブレスレット', ko: '수제 에너지 팔찌', ru: 'Энергетические браслеты ручной работы', fr: 'Bracelets Énergétiques Artisanaux', de: 'Handgefertigte Energie-Armbänder' },
  'home.shopCollection': { en: 'Shop Collection', zh: '选购系列', ja: 'コレクションを見る', ko: '컬렉션 쇼핑', ru: 'В коллекцию', fr: 'Voir la Collection', de: 'Kollektion entdecken' },
  'home.designYours': { en: 'Design Yours', zh: '设计你的', ja: '自分でデザイン', ko: '나만의 디자인', ru: 'Создать свой', fr: 'Créez le Vôtre', de: 'Eigenes Design' },
  'home.bestsellers': { en: 'Bestsellers', zh: '热销排行', ja: 'ベストセラー', ko: '베스트셀러', ru: 'Хиты продаж', fr: 'Meilleures Ventes', de: 'Bestseller' },
  'home.viewAll': { en: 'View All', zh: '查看全部', ja: 'すべて見る', ko: '전체 보기', ru: 'Смотреть все', fr: 'Voir Tout', de: 'Alle ansehen' },
  'home.categories': { en: 'Categories', zh: '分类', ja: 'カテゴリー', ko: '카테고리', ru: 'Категории', fr: 'Catégories', de: 'Kategorien' },
  'home.crystal': { en: 'Crystal', zh: '水晶', ja: 'クリスタル', ko: '크리스탈', ru: 'Кристалл', fr: 'Cristal', de: 'Kristall' },
  'home.jade': { en: 'Jade', zh: '玉石', ja: 'ヒスイ', ko: '비취', ru: 'Нефрит', fr: 'Jade', de: 'Jade' },
  'home.amber': { en: 'Amber', zh: '琥珀', ja: '琥珀', ko: '호박', ru: 'Янтарь', fr: 'Ambre', de: 'Bernstein' },
  'home.lava': { en: 'Lava', zh: '熔岩', ja: '溶岩', ko: '용암', ru: 'Лава', fr: 'Lave', de: 'Lava' },
  'home.discoverEnergy': { en: 'Discover Your Energy', zh: '发现你的能量', ja: 'あなたのエネルギーを知る', ko: '당신의 에너지를 발견하세요', ru: 'Откройте свою энергию', fr: 'Découvrez Votre Énergie', de: 'Entdecke deine Energie' },
  'home.energySubtitle': { en: 'AI-powered personality & elemental assessment', zh: 'AI 性格与五行评测', ja: 'AI性格・元素診断', ko: 'AI 성격 및 원소 평가', ru: 'AI-оценка личности и стихий', fr: 'Évaluation IA de la personnalité et des éléments', de: 'KI-gestützte Persönlichkeits- & Elementanalyse' },
  'home.startAssessment': { en: 'Start Assessment', zh: '开始评测', ja: '診断を開始', ko: '평가 시작', ru: 'Начать оценку', fr: 'Commencer', de: 'Bewertung starten' },

  'nav.shop': { en: 'Shop', zh: '商店', ja: 'ショップ', ko: '쇼핑', ru: 'Магазин', fr: 'Boutique', de: 'Shop' },
  'nav.designStudio': { en: 'Design Studio', zh: '设计工作室', ja: 'デザインスタジオ', ko: '디자인 스튜디오', ru: 'Дизайн-студия', fr: 'Studio de Design', de: 'Designstudio' },
  'nav.energy': { en: 'Energy', zh: '能量评估', ja: 'エネルギー', ko: '에너지', ru: 'Энергия', fr: 'Énergie', de: 'Energie' },
  'nav.cart': { en: 'Cart', zh: '购物车', ja: 'カート', ko: '장바구니', ru: 'Корзина', fr: 'Panier', de: 'Warenkorb' },
  'nav.profile': { en: 'Profile', zh: '我的', ja: 'プロフィール', ko: '프로필', ru: 'Профиль', fr: 'Profil', de: 'Profil' },
  'nav.lang': { en: 'Lang', zh: '语言', ja: '言語', ko: '언어', ru: 'Язык', fr: 'Langue', de: 'Sprache' },

  'products.title': { en: 'The Collection', zh: '全部产品', ja: 'コレクション', ko: '컬렉션', ru: 'Коллекция', fr: 'La Collection', de: 'Die Kollektion' },
  'products.subtitle': { en: 'Handpicked artisan bracelets for every energy', zh: '精选手工手串，匹配每种能量', ja: '厳選された職人ブレスレット', ko: '모든 에너지를 위한 수제 팔찌', ru: 'Браслеты ручной работы', fr: 'Bracelets artisanaux', de: 'Handverlesene Armbänder' },
  'products.search': { en: 'Search bracelets...', zh: '搜索手串...', ja: 'ブレスレットを検索...', ko: '팔찌 검색...', ru: 'Поиск браслетов...', fr: 'Rechercher...', de: 'Armbänder suchen...' },
  'products.all': { en: 'All', zh: '全部', ja: 'すべて', ko: '전체', ru: 'Все', fr: 'Tout', de: 'Alle' },
  'products.empty': { en: 'No products found', zh: '未找到产品', ja: '商品が見つかりません', ko: '제품이 없습니다', ru: 'Товары не найдены', fr: 'Aucun produit trouvé', de: 'Keine Produkte gefunden' },
  'products.addToCart': { en: 'Add to Cart', zh: '加入购物车', ja: 'カートに入れる', ko: '장바구니 담기', ru: 'В корзину', fr: 'Ajouter au Panier', de: 'In den Warenkorb' },
  'products.addedToCart': { en: 'Added to Cart', zh: '已加入购物车', ja: 'カートに追加しました', ko: '장바구니에 추가됨', ru: 'Добавлено в корзину', fr: 'Ajouté au Panier', de: 'Zum Warenkorb hinzugefügt' },
  'products.quantity': { en: 'Quantity', zh: '数量', ja: '数量', ko: '수량', ru: 'Количество', fr: 'Quantité', de: 'Menge' },
  'products.reviews': { en: 'Reviews', zh: '评价', ja: 'レビュー', ko: '리뷰', ru: 'Отзывы', fr: 'Avis', de: 'Bewertungen' },
  'products.designedBy': { en: 'Designed by', zh: '设计师', ja: 'デザイナー', ko: '디자이너', ru: 'Дизайнер', fr: 'Designé par', de: 'Designed von' },
  'products.designerCommission': { en: '2% of sale goes to designer', zh: '售价的2%归设计师', ja: '売上の2%がデザイナーへ', ko: '판매액의 2%가 디자이너에게', ru: '2% продажи дизайнеру', fr: '2% de la vente au designer', de: '2% des Verkaufserlöses an den Designer' },
  'products.youMayLike': { en: 'You May Also Like', zh: '猜你喜欢', ja: 'おすすめ', ko: '추천 상품', ru: 'Вам также может понравиться', fr: 'Vous Aimerez Aussi', de: 'Das könnte dir auch gefallen' },
  'products.defaultDescription': { en: 'Handcrafted with precision, each bead is selected for its unique energy properties. Ethically sourced and individually inspected to ensure the highest standard of quality and beauty.', zh: '精工制作，每颗珠子都因其独特的能量特性而精选。道德采购，逐个检查，确保最高品质与美感。', ja: '精密に作られ、各ビーズはそのユニークなエネルギー特性のために選ばれています。', ko: '정밀하게 제작된 각 구슬은 독특한 에너지 특성을 위해 선택되었습니다.', ru: 'Изготовлено с точностью, каждая бусина выбрана за её уникальные энергетические свойства.', fr: 'Fabriqué avec précision, chaque perle est sélectionnée pour ses propriétés énergétiques uniques.', de: 'Mit Präzision handgefertigt, jede Perle ist für ihre einzigartigen energetischen Eigenschaften ausgewählt.' },
  'products.loadMore': { en: 'Load More', zh: '加载更多', ja: 'もっと見る', ko: '더 보기', ru: 'Загрузить ещё', fr: 'Voir Plus', de: 'Mehr laden' },

  'product.addToCart': { en: 'Add to Cart', zh: '加入购物车', ja: 'カートに入れる', ko: '장바구니 담기', ru: 'В корзину', fr: 'Ajouter au Panier', de: 'In den Warenkorb' },
  'product.reviews': { en: 'Reviews', zh: '评价', ja: 'レビュー', ko: '리뷰', ru: 'Отзывы', fr: 'Avis', de: 'Bewertungen' },
  'product.youMayAlsoLike': { en: 'You May Also Like', zh: '猜你喜欢', ja: 'おすすめ', ko: '추천 상품', ru: 'Вам также может понравиться', fr: 'Vous Aimerez Aussi', de: 'Das könnte dir auch gefallen' },
  'product.buyItNow': { en: 'Buy It Now', zh: '立即购买', ja: '今すぐ買う', ko: '바로 구매', ru: 'Купить сейчас', fr: 'Acheter Maintenant', de: 'Jetzt kaufen' },

  'cart.title': { en: 'Cart', zh: '购物车', ja: 'カート', ko: '장바구니', ru: 'Корзина', fr: 'Panier', de: 'Warenkorb' },
  'cart.empty': { en: 'Your cart is empty', zh: '购物车是空的', ja: 'カートは空です', ko: '장바구니가 비었습니다', ru: 'Корзина пуста', fr: 'Votre panier est vide', de: 'Ihr Warenkorb ist leer' },
  'cart.emptySubtitle': { en: 'Browse products or design your own', zh: '浏览产品或自己设计', ja: '商品を見るか自分でデザイン', ko: '제품을 둘러보거나 직접 디자인하세요', ru: 'Посмотрите товары или создайте свой', fr: 'Parcourez ou créez le vôtre', de: 'Produkte durchstöbern oder eigenes Design' },
  'cart.custom': { en: 'Custom', zh: '定制', ja: 'カスタム', ko: '커스텀', ru: 'Кастомный', fr: 'Personnalisé', de: 'Individuell' },
  'cart.product': { en: 'Product', zh: '商品', ja: '商品', ko: '제품', ru: 'Товар', fr: 'Produit', de: 'Produkt' },
  'cart.total': { en: 'Total', zh: '合计', ja: '合計', ko: '합계', ru: 'Итого', fr: 'Total', de: 'Gesamtsumme' },
  'cart.checkout': { en: 'Checkout', zh: '结算', ja: 'レジに進む', ko: '결제', ru: 'Оформить заказ', fr: 'Commander', de: 'Zur Kasse' },

  'order.title': { en: 'Checkout', zh: '结算', ja: 'レジに進む', ko: '결제', ru: 'Оформление', fr: 'Commander', de: 'Zur Kasse' },
  'order.orderConfirmed': { en: 'Order Confirmed', zh: '订单确认', ja: '注文確定', ko: '주문 확인', ru: 'Заказ подтверждён', fr: 'Commande Confirmée', de: 'Bestellung bestätigt' },
  'order.orderPlaced': { en: 'Order Placed!', zh: '下单成功！', ja: '注文完了！', ko: '주문 완료!', ru: 'Заказ размещён!', fr: 'Commande Passée !', de: 'Bestellung aufgegeben!' },
  'order.orderId': { en: 'Order ID', zh: '订单号', ja: '注文番号', ko: '주문번호', ru: 'ID заказа', fr: 'ID Commande', de: 'Bestellnummer' },
  'order.total': { en: 'Total', zh: '总计', ja: '合計', ko: '합계', ru: 'Итого', fr: 'Total', de: 'Gesamt' },
  'order.shippingNotice': { en: "We'll process your payment and notify you when it ships.", zh: '我们将处理付款并在发货时通知您。', ja: 'お支払いを処理し、発送時にご連絡します。', ko: '결제를 처리하고 배송 시 알려드립니다.', ru: 'Мы обработаем платёж и уведомим вас об отправке.', fr: 'Nous traitons le paiement et vous informons de l\'expédition.', de: 'Wir bearbeiten die Zahlung und benachrichtigen Sie bei Versand.' },
  'order.backToShop': { en: 'Back to Shop', zh: '返回商店', ja: 'ショップに戻る', ko: '쇼핑으로 돌아가기', ru: 'В магазин', fr: 'Retour à la Boutique', de: 'Zurück zum Shop' },
  'order.summary': { en: 'Order Summary', zh: '订单摘要', ja: '注文概要', ko: '주문 요약', ru: 'Сводка заказа', fr: 'Récapitulatif', de: 'Bestellübersicht' },
  'order.shippingInfo': { en: 'Shipping Information', zh: '收货信息', ja: '配送情報', ko: '배송 정보', ru: 'Информация о доставке', fr: 'Informations de Livraison', de: 'Versandinformationen' },
  'order.email': { en: 'Email *', zh: '邮箱 *', ja: 'メールアドレス *', ko: '이메일 *', ru: 'Email *', fr: 'Email *', de: 'E-Mail *' },
  'order.fullName': { en: 'Full Name *', zh: '姓名 *', ja: '氏名 *', ko: '성명 *', ru: 'ФИО *', fr: 'Nom Complet *', de: 'Vollständiger Name *' },
  'order.address': { en: 'Address *', zh: '地址 *', ja: '住所 *', ko: '주소 *', ru: 'Адрес *', fr: 'Adresse *', de: 'Adresse *' },
  'order.city': { en: 'City *', zh: '城市 *', ja: '市区町村 *', ko: '도시 *', ru: 'Город *', fr: 'Ville *', de: 'Stadt *' },
  'order.state': { en: 'State', zh: '州/省', ja: '都道府県', ko: '주/도', ru: 'Регион', fr: 'État/Région', de: 'Bundesland' },
  'order.zip': { en: 'ZIP *', zh: '邮编 *', ja: '郵便番号 *', ko: '우편번호 *', ru: 'Почтовый индекс *', fr: 'Code Postal *', de: 'PLZ *' },
  'order.country': { en: 'Country', zh: '国家', ja: '国', ko: '국가', ru: 'Страна', fr: 'Pays', de: 'Land' },
  'order.phone': { en: 'Phone (optional)', zh: '电话（选填）', ja: '電話番号（任意）', ko: '전화번호 (선택)', ru: 'Телефон (опционально)', fr: 'Téléphone (optionnel)', de: 'Telefon (optional)' },
  'order.required': { en: 'Required', zh: '必填', ja: '必須', ko: '필수', ru: 'Обязательно', fr: 'Requis', de: 'Erforderlich' },
  'order.placeOrder': { en: 'Place Order', zh: '提交订单', ja: '注文を確定', ko: '주문하기', ru: 'Разместить заказ', fr: 'Passer Commande', de: 'Bestellung aufgeben' },
  'order.failed': { en: 'Order creation failed', zh: '订单创建失败', ja: '注文作成に失敗しました', ko: '주문 생성 실패', ru: 'Не удалось создать заказ', fr: 'Échec de la commande', de: 'Bestellung fehlgeschlagen' },
  'order.contactSupport': { en: 'Order created but payment setup failed. Contact support.', zh: '订单已创建但支付设置失败，请联系客服。', ja: '注文は作成されましたが支払い設定に失敗しました。サポートにお問い合わせください。', ko: '주문이 생성되었지만 결제 설정에 실패했습니다. 고객 지원에 문의하세요.', ru: 'Заказ создан, но настройка оплаты не удалась. Обратитесь в поддержку.', fr: 'Commande créée mais échec du paiement. Contactez le support.', de: 'Bestellung erstellt, aber Zahlungseinrichtung fehlgeschlagen. Support kontaktieren.' },
  'order.paymentSuccess': { en: 'Payment Successful!', zh: '支付成功！', ja: '支払い完了！', ko: '결제 성공!', ru: 'Оплата успешна!', fr: 'Paiement Réussi !', de: 'Zahlung erfolgreich!' },
  'order.paymentCancelled': { en: 'Payment Cancelled', zh: '支付取消', ja: '支払いキャンセル', ko: '결제 취소됨', ru: 'Оплата отменена', fr: 'Paiement Annulé', de: 'Zahlung abgebrochen' },
  'order.paymentSuccessSub': { en: 'Your order has been placed successfully.', zh: '您的订单已成功提交。', ja: 'ご注文が完了しました。', ko: '주문이 성공적으로 접수되었습니다.', ru: 'Ваш заказ успешно размещён.', fr: 'Votre commande a été passée avec succès.', de: 'Ihre Bestellung wurde erfolgreich aufgegeben.' },
  'order.paymentCancelledSub': { en: 'The payment was cancelled or failed.', zh: '支付被取消或失败。', ja: '支払いがキャンセルまたは失敗しました。', ko: '결제가 취소되거나 실패했습니다.', ru: 'Платёж был отменён или не удался.', fr: 'Le paiement a été annulé ou a échoué.', de: 'Die Zahlung wurde abgebrochen oder ist fehlgeschlagen.' },

  'designer.title': { en: 'Design Studio', zh: '设计工作室', ja: 'デザインスタジオ', ko: '디자인 스튜디오', ru: 'Дизайн-студия', fr: 'Studio de Design', de: 'Designstudio' },
  'designer.tapToStart': { en: 'Tap elements below to add to your bracelet', zh: '点击下方元素添加到手串', ja: '下の要素をタップして追加', ko: '아래 요소를 탭하여 팔찌에 추가하세요', ru: 'Нажмите на элементы ниже, чтобы добавить', fr: 'Appuyez sur les éléments pour ajouter', de: 'Tippe auf Elemente, um hinzuzufügen' },
  'designer.designName': { en: 'Design Name', zh: '设计名称', ja: 'デザイン名', ko: '디자인 이름', ru: 'Название дизайна', fr: 'Nom du Design', de: 'Design-Name' },
  'designer.elements': { en: 'elements', zh: '个元素', ja: '個の要素', ko: '개 요소', ru: 'элементов', fr: 'éléments', de: 'Elemente' },
  'designer.stringBand': { en: 'STRING / BAND', zh: '串绳 / 手链', ja: 'コード / バンド', ko: '끈 / 밴드', ru: 'ШНУР / ОСНОВА', fr: 'CORDON / LIEN', de: 'BAND / KORDEL' },
  'designer.none': { en: 'None', zh: '无', ja: 'なし', ko: '없음', ru: 'Нет', fr: 'Aucun', de: 'Keins' },
  'designer.beads': { en: 'Beads', zh: '珠子', ja: 'ビーズ', ko: '구슬', ru: 'Бусины', fr: 'Perles', de: 'Perlen' },
  'designer.charms': { en: 'Charms', zh: '挂件', ja: 'チャーム', ko: '참', ru: 'Подвески', fr: 'Charms', de: 'Charms' },
  'designer.pendants': { en: 'Pendants', zh: '吊坠', ja: 'ペンダント', ko: '펜던트', ru: 'Кулоны', fr: 'Pendentifs', de: 'Anhänger' },
  'designer.spacers': { en: 'Spacers', zh: '隔珠', ja: 'スペーサー', ko: '스페이서', ru: 'Распорки', fr: 'Entretoises', de: 'Abstandshalter' },
  'designer.clasps': { en: 'Clasps', zh: '搭扣', ja: '留め金', ko: '잠금장치', ru: 'Замки', fr: 'Fermoirs', de: 'Verschlüsse' },
  'designer.string': { en: 'String', zh: '串绳', ja: 'コード', ko: '끈', ru: 'Шнур', fr: 'Cordon', de: 'Kordel' },
  'designer.noElements': { en: 'No elements available', zh: '暂无元素', ja: '利用可能な要素がありません', ko: '사용 가능한 요소가 없습니다', ru: 'Нет доступных элементов', fr: 'Aucun élément disponible', de: 'Keine Elemente verfügbar' },
  'designer.inDesign': { en: 'in design', zh: '设计中', ja: 'デザイン中', ko: '디자인 중', ru: 'в дизайне', fr: 'dans le design', de: 'im Design' },
  'designer.save': { en: 'Save', zh: '保存', ja: '保存', ko: '저장', ru: 'Сохранить', fr: 'Enregistrer', de: 'Speichern' },
  'designer.update': { en: 'Update', zh: '更新', ja: '更新', ko: '업데이트', ru: 'Обновить', fr: 'Mettre à Jour', de: 'Aktualisieren' },
  'designer.saving': { en: 'Saving...', zh: '保存中...', ja: '保存中...', ko: '저장 중...', ru: 'Сохранение...', fr: 'Enregistrement...', de: 'Speichern...' },
  'designer.publish': { en: 'Publish', zh: '发布', ja: '公開', ko: '출시', ru: 'Опубликовать', fr: 'Publier', de: 'Veröffentlichen' },
  'designer.reorderHint': { en: 'Long-press a bead to remove. Use arrows to reorder.', zh: '长按珠子删除，箭头调整顺序。', ja: '長押しで削除、矢印で並び替え。', ko: '길게 눌러 제거, 화살표로 순서 변경.', ru: 'Долгое нажатие — удалить, стрелки — переместить.', fr: 'Appui long pour supprimer, flèches pour réorganiser.', de: 'Langes Drücken zum Entfernen, Pfeile zum Sortieren.' },
  'designer.clear': { en: 'Clear design', zh: '清空设计', ja: 'デザインをクリア', ko: '디자인 지우기', ru: 'Очистить дизайн', fr: 'Effacer le design', de: 'Design löschen' },
  'designer.published': { en: 'Design published! Others can now buy it.', zh: '设计已发布！其他人可以购买。', ja: 'デザインを公開しました！他の人が購入できます。', ko: '디자인이 게시되었습니다! 다른 사람들이 구매할 수 있습니다.', ru: 'Дизайн опубликован! Другие могут его купить.', fr: 'Design publié ! D\'autres peuvent l\'acheter.', de: 'Design veröffentlicht! Andere können es jetzt kaufen.' },
  'designer.saved': { en: 'Design saved!', zh: '设计已保存！', ja: 'デザインを保存しました！', ko: '디자인이 저장되었습니다!', ru: 'Дизайн сохранён!', fr: 'Design enregistré !', de: 'Design gespeichert!' },
  'designer.addElement': { en: 'Add at least one element to your bracelet', zh: '至少添加一个元素到手串', ja: '少なくとも1つの要素を追加してください', ko: '팔찌에 최소 하나의 요소를 추가하세요', ru: 'Добавьте хотя бы один элемент', fr: 'Ajoutez au moins un élément', de: 'Füge mindestens ein Element hinzu' },
  'designer.copyrightTitle': { en: 'Design Copyright Agreement', zh: '设计版权协议', ja: 'デザイン著作権契約', ko: '디자인 저작권 계약', ru: 'Авторское соглашение', fr: 'Accord de droits d\'auteur', de: 'Urheberrechtsvereinbarung' },
  'designer.copyrightText1': { en: 'By publishing this design, you agree that:', zh: '发布此设计即表示您同意：', ja: 'このデザインを公開することにより、以下に同意します：', ko: '이 디자인을 게시함으로써 다음에 동의합니다:', ru: 'Публикуя этот дизайн, вы соглашаетесь с тем, что:', fr: 'En publiant ce design, vous acceptez que:', de: 'Durch die Veröffentlichung dieses Designs stimmst du zu:' },
  'designer.copyright1': { en: 'The copyright of this design belongs to you as the author.', zh: '此设计的著作权归您所有。', ja: 'このデザインの著作権はあなたに帰属します。', ko: '이 디자인의 저작권은 작성자에게 있습니다.', ru: 'Авторские права на этот дизайн принадлежат вам.', fr: 'Les droits d\'auteur de ce design vous appartiennent.', de: 'Das Urheberrecht dieses Designs gehört Ihnen.' },
  'designer.copyright2': { en: 'The platform is authorized to produce and sell this design.', zh: '平台被授权生产和销售此设计。', ja: 'プラットフォームはこのデザインの製造と販売を許可されています。', ko: '플랫폼은 이 디자인의 제작 및 판매 권한을 가집니다.', ru: 'Платформа уполномочена производить и продавать этот дизайн.', fr: 'La plateforme est autorisée à produire et vendre ce design.', de: 'Die Plattform ist berechtigt, dieses Design herzustellen und zu verkaufen.' },
  'designer.copyright3': { en: 'You will receive a commission for each sale of your design.', zh: '您将在每次销售中获得佣金。', ja: '販売ごとに報酬を受け取ります。', ko: '판매 시마다 수수료를 받게 됩니다.', ru: 'Вы будете получать комиссию за каждую продажу.', fr: 'Vous recevrez une commission pour chaque vente.', de: 'Sie erhalten eine Provision für jeden Verkauf.' },
  'designer.copyright4': { en: 'This agreement cannot be revoked once published.', zh: '发布后此协议不可撤销。', ja: '一度公開すると、この契約を取り消すことはできません。', ko: '게시 후 이 계약은 취소할 수 없습니다.', ru: 'После публикации это соглашение не может быть отозвано.', fr: 'Cet accord ne peut pas être révoqué après publication.', de: 'Diese Vereinbarung kann nach Veröffentlichung nicht widerrufen werden.' },
  'designer.copyrightAccept': { en: 'I understand and agree to these terms', zh: '我理解并同意以上条款', ja: '上記の条件を理解し同意します', ko: '위 조건을 이해하고 동의합니다', ru: 'Я понимаю и соглашаюсь с этими условиями', fr: 'Je comprends et accepte ces conditions', de: 'Ich verstehe und stimme diesen Bedingungen zu' },
  'designer.confirmPublish': { en: 'Confirm & Publish', zh: '确认发布', ja: '確認して公開', ko: '확인 및 게시', ru: 'Подтвердить и опубликовать', fr: 'Confirmer & Publier', de: 'Bestätigen & Veröffentlichen' },
  'terms.title': { en: 'Terms of Service', zh: '服务条款', ja: '利用規約', ko: '이용약관', ru: 'Условия обслуживания', fr: "Conditions d'utilisation", de: 'Nutzungsbedingungen' },
  'terms.copyright': { en: 'Design Copyright & License', zh: '设计版权与授权', ja: 'デザイン著作権とライセンス', ko: '디자인 저작권 및 라이선스', ru: 'Авторские права и лицензия', fr: 'Droits d\'auteur et licence', de: 'Urheberrecht & Lizenz' },
  'terms.copyrightP1': { en: 'When you publish a design on AURA, you retain full copyright ownership. You grant AURA a non-exclusive, worldwide, royalty-bearing license to manufacture and sell the design.', zh: '当您在AURA发布设计时，您保留完整的著作权。您授予AURA非独占的、全球范围的、带版税的生产销售许可。', ja: 'AURAでデザインを公開する場合、完全な著作権を保持します。AURAに非独占的、世界的、ロイヤリティ付きの製造販売ライセンスを付与します。', ko: 'AURA에 디자인을 게시할 때, 완전한 저작권을 보유합니다. AURA에 비독점적, 전 세계적, 로열티 기반의 제조 및 판매 라이선스를 부여합니다.', ru: 'Публикуя дизайн на AURA, вы сохраняете полное авторское право. Вы предоставляете AURA неисключительную, всемирную лицензию с выплатой роялти.', fr: 'Lorsque vous publiez un design sur AURA, vous conservez l\'intégralité des droits d\'auteur. Vous accordez à AURA une licence non exclusive, mondiale, avec redevance.', de: 'Wenn Sie ein Design auf AURA veröffentlichen, behalten Sie das vollständige Urheberrecht. Sie gewähren AURA eine nicht-exklusive, weltweite, lizenzgebührenpflichtige Lizenz.' },
  'terms.copyrightP2': { en: 'The commission you earn on each sale constitutes the license fee. By publishing, you acknowledge this arrangement.', zh: '您每次销售获得的佣金即构成授权费用。发布即表示您认可此安排。', ja: '販売ごとに得られる報酬がライセンス料となります。公開することでこの取り決めを承認します。', ko: '각 판매에서 얻는 수수료가 라이선스 비용을 구성합니다. 게시함으로써 이 약정을 인정합니다.', ru: 'Комиссия, которую вы получаете с каждой продажи, составляет лицензионный платеж. Публикуя, вы подтверждаете эту договоренность.', fr: 'La commission que vous percevez sur chaque vente constitue les frais de licence. En publiant, vous reconnaissez cet accord.', de: 'Die Provision, die Sie bei jedem Verkauf erhalten, stellt die Lizenzgebühr dar. Mit der Veröffentlichung bestätigen Sie diese Vereinbarung.' },
  'common.back': { en: 'Back', zh: '返回', ja: '戻る', ko: '뒤로', ru: 'Назад', fr: 'Retour', de: 'Zurück' },

  'energy.title': { en: 'Energy Assessment', zh: '能量评估', ja: 'エネルギー診断', ko: '에너지 평가', ru: 'Оценка энергии', fr: 'Évaluation Énergétique', de: 'Energie-Bewertung' },
  'energy.discover': { en: 'Discover Your Energy', zh: '发现你的能量', ja: 'あなたのエネルギーを知る', ko: '당신의 에너지를 발견하세요', ru: 'Откройте свою энергию', fr: 'Découvrez Votre Énergie', de: 'Entdecke deine Energie' },
  'energy.subtitle': { en: 'Tell us about yourself for a personalized energy bracelet recommendation', zh: '告诉我们关于你，获得个性化能量手串推荐', ja: 'あなたの情報を教えて、パーソナライズされたおすすめを', ko: '자신에 대해 알려주시면 맞춤 에너지 팔찌를 추천해드립니다', ru: 'Расскажите о себе для персональной рекомендации', fr: 'Parlez-nous de vous pour une recommandation personnalisée', de: 'Erzähle uns von dir für eine persönliche Empfehlung' },
  'energy.birthDate': { en: 'Birth Date (YYYY-MM-DD, optional)', zh: '出生日期（YYYY-MM-DD，选填）', ja: '生年月日（YYYY-MM-DD、任意）', ko: '생년월일 (YYYY-MM-DD, 선택)', ru: 'Дата рождения (ГГГГ-ММ-ДД, опционально)', fr: 'Date de Naissance (AAAA-MM-JJ, optionnel)', de: 'Geburtsdatum (JJJJ-MM-TT, optional)' },
  'energy.zodiac': { en: 'Zodiac Sign', zh: '星座', ja: '星座', ko: '별자리', ru: 'Знак зодиака', fr: 'Signe Astrologique', de: 'Sternzeichen' },
  'energy.element': { en: 'Preferred Element', zh: '偏好五行', ja: '希望の元素', ko: '선호 원소', ru: 'Предпочитаемая стихия', fr: 'Élément Préféré', de: 'Bevorzugtes Element' },
  'energy.concerns': { en: 'Concerns or Goals', zh: '关注或目标', ja: '悩みや目標', ko: '고민 또는 목표', ru: 'Проблемы или цели', fr: 'Préoccupations ou Objectifs', de: 'Anliegen oder Ziele' },
  'energy.concernsHint': { en: 'e.g., stress relief, focus, better sleep...', zh: '例如：减压、专注、改善睡眠...', ja: '例：ストレス緩和、集中力、睡眠改善...', ko: '예: 스트레스 해소, 집중력, 수면 개선...', ru: 'например: снятие стресса, фокус, сон...', fr: 'ex.: réduction du stress, concentration, sommeil...', de: 'z.B. Stressabbau, Konzentration, besserer Schlaf...' },
  'energy.lifestyle': { en: 'Lifestyle & Habits', zh: '生活方式与习惯', ja: 'ライフスタイルと習慣', ko: '라이프스타일 및 습관', ru: 'Образ жизни и привычки', fr: 'Mode de Vie & Habitudes', de: 'Lebensstil & Gewohnheiten' },
  'energy.lifestyleHint': { en: 'e.g., active, desk job, creative work...', zh: '例如：活跃、久坐办公、创意工作...', ja: '例：アクティブ、デスクワーク、クリエイティブ...', ko: '예: 활동적, 사무직, 창의적 작업...', ru: 'например: активный, офисная работа, творчество...', fr: 'ex.: actif, travail de bureau, créatif...', de: 'z.B. aktiv, Schreibtischjob, kreative Arbeit...' },
  'energy.start': { en: 'Start Assessment', zh: '开始评估', ja: '診断開始', ko: '평가 시작', ru: 'Начать оценку', fr: 'Commencer', de: 'Bewertung starten' },
  'energy.selectZodiac': { en: 'Please select your zodiac sign', zh: '请选择星座', ja: '星座を選択してください', ko: '별자리를 선택하세요', ru: 'Выберите знак зодиака', fr: 'Sélectionnez votre signe', de: 'Bitte wähle dein Sternzeichen' },
  'energy.selectElement': { en: 'Please select your preferred element', zh: '请选择偏好元素', ja: '元素を選択してください', ko: '선호 원소를 선택하세요', ru: 'Выберите предпочитаемую стихию', fr: 'Sélectionnez votre élément', de: 'Bitte wähle dein bevorzugtes Element' },
  'energy.failed': { en: 'Assessment failed', zh: '评估失败', ja: '診断に失敗しました', ko: '평가 실패', ru: 'Оценка не удалась', fr: 'Évaluation échouée', de: 'Bewertung fehlgeschlagen' },
  'energy.noResults': { en: 'No recommendations available.', zh: '暂无推荐。', ja: '推奨はありません。', ko: '추천이 없습니다.', ru: 'Нет рекомендаций.', fr: 'Aucune recommandation.', de: 'Keine Empfehlungen verfügbar.' },
  'energy.profile': { en: 'Your Energy Profile', zh: '你的能量档案', ja: 'あなたのエネルギープロフィール', ko: '당신의 에너지 프로필', ru: 'Ваш энергетический профиль', fr: 'Votre Profil Énergétique', de: 'Dein Energie-Profil' },
  'energy.profileSub': { en: 'Personalized recommendations based on your inputs', zh: '基于你输入信息的个性化推荐', ja: 'あなたの入力に基づくパーソナライズされた推奨', ko: '입력 정보를 기반으로 한 맞춤 추천', ru: 'Персональные рекомендации на основе ваших данных', fr: 'Recommandations personnalisées', de: 'Personalisierte Empfehlungen' },
  'energy.colors': { en: 'Recommended Colors', zh: '推荐颜色', ja: 'おすすめの色', ko: '추천 색상', ru: 'Рекомендуемые цвета', fr: 'Couleurs Recommandées', de: 'Empfohlene Farben' },
  'energy.materials': { en: 'Recommended Materials', zh: '推荐材质', ja: 'おすすめの素材', ko: '추천 소재', ru: 'Рекомендуемые материалы', fr: 'Matériaux Recommandés', de: 'Empfohlene Materialien' },
  'energy.crystals': { en: 'Crystal Suggestions', zh: '水晶建议', ja: 'クリスタル提案', ko: '크리스탈 추천', ru: 'Рекомендации кристаллов', fr: 'Suggestions de Cristaux', de: 'Kristall-Vorschläge' },
  'energy.tryAgain': { en: 'Try Another Assessment', zh: '重新评估', ja: 'もう一度診断', ko: '다시 평가하기', ru: 'Попробовать снова', fr: 'Réessayer', de: 'Erneut bewerten' },

  'login.signIn': { en: 'Sign In', zh: '登录', ja: 'ログイン', ko: '로그인', ru: 'Войти', fr: 'Connexion', de: 'Anmelden' },
  'login.register': { en: 'Create Account', zh: '创建账号', ja: 'アカウント作成', ko: '계정 만들기', ru: 'Создать аккаунт', fr: 'Créer un Compte', de: 'Konto erstellen' },
  'login.email': { en: 'Email', zh: '邮箱', ja: 'メール', ko: '이메일', ru: 'Email', fr: 'Email', de: 'E-Mail' },
  'login.password': { en: 'Password', zh: '密码', ja: 'パスワード', ko: '비밀번호', ru: 'Пароль', fr: 'Mot de passe', de: 'Passwort' },

  'profile.title': { en: 'Profile', zh: '我的', ja: 'プロフィール', ko: '프로필', ru: 'Профиль', fr: 'Profil', de: 'Profil' },
  'profile.orders': { en: 'Orders', zh: '订单', ja: '注文履歴', ko: '주문', ru: 'Заказы', fr: 'Commandes', de: 'Bestellungen' },
  'profile.noOrders': { en: 'No orders yet', zh: '暂无订单', ja: '注文がありません', ko: '주문이 없습니다', ru: 'Пока нет заказов', fr: 'Aucune commande', de: 'Keine Bestellungen' },
  'profile.myDesigns': { en: 'My Designs', zh: '我的设计', ja: 'マイデザイン', ko: '내 디자인', ru: 'Мои дизайны', fr: 'Mes Designs', de: 'Meine Designs' },
  'profile.noDesigns': { en: "No designs yet. Go design something!", zh: '还没有设计，去设计一个吧！', ja: 'まだデザインがありません。デザインしてみよう！', ko: '아직 디자인이 없습니다. 디자인해보세요!', ru: 'Пока нет дизайнов. Создайте что-нибудь!', fr: 'Pas encore de designs. Créez-en un !', de: 'Noch keine Designs. Erstelle etwas!' },
  'profile.signOut': { en: 'Sign Out', zh: '退出', ja: 'サインアウト', ko: '로그아웃', ru: 'Выйти', fr: 'Déconnexion', de: 'Abmelden' },
  'profile.admin': { en: 'Admin', zh: '管理', ja: '管理', ko: '관리', ru: 'Админ', fr: 'Admin', de: 'Admin' },
  'profile.designerEarnings': { en: 'Designer Earnings', zh: '设计师收益', ja: 'デザイナー収入', ko: '디자이너 수익', ru: 'Заработок дизайнера', fr: 'Revenus Designer', de: 'Designer-Verdienst' },
  'profile.totalEarned': { en: 'Total Earned', zh: '总收入', ja: '総収入', ko: '총 수익', ru: 'Всего заработано', fr: 'Total Gagné', de: 'Gesamt verdient' },
  'profile.pending': { en: 'Pending', zh: '待结算', ja: '保留中', ko: '대기 중', ru: 'В ожидании', fr: 'En Attente', de: 'Ausstehend' },
  'profile.designsSold': { en: 'Designs Sold', zh: '已售设计', ja: '販売デザイン数', ko: '판매된 디자인', ru: 'Продано дизайнов', fr: 'Designs Vendus', de: 'Verkaufte Designs' },
  'profile.editTitle': { en: 'Edit Profile', zh: '编辑资料', ja: 'プロフィール編集', ko: '프로필 편집', ru: 'Редактировать профиль', fr: 'Modifier le Profil', de: 'Profil bearbeiten' },
  'profile.bio': { en: 'Bio', zh: '简介', ja: '自己紹介', ko: '소개', ru: 'О себе', fr: 'Bio', de: 'Bio' },
  'profile.cancel': { en: 'Cancel', zh: '取消', ja: 'キャンセル', ko: '취소', ru: 'Отмена', fr: 'Annuler', de: 'Abbrechen' },
  'profile.save': { en: 'Save', zh: '保存', ja: '保存', ko: '저장', ru: 'Сохранить', fr: 'Enregistrer', de: 'Speichern' },
  'profile.language': { en: 'Language', zh: '语言', ja: '言語', ko: '언어', ru: 'Язык', fr: 'Langue', de: 'Sprache' },

  'general.loading': { en: 'Loading...', zh: '加载中...', ja: '読み込み中...', ko: '로딩 중...', ru: 'Загрузка...', fr: 'Chargement...', de: 'Laden...' },
}

export function tr(key, lang) {
  const l = lang || currentLang
  const v = t[key]?.[l] || t[key]?.['en']
  return v || ''
}

export { locales, flags, names }
