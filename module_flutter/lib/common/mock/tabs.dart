import 'package:module_flutter/common/constant/cart_constants.dart';
import 'package:module_flutter/common/constant/home_constants.dart';
import 'package:module_flutter/common/constant/me_constants.dart';
import 'package:module_flutter/common/constant/search_constants.dart';
import 'package:module_flutter/common/constant/store_constants.dart';
import 'package:module_flutter/common/iconfonts/iconfonts.dart';
import 'package:module_flutter/common/model/tab.dart';

List<Tab> bottomTabs = [
  Tab(iconData: IconFonts.home.codePoint, text: HomeConstants.module),
  Tab(iconData: IconFonts.store.codePoint, text: StoreConstants.module),
  Tab(iconData: IconFonts.search.codePoint, text: SearchConstants.module),
  Tab(iconData: IconFonts.cart.codePoint, text: CartConstants.module),
  Tab(iconData: IconFonts.account.codePoint, text: MeConstants.module),
];
