package LoveDriving::KV;
use strict;
use warnings;
use Smart::Args;
use UnQLite;
use Try::Tiny;
use LoveDriving::Base;

sub start {
    args(
        my $class,
    );
    my $start_res = {
        id => '001',
        discomfort => 100,
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
