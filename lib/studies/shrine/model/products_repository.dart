// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:betterchips/studies/shrine/model/product.dart';

class ProductsRepository {
  static List<Product> loadProducts(Category category) {
    final allProducts = [
      Product(
        category: categoryAccessories,
        id: 0,
        isFeatured: true,
        name: (context) =>
            'shrineProductVagabondSack',
        price: 120,
        assetAspectRatio: 329 / 246,
      ),
      Product(
        category: categoryAccessories,
        id: 1,
        isFeatured: true,
        name: (context) =>
            'shrineProductStellaSunglasses',
        price: 58,
        assetAspectRatio: 329 / 247,
      ),
      Product(
        category: categoryAccessories,
        id: 2,
        isFeatured: false,
        name: (context) =>
            'shrineProductWhitneyBelt',
        price: 35,
        assetAspectRatio: 329 / 228,
      ),
      Product(
        category: categoryAccessories,
        id: 3,
        isFeatured: true,
        name: (context) =>
            'shrineProductGardenStrand',
        price: 98,
        assetAspectRatio: 329 / 246,
      ),
      Product(
        category: categoryAccessories,
        id: 4,
        isFeatured: false,
        name: (context) =>
            'shrineProductStrutEarrings',
        price: 34,
        assetAspectRatio: 329 / 246,
      ),
      Product(
        category: categoryAccessories,
        id: 5,
        isFeatured: false,
        name: (context) =>
            'shrineProductVarsitySocks',
        price: 12,
        assetAspectRatio: 329 / 246,
      ),
      Product(
        category: categoryAccessories,
        id: 6,
        isFeatured: false,
        name: (context) =>
            'shrineProductWeaveKeyring',
        price: 16,
        assetAspectRatio: 329 / 246,
      ),
      Product(
        category: categoryAccessories,
        id: 7,
        isFeatured: true,
        name: (context) =>
            'shrineProductGatsbyHat',
        price: 40,
        assetAspectRatio: 329 / 246,
      ),
      Product(
        category: categoryAccessories,
        id: 8,
        isFeatured: true,
        name: (context) =>
            'shrineProductShrugBag',
        price: 198,
        assetAspectRatio: 329 / 246,
      ),
      Product(
        category: categoryHome,
        id: 9,
        isFeatured: true,
        name: (context) =>
            'shrineProductGiltDeskTrio',
        price: 58,
        assetAspectRatio: 329 / 246,
      ),
      Product(
        category: categoryHome,
        id: 10,
        isFeatured: false,
        name: (context) =>
            'shrineProductCopperWireRack',
        price: 18,
        assetAspectRatio: 329 / 246,
      ),
      Product(
        category: categoryHome,
        id: 11,
        isFeatured: false,
        name: (context) =>
            'shrineProductSootheCeramicSet',
        price: 28,
        assetAspectRatio: 329 / 247,
      ),
      Product(
        category: categoryHome,
        id: 12,
        isFeatured: false,
        name: (context) =>
            'shrineProductHurrahsTeaSet',
        price: 34,
        assetAspectRatio: 329 / 213,
      ),
      Product(
        category: categoryHome,
        id: 13,
        isFeatured: true,
        name: (context) =>
            'shrineProductBlueStoneMug',
        price: 18,
        assetAspectRatio: 329 / 246,
      ),
      Product(
        category: categoryHome,
        id: 14,
        isFeatured: true,
        name: (context) =>
            'shrineProductRainwaterTray',
        price: 27,
        assetAspectRatio: 329 / 246,
      ),
      Product(
        category: categoryHome,
        id: 15,
        isFeatured: true,
        name: (context) =>
            'shrineProductChambrayNapkins',
        price: 16,
        assetAspectRatio: 329 / 246,
      ),
      Product(
        category: categoryHome,
        id: 16,
        isFeatured: true,
        name: (context) =>
            'shrineProductSucculentPlanters',
        price: 16,
        assetAspectRatio: 329 / 246,
      ),
      Product(
        category: categoryHome,
        id: 17,
        isFeatured: false,
        name: (context) =>
            'shrineProductQuartetTable',
        price: 175,
        assetAspectRatio: 329 / 246,
      ),
      Product(
        category: categoryHome,
        id: 18,
        isFeatured: true,
        name: (context) =>
            'shrineProductKitchenQuattro',
        price: 129,
        assetAspectRatio: 329 / 246,
      ),
      Product(
        category: categoryClothing,
        id: 19,
        isFeatured: false,
        name: (context) =>
            'shrineProductClaySweater',
        price: 48,
        assetAspectRatio: 329 / 219,
      ),
      Product(
        category: categoryClothing,
        id: 20,
        isFeatured: false,
        name: (context) =>
            'shrineProductSeaTunic',
        price: 45,
        assetAspectRatio: 329 / 221,
      ),
      Product(
        category: categoryClothing,
        id: 21,
        isFeatured: false,
        name: (context) =>
            'shrineProductPlasterTunic',
        price: 38,
        assetAspectRatio: 220 / 329,
      ),
      Product(
        category: categoryClothing,
        id: 22,
        isFeatured: false,
        name: (context) =>
            'shrineProductWhitePinstripeShirt',
        price: 70,
        assetAspectRatio: 219 / 329,
      ),
      Product(
        category: categoryClothing,
        id: 23,
        isFeatured: false,
        name: (context) =>
            'shrineProductChambrayShirt',
        price: 70,
        assetAspectRatio: 329 / 221,
      ),
      Product(
        category: categoryClothing,
        id: 24,
        isFeatured: true,
        name: (context) =>
            'shrineProductSeabreezeSweater',
        price: 60,
        assetAspectRatio: 220 / 329,
      ),
      Product(
        category: categoryClothing,
        id: 25,
        isFeatured: false,
        name: (context) =>
            'shrineProductGentryJacket',
        price: 178,
        assetAspectRatio: 329 / 219,
      ),
      Product(
        category: categoryClothing,
        id: 26,
        isFeatured: false,
        name: (context) =>
            'shrineProductNavyTrousers',
        price: 74,
        assetAspectRatio: 220 / 329,
      ),
      Product(
        category: categoryClothing,
        id: 27,
        isFeatured: true,
        name: (context) =>
            'shrineProductWalterHenleyWhite',
        price: 38,
        assetAspectRatio: 219 / 329,
      ),
      Product(
        category: categoryClothing,
        id: 28,
        isFeatured: true,
        name: (context) =>
            'shrineProductSurfAndPerfShirt',
        price: 48,
        assetAspectRatio: 329 / 219,
      ),
      Product(
        category: categoryClothing,
        id: 29,
        isFeatured: true,
        name: (context) =>
            'shrineProductGingerScarf',
        price: 98,
        assetAspectRatio: 219 / 329,
      ),
      Product(
        category: categoryClothing,
        id: 30,
        isFeatured: true,
        name: (context) =>
            'shrineProductRamonaCrossover',
        price: 68,
        assetAspectRatio: 220 / 329,
      ),
      Product(
        category: categoryClothing,
        id: 31,
        isFeatured: false,
        name: (context) =>
            'shrineProductChambrayShirt',
        price: 38,
        assetAspectRatio: 329 / 223,
      ),
      Product(
        category: categoryClothing,
        id: 32,
        isFeatured: false,
        name: (context) =>
            'shrineProductClassicWhiteCollar',
        price: 58,
        assetAspectRatio: 221 / 329,
      ),
      Product(
        category: categoryClothing,
        id: 33,
        isFeatured: true,
        name: (context) =>
            'shrineProductCeriseScallopTee',
        price: 42,
        assetAspectRatio: 329 / 219,
      ),
      Product(
        category: categoryClothing,
        id: 34,
        isFeatured: false,
        name: (context) =>
            'shrineProductShoulderRollsTee',
        price: 27,
        assetAspectRatio: 220 / 329,
      ),
      Product(
        category: categoryClothing,
        id: 35,
        isFeatured: false,
        name: (context) =>
            'shrineProductGreySlouchTank',
        price: 24,
        assetAspectRatio: 222 / 329,
      ),
      Product(
        category: categoryClothing,
        id: 36,
        isFeatured: false,
        name: (context) =>
            'shrineProductSunshirtDress',
        price: 58,
        assetAspectRatio: 219 / 329,
      ),
      Product(
        category: categoryClothing,
        id: 37,
        isFeatured: true,
        name: (context) =>
            'shrineProductFineLinesTee',
        price: 58,
        assetAspectRatio: 219 / 329,
      ),
    ];
    if (category == categoryAll) {
      return allProducts;
    } else {
      return allProducts.where((p) => p.category == category).toList();
    }
  }
}
