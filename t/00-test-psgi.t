use Test;
use Test::PSGI;
plan 4;

my $app = sub ($env) {
    return [200, ['Content-Type' => 'text/plain'], "Hello world"];
}

test_psgi :$app,
    client => sub ($cb) {
        pass;
        my $res = $cb.(get '/');
        is $res.code, 200;
        is $res.headers<Content-Type>, 'text/plain';
        is $res.content, "Hello world";
    };
