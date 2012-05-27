class WebNano6 {
    method psgi_app {
        sub ($env) { [ 404, {}, "" ] }
    }
}
