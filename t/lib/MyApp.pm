class MyApp {
    method psgi_app {
        sub ($env) { [ 404, {}, "" ] }
    }
}
