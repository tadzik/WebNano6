role WebNano6::FindController {

    method controller_search_path { self.WHAT.perl };

    method find_nested( $name_part ){
        return if $name_part ~~ /\./;
        $name_part.subst( /\//, '::', :g );
        for $.controller_search_path -> $base {
            my $controller_class = $base ~ '::' ~ $name_part;
            require $controller_class;
            CATCH{
                default {
                    next;
                }
            }
            if ( ::($controller_class).isa( 'WebNano6::Controller' ) ) {
                return $controller_class;
            }
        }
        return;
    }
}


