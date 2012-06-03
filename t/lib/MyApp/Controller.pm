use WebNano6::Controller;

class MyApp::Controller is WebNano6::Controller {

    has $.url_map = { 'mapped url' => 'mapped_url' };

    method simple_GET { 'The simple_GET action' }

    method index_action { 'This is the home page' }

    method mapped_url { 'This is the mapped url page' }

    method postonly_POST { 'This is a method with _post postfix' }

}


