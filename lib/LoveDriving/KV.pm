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

    my $user_id = '';
    #一意なIDを与える
    for my $id ( @{config()->{userid}} ) {
        if ( defined( unqlite()->kv_fetch( $id ) ) ) {
            next;
        } else {
            $user_id = $id;
            last;
        }
    }

    #不快指数の初期値100を与える
    unqlite()->kv_store( $user_id, 100 );

    my $start_res = {
        id => $user_id,
        discomfort => unqlite()->kv_fetch( $user_id ),
    };
    return $start_res;
}


sub get_discomfort {
    args(
        my $class,
        my $id => 'Str',
    );
    my $kv = unqlite()->kv_fetch( $id ) // 0;
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
    }
    return $is_save;
}


sub end {
    args(
        my $class,
        my $id => 'Str',
    );
    my $is_end = 0;
    try {
        unqlite()->kv_delete( $id );
        $is_end = 1;
    } catch {
        $is_end = 0;
    }
    return $is_end;
}

1;
