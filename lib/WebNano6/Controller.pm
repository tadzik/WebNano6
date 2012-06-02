class WebNano6::Controller {

    has @.path;

    has $.DEBUG;

    has %.env;

    method search_subcontrollers { False }

    method handle( %args ) {
        my $self = self.new( |%args );
        my $out = $self.local_dispatch();
        return $out if defined( $out ) || !$self.search_subcontrollers;
        my $path_part = shift $self.path;
        return $self.dispatch_to_class( $path_part );
    }

    method local_dispatch {
        my $name = shift $.path;
        $name = 'index' if !defined( $name ) || !$name.chars;
        my $method = %.env<REQUEST_METHOD>.uc;
        if ( $method eq 'GET' || $method eq 'POST' ) {
            my $action = $name ~ '_' ~ $method;
            if ( self.^find_method( $action ) ) {
                return self."$action"();
            }
        }
    }
}

