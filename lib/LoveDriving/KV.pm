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
    my $type_id  = $id . '_type';
    my $times_id = $id . '_times';

    # 初期値を与える
    unqlite()->kv_store( $id, 100 );
    unqlite()->kv_store( $type_id, 0 );
    unqlite()->kv_store( $times_id, 0 );

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

    # UnQLiteにkeyが存在しない場合(startしていない場合)の処理
    unless ( defined( unqlite()->kv_fetch( $id ) ) ) {
        die 'db key not found';
    }
        
    return unqlite()->kv_fetch( $id );
}


sub get_type {
    args(
        my $class,
        my $id => 'Str',
    );
    
    return unqlite()->kv_fetch( $id.'_type' );
}


sub get_show_times {
    args(
        my $class,
        my $id => 'Str',
    );

    return unqlite()->kv_fetch( $id.'_times' );
}


sub save {
    args(
        my $class,
        my $id         => 'Str',
        my $discomfort => 'Int',
        my $type       => 'Int',
        my $show_times => 'Int',
    );

    my $is_save = 0;
    my $type_id  = $id . '_type';
    my $times_id = $id . '_times';

    try {
        unqlite()->kv_store( $id, $discomfort );
        unqlite()->kv_store( $type_id, $type );
        unqlite()->kv_store( $times_id, $show_times );
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
