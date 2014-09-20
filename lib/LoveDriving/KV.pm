package LoveDriving::KV;
use strict;
use warnings;
use Smart::Args;
use Try::Tiny;
use LoveDriving::Base;

sub start {
    args(
        my $class,
    );

    my $id = '';
    #一意なIDを与える
    for my $tmp_id ( @{config()->{vid}} ) {
        if ( defined( unqlite()->kv_fetch( $tmp_id ) ) ) {
            next;
        } else {
            $id = $tmp_id;
            last;
        }
    }

    #不快指数の初期値100を与える
    unqlite()->kv_store( $id, 100 );

    return {
        id         => $id,
        discomfort => unqlite()->kv_fetch( $id ),
    };
}


sub get_discomfort {
    args(
        my $class,
        my $id => 'Str',
    );

    my $kv = unqlite()->kv_fetch( $id );

    return $kv;
}


sub save_discomfort {
    args(
        my $class,
        my $id         => 'Str',
        my $discomfort => 'Int',
    );
    my $is_save = 0;
    try {
        unqlite()->kv_store( $id, $discomfort );
        $is_save = 1;
    } catch {
        $is_save = 0;
    };
    return $is_save;
}


sub end {
    args(
        my $class,
        my $id => 'Str',
    );

    my $result = {
        is_end     => 0,
        discomfort => unqlite()->kv_fetch( $id ),
    };

    try {
        unqlite()->kv_delete( $id );
        $result->{is_end} = 1;
    } catch {
        $result->{is_end} = 0;
    };

    return $result;
}

1;
