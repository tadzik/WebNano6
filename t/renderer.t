use Test;

use lib 'lib';
use WebNano6::Renderer::Mojo;
use WebNano6::Controller;

my $c = WebNano6::Controller.new;
my $renderer = WebNano6::Renderer::Mojo.new( root => 't/data/templates' );
my $rendered = $renderer.render( c => $c, template => 'dummy_template', 'some value' );
ok( $rendered ~~ m/ some_var \:\ some\ value /, 'vars' );
ok( $rendered ~~ m/ ^ Some\ text /, 'Slurping template file' );

done;
