use Test;
use Test::PSGI;

use lib 't/lib';
use MyApp;

sub like ($a, $b, $desc = '') {
    ok $a ~~ $b, $desc
}

my $app = MyApp.new;
is( $app.controller_search_path, ( 'MyApp' ) );
is( $app.find_nested( '' ), 'MyApp::Controller' );

my $res = $app.handle( { REQUEST_METHOD => 'GET', REQUEST_URI => '/simple' } );
is( $res.content, 'The simple_GET action' );

done;