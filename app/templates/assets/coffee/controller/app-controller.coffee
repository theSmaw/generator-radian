# This is the heart and soul of the app. It's up to you and your team on whether you choose to use a 'class' pattern
# but from experience following this pattern provides a clean and adaptable layout for your code.
define [
  # Jump to [`config.coffee`](config.html) ☛
  'config'
  'angular'
  # Load up the base controller, all controllers inherit from it. All hail the base controller. Wow.
  # Jump to [`controller/radian-controller.coffee`](radian-controller.html) ☛
  'controller/radian-controller'
  # Fast apps are nice, and in order to keep your app nice and fast it's a good idea to make use of
  # [`$templateCache`](http://docs.angularjs.org/api/ng.$templateCache), so here we have a file that takes care of that;
  # during development it's left empty on purpose and it's then filled with the compiled [Jade](http://jade-lang.com)
  # templates during build time.
  # Jump to [`partials.coffee`](partials.html) ☛
  'partials'
  # Before `appController` is added to the app it is vital to load in the
  # [`ngRoute`](http://docs.angularjs.org/api/ngRoute.$routeProvider) configuration. If your app is driven from an API
  # and thus the navigation needs to be loaded before the app can work out where to go then it's a good idea to use
  # [`$route.reload()`](http://docs.angularjs.org/api/ngRoute.$route) after the navigation data has been loaded.
  # Jump to [`routes.coffee`](routes.html) ☛
  'routes'
  <% if (includeExample) { %># Jump to [`controller/header/header-controller.coffee`](header-controller.html) ☛
  'controller/header/header-controller'
  # Jump to [`controller/footer-controller.coffee`](footer-controller.html) ☛
  'controller/footer-controller'
  # One problem that people struggled with regarding [AngularJS](http://angularjs.org) is how to deal with sending data
  # between modules in the app. This has been resolved here by the use of factories, in this case it's a factory that
  # broadcasts updates to the document's title and any module that can inject the factory can set the title.
  # This deals with issues around misuse of the `$rootScope`/`$scope` to pass data up and down the chain and keeps
  # everything testable.
  # Jump to [`factory/page-loader-factory.coffee`](page-loader-factory.html) ☛
  'factory/page-loader-factory'
  # Jump to [`factory/page-title-factory.coffee`](page-title-factory.html) ☛
  'factory/page-title-factory'
<% } %>], (cfg, A, RC) ->
  # Every controller class in radian follows the same pattern. It's also preferable to explicity specify the `$inject`
  # modules as this code will be minified.
  class extends RC
    # You register your controller by calling `@register` and passing in the class's name and then the dependancies as
    # an array.
    @register 'AppController', [
      '$scope'<% if (includeExample) { %>
      'pageLoaderFactory'
      'pageTitleFactory'
    <% } %>]

    init: () ->
      <% if (includeExample) { %>@addListeners()
      @addListeners()
      @addPartials()
      @addScopeMethods()

    addListeners: () ->
      @pageLoaderFactory.addListener A.bind @, @handlePageLoaderChange
      @pageTitleFactory.addListener A.bind @, @handlePageTitleChange

    addPartials: () ->
      @$scope.ctaPartial = cfg.path.partial + 'cta-partial.html'
      @$scope.footerPartial = cfg.path.partial + 'footer-partial.html'
      @$scope.headerPartial = cfg.path.partial + 'header/header-partial.html'

    addScopeMethods: () ->
      @$scope.handleViewLoaded = A.bind @, @handleViewLoaded

    handlePageTitleChange: (event, title) ->
      @$scope.pageTitle = "Radian ~ A scalable AngularJS framework ~ #{title}"

    handlePageLoaderChange: (event, show) ->
      # _'Why is it `@$scope.hideLoader` instead of `@$scope.showLoader`?'_ Well, my old chum, by default we show the
      # loader until our application sends an event via the [`pageLoaderFactory`](page-loader-factory.html), this way
      # it is a more elegant experience.
      @$scope.hideLoader = !show

    handleViewLoaded: () ->
      # _'Why not just set `@$scope.hideLoader` here instead of using `@pageLoaderFactory.hide()`?'_ Well, there may be
      # more modules in the app that are listening to `pageLoaderFactory` than just this controller, so it's only polite
      # to let them know what's up.
      @pageLoaderFactory.hide()<% } %>