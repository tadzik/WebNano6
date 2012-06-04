use WebNano6::FindController;

class WebNano6 does WebNano6::FindController {

    method psgi_app {
        sub ( %env ) { self.handle( %env ) }
    }
    method handle( %env ){
        my $path = %env<PATH_INFO>;
        $path.subst( /^\//, '' );
        my @parts = $path.split( '/' );
        my $c_class = $.find_nested( 'Controller' );
        die 'Cannot find root controller' if !$c_class;
        my $out = ::($c_class).handle(
            {
                path => [ @parts ],
                app => self,
                env => %env,
                self_url => '/',
            }
        );
        if ( ! $out ) {
            return [ 404, [ 'Content-type' => 'text/plain' ], 'Not Found' ];
        }
        return [ 200, [ 'Content-Type' => 'text/html' ], $out ];
    }
}

