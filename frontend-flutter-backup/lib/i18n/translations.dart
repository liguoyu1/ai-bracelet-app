import 'package:flutter/material.dart';

/// Supported languages
enum AppLocale {
  en('English', '🇬🇧', 'USD', r'$'),
  zh('中文', '🇨🇳', 'CNY', '¥'),
  ja('日本語', '🇯🇵', 'JPY', '¥'),
  ko('한국어', '🇰🇷', 'KRW', '₩'),
  ru('Русский', '🇷🇺', 'RUB', '₽'),
  fr('Français', '🇫🇷', 'EUR', '€'),
  de('Deutsch', '🇩🇪', 'EUR', '€');

  final String label;
  final String flag;
  final String currencyCode;
  final String currencySymbol;
  const AppLocale(this.label, this.flag, this.currencyCode, this.currencySymbol);

  Locale get flutterLocale {
    switch (this) {
      case AppLocale.en: return const Locale('en');
      case AppLocale.zh: return const Locale('zh');
      case AppLocale.ja: return const Locale('ja');
      case AppLocale.ko: return const Locale('ko');
      case AppLocale.ru: return const Locale('ru');
      case AppLocale.fr: return const Locale('fr');
      case AppLocale.de: return const Locale('de');
    }
  }
}

/// Translation map: key → per-locale strings
typedef TranslationMap = Map<AppLocale, String>;

class Translations {
  static Translations? _instance;
  static Translations get I => _instance!;

  AppLocale _locale = AppLocale.en;
  AppLocale get locale => _locale;
  set locale(AppLocale v) => _locale = v;

  Translations._();

  static Translations init(AppLocale locale) {
    _instance = Translations._().._locale = locale;
    return _instance!;
  }

  String t(String key) => _all[key]?[_locale] ?? _all[key]?[AppLocale.en] ?? key;

  // Convenience
  String get navShop => t('nav.shop');
  String get navDesignStudio => t('nav.designStudio');
  String get navEnergy => t('nav.energy');
  String get navCart => t('nav.cart');
  String get navProfile => t('nav.profile');

  String get homeTitle => t('home.title');
  String get homeTagline => t('home.tagline');
  String get homeShopCollection => t('home.shopCollection');
  String get homeDesignYours => t('home.designYours');
  String get homeBestsellers => t('home.bestsellers');
  String get homeViewAll => t('home.viewAll');
  String get homeCategories => t('home.categories');
  String get homeCrystal => t('home.crystal');
  String get homeJade => t('home.jade');
  String get homeAmber => t('home.amber');
  String get homeLava => t('home.lava');
  String get homeDiscoverEnergy => t('home.discoverEnergy');
  String get homeEnergySubtitle => t('home.energySubtitle');
  String get homeStartAssessment => t('home.startAssessment');
  String get homeFromCommunity => t('home.fromCommunity');

  String get productsTitle => t('products.title');
  String get productsSubtitle => t('products.subtitle');
  String get productsSearch => t('products.search');
  String get productsAll => t('products.all');
  String get productsEmpty => t('products.empty');
  String get productsAddToCart => t('products.addToCart');
  String get productsAddedToCart => t('products.addedToCart');
  String get productsQuantity => t('products.quantity');
  String get productsReviews => t('products.reviews');
  String get productsDesignedBy => t('products.designedBy');
  String get productsDesignerCommission => t('products.designerCommission');
  String get productsYouMayLike => t('products.youMayLike');
  String get productsDefaultDescription => t('products.defaultDescription');

  String get cartTitle => t('cart.title');
  String get cartEmpty => t('cart.empty');
  String get cartEmptySubtitle => t('cart.emptySubtitle');
  String get cartCustom => t('cart.custom');
  String get cartProduct => t('cart.product');
  String get cartTotal => t('cart.total');
  String get cartCheckout => t('cart.checkout');

  String get orderOrderConfirmed => t('order.orderConfirmed');
  String get orderOrderPlaced => t('order.orderPlaced');
  String get orderOrderId => t('order.orderId');
  String get orderTotal => t('order.total');
  String get orderShippingNotice => t('order.shippingNotice');
  String get orderBackToShop => t('order.backToShop');
  String get orderSummary => t('order.summary');
  String get orderShippingInfo => t('order.shippingInfo');
  String get orderEmail => t('order.email');
  String get orderFullName => t('order.fullName');
  String get orderAddress => t('order.address');
  String get orderCity => t('order.city');
  String get orderState => t('order.state');
  String get orderZip => t('order.zip');
  String get orderCountry => t('order.country');
  String get orderPhone => t('order.phone');
  String get orderRequired => t('order.required');
  String get orderPlaceOrder => t('order.placeOrder');
  String get orderFailed => t('order.failed');
  String get orderContactSupport => t('order.contactSupport');
  String get orderPaymentSuccess => t('order.paymentSuccess');
  String get orderPaymentCancelled => t('order.paymentCancelled');
  String get orderPaymentSuccessSub => t('order.paymentSuccessSub');
  String get orderPaymentCancelledSub => t('order.paymentCancelledSub');

  String get designerTitle => t('designer.title');
  String get designerTapToStart => t('designer.tapToStart');
  String get designerDesignName => t('designer.designName');
  String get designerElements => t('designer.elements');
  String get designerStringBand => t('designer.stringBand');
  String get designerNone => t('designer.none');
  String get designerBeads => t('designer.beads');
  String get designerCharms => t('designer.charms');
  String get designerPendants => t('designer.pendants');
  String get designerSpacers => t('designer.spacers');
  String get designerClasps => t('designer.clasps');
  String get designerString => t('designer.string');
  String get designerNoElements => t('designer.noElements');
  String get designerInDesign => t('designer.inDesign');
  String get designerSave => t('designer.save');
  String get designerUpdate => t('designer.update');
  String get designerSaving => t('designer.saving');
  String get designerPublish => t('designer.publish');
  String get designerReorderHint => t('designer.reorderHint');
  String get designerClear => t('designer.clear');
  String get designerPublished => t('designer.published');
  String get designerSaved => t('designer.saved');
  String get designerAddElement => t('designer.addElement');

  String get energyTitle => t('energy.title');
  String get energyDiscover => t('energy.discover');
  String get energySubtitle => t('energy.subtitle');
  String get energyBirthDate => t('energy.birthDate');
  String get energyZodiac => t('energy.zodiac');
  String get energyElement => t('energy.element');
  String get energyConcerns => t('energy.concerns');
  String get energyConcernsHint => t('energy.concernsHint');
  String get energyLifestyle => t('energy.lifestyle');
  String get energyLifestyleHint => t('energy.lifestyleHint');
  String get energyStart => t('energy.start');
  String get energySelectZodiac => t('energy.selectZodiac');
  String get energySelectElement => t('energy.selectElement');
  String get energyFailed => t('energy.failed');
  String get energyNoResults => t('energy.noResults');
  String get energyProfile => t('energy.profile');
  String get energyProfileSub => t('energy.profileSub');
  String get energyColors => t('energy.colors');
  String get energyMaterials => t('energy.materials');
  String get energyCrystals => t('energy.crystals');
  String get energyTryAgain => t('energy.tryAgain');

  // Zodiac signs
  final zodiacSigns = [
    'zodiac.aries','zodiac.taurus','zodiac.gemini','zodiac.cancer',
    'zodiac.leo','zodiac.virgo','zodiac.libra','zodiac.scorpio',
    'zodiac.sagittarius','zodiac.capricorn','zodiac.aquarius','zodiac.pisces',
  ];
  final elements = ['element.wood','element.fire','element.earth','element.metal','element.water'];

  String zodiac(String key) => t(key);
  String element(String key) => t(key);

  String get authAura => t('auth.aura');
  String get authTagline => t('auth.tagline');
  String get authName => t('auth.name');
  String get authEmail => t('auth.email');
  String get authPassword => t('auth.password');
  String get authCreateAccount => t('auth.createAccount');
  String get authSignIn => t('auth.signIn');
  String get authAlreadyHave => t('auth.alreadyHave');
  String get authDontHave => t('auth.dontHave');
  String get authEnterName => t('auth.enterName');

  String get profileTitle => t('profile.title');
  String get profileDesignerEarnings => t('profile.designerEarnings');
  String get profileTotalEarned => t('profile.totalEarned');
  String get profilePending => t('profile.pending');
  String get profileDesignsSold => t('profile.designsSold');
  String get profileOrders => t('profile.orders');
  String get profileNoOrders => t('profile.noOrders');
  String get profileMyDesigns => t('profile.myDesigns');
  String get profileNoDesigns => t('profile.noDesigns');
  String get profileAdminPanel => t('profile.adminPanel');
  String get profileLogout => t('profile.logout');
  String get profileSignOut => t('profile.signOut');
  String get profileEditTitle => t('profile.editTitle');
  String get profileBio => t('profile.bio');
  String get profileCancel => t('profile.cancel');
  String get profileSave => t('profile.save');
  String get profileOrderId => t('profile.orderId');
  String get profileStatus => t('profile.status');
  String get profileDate => t('profile.date');
  String get profileShipping => t('profile.shipping');
  String get profilePublished => t('profile.published');
  String get profileDraft => t('profile.draft');
  String get profileLanguage => t('profile.language');

  String get searchBracelets => t('search.bracelets');

  String get generalLoading => t('general.loading');
}

/// Static key → per-locale string map
final Map<String, TranslationMap> _all = {
  // Navigation
  'nav.shop': {AppLocale.en: 'Shop', AppLocale.zh: '商店', AppLocale.ja: 'ショップ', AppLocale.ko: '쇼핑', AppLocale.ru: 'Магазин', AppLocale.fr: 'Boutique', AppLocale.de: 'Shop'},
  'nav.designStudio': {AppLocale.en: 'Design Studio', AppLocale.zh: '设计工作室', AppLocale.ja: 'デザインスタジオ', AppLocale.ko: '디자인 스튜디오', AppLocale.ru: 'Дизайн-студия', AppLocale.fr: 'Studio de Design', AppLocale.de: 'Designstudio'},
  'nav.energy': {AppLocale.en: 'Energy', AppLocale.zh: '能量评估', AppLocale.ja: 'エネルギー', AppLocale.ko: '에너지', AppLocale.ru: 'Энергия', AppLocale.fr: 'Énergie', AppLocale.de: 'Energie'},
  'nav.cart': {AppLocale.en: 'Cart', AppLocale.zh: '购物车', AppLocale.ja: 'カート', AppLocale.ko: '장바구니', AppLocale.ru: 'Корзина', AppLocale.fr: 'Panier', AppLocale.de: 'Warenkorb'},
  'nav.profile': {AppLocale.en: 'Profile', AppLocale.zh: '我的', AppLocale.ja: 'プロフィール', AppLocale.ko: '프로필', AppLocale.ru: 'Профиль', AppLocale.fr: 'Profil', AppLocale.de: 'Profil'},

  // Home
  'home.title': {AppLocale.en: 'AURA', AppLocale.zh: 'AURA', AppLocale.ja: 'AURA', AppLocale.ko: 'AURA', AppLocale.ru: 'AURA', AppLocale.fr: 'AURA', AppLocale.de: 'AURA'},
  'home.tagline': {AppLocale.en: 'Handcrafted Energy Bracelets', AppLocale.zh: '手工能量手串', AppLocale.ja: '手作りエナジーブレスレット', AppLocale.ko: '수제 에너지 팔찌', AppLocale.ru: 'Энергетические браслеты ручной работы', AppLocale.fr: 'Bracelets Énergétiques Artisanaux', AppLocale.de: 'Handgefertigte Energie-Armbänder'},
  'home.shopCollection': {AppLocale.en: 'Shop Collection', AppLocale.zh: '选购系列', AppLocale.ja: 'コレクションを見る', AppLocale.ko: '컬렉션 쇼핑', AppLocale.ru: 'В коллекцию', AppLocale.fr: 'Voir la Collection', AppLocale.de: 'Kollektion entdecken'},
  'home.designYours': {AppLocale.en: 'Design Yours', AppLocale.zh: '设计你的', AppLocale.ja: '自分でデザイン', AppLocale.ko: '나만의 디자인', AppLocale.ru: 'Создать свой', AppLocale.fr: 'Créez le Vôtre', AppLocale.de: 'Eigenes Design'},
  'home.bestsellers': {AppLocale.en: 'Bestsellers', AppLocale.zh: '热销排行', AppLocale.ja: 'ベストセラー', AppLocale.ko: '베스트셀러', AppLocale.ru: 'Хиты продаж', AppLocale.fr: 'Meilleures Ventes', AppLocale.de: 'Bestseller'},
  'home.viewAll': {AppLocale.en: 'View All', AppLocale.zh: '查看全部', AppLocale.ja: 'すべて見る', AppLocale.ko: '전체 보기', AppLocale.ru: 'Смотреть все', AppLocale.fr: 'Voir Tout', AppLocale.de: 'Alle ansehen'},
  'home.categories': {AppLocale.en: 'Categories', AppLocale.zh: '分类', AppLocale.ja: 'カテゴリー', AppLocale.ko: '카테고리', AppLocale.ru: 'Категории', AppLocale.fr: 'Catégories', AppLocale.de: 'Kategorien'},
  'home.crystal': {AppLocale.en: 'Crystal', AppLocale.zh: '水晶', AppLocale.ja: 'クリスタル', AppLocale.ko: '크리스탈', AppLocale.ru: 'Кристалл', AppLocale.fr: 'Cristal', AppLocale.de: 'Kristall'},
  'home.jade': {AppLocale.en: 'Jade', AppLocale.zh: '玉石', AppLocale.ja: 'ヒスイ', AppLocale.ko: '비취', AppLocale.ru: 'Нефрит', AppLocale.fr: 'Jade', AppLocale.de: 'Jade'},
  'home.amber': {AppLocale.en: 'Amber', AppLocale.zh: '琥珀', AppLocale.ja: '琥珀', AppLocale.ko: '호박', AppLocale.ru: 'Янтарь', AppLocale.fr: 'Ambre', AppLocale.de: 'Bernstein'},
  'home.lava': {AppLocale.en: 'Lava', AppLocale.zh: '熔岩', AppLocale.ja: '溶岩', AppLocale.ko: '용암', AppLocale.ru: 'Лава', AppLocale.fr: 'Lave', AppLocale.de: 'Lava'},
  'home.discoverEnergy': {AppLocale.en: 'Discover Your Energy', AppLocale.zh: '发现你的能量', AppLocale.ja: 'あなたのエネルギーを知る', AppLocale.ko: '당신의 에너지를 발견하세요', AppLocale.ru: 'Откройте свою энергию', AppLocale.fr: 'Découvrez Votre Énergie', AppLocale.de: 'Entdecke deine Energie'},
  'home.energySubtitle': {AppLocale.en: 'AI-powered personality & elemental assessment', AppLocale.zh: 'AI 性格与五行评测', AppLocale.ja: 'AI性格・元素診断', AppLocale.ko: 'AI 성격 및 원소 평가', AppLocale.ru: 'AI-оценка личности и стихий', AppLocale.fr: 'Évaluation IA de la personnalité et des éléments', AppLocale.de: 'KI-gestützte Persönlichkeits- & Elementanalyse'},
  'home.startAssessment': {AppLocale.en: 'Start Assessment', AppLocale.zh: '开始评测', AppLocale.ja: '診断を開始', AppLocale.ko: '평가 시작', AppLocale.ru: 'Начать оценку', AppLocale.fr: 'Commencer', AppLocale.de: 'Bewertung starten'},
  'home.fromCommunity': {AppLocale.en: 'From the Community', AppLocale.zh: '社区设计', AppLocale.ja: 'コミュニティ作品', AppLocale.ko: '커뮤니티 디자인', AppLocale.ru: 'Работы сообщества', AppLocale.fr: 'Créations de la Communauté', AppLocale.de: 'Aus der Community'},

  // Products
  'products.title': {AppLocale.en: 'The Collection', AppLocale.zh: '全部产品', AppLocale.ja: 'コレクション', AppLocale.ko: '컬렉션', AppLocale.ru: 'Коллекция', AppLocale.fr: 'La Collection', AppLocale.de: 'Die Kollektion'},
  'products.subtitle': {AppLocale.en: 'Handpicked artisan bracelets for every energy', AppLocale.zh: '精选手工手串，匹配每种能量', AppLocale.ja: '厳選された職人ブレスレット', AppLocale.ko: '모든 에너지를 위한 수제 팔찌', AppLocale.ru: 'Браслеты ручной работы для каждой энергии', AppLocale.fr: 'Bracelets artisanaux pour chaque énergie', AppLocale.de: 'Handverlesene Armbänder für jede Energie'},
  'products.search': {AppLocale.en: 'Search bracelets...', AppLocale.zh: '搜索手串...', AppLocale.ja: 'ブレスレットを検索...', AppLocale.ko: '팔찌 검색...', AppLocale.ru: 'Поиск браслетов...', AppLocale.fr: 'Rechercher...', AppLocale.de: 'Armbänder suchen...'},
  'products.all': {AppLocale.en: 'All', AppLocale.zh: '全部', AppLocale.ja: 'すべて', AppLocale.ko: '전체', AppLocale.ru: 'Все', AppLocale.fr: 'Tout', AppLocale.de: 'Alle'},
  'products.empty': {AppLocale.en: 'No products found', AppLocale.zh: '未找到产品', AppLocale.ja: '商品が見つかりません', AppLocale.ko: '제품이 없습니다', AppLocale.ru: 'Товары не найдены', AppLocale.fr: 'Aucun produit trouvé', AppLocale.de: 'Keine Produkte gefunden'},
  'products.addToCart': {AppLocale.en: 'Add to Cart', AppLocale.zh: '加入购物车', AppLocale.ja: 'カートに入れる', AppLocale.ko: '장바구니 담기', AppLocale.ru: 'В корзину', AppLocale.fr: 'Ajouter au Panier', AppLocale.de: 'In den Warenkorb'},
  'products.addedToCart': {AppLocale.en: 'Added to Cart', AppLocale.zh: '已加入购物车', AppLocale.ja: 'カートに追加しました', AppLocale.ko: '장바구니에 추가됨', AppLocale.ru: 'Добавлено в корзину', AppLocale.fr: 'Ajouté au Panier', AppLocale.de: 'Zum Warenkorb hinzugefügt'},
  'products.quantity': {AppLocale.en: 'Quantity', AppLocale.zh: '数量', AppLocale.ja: '数量', AppLocale.ko: '수량', AppLocale.ru: 'Количество', AppLocale.fr: 'Quantité', AppLocale.de: 'Menge'},
  'products.reviews': {AppLocale.en: 'Reviews', AppLocale.zh: '评价', AppLocale.ja: 'レビュー', AppLocale.ko: '리뷰', AppLocale.ru: 'Отзывы', AppLocale.fr: 'Avis', AppLocale.de: 'Bewertungen'},
  'products.designedBy': {AppLocale.en: 'Designed by', AppLocale.zh: '设计师', AppLocale.ja: 'デザイナー', AppLocale.ko: '디자이너', AppLocale.ru: 'Дизайнер', AppLocale.fr: 'Designé par', AppLocale.de: 'Designed von'},
  'products.designerCommission': {AppLocale.en: '2% of sale goes to designer', AppLocale.zh: '售价的2%归设计师', AppLocale.ja: '売上の2%がデザイナーへ', AppLocale.ko: '판매액의 2%가 디자이너에게', AppLocale.ru: '2% продажи дизайнеру', AppLocale.fr: '2% de la vente au designer', AppLocale.de: '2% des Verkaufserlöses an den Designer'},
  'products.youMayLike': {AppLocale.en: 'You May Also Like', AppLocale.zh: '猜你喜欢', AppLocale.ja: 'おすすめ', AppLocale.ko: '추천 상품', AppLocale.ru: 'Вам также может понравиться', AppLocale.fr: 'Vous Aimerez Aussi', AppLocale.de: 'Das könnte dir auch gefallen'},
  'products.defaultDescription': {AppLocale.en: 'Handcrafted with precision, each bead is selected for its unique energy properties. Ethically sourced and individually inspected to ensure the highest standard of quality and beauty. A timeless piece designed to accompany you through every journey.', AppLocale.zh: '精工制作，每颗珠子都因其独特的能量特性而精选。道德采购，逐个检查，确保最高品质与美感。', AppLocale.ja: '精密に作られ、各ビーズはそのユニークなエネルギー特性のために選ばれています。倫理的に調達され、最高の品質と美しさを保証するために個別に検査されています。', AppLocale.ko: '정밀하게 제작된 각 구슬은 독특한 에너지 특성을 위해 선택되었습니다. 윤리적으로 조달되고 최고 수준의 품질과 아름다움을 보장하기 위해 개별적으로 검사됩니다.', AppLocale.ru: 'Изготовлено с точностью, каждая бусина выбрана за её уникальные энергетические свойства. Этично добыто и индивидуально проверено.', AppLocale.fr: 'Fabriqué avec précision, chaque perle est sélectionnée pour ses propriétés énergétiques uniques. Sourcé éthiquement et inspecté individuellement.', AppLocale.de: 'Mit Präzision handgefertigt, jede Perle ist für ihre einzigartigen energetischen Eigenschaften ausgewählt. Ethisch beschafft und einzeln geprüft.'},

  // Cart
  'cart.title': {AppLocale.en: 'Cart', AppLocale.zh: '购物车', AppLocale.ja: 'カート', AppLocale.ko: '장바구니', AppLocale.ru: 'Корзина', AppLocale.fr: 'Panier', AppLocale.de: 'Warenkorb'},
  'cart.empty': {AppLocale.en: 'Your cart is empty', AppLocale.zh: '购物车是空的', AppLocale.ja: 'カートは空です', AppLocale.ko: '장바구니가 비었습니다', AppLocale.ru: 'Корзина пуста', AppLocale.fr: 'Votre panier est vide', AppLocale.de: 'Ihr Warenkorb ist leer'},
  'cart.emptySubtitle': {AppLocale.en: 'Browse products or design your own', AppLocale.zh: '浏览产品或自己设计', AppLocale.ja: '商品を見るか自分でデザイン', AppLocale.ko: '제품을 둘러보거나 직접 디자인하세요', AppLocale.ru: 'Посмотрите товары или создайте свой', AppLocale.fr: 'Parcourez ou créez le vôtre', AppLocale.de: 'Produkte durchstöbern oder eigenes Design'},
  'cart.custom': {AppLocale.en: 'Custom', AppLocale.zh: '定制', AppLocale.ja: 'カスタム', AppLocale.ko: '커스텀', AppLocale.ru: 'Кастомный', AppLocale.fr: 'Personnalisé', AppLocale.de: 'Individuell'},
  'cart.product': {AppLocale.en: 'Product', AppLocale.zh: '商品', AppLocale.ja: '商品', AppLocale.ko: '제품', AppLocale.ru: 'Товар', AppLocale.fr: 'Produit', AppLocale.de: 'Produkt'},
  'cart.total': {AppLocale.en: 'Total', AppLocale.zh: '合计', AppLocale.ja: '合計', AppLocale.ko: '합계', AppLocale.ru: 'Итого', AppLocale.fr: 'Total', AppLocale.de: 'Gesamtsumme'},
  'cart.checkout': {AppLocale.en: 'Checkout', AppLocale.zh: '结算', AppLocale.ja: 'レジに進む', AppLocale.ko: '결제', AppLocale.ru: 'Оформить заказ', AppLocale.fr: 'Commander', AppLocale.de: 'Zur Kasse'},

  // Order
  'order.orderConfirmed': {AppLocale.en: 'Order Confirmed', AppLocale.zh: '订单确认', AppLocale.ja: '注文確定', AppLocale.ko: '주문 확인', AppLocale.ru: 'Заказ подтверждён', AppLocale.fr: 'Commande Confirmée', AppLocale.de: 'Bestellung bestätigt'},
  'order.orderPlaced': {AppLocale.en: 'Order Placed!', AppLocale.zh: '下单成功！', AppLocale.ja: '注文完了！', AppLocale.ko: '주문 완료!', AppLocale.ru: 'Заказ размещён!', AppLocale.fr: 'Commande Passée !', AppLocale.de: 'Bestellung aufgegeben!'},
  'order.orderId': {AppLocale.en: 'Order ID', AppLocale.zh: '订单号', AppLocale.ja: '注文番号', AppLocale.ko: '주문번호', AppLocale.ru: 'ID заказа', AppLocale.fr: 'ID Commande', AppLocale.de: 'Bestellnummer'},
  'order.total': {AppLocale.en: 'Total', AppLocale.zh: '总计', AppLocale.ja: '合計', AppLocale.ko: '합계', AppLocale.ru: 'Итого', AppLocale.fr: 'Total', AppLocale.de: 'Gesamt'},
  'order.shippingNotice': {AppLocale.en: "We'll process your payment and notify you when it ships.", AppLocale.zh: '我们将处理付款并在发货时通知您。', AppLocale.ja: 'お支払いを処理し、発送時にご連絡します。', AppLocale.ko: '결제를 처리하고 배송 시 알려드립니다.', AppLocale.ru: 'Мы обработаем платёж и уведомим вас об отправке.', AppLocale.fr: 'Nous traitons le paiement et vous informons de l\'expédition.', AppLocale.de: 'Wir bearbeiten die Zahlung und benachrichtigen Sie bei Versand.'},
  'order.backToShop': {AppLocale.en: 'Back to Shop', AppLocale.zh: '返回商店', AppLocale.ja: 'ショップに戻る', AppLocale.ko: '쇼핑으로 돌아가기', AppLocale.ru: 'В магазин', AppLocale.fr: 'Retour à la Boutique', AppLocale.de: 'Zurück zum Shop'},
  'order.summary': {AppLocale.en: 'Order Summary', AppLocale.zh: '订单摘要', AppLocale.ja: '注文概要', AppLocale.ko: '주문 요약', AppLocale.ru: 'Сводка заказа', AppLocale.fr: 'Récapitulatif', AppLocale.de: 'Bestellübersicht'},
  'order.shippingInfo': {AppLocale.en: 'Shipping Information', AppLocale.zh: '收货信息', AppLocale.ja: '配送情報', AppLocale.ko: '배송 정보', AppLocale.ru: 'Информация о доставке', AppLocale.fr: 'Informations de Livraison', AppLocale.de: 'Versandinformationen'},
  'order.email': {AppLocale.en: 'Email *', AppLocale.zh: '邮箱 *', AppLocale.ja: 'メールアドレス *', AppLocale.ko: '이메일 *', AppLocale.ru: 'Email *', AppLocale.fr: 'Email *', AppLocale.de: 'E-Mail *'},
  'order.fullName': {AppLocale.en: 'Full Name *', AppLocale.zh: '姓名 *', AppLocale.ja: '氏名 *', AppLocale.ko: '성명 *', AppLocale.ru: 'ФИО *', AppLocale.fr: 'Nom Complet *', AppLocale.de: 'Vollständiger Name *'},
  'order.address': {AppLocale.en: 'Address *', AppLocale.zh: '地址 *', AppLocale.ja: '住所 *', AppLocale.ko: '주소 *', AppLocale.ru: 'Адрес *', AppLocale.fr: 'Adresse *', AppLocale.de: 'Adresse *'},
  'order.city': {AppLocale.en: 'City *', AppLocale.zh: '城市 *', AppLocale.ja: '市区町村 *', AppLocale.ko: '도시 *', AppLocale.ru: 'Город *', AppLocale.fr: 'Ville *', AppLocale.de: 'Stadt *'},
  'order.state': {AppLocale.en: 'State', AppLocale.zh: '州/省', AppLocale.ja: '都道府県', AppLocale.ko: '주/도', AppLocale.ru: 'Регион', AppLocale.fr: 'État/Région', AppLocale.de: 'Bundesland'},
  'order.zip': {AppLocale.en: 'ZIP *', AppLocale.zh: '邮编 *', AppLocale.ja: '郵便番号 *', AppLocale.ko: '우편번호 *', AppLocale.ru: 'Почтовый индекс *', AppLocale.fr: 'Code Postal *', AppLocale.de: 'PLZ *'},
  'order.country': {AppLocale.en: 'Country', AppLocale.zh: '国家', AppLocale.ja: '国', AppLocale.ko: '국가', AppLocale.ru: 'Страна', AppLocale.fr: 'Pays', AppLocale.de: 'Land'},
  'order.phone': {AppLocale.en: 'Phone (optional)', AppLocale.zh: '电话（选填）', AppLocale.ja: '電話番号（任意）', AppLocale.ko: '전화번호 (선택)', AppLocale.ru: 'Телефон (опционально)', AppLocale.fr: 'Téléphone (optionnel)', AppLocale.de: 'Telefon (optional)'},
  'order.required': {AppLocale.en: 'Required', AppLocale.zh: '必填', AppLocale.ja: '必須', AppLocale.ko: '필수', AppLocale.ru: 'Обязательно', AppLocale.fr: 'Requis', AppLocale.de: 'Erforderlich'},
  'order.placeOrder': {AppLocale.en: 'Place Order', AppLocale.zh: '提交订单', AppLocale.ja: '注文を確定', AppLocale.ko: '주문하기', AppLocale.ru: 'Разместить заказ', AppLocale.fr: 'Passer Commande', AppLocale.de: 'Bestellung aufgeben'},
  'order.failed': {AppLocale.en: 'Order creation failed', AppLocale.zh: '订单创建失败', AppLocale.ja: '注文作成に失敗しました', AppLocale.ko: '주문 생성 실패', AppLocale.ru: 'Не удалось создать заказ', AppLocale.fr: 'Échec de la commande', AppLocale.de: 'Bestellung fehlgeschlagen'},
  'order.contactSupport': {AppLocale.en: 'Order created but payment setup failed. Contact support.', AppLocale.zh: '订单已创建但支付设置失败，请联系客服。', AppLocale.ja: '注文は作成されましたが支払い設定に失敗しました。サポートにお問い合わせください。', AppLocale.ko: '주문이 생성되었지만 결제 설정에 실패했습니다. 고객 지원에 문의하세요.', AppLocale.ru: 'Заказ создан, но настройка оплаты не удалась. Обратитесь в поддержку.', AppLocale.fr: 'Commande créée mais échec du paiement. Contactez le support.', AppLocale.de: 'Bestellung erstellt, aber Zahlungseinrichtung fehlgeschlagen. Support kontaktieren.'},
  'order.paymentSuccess': {AppLocale.en: 'Payment Successful!', AppLocale.zh: '支付成功！', AppLocale.ja: '支払い完了！', AppLocale.ko: '결제 성공!', AppLocale.ru: 'Оплата успешна!', AppLocale.fr: 'Paiement Réussi !', AppLocale.de: 'Zahlung erfolgreich!'},
  'order.paymentCancelled': {AppLocale.en: 'Payment Cancelled', AppLocale.zh: '支付取消', AppLocale.ja: '支払いキャンセル', AppLocale.ko: '결제 취소됨', AppLocale.ru: 'Оплата отменена', AppLocale.fr: 'Paiement Annulé', AppLocale.de: 'Zahlung abgebrochen'},
  'order.paymentSuccessSub': {AppLocale.en: 'Your order has been placed successfully.', AppLocale.zh: '您的订单已成功提交。', AppLocale.ja: 'ご注文が完了しました。', AppLocale.ko: '주문이 성공적으로 접수되었습니다.', AppLocale.ru: 'Ваш заказ успешно размещён.', AppLocale.fr: 'Votre commande a été passée avec succès.', AppLocale.de: 'Ihre Bestellung wurde erfolgreich aufgegeben.'},
  'order.paymentCancelledSub': {AppLocale.en: 'The payment was cancelled or failed.', AppLocale.zh: '支付被取消或失败。', AppLocale.ja: '支払いがキャンセルまたは失敗しました。', AppLocale.ko: '결제가 취소되거나 실패했습니다.', AppLocale.ru: 'Платёж был отменён или не удался.', AppLocale.fr: 'Le paiement a été annulé ou a échoué.', AppLocale.de: 'Die Zahlung wurde abgebrochen oder ist fehlgeschlagen.'},

  // Designer
  'designer.title': {AppLocale.en: 'Design Studio', AppLocale.zh: '设计工作室', AppLocale.ja: 'デザインスタジオ', AppLocale.ko: '디자인 스튜디오', AppLocale.ru: 'Дизайн-студия', AppLocale.fr: 'Studio de Design', AppLocale.de: 'Designstudio'},
  'designer.tapToStart': {AppLocale.en: 'Tap elements below to add to your bracelet', AppLocale.zh: '点击下方元素添加到手串', AppLocale.ja: '下の要素をタップして追加', AppLocale.ko: '아래 요소를 탭하여 팔찌에 추가하세요', AppLocale.ru: 'Нажмите на элементы ниже, чтобы добавить', AppLocale.fr: 'Appuyez sur les éléments pour ajouter', AppLocale.de: 'Tippe auf Elemente, um hinzuzufügen'},
  'designer.designName': {AppLocale.en: 'Design Name', AppLocale.zh: '设计名称', AppLocale.ja: 'デザイン名', AppLocale.ko: '디자인 이름', AppLocale.ru: 'Название дизайна', AppLocale.fr: 'Nom du Design', AppLocale.de: 'Design-Name'},
  'designer.elements': {AppLocale.en: 'elements', AppLocale.zh: '个元素', AppLocale.ja: '個の要素', AppLocale.ko: '개 요소', AppLocale.ru: 'элементов', AppLocale.fr: 'éléments', AppLocale.de: 'Elemente'},
  'designer.stringBand': {AppLocale.en: 'STRING / BAND', AppLocale.zh: '串绳 / 手链', AppLocale.ja: 'コード / バンド', AppLocale.ko: '끈 / 밴드', AppLocale.ru: 'ШНУР / ОСНОВА', AppLocale.fr: 'CORDON / LIEN', AppLocale.de: 'BAND / KORDEL'},
  'designer.none': {AppLocale.en: 'None', AppLocale.zh: '无', AppLocale.ja: 'なし', AppLocale.ko: '없음', AppLocale.ru: 'Нет', AppLocale.fr: 'Aucun', AppLocale.de: 'Keins'},
  'designer.beads': {AppLocale.en: 'Beads', AppLocale.zh: '珠子', AppLocale.ja: 'ビーズ', AppLocale.ko: '구슬', AppLocale.ru: 'Бусины', AppLocale.fr: 'Perles', AppLocale.de: 'Perlen'},
  'designer.charms': {AppLocale.en: 'Charms', AppLocale.zh: '挂件', AppLocale.ja: 'チャーム', AppLocale.ko: '참', AppLocale.ru: 'Подвески', AppLocale.fr: 'Charms', AppLocale.de: 'Charms'},
  'designer.pendants': {AppLocale.en: 'Pendants', AppLocale.zh: '吊坠', AppLocale.ja: 'ペンダント', AppLocale.ko: '펜던트', AppLocale.ru: 'Кулоны', AppLocale.fr: 'Pendentifs', AppLocale.de: 'Anhänger'},
  'designer.spacers': {AppLocale.en: 'Spacers', AppLocale.zh: '隔珠', AppLocale.ja: 'スペーサー', AppLocale.ko: '스페이서', AppLocale.ru: 'Распорки', AppLocale.fr: 'Entretoises', AppLocale.de: 'Abstandshalter'},
  'designer.clasps': {AppLocale.en: 'Clasps', AppLocale.zh: '搭扣', AppLocale.ja: '留め金', AppLocale.ko: '잠금장치', AppLocale.ru: 'Замки', AppLocale.fr: 'Fermoirs', AppLocale.de: 'Verschlüsse'},
  'designer.string': {AppLocale.en: 'String', AppLocale.zh: '串绳', AppLocale.ja: 'コード', AppLocale.ko: '끈', AppLocale.ru: 'Шнур', AppLocale.fr: 'Cordon', AppLocale.de: 'Kordel'},
  'designer.noElements': {AppLocale.en: 'No elements available', AppLocale.zh: '暂无元素', AppLocale.ja: '利用可能な要素がありません', AppLocale.ko: '사용 가능한 요소가 없습니다', AppLocale.ru: 'Нет доступных элементов', AppLocale.fr: 'Aucun élément disponible', AppLocale.de: 'Keine Elemente verfügbar'},
  'designer.inDesign': {AppLocale.en: 'in design', AppLocale.zh: '设计中', AppLocale.ja: 'デザイン中', AppLocale.ko: '디자인 중', AppLocale.ru: 'в дизайне', AppLocale.fr: 'dans le design', AppLocale.de: 'im Design'},
  'designer.save': {AppLocale.en: 'Save', AppLocale.zh: '保存', AppLocale.ja: '保存', AppLocale.ko: '저장', AppLocale.ru: 'Сохранить', AppLocale.fr: 'Enregistrer', AppLocale.de: 'Speichern'},
  'designer.update': {AppLocale.en: 'Update', AppLocale.zh: '更新', AppLocale.ja: '更新', AppLocale.ko: '업데이트', AppLocale.ru: 'Обновить', AppLocale.fr: 'Mettre à Jour', AppLocale.de: 'Aktualisieren'},
  'designer.saving': {AppLocale.en: 'Saving...', AppLocale.zh: '保存中...', AppLocale.ja: '保存中...', AppLocale.ko: '저장 중...', AppLocale.ru: 'Сохранение...', AppLocale.fr: 'Enregistrement...', AppLocale.de: 'Speichern...'},
  'designer.publish': {AppLocale.en: 'Publish', AppLocale.zh: '发布', AppLocale.ja: '公開', AppLocale.ko: '출시', AppLocale.ru: 'Опубликовать', AppLocale.fr: 'Publier', AppLocale.de: 'Veröffentlichen'},
  'designer.reorderHint': {AppLocale.en: 'Long-press a bead to remove. Use arrows to reorder.', AppLocale.zh: '长按珠子删除，箭头调整顺序。', AppLocale.ja: '長押しで削除、矢印で並び替え。', AppLocale.ko: '길게 눌러 제거, 화살표로 순서 변경.', AppLocale.ru: 'Долгое нажатие — удалить, стрелки — переместить.', AppLocale.fr: 'Appui long pour supprimer, flèches pour réorganiser.', AppLocale.de: 'Langes Drücken zum Entfernen, Pfeile zum Sortieren.'},
  'designer.clear': {AppLocale.en: 'Clear design', AppLocale.zh: '清空设计', AppLocale.ja: 'デザインをクリア', AppLocale.ko: '디자인 지우기', AppLocale.ru: 'Очистить дизайн', AppLocale.fr: 'Effacer le design', AppLocale.de: 'Design löschen'},
  'designer.published': {AppLocale.en: 'Design published! Others can now buy it.', AppLocale.zh: '设计已发布！其他人可以购买。', AppLocale.ja: 'デザインを公開しました！他の人が購入できます。', AppLocale.ko: '디자인이 게시되었습니다! 다른 사람들이 구매할 수 있습니다.', AppLocale.ru: 'Дизайн опубликован! Другие могут его купить.', AppLocale.fr: 'Design publié ! D\'autres peuvent l\'acheter.', AppLocale.de: 'Design veröffentlicht! Andere können es jetzt kaufen.'},
  'designer.saved': {AppLocale.en: 'Design saved!', AppLocale.zh: '设计已保存！', AppLocale.ja: 'デザインを保存しました！', AppLocale.ko: '디자인이 저장되었습니다!', AppLocale.ru: 'Дизайн сохранён!', AppLocale.fr: 'Design enregistré !', AppLocale.de: 'Design gespeichert!'},
  'designer.addElement': {AppLocale.en: 'Add at least one element to your bracelet', AppLocale.zh: '至少添加一个元素到手串', AppLocale.ja: '少なくとも1つの要素を追加してください', AppLocale.ko: '팔찌에 최소 하나의 요소를 추가하세요', AppLocale.ru: 'Добавьте хотя бы один элемент', AppLocale.fr: 'Ajoutez au moins un élément', AppLocale.de: 'Füge mindestens ein Element hinzu'},

  // Energy
  'energy.title': {AppLocale.en: 'Energy Assessment', AppLocale.zh: '能量评估', AppLocale.ja: 'エネルギー診断', AppLocale.ko: '에너지 평가', AppLocale.ru: 'Оценка энергии', AppLocale.fr: 'Évaluation Énergétique', AppLocale.de: 'Energie-Bewertung'},
  'energy.discover': {AppLocale.en: 'Discover Your Energy', AppLocale.zh: '发现你的能量', AppLocale.ja: 'あなたのエネルギーを知る', AppLocale.ko: '당신의 에너지를 발견하세요', AppLocale.ru: 'Откройте свою энергию', AppLocale.fr: 'Découvrez Votre Énergie', AppLocale.de: 'Entdecke deine Energie'},
  'energy.subtitle': {AppLocale.en: 'Tell us about yourself for a personalized energy bracelet recommendation', AppLocale.zh: '告诉我们关于你，获得个性化能量手串推荐', AppLocale.ja: 'あなたの情報を教えて、パーソナライズされたおすすめを', AppLocale.ko: '자신에 대해 알려주시면 맞춤 에너지 팔찌를 추천해드립니다', AppLocale.ru: 'Расскажите о себе для персональной рекомендации', AppLocale.fr: 'Parlez-nous de vous pour une recommandation personnalisée', AppLocale.de: 'Erzähle uns von dir für eine persönliche Empfehlung'},
  'energy.birthDate': {AppLocale.en: 'Birth Date (YYYY-MM-DD, optional)', AppLocale.zh: '出生日期（YYYY-MM-DD，选填）', AppLocale.ja: '生年月日（YYYY-MM-DD、任意）', AppLocale.ko: '생년월일 (YYYY-MM-DD, 선택)', AppLocale.ru: 'Дата рождения (ГГГГ-ММ-ДД, опционально)', AppLocale.fr: 'Date de Naissance (AAAA-MM-JJ, optionnel)', AppLocale.de: 'Geburtsdatum (JJJJ-MM-TT, optional)'},
  'energy.zodiac': {AppLocale.en: 'Zodiac Sign', AppLocale.zh: '星座', AppLocale.ja: '星座', AppLocale.ko: '별자리', AppLocale.ru: 'Знак зодиака', AppLocale.fr: 'Signe Astrologique', AppLocale.de: 'Sternzeichen'},
  'energy.element': {AppLocale.en: 'Preferred Element', AppLocale.zh: '偏好五行', AppLocale.ja: '希望の元素', AppLocale.ko: '선호 원소', AppLocale.ru: 'Предпочитаемая стихия', AppLocale.fr: 'Élément Préféré', AppLocale.de: 'Bevorzugtes Element'},
  'energy.concerns': {AppLocale.en: 'Concerns or Goals', AppLocale.zh: '关注或目标', AppLocale.ja: '悩みや目標', AppLocale.ko: '고민 또는 목표', AppLocale.ru: 'Проблемы или цели', AppLocale.fr: 'Préoccupations ou Objectifs', AppLocale.de: 'Anliegen oder Ziele'},
  'energy.concernsHint': {AppLocale.en: 'e.g., stress relief, focus, better sleep...', AppLocale.zh: '例如：减压、专注、改善睡眠...', AppLocale.ja: '例：ストレス緩和、集中力、睡眠改善...', AppLocale.ko: '예: 스트레스 해소, 집중력, 수면 개선...', AppLocale.ru: 'например: снятие стресса, фокус, сон...', AppLocale.fr: 'ex.: réduction du stress, concentration, sommeil...', AppLocale.de: 'z.B. Stressabbau, Konzentration, besserer Schlaf...'},
  'energy.lifestyle': {AppLocale.en: 'Lifestyle & Habits', AppLocale.zh: '生活方式与习惯', AppLocale.ja: 'ライフスタイルと習慣', AppLocale.ko: '라이프스타일 및 습관', AppLocale.ru: 'Образ жизни и привычки', AppLocale.fr: 'Mode de Vie & Habitudes', AppLocale.de: 'Lebensstil & Gewohnheiten'},
  'energy.lifestyleHint': {AppLocale.en: 'e.g., active, desk job, creative work...', AppLocale.zh: '例如：活跃、久坐办公、创意工作...', AppLocale.ja: '例：アクティブ、デスクワーク、クリエイティブ...', AppLocale.ko: '예: 활동적, 사무직, 창의적 작업...', AppLocale.ru: 'например: активный, офисная работа, творчество...', AppLocale.fr: 'ex.: actif, travail de bureau, créatif...', AppLocale.de: 'z.B. aktiv, Schreibtischjob, kreative Arbeit...'},
  'energy.start': {AppLocale.en: 'Start Assessment', AppLocale.zh: '开始评估', AppLocale.ja: '診断開始', AppLocale.ko: '평가 시작', AppLocale.ru: 'Начать оценку', AppLocale.fr: 'Commencer', AppLocale.de: 'Bewertung starten'},
  'energy.selectZodiac': {AppLocale.en: 'Please select your zodiac sign', AppLocale.zh: '请选择星座', AppLocale.ja: '星座を選択してください', AppLocale.ko: '별자리를 선택하세요', AppLocale.ru: 'Выберите знак зодиака', AppLocale.fr: 'Sélectionnez votre signe', AppLocale.de: 'Bitte wähle dein Sternzeichen'},
  'energy.selectElement': {AppLocale.en: 'Please select your preferred element', AppLocale.zh: '请选择偏好元素', AppLocale.ja: '元素を選択してください', AppLocale.ko: '선호 원소를 선택하세요', AppLocale.ru: 'Выберите предпочитаемую стихию', AppLocale.fr: 'Sélectionnez votre élément', AppLocale.de: 'Bitte wähle dein bevorzugtes Element'},
  'energy.failed': {AppLocale.en: 'Assessment failed', AppLocale.zh: '评估失败', AppLocale.ja: '診断に失敗しました', AppLocale.ko: '평가 실패', AppLocale.ru: 'Оценка не удалась', AppLocale.fr: 'Évaluation échouée', AppLocale.de: 'Bewertung fehlgeschlagen'},
  'energy.noResults': {AppLocale.en: 'No recommendations available.', AppLocale.zh: '暂无推荐。', AppLocale.ja: '推奨はありません。', AppLocale.ko: '추천이 없습니다.', AppLocale.ru: 'Нет рекомендаций.', AppLocale.fr: 'Aucune recommandation.', AppLocale.de: 'Keine Empfehlungen verfügbar.'},
  'energy.profile': {AppLocale.en: 'Your Energy Profile', AppLocale.zh: '你的能量档案', AppLocale.ja: 'あなたのエネルギープロフィール', AppLocale.ko: '당신의 에너지 프로필', AppLocale.ru: 'Ваш энергетический профиль', AppLocale.fr: 'Votre Profil Énergétique', AppLocale.de: 'Dein Energie-Profil'},
  'energy.profileSub': {AppLocale.en: 'Personalized recommendations based on your inputs', AppLocale.zh: '基于你输入信息的个性化推荐', AppLocale.ja: 'あなたの入力に基づくパーソナライズされた推奨', AppLocale.ko: '입력 정보를 기반으로 한 맞춤 추천', AppLocale.ru: 'Персональные рекомендации на основе ваших данных', AppLocale.fr: 'Recommandations personnalisées', AppLocale.de: 'Personalisierte Empfehlungen'},
  'energy.colors': {AppLocale.en: 'Recommended Colors', AppLocale.zh: '推荐颜色', AppLocale.ja: 'おすすめの色', AppLocale.ko: '추천 색상', AppLocale.ru: 'Рекомендуемые цвета', AppLocale.fr: 'Couleurs Recommandées', AppLocale.de: 'Empfohlene Farben'},
  'energy.materials': {AppLocale.en: 'Recommended Materials', AppLocale.zh: '推荐材质', AppLocale.ja: 'おすすめの素材', AppLocale.ko: '추천 소재', AppLocale.ru: 'Рекомендуемые материалы', AppLocale.fr: 'Matériaux Recommandés', AppLocale.de: 'Empfohlene Materialien'},
  'energy.crystals': {AppLocale.en: 'Crystal Suggestions', AppLocale.zh: '水晶建议', AppLocale.ja: 'クリスタル提案', AppLocale.ko: '크리스탈 추천', AppLocale.ru: 'Рекомендации кристаллов', AppLocale.fr: 'Suggestions de Cristaux', AppLocale.de: 'Kristall-Vorschläge'},
  'energy.tryAgain': {AppLocale.en: 'Try Another Assessment', AppLocale.zh: '重新评估', AppLocale.ja: 'もう一度診断', AppLocale.ko: '다시 평가하기', AppLocale.ru: 'Попробовать снова', AppLocale.fr: 'Réessayer', AppLocale.de: 'Erneut bewerten'},

  // Zodiac
  'zodiac.aries': {AppLocale.en: 'Aries', AppLocale.zh: '白羊座', AppLocale.ja: '牡羊座', AppLocale.ko: '양자리', AppLocale.ru: 'Овен', AppLocale.fr: 'Bélier', AppLocale.de: 'Widder'},
  'zodiac.taurus': {AppLocale.en: 'Taurus', AppLocale.zh: '金牛座', AppLocale.ja: '牡牛座', AppLocale.ko: '황소자리', AppLocale.ru: 'Телец', AppLocale.fr: 'Taureau', AppLocale.de: 'Stier'},
  'zodiac.gemini': {AppLocale.en: 'Gemini', AppLocale.zh: '双子座', AppLocale.ja: '双子座', AppLocale.ko: '쌍둥이자리', AppLocale.ru: 'Близнецы', AppLocale.fr: 'Gémeaux', AppLocale.de: 'Zwillinge'},
  'zodiac.cancer': {AppLocale.en: 'Cancer', AppLocale.zh: '巨蟹座', AppLocale.ja: '蟹座', AppLocale.ko: '게자리', AppLocale.ru: 'Рак', AppLocale.fr: 'Cancer', AppLocale.de: 'Krebs'},
  'zodiac.leo': {AppLocale.en: 'Leo', AppLocale.zh: '狮子座', AppLocale.ja: '獅子座', AppLocale.ko: '사자자리', AppLocale.ru: 'Лев', AppLocale.fr: 'Lion', AppLocale.de: 'Löwe'},
  'zodiac.virgo': {AppLocale.en: 'Virgo', AppLocale.zh: '处女座', AppLocale.ja: '乙女座', AppLocale.ko: '처녀자리', AppLocale.ru: 'Дева', AppLocale.fr: 'Vierge', AppLocale.de: 'Jungfrau'},
  'zodiac.libra': {AppLocale.en: 'Libra', AppLocale.zh: '天秤座', AppLocale.ja: '天秤座', AppLocale.ko: '천칭자리', AppLocale.ru: 'Весы', AppLocale.fr: 'Balance', AppLocale.de: 'Waage'},
  'zodiac.scorpio': {AppLocale.en: 'Scorpio', AppLocale.zh: '天蝎座', AppLocale.ja: '蠍座', AppLocale.ko: '전갈자리', AppLocale.ru: 'Скорпион', AppLocale.fr: 'Scorpion', AppLocale.de: 'Skorpion'},
  'zodiac.sagittarius': {AppLocale.en: 'Sagittarius', AppLocale.zh: '射手座', AppLocale.ja: '射手座', AppLocale.ko: '궁수자리', AppLocale.ru: 'Стрелец', AppLocale.fr: 'Sagittaire', AppLocale.de: 'Schütze'},
  'zodiac.capricorn': {AppLocale.en: 'Capricorn', AppLocale.zh: '摩羯座', AppLocale.ja: '山羊座', AppLocale.ko: '염소자리', AppLocale.ru: 'Козерог', AppLocale.fr: 'Capricorne', AppLocale.de: 'Steinbock'},
  'zodiac.aquarius': {AppLocale.en: 'Aquarius', AppLocale.zh: '水瓶座', AppLocale.ja: '水瓶座', AppLocale.ko: '물병자리', AppLocale.ru: 'Водолей', AppLocale.fr: 'Verseau', AppLocale.de: 'Wassermann'},
  'zodiac.pisces': {AppLocale.en: 'Pisces', AppLocale.zh: '双鱼座', AppLocale.ja: '魚座', AppLocale.ko: '물고기자리', AppLocale.ru: 'Рыбы', AppLocale.fr: 'Poissons', AppLocale.de: 'Fische'},

  // Elements (Five Elements)
  'element.wood': {AppLocale.en: 'Wood', AppLocale.zh: '木', AppLocale.ja: '木', AppLocale.ko: '목', AppLocale.ru: 'Дерево', AppLocale.fr: 'Bois', AppLocale.de: 'Holz'},
  'element.fire': {AppLocale.en: 'Fire', AppLocale.zh: '火', AppLocale.ja: '火', AppLocale.ko: '화', AppLocale.ru: 'Огонь', AppLocale.fr: 'Feu', AppLocale.de: 'Feuer'},
  'element.earth': {AppLocale.en: 'Earth', AppLocale.zh: '土', AppLocale.ja: '土', AppLocale.ko: '토', AppLocale.ru: 'Земля', AppLocale.fr: 'Terre', AppLocale.de: 'Erde'},
  'element.metal': {AppLocale.en: 'Metal', AppLocale.zh: '金', AppLocale.ja: '金', AppLocale.ko: '금', AppLocale.ru: 'Металл', AppLocale.fr: 'Métal', AppLocale.de: 'Metall'},
  'element.water': {AppLocale.en: 'Water', AppLocale.zh: '水', AppLocale.ja: '水', AppLocale.ko: '수', AppLocale.ru: 'Вода', AppLocale.fr: 'Eau', AppLocale.de: 'Wasser'},

  // Auth
  'auth.aura': {AppLocale.en: 'AURA', AppLocale.zh: 'AURA', AppLocale.ja: 'AURA', AppLocale.ko: 'AURA', AppLocale.ru: 'AURA', AppLocale.fr: 'AURA', AppLocale.de: 'AURA'},
  'auth.tagline': {AppLocale.en: 'Handcrafted Energy Bracelets', AppLocale.zh: '手工能量手串', AppLocale.ja: '手作りエナジーブレスレット', AppLocale.ko: '수제 에너지 팔찌', AppLocale.ru: 'Энергетические браслеты ручной работы', AppLocale.fr: 'Bracelets Énergétiques Artisanaux', AppLocale.de: 'Handgefertigte Energie-Armbänder'},
  'auth.name': {AppLocale.en: 'Name', AppLocale.zh: '姓名', AppLocale.ja: '名前', AppLocale.ko: '이름', AppLocale.ru: 'Имя', AppLocale.fr: 'Nom', AppLocale.de: 'Name'},
  'auth.email': {AppLocale.en: 'Email', AppLocale.zh: '邮箱', AppLocale.ja: 'メール', AppLocale.ko: '이메일', AppLocale.ru: 'Email', AppLocale.fr: 'Email', AppLocale.de: 'E-Mail'},
  'auth.password': {AppLocale.en: 'Password', AppLocale.zh: '密码', AppLocale.ja: 'パスワード', AppLocale.ko: '비밀번호', AppLocale.ru: 'Пароль', AppLocale.fr: 'Mot de passe', AppLocale.de: 'Passwort'},
  'auth.createAccount': {AppLocale.en: 'Create Account', AppLocale.zh: '创建账号', AppLocale.ja: 'アカウント作成', AppLocale.ko: '계정 만들기', AppLocale.ru: 'Создать аккаунт', AppLocale.fr: 'Créer un Compte', AppLocale.de: 'Konto erstellen'},
  'auth.signIn': {AppLocale.en: 'Sign In', AppLocale.zh: '登录', AppLocale.ja: 'ログイン', AppLocale.ko: '로그인', AppLocale.ru: 'Войти', AppLocale.fr: 'Se Connecter', AppLocale.de: 'Anmelden'},
  'auth.alreadyHave': {AppLocale.en: 'Already have an account? Sign In', AppLocale.zh: '已有账号？登录', AppLocale.ja: 'アカウントをお持ちですか？ログイン', AppLocale.ko: '계정이 있으신가요? 로그인', AppLocale.ru: 'Уже есть аккаунт? Войти', AppLocale.fr: 'Déjà un compte ? Connectez-vous', AppLocale.de: 'Bereits ein Konto? Anmelden'},
  'auth.dontHave': {AppLocale.en: "Don't have an account? Register", AppLocale.zh: '没有账号？注册', AppLocale.ja: 'アカウントがない方？登録', AppLocale.ko: '계정이 없으신가요? 등록', AppLocale.ru: 'Нет аккаунта? Зарегистрироваться', AppLocale.fr: 'Pas de compte ? Inscrivez-vous', AppLocale.de: 'Kein Konto? Registrieren'},
  'auth.enterName': {AppLocale.en: 'Please enter your name', AppLocale.zh: '请输入姓名', AppLocale.ja: '名前を入力してください', AppLocale.ko: '이름을 입력하세요', AppLocale.ru: 'Пожалуйста, введите имя', AppLocale.fr: 'Veuillez entrer votre nom', AppLocale.de: 'Bitte gib deinen Namen ein'},

  // Profile
  'profile.title': {AppLocale.en: 'Profile', AppLocale.zh: '我的', AppLocale.ja: 'プロフィール', AppLocale.ko: '프로필', AppLocale.ru: 'Профиль', AppLocale.fr: 'Profil', AppLocale.de: 'Profil'},
  'profile.designerEarnings': {AppLocale.en: 'Designer Earnings', AppLocale.zh: '设计师收益', AppLocale.ja: 'デザイナー収入', AppLocale.ko: '디자이너 수익', AppLocale.ru: 'Заработок дизайнера', AppLocale.fr: 'Revenus Designer', AppLocale.de: 'Designer-Verdienst'},
  'profile.totalEarned': {AppLocale.en: 'Total Earned', AppLocale.zh: '总收入', AppLocale.ja: '総収入', AppLocale.ko: '총 수익', AppLocale.ru: 'Всего заработано', AppLocale.fr: 'Total Gagné', AppLocale.de: 'Gesamt verdient'},
  'profile.pending': {AppLocale.en: 'Pending', AppLocale.zh: '待结算', AppLocale.ja: '保留中', AppLocale.ko: '대기 중', AppLocale.ru: 'В ожидании', AppLocale.fr: 'En Attente', AppLocale.de: 'Ausstehend'},
  'profile.designsSold': {AppLocale.en: 'Designs Sold', AppLocale.zh: '已售设计', AppLocale.ja: '販売デザイン数', AppLocale.ko: '판매된 디자인', AppLocale.ru: 'Продано дизайнов', AppLocale.fr: 'Designs Vendus', AppLocale.de: 'Verkaufte Designs'},
  'profile.orders': {AppLocale.en: 'Orders', AppLocale.zh: '订单', AppLocale.ja: '注文履歴', AppLocale.ko: '주문', AppLocale.ru: 'Заказы', AppLocale.fr: 'Commandes', AppLocale.de: 'Bestellungen'},
  'profile.noOrders': {AppLocale.en: 'No orders yet', AppLocale.zh: '暂无订单', AppLocale.ja: '注文がありません', AppLocale.ko: '주문이 없습니다', AppLocale.ru: 'Пока нет заказов', AppLocale.fr: 'Aucune commande', AppLocale.de: 'Noch keine Bestellungen'},
  'profile.myDesigns': {AppLocale.en: 'My Designs', AppLocale.zh: '我的设计', AppLocale.ja: 'マイデザイン', AppLocale.ko: '내 디자인', AppLocale.ru: 'Мои дизайны', AppLocale.fr: 'Mes Designs', AppLocale.de: 'Meine Designs'},
  'profile.noDesigns': {AppLocale.en: "No designs yet. Go design something!", AppLocale.zh: '还没有设计，去设计一个吧！', AppLocale.ja: 'まだデザインがありません。デザインしてみよう！', AppLocale.ko: '아직 디자인이 없습니다. 디자인해보세요!', AppLocale.ru: 'Пока нет дизайнов. Создайте что-нибудь!', AppLocale.fr: 'Pas encore de designs. Créez-en un !', AppLocale.de: 'Noch keine Designs. Erstelle etwas!'},
  'profile.adminPanel': {AppLocale.en: 'Admin Panel', AppLocale.zh: '管理面板', AppLocale.ja: '管理パネル', AppLocale.ko: '관리자 패널', AppLocale.ru: 'Панель администратора', AppLocale.fr: 'Panneau Admin', AppLocale.de: 'Admin-Panel'},
  'profile.logout': {AppLocale.en: 'Logout', AppLocale.zh: '退出登录', AppLocale.ja: 'ログアウト', AppLocale.ko: '로그아웃', AppLocale.ru: 'Выйти', AppLocale.fr: 'Déconnexion', AppLocale.de: 'Abmelden'},
  'profile.signOut': {AppLocale.en: 'Sign Out', AppLocale.zh: '退出', AppLocale.ja: 'サインアウト', AppLocale.ko: '로그아웃', AppLocale.ru: 'Выйти', AppLocale.fr: 'Déconnexion', AppLocale.de: 'Abmelden'},
  'profile.editTitle': {AppLocale.en: 'Edit Profile', AppLocale.zh: '编辑资料', AppLocale.ja: 'プロフィール編集', AppLocale.ko: '프로필 편집', AppLocale.ru: 'Редактировать профиль', AppLocale.fr: 'Modifier le Profil', AppLocale.de: 'Profil bearbeiten'},
  'profile.bio': {AppLocale.en: 'Bio', AppLocale.zh: '简介', AppLocale.ja: '自己紹介', AppLocale.ko: '소개', AppLocale.ru: 'О себе', AppLocale.fr: 'Bio', AppLocale.de: 'Bio'},
  'profile.cancel': {AppLocale.en: 'Cancel', AppLocale.zh: '取消', AppLocale.ja: 'キャンセル', AppLocale.ko: '취소', AppLocale.ru: 'Отмена', AppLocale.fr: 'Annuler', AppLocale.de: 'Abbrechen'},
  'profile.save': {AppLocale.en: 'Save', AppLocale.zh: '保存', AppLocale.ja: '保存', AppLocale.ko: '저장', AppLocale.ru: 'Сохранить', AppLocale.fr: 'Enregistrer', AppLocale.de: 'Speichern'},
  'profile.orderId': {AppLocale.en: 'Order', AppLocale.zh: '订单', AppLocale.ja: '注文', AppLocale.ko: '주문', AppLocale.ru: 'Заказ', AppLocale.fr: 'Commande', AppLocale.de: 'Bestellung'},
  'profile.status': {AppLocale.en: 'Status', AppLocale.zh: '状态', AppLocale.ja: 'ステータス', AppLocale.ko: '상태', AppLocale.ru: 'Статус', AppLocale.fr: 'Statut', AppLocale.de: 'Status'},
  'profile.date': {AppLocale.en: 'Date', AppLocale.zh: '日期', AppLocale.ja: '日付', AppLocale.ko: '날짜', AppLocale.ru: 'Дата', AppLocale.fr: 'Date', AppLocale.de: 'Datum'},
  'profile.shipping': {AppLocale.en: 'Shipping', AppLocale.zh: '收货地址', AppLocale.ja: '配送先', AppLocale.ko: '배송지', AppLocale.ru: 'Доставка', AppLocale.fr: 'Livraison', AppLocale.de: 'Versand'},
  'profile.published': {AppLocale.en: 'Published', AppLocale.zh: '已发布', AppLocale.ja: '公開済み', AppLocale.ko: '게시됨', AppLocale.ru: 'Опубликовано', AppLocale.fr: 'Publié', AppLocale.de: 'Veröffentlicht'},
  'profile.draft': {AppLocale.en: 'Draft', AppLocale.zh: '草稿', AppLocale.ja: '下書き', AppLocale.ko: '임시저장', AppLocale.ru: 'Черновик', AppLocale.fr: 'Brouillon', AppLocale.de: 'Entwurf'},
  'profile.language': {AppLocale.en: 'Language', AppLocale.zh: '语言', AppLocale.ja: '言語', AppLocale.ko: '언어', AppLocale.ru: 'Язык', AppLocale.fr: 'Langue', AppLocale.de: 'Sprache'},

  // Search
  'search.bracelets': {AppLocale.en: 'Search bracelets...', AppLocale.zh: '搜索手串...', AppLocale.ja: 'ブレスレットを検索...', AppLocale.ko: '팔찌 검색...', AppLocale.ru: 'Поиск браслетов...', AppLocale.fr: 'Rechercher...', AppLocale.de: 'Armbänder suchen...'},

  // General
  'general.loading': {AppLocale.en: 'Loading...', AppLocale.zh: '加载中...', AppLocale.ja: '読み込み中...', AppLocale.ko: '로딩 중...', AppLocale.ru: 'Загрузка...', AppLocale.fr: 'Chargement...', AppLocale.de: 'Laden...'},
};
