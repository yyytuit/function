DbShohin2.create!([
  {
    shohin_mei: 'Tシャツ',
    shohin_bunrui: '衣服',
    hanbai_tanka: 1000,
    shiire_tanka: 500,
    torokubi: '2009-09-20',
  },
  {
    shohin_mei: '穴あけパンチ',
    shohin_bunrui: '事務用品',
    hanbai_tanka: 500,
    shiire_tanka: 320,
    torokubi: '2009-09-01',
  },
  {
    shohin_mei: 'カッターシャツ',
    shohin_bunrui: '衣服',
    hanbai_tanka: '4000',
    shiire_tanka: '2800',
  },
  {
    shohin_mei: '包丁',
    shohin_bunrui: 'キッチン用品',
    hanbai_tanka: 3000,
    shiire_tanka: 2800,
    torokubi: '2009-09-20',
  },
  {
    shohin_mei: '包丁鍋',
    shohin_bunrui: 'キッチン用品',
    hanbai_tanka: 6800,
    shiire_tanka: 5000,
    torokubi: '2009-01-15',
  },
  {
    shohin_mei: 'フォーク',
    shohin_bunrui: 'キッチン用品',
    hanbai_tanka: 500,
    torokubi:'2009-09-20',
  },
  {
    shohin_mei: 'おろしがね',
    shohin_bunrui: 'キッチン用品',
    hanbai_tanka: 880,
    shiire_tanka: 790,
    torokubi: '2009-04-28',
  },
  {
    shohin_mei: 'ボールペン',
    shohin_bunrui: '事務用品',
    hanbai_tanka: 100,
    torokubi: '2009-11-11',
  },
  {
    shohin_mei: '手袋',
    shohin_bunrui: '衣服',
    hanbai_tanka: 800,
    shiire_tanka: 500,
  },
  {
    shohin_mei: 'やかん',
    shohin_bunrui: 'キッチン用品',
    hanbai_tanka: 2000,
    shiire_tanka: 1700,
    torokubi: '2009-09-20',
  }
])
DbShohin2.where(id: 4..8).destroy_all
