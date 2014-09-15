package Model::Calc;
use strict;
use warnings;
use Smart::Args;
use UnQLite;

sub calc {
    args(
        my $class,
        my $id => 'Int',
    );

    my $db = UnQLite->open('lovedriving.db');
    $db->kv_store( $id, 10 );
    my $value = $db->kv_fetch( $id );

    return $value;
}

1;
