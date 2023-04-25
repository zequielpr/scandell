import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:flutter/material.dart';
import 'package:scasell/bar_menu/negocio/Producto/Producto.dart';

import '../bar_menu/negocio/Negocio.dart';
import '../bar_menu/negocio/Producto/crear_producto/CrearProducto.dart';
import '../main.dart';

@MaterialAutoRouter(replaceInRouteName: 'Page,Route', routes: <AutoRoute>[
  CustomRoute(
      path: '/MyHomePage',
      name: 'MyHomePageRouter',
      page: MyHomePage,
      initial: true,
      transitionsBuilder: TransitionsBuilders.noTransition,
      children: [
        //Rutas de home

        CustomRoute(
            path: "Negocio",
            name: "NegocioRouter",
            page: EmptyRouterPage,
            transitionsBuilder: TransitionsBuilders.noTransition,
            children: [
              CustomRoute(
                path: '',
                page: Negocio,
                transitionsBuilder: TransitionsBuilders.noTransition,
              ),
              CustomRoute(
                path: 'Producto',
                page: Producto,
                name: 'ProductoRouter',
                transitionsBuilder: TransitionsBuilders.noTransition,
              ),
              CustomRoute(
                page: CrearProducto,
                path: 'CrearProducto',
                name: 'CrearProductoRouter',
                transitionsBuilder: TransitionsBuilders.noTransition,
              )
            ]),
      ])
])
class $AppRouter {}
