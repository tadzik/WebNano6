use WebNano6::Controller;

class WebNano6 {

    method controller_search_path { self.WHAT.perl };

    method psgi_app {
        sub ($env) { [ 404, {}, "" ] }
    }
    method find_nested( $name_part ){
        return if $name_part ~~ /\./;
        $name_part.subst( /\//, '::', :g );
        for $.controller_search_path -> $base {
            my $controller_class = $base ~ '::Controller' ~ $name_part;
            require $controller_class;
            CATCH{
                default {
                    next;
                }
            }
            if ( ::($controller_class).isa( WebNano6::Controller ) ) {
                return $controller_class;
            }
        }
        die 'Cannot find controller';
    }
    method handle( %env ){
        my $path = %env<PATH_INFO>;
        $path.subst( /^\//, '' );
        my @parts = $path.split( '/' );
        my $c_class = $.find_nested( '' );
        die 'Cannot find root controller' if !$c_class;
        my $out = ::($c_class).handle(
            {
                path => [ @parts ],
                app => self,
                env => %env,
                self_url => '/',
            }
        );
        return [ 200, [ 'Content-Type' => 'text/html' ], $out ];
    }
}

