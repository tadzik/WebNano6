use Test;
use Test::PSGI;

use lib 't/lib';
use MyApp;

sub like ($a, $b, $desc = '') {
    ok $a ~~ $b, $desc
}

test_psgi( 
    app => MyApp.new.psgi_app, 
    client => sub ($cb) {
        my $res = $cb.(get "/");
        is( $res.content, 'This is the home page' );
        $res = $cb.(get "/mapped url");
        is( $res.content, 'This is the mapped url page' );
        $res = $cb.(get "/postonly");
        is( $res.code, 404 , 'get for a post controller' );
        $res = $cb.(post "/postonly");
        is( $res.content, 'This is a method with _post postfix', 'POST only' );

        $res = $cb.(get "NestedController/some_method");
        is( $res.content, 'This is a method with _action postfix' );
        $res = $cb.(get "NestedController/safe_method");
        is( $res.content, 'This is the safe_method page' );
        $res = $cb.(get "NestedController/self_url");
        is( $res.content, '/NestedController/', 'self_url' );
        $res = $cb.(get "NestedController/env_check");
        is( $res.content, 'env present', 'env_check' );
        exit;
        $res = $cb.(get "NestedController/with_template");
        like( $res.content, rx/This is a NestedController page rendered with a template/ );

        $res = $cb.(get "NestedController2/some_method");
        like( $res.content, rx/'This is a method with _action postfix in MyApp::Controller::NestedController2'/ );
        $res = $cb.(get "NestedController2/with_template");
        like( $res.content, rx/'This is a MyApp::Controller::NestedController2 page rendered with a template'/ );

        $res = $cb.(get "Product/some");
        like( $res.content, rx/This is the example template for ControllerWithTemplates/ );
        $res = $cb.(get "Product/another");
        like( $res.content, rx/This is template for Product/ );
        $res = $cb.(get "Product/third");
        like( $res.content, rx/This is template for Product/ );

        $res = $cb.(get "Book/some");
        like( $res.content, rx/This is the example template for ControllerWithTemplates/ );
        $res = $cb.(get "Book/another");
        like( $res.content, rx/This is template for Product/ );
        $res = $cb.(get "Book/third");
        like( $res.content, rx/This is template for Book/ );

        $res = $cb.(get "/there_is_no_such_page");
        is( $res.code, 404 , '404 for non existing controller' );
        $res = $cb.(get "/ThisIsNotController/");
        is( $res.code, 404 , '404 for a non controller' );

        $res = $cb.(get "/DoesNotCompile/");
        is( $res.code, 500, '500 for controller that does not compile' );
#        in some circumstances the above code dies instead of issuing a 500

        $res = $cb.(get "Deep/Nested/some");
        is( $res.content, "This is 'some_action' in 'MyApp::Controller::Deep::Nested'" );
     } 
);

done;
