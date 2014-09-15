package Model::Calc;
use strict;
use warnings;
use Smart::Args;
use UnQLite;
use Furl;
use JSON qw/decode_json/;
use Model::Request;

sub get_discomfort {
    args(
        my $class,
        my $id => 'Int',
    );

    my $res = Model::Request->vehicle_info(
        id => $id,
    );

    #my $db = UnQLite->open('lovedriving.db');
    #$db->kv_store( $id, 10 );
    #my $value = $db->kv_fetch( $id );

    return $res;
}

1;
