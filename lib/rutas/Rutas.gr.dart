// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:auto_route/empty_router_widgets.dart' as _i2;
import 'package:cloud_firestore/cloud_firestore.dart' as _i8;
import 'package:flutter/material.dart' as _i7;

import '../bar_menu/negocio/Negocio.dart' as _i3;
import '../bar_menu/negocio/Producto/crear_producto/CrearProducto.dart' as _i5;
import '../bar_menu/negocio/Producto/Producto.dart' as _i4;
import '../main.dart' as _i1;

class AppRouter extends _i6.RootStackRouter {
  AppRouter([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    MyHomePageRouter.name: (routeData) {
      return _i6.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.MyHomePage(),
        transitionsBuilder: _i6.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    NegocioRouter.name: (routeData) {
      return _i6.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i2.EmptyRouterPage(),
        transitionsBuilder: _i6.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    Negocio.name: (routeData) {
      return _i6.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i3.Negocio(),
        transitionsBuilder: _i6.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProductoRouter.name: (routeData) {
      final args = routeData.argsAs<ProductoRouterArgs>();
      return _i6.CustomPage<dynamic>(
        routeData: routeData,
        child: _i4.Producto(
          key: args.key,
          documentoNegocio: args.documentoNegocio,
        ),
        transitionsBuilder: _i6.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    CrearProductoRouter.name: (routeData) {
      final args = routeData.argsAs<CrearProductoRouterArgs>();
      return _i6.CustomPage<dynamic>(
        routeData: routeData,
        child: _i5.CrearProducto(
          key: args.key,
          collectionReferenceProductos: args.collectionReferenceProductos,
          idCodigoDeBarra: args.idCodigoDeBarra,
        ),
        transitionsBuilder: _i6.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/MyHomePage',
          fullMatch: true,
        ),
        _i6.RouteConfig(
          MyHomePageRouter.name,
          path: '/MyHomePage',
          children: [
            _i6.RouteConfig(
              NegocioRouter.name,
              path: 'Negocio',
              parent: MyHomePageRouter.name,
              children: [
                _i6.RouteConfig(
                  Negocio.name,
                  path: '',
                  parent: NegocioRouter.name,
                ),
                _i6.RouteConfig(
                  ProductoRouter.name,
                  path: 'Producto',
                  parent: NegocioRouter.name,
                ),
                _i6.RouteConfig(
                  CrearProductoRouter.name,
                  path: 'CrearProducto',
                  parent: NegocioRouter.name,
                ),
              ],
            )
          ],
        ),
      ];
}

/// generated route for
/// [_i1.MyHomePage]
class MyHomePageRouter extends _i6.PageRouteInfo<void> {
  const MyHomePageRouter({List<_i6.PageRouteInfo>? children})
      : super(
          MyHomePageRouter.name,
          path: '/MyHomePage',
          initialChildren: children,
        );

  static const String name = 'MyHomePageRouter';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class NegocioRouter extends _i6.PageRouteInfo<void> {
  const NegocioRouter({List<_i6.PageRouteInfo>? children})
      : super(
          NegocioRouter.name,
          path: 'Negocio',
          initialChildren: children,
        );

  static const String name = 'NegocioRouter';
}

/// generated route for
/// [_i3.Negocio]
class Negocio extends _i6.PageRouteInfo<void> {
  const Negocio()
      : super(
          Negocio.name,
          path: '',
        );

  static const String name = 'Negocio';
}

/// generated route for
/// [_i4.Producto]
class ProductoRouter extends _i6.PageRouteInfo<ProductoRouterArgs> {
  ProductoRouter({
    _i7.Key? key,
    required _i8.DocumentSnapshot<Object?> documentoNegocio,
  }) : super(
          ProductoRouter.name,
          path: 'Producto',
          args: ProductoRouterArgs(
            key: key,
            documentoNegocio: documentoNegocio,
          ),
        );

  static const String name = 'ProductoRouter';
}

class ProductoRouterArgs {
  const ProductoRouterArgs({
    this.key,
    required this.documentoNegocio,
  });

  final _i7.Key? key;

  final _i8.DocumentSnapshot<Object?> documentoNegocio;

  @override
  String toString() {
    return 'ProductoRouterArgs{key: $key, documentoNegocio: $documentoNegocio}';
  }
}

/// generated route for
/// [_i5.CrearProducto]
class CrearProductoRouter extends _i6.PageRouteInfo<CrearProductoRouterArgs> {
  CrearProductoRouter({
    _i7.Key? key,
    required _i8.CollectionReference<Object?> collectionReferenceProductos,
    required String? idCodigoDeBarra,
  }) : super(
          CrearProductoRouter.name,
          path: 'CrearProducto',
          args: CrearProductoRouterArgs(
            key: key,
            collectionReferenceProductos: collectionReferenceProductos,
            idCodigoDeBarra: idCodigoDeBarra,
          ),
        );

  static const String name = 'CrearProductoRouter';
}

class CrearProductoRouterArgs {
  const CrearProductoRouterArgs({
    this.key,
    required this.collectionReferenceProductos,
    required this.idCodigoDeBarra,
  });

  final _i7.Key? key;

  final _i8.CollectionReference<Object?> collectionReferenceProductos;

  final String? idCodigoDeBarra;

  @override
  String toString() {
    return 'CrearProductoRouterArgs{key: $key, collectionReferenceProductos: $collectionReferenceProductos, idCodigoDeBarra: $idCodigoDeBarra}';
  }
}
