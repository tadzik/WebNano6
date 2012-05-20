module Test::PSGI;

class PSGI::Request {
    has %.env;
}

sub get($foo) is export {
    PSGI::Request.new(REQUEST_METHOD => 'GET', REQUEST_URI => $foo)
}

sub post($foo) is export {
    PSGI::Request.new(REQUEST_METHOD => 'POST', REQUEST_URI => $foo)
}

class PSGI::Response {
    has $.code;
    has $.headers;
    has $.content;

    method new(@r) {
        self.bless(*, :code(@r[0]), :headers(@r[1].hash), :content(@r[2]))
    }
}

multi test_psgi(:$app, :$client) is export {
    test_psgi($app, $client)
}

multi test_psgi($app, $client) is export {
    my $cb = sub (PSGI::Request $req){
        PSGI::Response.new($app.($req.env))
    }

    $client.($cb);
}
