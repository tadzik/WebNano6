use WebNano6::FindController;

class WebNano6::Controller does WebNano6::FindController {

    has @.path;

    has $.DEBUG;

    has %.env;

    has $.url_map;

    has $.app;

    has $.self_url;

    method search_subcontrollers { False }

    method handle( %args ) {
        my $self = self.new( |%args );
        my $out = $self.local_dispatch();
        return $out if defined( $out ) || !$self.search_subcontrollers;
        my $path_part = shift $self.path;
        return $self.dispatch_to_class( $path_part );
    }

    method local_dispatch {
        my $first = my $name = shift $.path;
        $name = 'index' if !defined( $name ) || !$name.chars;
        my $method = %.env<REQUEST_METHOD>.uc;
        my $action;
        if ( my $map = self.url_map ) {
            if ( $map.isa( Hash ) ) {
                $action = $map{$name};
            }
            if ( $map.isa( Array ) ) {
                $action = $name;
            }
            if ( $action.isa( Str ) && self.^find_method( $action ) ) {
                return self."$action"();
            }
        }
        if ( $method eq 'GET' || $method eq 'POST' ) {
            $action = $name ~ '_' ~ $method;
            if ( self.^find_method( $action ) ) {
                return self."$action"();
            }
        }
        if ( $action = self.^find_method( $name ~ '_action' ) ) {
            return self."$action"();
        }
        if ( $first.isa( Str ) ) {
            my $c_class = self.find_nested( $first );
            if ( $c_class ) {
                return ::($c_class).handle(
                    {   
                        path => $.path,
                        app => $.app,
                        env => %.env,
                        self_url => $.self_url ~ $first ~ '/',
                    }
                );
            }
        }

        return;
    }
}

