use WebNano6::Controller;

class MyApp::Controller::NestedController is WebNano6::Controller {
    has $.url_map = [ 'safe_method' ];

    method some_method_action { 'This is a method with _action postfix' }
    method safe_method { 'This is the safe_method page' }
}

