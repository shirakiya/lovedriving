use strict;
use warnings;
use utf8;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'extlib', 'lib', 'perl5');
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use Amon2::Lite;
use LoveDriving::Calc;
use LoveDriving::Request;

our $VERSION = '0.01';

# put your configuration here
sub load_config {
    my $c = shift;

    my $mode = $c->mode_name || 'development';

    # 設定ファイルの読み込み
    my $basedir = File::Spec->rel2abs( File::Spec->catdir( dirname(__FILE__) ) );
    my $config = do File::Spec->catfile( $basedir, 'config.pl' );
    
    return $config;
}


# Routing
post '/start' => sub {
    my $c = shift;

    # id、彼女不快指数の取得
    my $start_res = LoveDriving::Calc->start;

    return $c->render_json({
        id         => $start_res->{id},
        discomfort => $start_res->{discomfort},
    });
};


get '/' => sub {
    my $c = shift;
    return $c->render('index.tt');
};


post '/vehicleinfo' => sub {
    my $c = shift;
    my $id = $c->req->param('id');

    # 走行情報の取得
    my $content = LoveDriving::Request->vehicle_info( id => $id );

    # 不快指数の取得
    my $discomfort = LoveDriving::Calc->get_discomfort(
        id      => $id,
        content => $content,
    );

    # 停車判定の取得
    my $is_stop = LoveDriving::Calc->get_is_stop(
        content => $content,
    );

    return $c->render_json({
        discomfort => $discomfort,
        is_stop    => $is_stop,
    });
};


post '/end' => sub {
    my $c = shift;
    my $id = $c->req->param('id');

    my $is_end = LoveDriving::Calc->end( id => $id );

    return $c->render_json({
        is_end => $is_end,
    });
};


# load plugins
__PACKAGE__->load_plugin(
    'Web::JSON',
);
__PACKAGE__->to_app(handle_static => 1);


__DATA__

@@ index.tt
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>lovedriving</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="[% uri_for('/static/js/main.js') %]"></script>
    <link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.min.css" rel="stylesheet">
    <script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="[% uri_for('/static/css/main.css') %]">
</head>
<body>
    <div class="container">
        <section class="row">
            <form method="post" action="[% uri_for('/start') %]">
                <p>ID：<input type="text" id="id" name="id"></p>
                <p><input type="submit" value="送信"></p>
            </form>
        </section>
    </div>
</body>
</html>

@@ /static/js/main.js

@@ /static/css/main.css
footer {
    text-align: right;
}
