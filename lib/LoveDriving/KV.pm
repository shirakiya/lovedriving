package LoveDriving::KV;
use strict;
use warnings;
use Smart::Args;
use UnQLite;
use Try::Tiny;

sub start {
    args(
        my $class,
        my $id => 'Str',
    );

    my $kv = UnQLite->open('lovedriving.db');
    my $is_start = 0;

    try {
        $kv->kv_store( $id, 0 );
        $is_start = 1;
    } catch {
        $is_start = 0
    };

    return $is_start;
}


sub get_discomfort {
    args(
        my $class,
        my $id => 'Str',
    );

    my $kv = UnQLite->open('lovedriving.db');

    return $kv->kv_fetch( $id ) or 0;
}


sub save_discomfort {
    args(
        my $class,
        my $id         => 'Str',
        my $discomfort => 'Int',
    );

    my $kv = UnQLite->open('lovedriving.db');
    my $is_save = 0;

    try {
        $kv->kv_store( $id );
        $is_save = 1;
    } catch {
        $is_save = 0;
    }

    return $is_save;
}


sub end {
    args(
        my $class,
        my $id => 'Str',
    );

    my $kv = UnQLite->open('lovedriving.db');
    my $is_end = 0;

    try {
        $kv->kv_delete( $id );
        $is_end = 1;
    } catch {
        $is_end = 0;
    }

    return $is_end;
}

1;
