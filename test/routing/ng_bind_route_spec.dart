library ng_bind_route_spec;

import 'dart:html';
import '../_specs.dart';
import 'package:angular/routing/module.dart';
import 'package:angular/mock/module.dart';

main() {
  describe('ngBindRoute', () {
    TestBed _;

    beforeEachModule((Module m) => m
      ..install(new AngularMockModule())
      ..bind(RouteInitializerFn, toImplementation: NestedRouteInitializer));

    beforeEach((TestBed tb) {
      _ = tb;
    });


    it('should inject null RouteProvider when no ng-bind-route', async(() {
      Element root = _.compile('<div probe="routeProbe"></div>');
      expect(_.rootScope.context['routeProbe'].injector.get(RouteProvider)).toBeNull();
    }));


    it('should inject RouteProvider with correct flat route', async(() {
      Element root = _.compile(
          '<div ng-bind-route="library"><div probe="routeProbe"></div></div>');
      expect(_.rootScope.context['routeProbe'].injector.get(RouteProvider).routeName)
          .toEqual('library');
    }));


    it('should inject RouteProvider with correct nested route', async(() {
      Element root = _.compile(
          '<div ng-bind-route="library">'
          '  <div ng-bind-route=".all">'
          '    <div probe="routeProbe"></div>'
          '  </div>'
          '</div>');
      expect(_.rootScope.context['routeProbe'].injector.get(RouteProvider).route.name)
          .toEqual('all');
    }));

    it('should expose NgBindRoute as RouteProvider', async(() {
      Element root = _.compile(
          '<div ng-bind-route="library"><div probe="routeProbe"></div></div>');
      expect(_.rootScope.context['routeProbe'].injector.get(RouteProvider) is NgBindRoute).toBeTruthy();
    }));

  });
}

class NestedRouteInitializer implements Function {
  void call(Router router, RouteViewFactory view) {
    router.root
      ..addRoute(
          name: 'library',
          path: '/library',
          enter: view('library.html'),
          mount: (Route route) => route
            ..addRoute(
                name: 'all',
                path: '/all',
                enter: view('book_list.html'))
            ..addRoute(
                name: 'book',
                path: '/:bookId',
                mount: (Route route) => route
                  ..addRoute(
                      name: 'overview',
                      path: '/overview',
                      defaultRoute: true,
                      enter: view('book_overview.html'))
                  ..addRoute(
                      name: 'read',
                      path: '/read',
                      enter: view('book_read.html'))))
                  ..addRoute(
                      name: 'admin',
                      path: '/admin',
                      enter: view('admin.html'));
  }
}
