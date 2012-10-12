use Template::Mojo;

class WebNano6::Renderer::Mojo {

    has $.root;


    has @.INCLUDE_PATH = ( '' );

    has $.TEMPLATE_EXTENSION = '';

    method render(:$c, :$template, *@vars ){
        my $text = slurp $.root ~ "/$template" ~ $.TEMPLATE_EXTENSION;
        my $tmojo = Template::Mojo.new( $text );
        return $tmojo.render(|@vars);
    }
}

